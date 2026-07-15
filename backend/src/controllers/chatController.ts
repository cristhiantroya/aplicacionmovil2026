import { Response } from "express";
import prisma from "../utils/prisma";
import { AuthRequest } from "../middlewares/auth";

export const createOrGetConversation = async (req: AuthRequest, res: Response) => {
  try {
    const { id_producto } = req.body;
    const userId = req.user?.id_usuario;

    if (!userId) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const producto = await prisma.producto.findUnique({
      where: { id_producto: Number(id_producto) },
      include: { usuario: true },
    });

    if (!producto) {
      return res.status(404).json({ message: "Product not found" });
    }

    const idVendedor = producto.id_usuario;

    // No puedes iniciar una conversación contigo mismo
    if (idVendedor === userId) {
      return res.status(400).json({ message: "no puedes iniciar una conversación contigo mismo" });
    }

    let conversacion = await prisma.conversacion.findFirst({
      where: {
        id_producto: Number(id_producto),
        id_comprador: userId,
      },
      include: {
        producto: true,
        comprador: true,
        vendedor: true,
        mensajes: {
          orderBy: { creado_en: "desc" },
          take: 1,
        },
      },
    });

    if (!conversacion) {
      conversacion = await prisma.conversacion.create({
        data: {
          id_producto: Number(id_producto),
          id_comprador: userId,
          id_vendedor: idVendedor,
        },
        include: {
          producto: true,
          comprador: true,
          vendedor: true,
          mensajes: {
            orderBy: { creado_en: "desc" },
            take: 1,
          },
        },
      });
    }

    const lastMsg = conversacion.mensajes[0] ?? null;
    const otherUser =
      conversacion.id_comprador === userId ? conversacion.vendedor : conversacion.comprador;

    res.status(200).json({
      id_conversacion: conversacion.id_conversacion,
      id_producto: conversacion.id_producto,
      producto: conversacion.producto,
      otherParticipant: {
        id_usuario: otherUser.id_usuario,
        nombre: otherUser.nombre,
      },
      ultimo_mensaje: lastMsg
        ? {
            id_mensaje: lastMsg.id_mensaje,
            id_conversacion: conversacion.id_conversacion,
            contenido: lastMsg.contenido,
            creado_en: lastMsg.creado_en,
            leido: lastMsg.leido,
            id_emisor: lastMsg.id_emisor,
          }
        : null,
      tiene_no_leidos: false,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
};

export const getConversations = async (req: AuthRequest, res: Response) => {
  try {
    const userId = req.user?.id_usuario;

    if (!userId) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const conversaciones = await prisma.conversacion.findMany({
      where: {
        OR: [{ id_comprador: userId }, { id_vendedor: userId }],
      },
      include: {
        producto: true,
        comprador: true,
        vendedor: true,
        mensajes: {
          orderBy: { creado_en: "desc" },
          take: 1,
        },
      },
      orderBy: { creado_en: "desc" },
    });

    const mapped = conversaciones.map((c) => {
      const lastMsg = c.mensajes[0] ?? null;
      const otherUser =
        c.id_comprador === userId ? c.vendedor : c.comprador;

      return {
        id_conversacion: c.id_conversacion,
        id_producto: c.id_producto,
        producto: c.producto,
        otherParticipant: {
          id_usuario: otherUser?.id_usuario,
          nombre: otherUser?.nombre,
        },
        ultimo_mensaje: lastMsg
          ? {
              id_mensaje: lastMsg.id_mensaje,
              id_conversacion: c.id_conversacion,
              contenido: lastMsg.contenido,
              creado_en: lastMsg.creado_en,
              leido: lastMsg.leido,
              id_emisor: lastMsg.id_emisor,
            }
          : null,
      };
    });

    // Recalcular tiene_no_leidos correctamente con query extra
    const withUnread = await Promise.all(
      mapped.map(async (m) => {
        const conv = await prisma.conversacion.findUnique({
          where: { id_conversacion: m.id_conversacion },
          include: {
            mensajes: {
              where: { leido: false, id_emisor: { not: userId } },
            },
          },
        });

        return {
          ...m,
          tiene_no_leidos: (conv?.mensajes?.length ?? 0) > 0,
        };
      })
    );

    res.status(200).json(withUnread);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
};

export const getConversationMessages = async (req: AuthRequest, res: Response) => {
  try {
    const { id } = req.params;
    const userId = req.user?.id_usuario;

    if (!userId) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const conversation = await prisma.conversacion.findUnique({
      where: { id_conversacion: Number(id) },
      include: {
        comprador: true,
        vendedor: true,
      },
    });

    if (!conversation) {
      return res.status(404).json({ message: "Conversation not found" });
    }

    const isParticipant =
      conversation.id_comprador === userId || conversation.id_vendedor === userId;

    if (!isParticipant) {
      return res.status(403).json({ message: "No tienes permiso sobre este recurso" });
    }

    const mensajes = await prisma.mensaje.findMany({
      where: { id_conversacion: Number(id) },
      orderBy: { creado_en: "asc" },
      include: { emisor: true },
    });

    res.status(200).json(mensajes);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
};

export const sendMessage = async (req: AuthRequest, res: Response) => {
  try {
    const { id } = req.params;
    const { contenido } = req.body;
    const userId = req.user?.id_usuario;

    if (!userId) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const conversation = await prisma.conversacion.findUnique({
      where: { id_conversacion: Number(id) },
      include: { comprador: true, vendedor: true },
    });

    if (!conversation) {
      return res.status(404).json({ message: "Conversation not found" });
    }

    const isParticipant =
      conversation.id_comprador === userId || conversation.id_vendedor === userId;

    if (!isParticipant) {
      return res.status(403).json({ message: "No tienes permiso sobre este recurso" });
    }

    const nuevoMensaje = await prisma.mensaje.create({
      data: {
        id_conversacion: Number(id),
        id_emisor: userId,
        contenido,
      },
      include: { emisor: true },
    });

    res.status(201).json(nuevoMensaje);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
};

export const markAsRead = async (req: AuthRequest, res: Response) => {
  try {
    const { id } = req.params;
    const userId = req.user?.id_usuario;

    if (!userId) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const conversation = await prisma.conversacion.findUnique({
      where: { id_conversacion: Number(id) },
      include: { comprador: true, vendedor: true },
    });

    if (!conversation) {
      return res.status(404).json({ message: "Conversation not found" });
    }

    const isParticipant =
      conversation.id_comprador === userId || conversation.id_vendedor === userId;

    if (!isParticipant) {
      return res.status(403).json({ message: "No tienes permiso sobre este recurso" });
    }

    await prisma.mensaje.updateMany({
      where: {
        id_conversacion: Number(id),
        leido: false,
        id_emisor: { not: userId },
      },
      data: { leido: true },
    });

    res.status(200).json({ message: "Messages marked as read" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
};