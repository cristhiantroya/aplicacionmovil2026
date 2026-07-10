import express from "express";
import {
  getProducts,
  getProductById,
  createProduct,
  getUserProducts,
} from "../controllers/productController";
import { authenticateToken } from "../middlewares/auth";

const router = express.Router();

router.get("/", getProducts);
router.get("/user", authenticateToken, getUserProducts);
router.get("/:id", getProductById);
router.post("/", authenticateToken, createProduct);

export default router;
