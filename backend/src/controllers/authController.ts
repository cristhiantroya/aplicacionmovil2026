import { Request, Response } from "express";
import bcrypt from "bcrypt";
import jwt, { SignOptions } from "jsonwebtoken";
import prisma from "../utils/prisma";

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

    // Forzamos a TypeScript a entender que expiresIn es un texto válido
    const signOptions: SignOptions = {
      expiresIn: (process.env.JWT_EXPIRES_IN as any) || "7d"
    };

    const token = jwt.sign(
      { id: user.id_usuario },
      process.env.JWT_SECRET || "fallback-secret",
      signOptions
    );

    res.status(201).json({
      message: "User registered successfully",
      token,
      user: {
        id_usuario: user.id_usuario,
        nombre: user.nombre,
        correo: user.correo,
        reputacion: user.reputacion,
        estado_cuenta: user.estado_cuenta,
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

    // Forzamos a TypeScript a entender que expiresIn es un texto válido
    const signOptions: SignOptions = {
      expiresIn: (process.env.JWT_EXPIRES_IN as any) || "7d"
    };

    const token = jwt.sign(
      { id: user.id_usuario },
      process.env.JWT_SECRET || "fallback-secret",
      signOptions
    );

    res.status(200).json({
      message: "Login successful",
      token,
      user: {
        id_usuario: user.id_usuario,
        nombre: user.nombre,
        correo: user.correo,
        reputacion: user.reputacion,
        estado_cuenta: user.estado_cuenta,
      },
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
};
