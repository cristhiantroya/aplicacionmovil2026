import express from "express";
import {
  createVerification,
  getVerification,
  reviewVerification,
} from "../controllers/verificationController";
import { authenticateToken } from "../middlewares/auth";
import { isAdmin } from "../middlewares/isAdmin";

const router = express.Router();

router.post("/", authenticateToken, createVerification);
router.get("/", authenticateToken, getVerification);
router.patch("/:id", authenticateToken, isAdmin, reviewVerification);

export default router;