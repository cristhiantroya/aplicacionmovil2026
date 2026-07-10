import express from "express";
import {
  getNotifications,
  markNotificationAsRead,
} from "../controllers/notificationController";
import { authenticateToken } from "../middlewares/auth";

const router = express.Router();

router.get("/", authenticateToken, getNotifications);
router.put("/:id/read", authenticateToken, markNotificationAsRead);

export default router;
