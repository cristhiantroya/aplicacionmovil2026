import express from "express";
import {
  createRating,
  getUserRatings,
} from "../controllers/ratingController";
import { authenticateToken } from "../middlewares/auth";

const router = express.Router();

router.post("/", authenticateToken, createRating);
router.get("/user", authenticateToken, getUserRatings);

export default router;
