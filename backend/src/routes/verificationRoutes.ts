import express from "express";
import {
  createVerification,
  getVerification,
  reviewVerification,
} from "../controllers/verificationController";
import { authenticateToken } from "../middlewares/auth";
import { isAdmin } from "../middlewares/isAdmin";

const router = express.Router();

/**
 * @swagger
 * /api/verifications:
 *   post:
 *     summary: Request a new verification
 *     tags: [Verifications]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       201:
 *         description: Verification request created
 */
router.post("/", authenticateToken, createVerification);

/**
 * @swagger
 * /api/verifications:
 *   get:
 *     summary: Get the authenticated user's verification
 *     tags: [Verifications]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Verification details
 */
router.get("/", authenticateToken, getVerification);

/**
 * @swagger
 * /api/verifications/{id}:
 *   patch:
 *     summary: Review a verification (admin only)
 *     tags: [Verifications]
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
 *               estado:
 *                 type: string
 *                 enum: [aprobado, rechazado]
 *     responses:
 *       200:
 *         description: Verification reviewed successfully
 */
router.patch("/:id", authenticateToken, isAdmin, reviewVerification);

export default router;