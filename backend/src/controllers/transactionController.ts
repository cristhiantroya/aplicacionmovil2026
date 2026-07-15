import { Response } from "express";
import prisma from "../utils/prisma";
import { AuthRequest } from "../middlewares/auth";

export const createTransaction = async (req: AuthRequest, res: Response) => {
  try {
    const { id_producto, id_punto } = req.body;
    const userId = req.user?.id_usuario;

    if (!userId) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const product = await prisma.producto.findUnique({
      where: { id_producto: parseInt(id_producto as string) },
    });

    if (!product) {
      return res.status(404).json({ message: "Product not found" });
    }

    if (product.estado_disponibilidad !== "disponible") {
      return res.status(400).json({ message: "Product not available" });
    }

    if (product.id_usuario === userId) {
      return res
        .status(400)
        .json({ message: "You can't buy your own product" });
    }

    const point = await prisma.puntoSeguro.findUnique({
      where: { id_punto: parseInt(id_punto as string) },
    });

    if (!point) {
      return res.status(404).json({ message: "Safe point not found" });
    }

    const transaction = await prisma.transaccion.create({
      data: {
        id_comprador: userId,
        id_vendedor: product.id_usuario,
        id_producto: parseInt(id_producto as string),
        id_punto: parseInt(id_punto as string),
        monto: product.precio,
        estado_escrow: "pendiente",
      },
    });

    await prisma.producto.update({
      where: { id_producto: parseInt(id_producto as string) },
      data: { estado_disponibilidad: "reservado" },
    });

    await prisma.notificacion.createMany({
      data: [
        {
          id_usuario: product.id_usuario,
          titulo: "Producto Reservado",
          mensaje: `Tu producto ${product.nombre} ha sido reservado!`,
          tipo: "transaccion",
        },
        {
          id_usuario: userId,
          titulo: "Transacción Iniciada",
          mensaje: `Has iniciado la compra de ${product.nombre}!`,
          tipo: "transaccion",
        },
      ],
    });

    res
      .status(201)
      .json({ message: "Transaction created successfully", transaction });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
};

export const updateTransactionStatus = async (
  req: AuthRequest,
  res: Response
) => {
  try {
    const { id } = req.params;
    const txId = Array.isArray(id) ? id[0] : id;
    const { estado_escrow } = req.body;
    const userId = req.user?.id_usuario;

    if (!userId) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const transaction = await prisma.transaccion.findUnique({
      where: { id_transaccion: parseInt(txId as string) },
      include: { producto: true },
    });

    if (!transaction) {
      return res.status(404).json({ message: "Transaction not found" });
    }

    if (
      transaction.id_comprador !== userId &&
      transaction.id_vendedor !== userId
    ) {
      return res.status(403).json({ message: "Unauthorized" });
    }

    const updatedTransaction = await prisma.transaccion.update({
      where: { id_transaccion: parseInt(txId as string) },
      data: { estado_escrow },
    });

    if (estado_escrow === "completada") {
      await prisma.producto.update({
        where: { id_producto: transaction.id_producto },
        data: { estado_disponibilidad: "vendido" },
      });
    }

    await prisma.notificacion.createMany({
      data: [
        {
          id_usuario: transaction.id_vendedor,
          titulo: "Actualización de Transacción",
          mensaje: `La transacción de ${transaction.producto?.nombre} ha sido actualizada a ${estado_escrow}!`,
          tipo: "transaccion",
        },
        {
          id_usuario: transaction.id_comprador,
          titulo: "Actualización de Transacción",
          mensaje: `La transacción de ${transaction.producto?.nombre} ha sido actualizada a ${estado_escrow}!`,
          tipo: "transaccion",
        },
      ],
    });

    res.status(200).json({
      message: "Transaction updated successfully",
      transaction: updatedTransaction,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
};

export const getTransactions = async (req: AuthRequest, res: Response) => {
  try {
    const userId = req.user?.id_usuario;

    if (!userId) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const transactions = await prisma.transaccion.findMany({
      where: {
        OR: [{ id_comprador: userId }, { id_vendedor: userId }],
      },
      include: {
        producto: true,
        comprador: true,
        vendedor: true,
        puntoSeguro: true,
      },
    });

    res.status(200).json(transactions);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
};
