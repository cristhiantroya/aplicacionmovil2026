import { Response } from "express";
import prisma from "../utils/prisma";
import { AuthRequest } from "../middlewares/auth";

export const createVerification = async (req: AuthRequest, res: Response) => {
  try {
    const { tipo_documento } = req.body;
    const userId = req.user?.id_usuario;

    if (!userId) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const existingVerification = await prisma.verificacion.findFirst({
      where: { id_usuario: userId },
    });

    if (existingVerification) {
      return res
        .status(400)
        .json({ message: "Verification already requested" });
    }

    const verification = await prisma.verificacion.create({
      data: {
        id_usuario: userId,
        tipo_documento,
      },
    });

    res.status(201).json({
      message: "Verification request submitted successfully",
      verification,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
};

export const getVerification = async (req: AuthRequest, res: Response) => {
  try {
    const userId = req.user?.id_usuario;

    if (!userId) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const verification = await prisma.verificacion.findFirst({
      where: { id_usuario: userId },
    });

    res.status(200).json(verification);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
};
export const reviewVerification = async (req: AuthRequest, res: Response) => {
  try {
    const { id } = req.params;
    const { estado } = req.body;

    if (!["aprobado", "rechazado"].includes(estado)) {
      return res
        .status(400)
        .json({ message: "Invalid status. Use 'aprobado' or 'rechazado'." });
    }

    const verification = await prisma.verificacion.update({
      where: { id_verificacion: Number(id) },
      data: { estado },
    });

    if (estado === "aprobado") {
      await prisma.usuario.update({
        where: { id_usuario: verification.id_usuario },
        data: { estado_cuenta: "activo" },
      });
    }

    res.status(200).json({ message: "Verification reviewed", verification });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
};
