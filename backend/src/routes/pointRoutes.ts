import express from "express";
import { getSafePoints, createSafePoint } from "../controllers/pointController";
import { authenticateToken } from "../middlewares/auth";

const router = express.Router();

router.get("/", getSafePoints); // Public, según petición del usuario
router.post("/", authenticateToken, createSafePoint); // Requiere autenticación

export default router;
