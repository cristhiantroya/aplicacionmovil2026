import { Request, Response } from "express";
import bcrypt from "bcrypt";
import prisma from "../utils/prisma";
import {
  generateAccessToken,
  generateRefreshToken,
  hashToken,
  getRefreshExpiryDate,
} from "../utils/tokens";

export const register = async (req: Request, res: Response) => {
  try {
    const { nombre, correo, contrasena, documento_identidad, telefono } =
      req.body;

    const existingUser = await prisma.usuario.findFirst({
      where: {
        OR: [{ correo }, { documento_identidad }],
      },
    });

    if (existingUser) {
      return res.status(400).json({ message: "User already exists" });
    }

    const hashedPassword = await bcrypt.hash(contrasena, 10);

    const user = await prisma.usuario.create({
      data: {
        nombre,
        correo,
        contrasena: hashedPassword,
        documento_identidad,
        telefono,
      },
    });

    const accessToken = generateAccessToken(user.id_usuario, user.rol);
    const refreshToken = generateRefreshToken();

    await prisma.refreshToken.create({
      data: {
        token_hash: hashToken(refreshToken),
        id_usuario: user.id_usuario,
        fecha_expiracion: getRefreshExpiryDate(),
      },
    });

    res.status(201).json({
      message: "User registered successfully",
      accessToken,
      refreshToken,
      user: {
        id_usuario: user.id_usuario,
        nombre: user.nombre,
        correo: user.correo,
        reputacion: user.reputacion,
        estado_cuenta: user.estado_cuenta,
        rol: user.rol,
      },
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
};

export const login = async (req: Request, res: Response) => {
  try {
    const { correo, contrasena } = req.body;

    const user = await prisma.usuario.findUnique({ where: { correo } });

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const isPasswordValid = await bcrypt.compare(contrasena, user.contrasena);

    if (!isPasswordValid) {
      return res.status(401).json({ message: "Invalid credentials" });
    }

    const accessToken = generateAccessToken(user.id_usuario, user.rol);
    const refreshToken = generateRefreshToken();

    await prisma.refreshToken.create({
      data: {
        token_hash: hashToken(refreshToken),
        id_usuario: user.id_usuario,
        fecha_expiracion: getRefreshExpiryDate(),
      },
    });

    res.status(200).json({
      message: "Login successful",
      accessToken,
      refreshToken,
      user: {
        id_usuario: user.id_usuario,
        nombre: user.nombre,
        correo: user.correo,
        reputacion: user.reputacion,
        estado_cuenta: user.estado_cuenta,
        rol: user.rol,
      },
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
};

// Recibe un refresh token válido y entrega un access token nuevo
// (y rota el refresh token: revoca el usado y entrega uno nuevo)
export const refresh = async (req: Request, res: Response) => {
  try {
    const { refreshToken } = req.body;

    if (!refreshToken) {
      return res.status(400).json({ message: "Refresh token is required" });
    }

    const tokenHash = hashToken(refreshToken);

    const storedToken = await prisma.refreshToken.findUnique({
      where: { token_hash: tokenHash },
    });

    if (
      !storedToken ||
      storedToken.revocado ||
      storedToken.fecha_expiracion < new Date()
    ) {
      return res
        .status(401)
        .json({ message: "Invalid or expired refresh token" });
    }

    // Buscamos el rol ACTUAL del usuario (pudo cambiar desde el último login)
    const usuario = await prisma.usuario.findUnique({
      where: { id_usuario: storedToken.id_usuario },
    });

    if (!usuario) {
      return res.status(401).json({ message: "User no longer exists" });
    }

    await prisma.refreshToken.update({
      where: { id_refresh_token: storedToken.id_refresh_token },
      data: { revocado: true },
    });

    const newAccessToken = generateAccessToken(usuario.id_usuario, usuario.rol);
    const newRefreshToken = generateRefreshToken();

    await prisma.refreshToken.create({
      data: {
        token_hash: hashToken(newRefreshToken),
        id_usuario: usuario.id_usuario,
        fecha_expiracion: getRefreshExpiryDate(),
      },
    });

    res.status(200).json({
      accessToken: newAccessToken,
      refreshToken: newRefreshToken,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
};

// Revoca un refresh token (cerrar sesión / invalidar acceso robado)
export const logout = async (req: Request, res: Response) => {
  try {
    const { refreshToken } = req.body;

    if (!refreshToken) {
      return res.status(400).json({ message: "Refresh token is required" });
    }

    const tokenHash = hashToken(refreshToken);

    await prisma.refreshToken.updateMany({
      where: { token_hash: tokenHash },
      data: { revocado: true },
    });

    res.status(200).json({ message: "Logged out successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
};