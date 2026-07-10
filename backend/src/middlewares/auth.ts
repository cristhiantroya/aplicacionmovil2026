import { Request, Response, NextFunction } from "express";
import jwt from "jsonwebtoken";
import prisma from "../utils/prisma";

interface AuthRequest extends Request {
  user?: {
    id_usuario: number;
    rol: string;
  };
}

export const authenticateToken = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  const authHeader = req.headers["authorization"];
  const token = authHeader && authHeader.split(" ")[1];

  if (!token) {
    return res.status(401).json({ message: "Token not provided" });
  }

  try {
    const decoded = jwt.verify(
      token,
      process.env.JWT_SECRET || "fallback-secret"
    ) as { id: number };

    const user = await prisma.usuario.findUnique({
      where: { id_usuario: decoded.id },
    });

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    req.user = { id_usuario: user.id_usuario, rol: user.rol };
    next();
  } catch (error) {
    return res.status(403).json({ message: "Invalid token" });
  }
};

export { AuthRequest };