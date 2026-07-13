import { Response } from "express";
import prisma from "../utils/prisma";
import { AuthRequest } from "../middlewares/auth";
import cloudinary from "../utils/cloudinary";

export const getProducts = async (req: AuthRequest, res: Response) => {
  try {
    const products = await prisma.producto.findMany({
      where: { estado_disponibilidad: "disponible" },
      include: { usuario: true, imagenes: true },
    });

    res.status(200).json(products);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
};

export const getProductById = async (req: AuthRequest, res: Response) => {
  try {
    const { id } = req.params;
    const product = await prisma.producto.findUnique({
      where: { id_producto: parseInt(id) },
      include: { usuario: true, imagenes: true },
    });

    if (!product) {
      return res.status(404).json({ message: "Product not found" });
    }

    res.status(200).json(product);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
};

export const createProduct = async (req: AuthRequest, res: Response) => {
  try {
    const { nombre, descripcion, precio, estado_uso, categoria, ubicacion } = req.body;
    const userId = req.user?.id_usuario;

    if (!userId) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const userVerification = await prisma.verificacion.findFirst({
      where: { id_usuario: userId, estado: "aprobado" },
    });

    if (!userVerification) {
      return res
        .status(403)
        .json({ message: "User must be verified to post products" });
    }

    const product = await prisma.producto.create({
      data: {
        id_usuario: userId,
        nombre,
        descripcion,
        precio: parseFloat(precio),
        estado_uso,
        categoria,
        ubicacion,
      },
    });

    res.status(201).json({ message: "Product created successfully", product });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
};

export const getUserProducts = async (req: AuthRequest, res: Response) => {
  try {
    const userId = req.user?.id_usuario;

    if (!userId) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const products = await prisma.producto.findMany({
      where: { id_usuario: userId },
      include: { imagenes: true },
    });

    res.status(200).json(products);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
};

export const updateProduct = async (req: AuthRequest, res: Response) => {
  try {
    const { id } = req.params;
    const { nombre, descripcion, precio, estado_uso, categoria, ubicacion } = req.body;
    const userId = req.user?.id_usuario;
    const userRole = req.user?.rol;

    if (!userId) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const product = await prisma.producto.findUnique({
      where: { id_producto: parseInt(id) },
    });

    if (!product) {
      return res.status(404).json({ message: "Product not found" });
    }

    // Verificar propiedad o rol admin
    if (product.id_usuario !== userId && userRole !== "admin") {
      return res.status(403).json({ message: "No tienes permiso sobre este recurso" });
    }

    const updatedProduct = await prisma.producto.update({
      where: { id_producto: parseInt(id) },
      data: {
        nombre: nombre || product.nombre,
        descripcion: descripcion !== undefined ? descripcion : product.descripcion,
        precio: precio ? parseFloat(precio) : product.precio,
        estado_uso: estado_uso || product.estado_uso,
        categoria: categoria || product.categoria,
        ubicacion: ubicacion !== undefined ? ubicacion : product.ubicacion,
      },
    });

    res.status(200).json({ message: "Product updated successfully", product: updatedProduct });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
};

export const deleteProduct = async (req: AuthRequest, res: Response) => {
  try {
    const { id } = req.params;
    const userId = req.user?.id_usuario;
    const userRole = req.user?.rol;

    if (!userId) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const product = await prisma.producto.findUnique({
      where: { id_producto: parseInt(id) },
      include: { transacciones: true },
    });

    if (!product) {
      return res.status(404).json({ message: "Product not found" });
    }

    // Verificar propiedad o rol admin
    if (product.id_usuario !== userId && userRole !== "admin") {
      return res.status(403).json({ message: "No tienes permiso sobre este recurso" });
    }

    // Verificar que no haya transacciones activas
    const hasActiveTransaction = product.transacciones.some(
      (t) => t.estado_escrow === "pendiente"
    );
    if (hasActiveTransaction) {
      return res.status(400).json({
        message: "No se puede eliminar el producto porque tiene transacciones activas",
      });
    }

    await prisma.producto.delete({
      where: { id_producto: parseInt(id) },
    });

    res.status(200).json({ message: "Product deleted successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
};

export const addProductImage = async (req: AuthRequest, res: Response) => {
  try {
    const { id } = req.params;
    const userId = req.user?.id_usuario;
    const userRole = req.user?.rol;
    const file = req.file;

    if (!userId) {
      return res.status(401).json({ message: "Unauthorized" });
    }
    if (!file) {
      return res.status(400).json({ message: "No image file provided" });
    }

    const product = await prisma.producto.findUnique({
      where: { id_producto: parseInt(id) },
    });

    if (!product) {
      return res.status(404).json({ message: "Product not found" });
    }

    // Verificar propiedad o rol admin
    if (product.id_usuario !== userId && userRole !== "admin") {
      return res.status(403).json({ message: "No tienes permiso sobre este recurso" });
    }

    // Upload to Cloudinary
    const uploadResult = await new Promise<any>((resolve, reject) => {
      const uploadStream = cloudinary.uploader.upload_stream(
        { folder: "comprasegura/productos" },
        (error, result) => {
          if (error) reject(error);
          else resolve(result);
        }
      );
      uploadStream.end(file.buffer);
    });

    const image = await prisma.imagenProducto.create({
      data: {
        id_producto: parseInt(id),
        url: uploadResult.secure_url,
      },
    });

    res.status(201).json({ message: "Image added successfully", image });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
};

export const deleteProductImage = async (req: AuthRequest, res: Response) => {
  try {
    const { id, imageId } = req.params;
    const userId = req.user?.id_usuario;
    const userRole = req.user?.rol;

    if (!userId) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const image = await prisma.imagenProducto.findUnique({
      where: { id_imagen: parseInt(imageId) },
      include: { producto: true },
    });

    if (!image) {
      return res.status(404).json({ message: "Image not found" });
    }

    // Verificar que la imagen pertenece al producto y el usuario es dueño o admin
    if (
      image.id_producto !== parseInt(id) ||
      (image.producto.id_usuario !== userId && userRole !== "admin")
    ) {
      return res.status(403).json({ message: "No tienes permiso sobre este recurso" });
    }

    // Delete from Cloudinary (extract public ID from URL)
    const publicId = image.url.split("/").pop()?.split(".")[0];
    if (publicId) {
      await cloudinary.uploader.destroy(`comprasegura/productos/${publicId}`);
    }

    await prisma.imagenProducto.delete({
      where: { id_imagen: parseInt(imageId) },
    });

    res.status(200).json({ message: "Image deleted successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
};
