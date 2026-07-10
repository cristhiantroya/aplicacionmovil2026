import { Response } from "express";
import prisma from "../utils/prisma";
import { AuthRequest } from "../middlewares/auth";

export const createRating = async (req: AuthRequest, res: Response) => {
  try {
    const { id_transaccion, puntuacion, comentario } = req.body;
    const userId = req.user?.id_usuario;

    if (!userId) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const transaction = await prisma.transaccion.findUnique({
      where: { id_transaccion: parseInt(id_transaccion) },
    });

    if (!transaction) {
      return res.status(404).json({ message: "Transaction not found" });
    }

    if (transaction.estado_escrow !== "completada") {
      return res
        .status(400)
        .json({ message: "Transaction must be completed to rate" });
    }

    let id_receptor: number;

    if (transaction.id_comprador === userId) {
      id_receptor = transaction.id_vendedor;
    } else if (transaction.id_vendedor === userId) {
      id_receptor = transaction.id_comprador;
    } else {
      return res.status(403).json({ message: "Unauthorized" });
    }

    const existingRating = await prisma.calificacion.findFirst({
      where: {
        id_transaccion: parseInt(id_transaccion),
        id_emisor: userId,
      },
    });

    if (existingRating) {
      return res
        .status(400)
        .json({ message: "You have already rated this transaction" });
    }

    const rating = await prisma.calificacion.create({
      data: {
        id_transaccion: parseInt(id_transaccion),
        id_emisor: userId,
        id_receptor,
        puntuacion,
        comentario,
      },
    });

    const allRatings = await prisma.calificacion.findMany({
      where: { id_receptor },
    });

    const averageRating =
      allRatings.reduce((sum, r) => sum + r.puntuacion, 0) / allRatings.length;

    await prisma.usuario.update({
      where: { id_usuario: id_receptor },
      data: { reputacion: averageRating },
    });

    res
      .status(201)
      .json({ message: "Rating created successfully", rating });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
};

export const getUserRatings = async (req: AuthRequest, res: Response) => {
  try {
    const userId = req.user?.id_usuario;

    if (!userId) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const ratings = await prisma.calificacion.findMany({
      where: { id_receptor: userId },
      include: { emisor: true, transaccion: true },
    });

    res.status(200).json(ratings);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
};
