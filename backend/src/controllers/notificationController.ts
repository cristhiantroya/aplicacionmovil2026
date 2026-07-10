import { Response } from "express";
import prisma from "../utils/prisma";
import { AuthRequest } from "../middlewares/auth";

export const getNotifications = async (req: AuthRequest, res: Response) => {
  try {
    const userId = req.user?.id_usuario;

    if (!userId) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const notifications = await prisma.notificacion.findMany({
      where: { id_usuario: userId },
      orderBy: { fecha_envio: "desc" },
    });

    res.status(200).json(notifications);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
};

export const markNotificationAsRead = async (
  req: AuthRequest,
  res: Response
) => {
  try {
    const { id } = req.params;
    const userId = req.user?.id_usuario;

    if (!userId) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    // Usamos String(id) para asegurar que TypeScript sepa que es un texto simple
    const notificationId = parseInt(String(id));

    const notification = await prisma.notificacion.findUnique({
      where: { id_notificacion: notificationId },
    });

    if (!notification || notification.id_usuario !== userId) {
      return res.status(404).json({ message: "Notification not found" });
    }

    const updatedNotification = await prisma.notificacion.update({
      where: { id_notificacion: notificationId },
      data: { leido: true },
    });

    res.status(200).json({
      message: "Notification marked as read",
      notification: updatedNotification,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
};

