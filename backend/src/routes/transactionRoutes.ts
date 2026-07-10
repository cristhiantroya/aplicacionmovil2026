import express from "express";
import {
  createTransaction,
  updateTransactionStatus,
  getTransactions,
} from "../controllers/transactionController";
import { authenticateToken } from "../middlewares/auth";

const router = express.Router();

router.post("/", authenticateToken, createTransaction);
router.put("/:id", authenticateToken, updateTransactionStatus);
router.get("/", authenticateToken, getTransactions);

export default router;
