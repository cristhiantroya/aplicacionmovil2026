import { Response } from "express";
import prisma from "../utils/prisma";
import { AuthRequest } from "../middlewares/auth";
import cloudinary from "../utils/cloudinary";
import cache from "../utils/cache";
import { enqueueImagenProducto } from "../utils/imageQueue";

const normalizeParamToString = (value: string | string[] | undefined) => {
  if (Array.isArray(value)) return value[0];
  return value;
};

export const getProducts = async (req: AuthRequest, res: Response) => {
  try {
    const cacheKey = "products:list";
    const cached = cache.get(cacheKey);

    if (cached) {
      console.log(`🟢 CACHE HIT: ${cacheKey}`);
      return res.status(200).json(cached);
    }

    console.log(`🔴 CACHE MISS: ${cacheKey}`);
    const products = await prisma.producto.findMany({
      where: { estado_disponibilidad: "disponible" },
      // Lazy loading parcial para performance:
      // - Lista (home): solo necesitamos una miniatura (1 imagen) por producto.
      // - Detalle (productById): se incluyen todas las imágenes para que el usuario vea todas.
      include: {
        usuario: true,
        imagenes: { take: 1, orderBy: { id_imagen: "asc" } },
      },
    });

    cache.set(cacheKey, products);
    res.status(200).json(products);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
};

export const getProductById = async (req: AuthRequest, res: Response) => {
  try {
    const { id } = req.params;
    const productId = normalizeParamToString(id);

    const product = await prisma.producto.findUnique({
      where: { id_producto: parseInt(productId as string) },
      // Detalle del producto: se requiere mostrar TODAS las imágenes.
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

    cache.del("products:list");
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
    const productId = normalizeParamToString(id);

    const { nombre, descripcion, precio, estado_uso, categoria, ubicacion } = req.body;
    const userId = req.user?.id_usuario;
    const userRole = req.user?.rol;

    if (!userId) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const product = await prisma.producto.findUnique({
      where: { id_producto: parseInt(productId as string) },
    });

    if (!product) {
      return res.status(404).json({ message: "Product not found" });
    }

    // Verificar propiedad o rol admin
    if (product.id_usuario !== userId && userRole !== "admin") {
      return res.status(403).json({ message: "No tienes permiso sobre este recurso" });
    }

    const updatedProduct = await prisma.producto.update({
      where: { id_producto: parseInt(productId as string) },
      data: {
        nombre: nombre || product.nombre,
        descripcion: descripcion !== undefined ? descripcion : product.descripcion,
        precio: precio ? parseFloat(precio) : product.precio,
        estado_uso: estado_uso || product.estado_uso,
        categoria: categoria || product.categoria,
        ubicacion: ubicacion !== undefined ? ubicacion : product.ubicacion,
      },
    });
    cache.del("products:list");
    res.status(200).json({ message: "Product updated successfully", product: updatedProduct });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
};

export const deleteProduct = async (req: AuthRequest, res: Response) => {
  try {
    const { id } = req.params;
    const productId = normalizeParamToString(id);

    const userId = req.user?.id_usuario;
    const userRole = req.user?.rol;

    if (!userId) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const product = await prisma.producto.findUnique({
      where: { id_producto: parseInt(productId as string) },
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
      where: { id_producto: parseInt(productId as string) },
    });

    cache.del("products:list");
    res.status(200).json({ message: "Product deleted successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
};

export const addProductImage = async (req: AuthRequest, res: Response) => {
  try {
    const { id } = req.params;
    const productId = normalizeParamToString(id);

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
      where: { id_producto: parseInt(productId as string) },
    });

    if (!product) {
      return res.status(404).json({ message: "Product not found" });
    }

    // Verificar propiedad o rol admin
    if (product.id_usuario !== userId && userRole !== "admin") {
      return res
        .status(403)
        .json({ message: "No tienes permiso sobre este recurso" });
    }

    // 1) Crear registro inmediatamente como "procesando" (url aún null)
    const image = await prisma.imagenProducto.create({
      data: {
        id_producto: parseInt(productId as string),
        estado: "procesando",
      },
    });

    // 2) Encolar el trabajo en background
    await enqueueImagenProducto({
      id_imagen: image.id_imagen,
      id_producto: image.id_producto,
      buffer: file.buffer as Buffer,
    });

    // 3) Responder en seguida (202 Accepted)
    res.status(202).json({
      message: "Image enqueued for processing",
      image,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
};

export const deleteProductImage = async (req: AuthRequest, res: Response) => {
  try {
    const { id, imageId } = req.params;
    const productId = normalizeParamToString(id);
    const imageIdStr = normalizeParamToString(imageId);

    const userId = req.user?.id_usuario;
    const userRole = req.user?.rol;

    if (!userId) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const image = await prisma.imagenProducto.findUnique({
      where: { id_imagen: parseInt(imageIdStr as string) },
      include: { producto: true },
    });

    if (!image) {
      return res.status(404).json({ message: "Image not found" });
    }

    // Verificar que la imagen pertenece al producto y el usuario es dueño o admin
    if (
      image.id_producto !== parseInt(productId as string) ||
      (image.producto.id_usuario !== userId && userRole !== "admin")
    ) {
      return res.status(403).json({ message: "No tienes permiso sobre este recurso" });
    }

    // Delete from Cloudinary (extract public ID from URL)
    if (image.url) {
      const publicId = image.url.split("/").pop()?.split(".")[0];
      if (publicId) {
        await cloudinary.uploader.destroy(`comprasegura/productos/${publicId}`);
      }
    }

    await prisma.imagenProducto.delete({
      where: { id_imagen: parseInt(imageIdStr as string) },
    });

    res.status(200).json({ message: "Image deleted successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
};
