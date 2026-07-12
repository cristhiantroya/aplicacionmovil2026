import express from "express";
import {
  getProducts,
  getProductById,
  createProduct,
  getUserProducts,
  updateProduct,
  deleteProduct,
} from "../controllers/productController";
import { authenticateToken } from "../middlewares/auth";
import { validate, productSchema, updateProductSchema } from "../middlewares/validation";

const router = express.Router();

/**
 * @swagger
 * /api/products:
 *   get:
 *     summary: Get all available products
 *     tags: [Products]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: List of products
 */
router.get("/", authenticateToken, getProducts);

/**
 * @swagger
 * /api/products/user:
 *   get:
 *     summary: Get products of the authenticated user
 *     tags: [Products]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: List of user products
 */
router.get("/user", authenticateToken, getUserProducts);

/**
 * @swagger
 * /api/products/{id}:
 *   get:
 *     summary: Get a product by ID
 *     tags: [Products]
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
 *         description: Product details
 *       404:
 *         description: Product not found
 */
router.get("/:id", authenticateToken, getProductById);

/**
 * @swagger
 * /api/products:
 *   post:
 *     summary: Create a new product
 *     tags: [Products]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               nombre:
 *                 type: string
 *               descripcion:
 *                 type: string
 *                 optional: true
 *               precio:
 *                 type: string
 *               estado_uso:
 *                 type: string
 *                 enum: [nuevo, usado]
 *     responses:
 *       201:
 *         description: Product created successfully
 *       400:
 *         description: Invalid data
 *       403:
 *         description: User not verified
 */
router.post("/", authenticateToken, validate(productSchema), createProduct);

/**
 * @swagger
 * /api/products/{id}:
 *   put:
 *     summary: Update a product
 *     tags: [Products]
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
 *               nombre:
 *                 type: string
 *               descripcion:
 *                 type: string
 *               precio:
 *                 type: string
 *               estado_uso:
 *                 type: string
 *                 enum: [nuevo, usado]
 *     responses:
 *       200:
 *         description: Product updated successfully
 *       403:
 *         description: Not allowed to update this product
 */
router.put("/:id", authenticateToken, validate(updateProductSchema), updateProduct);

/**
 * @swagger
 * /api/products/{id}:
 *   delete:
 *     summary: Delete a product
 *     tags: [Products]
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
 *         description: Product deleted successfully
 *       403:
 *         description: Not allowed to delete this product
 */
router.delete("/:id", authenticateToken, deleteProduct);

export default router;
