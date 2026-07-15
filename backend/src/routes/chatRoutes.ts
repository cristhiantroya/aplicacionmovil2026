import express from "express";
import { authenticateToken } from "../middlewares/auth";
import { validate, mensajeSchema } from "../middlewares/validation";
import {
  createOrGetConversation,
  getConversations,
  getConversationMessages,
  sendMessage,
  markAsRead,
} from "../controllers/chatController";

const router = express.Router();

/**
 * @swagger
 * /api/chat/conversaciones:
 *   post:
 *     summary: Create or retrieve a conversation
 *     tags: [Chat]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               id_producto:
 *                 type: integer
 *     responses:
 *       200:
 *         description: Conversation returned
 *       400:
 *         description: Cannot start conversation with yourself
 */
router.post("/conversaciones", authenticateToken, createOrGetConversation);

/**
 * @swagger
 * /api/chat/conversaciones:
 *   get:
 *     summary: List conversations of the authenticated user
 *     tags: [Chat]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: List of conversations
 */
router.get("/conversaciones", authenticateToken, getConversations);

/**
 * @swagger
 * /api/chat/conversaciones/{id}/mensajes:
 *   get:
 *     summary: List messages of a conversation
 *     tags: [Chat]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Messages list
 *       403:
 *         description: Forbidden
 */
router.get("/conversaciones/:id/mensajes", authenticateToken, getConversationMessages);

/**
 * @swagger
 * /api/chat/conversaciones/{id}/mensajes:
 *   post:
 *     summary: Send a new message
 *     tags: [Chat]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               contenido:
 *                 type: string
 *     responses:
 *       201:
 *         description: Message created
 *       400:
 *         description: Validation error
 *       403:
 *         description: Forbidden
 */
router.post("/conversaciones/:id/mensajes", authenticateToken, validate(mensajeSchema), sendMessage);

/**
 * @swagger
 * /api/chat/conversaciones/{id}/leido:
 *   patch:
 *     summary: Mark messages as read
 *     tags: [Chat]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Marked as read
 *       403:
 *         description: Forbidden
 */
router.patch("/conversaciones/:id/leido", authenticateToken, markAsRead);

export default router;
