import { Request, Response } from "express";
import prisma from "../utils/prisma";

export const getSafePoints = async (req: Request, res: Response) => {
  try {
    const { ciudad } = req.query;
    const points = await prisma.puntoSeguro.findMany({
      where: ciudad ? { ciudad: String(ciudad) } : {},
    });

    res.status(200).json(points);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
};

export const createSafePoint = async (req: Request, res: Response) => {
  try {
    const { nombre, direccion, ciudad, latitud, longitud } = req.body;

    const point = await prisma.puntoSeguro.create({
      data: {
        nombre,
        direccion,
        ciudad,
        latitud: parseFloat(latitud),
        longitud: parseFloat(longitud),
      },
    });

    res
      .status(201)
      .json({ message: "Safe point created successfully", point });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
};
