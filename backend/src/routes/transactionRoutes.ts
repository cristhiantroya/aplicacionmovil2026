import express from "express";
import {
  createTransaction,
  updateTransactionStatus,
  getTransactions,
} from "../controllers/transactionController";
import { authenticateToken } from "../middlewares/auth";
import { validate, transactionSchema } from "../middlewares/validation";

const router = express.Router();

router.post("/", authenticateToken, validate(transactionSchema), createTransaction);
router.put("/:id", authenticateToken, updateTransactionStatus);
router.get("/", authenticateToken, getTransactions);

export default router;
