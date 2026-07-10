import express from "express";
import { getSafePoints, createSafePoint } from "../controllers/pointController";

const router = express.Router();

router.get("/", getSafePoints);
router.post("/", createSafePoint);

export default router;
