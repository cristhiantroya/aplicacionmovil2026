import { Request, Response, NextFunction } from "express";
import { z } from "zod";

// Validation Schemas
export const registerSchema = z.object({
  nombre: z.string().min(1, "El nombre es requerido"),
  correo: z.string().email("Correo electrónico inválido"),
  contrasena: z.string().min(8, "La contraseña debe tener al menos 8 caracteres"),
  documento_identidad: z.string().min(1, "El documento de identidad es requerido"),
  telefono: z.string().optional(),
});

export const loginSchema = z.object({
  correo: z.string().email("Correo electrónico inválido"),
  contrasena: z.string().min(1, "La contraseña es requerida"),
});

export const productSchema = z.object({
  nombre: z.string().min(1, "El nombre es requerido"),
  descripcion: z.string().optional(),
  precio: z.number().positive("El precio debe ser un número mayor que 0"),
  estado_uso: z.enum(["nuevo", "usado"], {
      message: "El estado de uso debe ser 'nuevo' o 'usado'",
  }),
});
export const updateProductSchema = productSchema.partial();
export const transactionSchema = z.object({
  id_producto: z.number().int().positive("El id del producto debe ser un número válido y positivo"),
  id_punto: z.number().int().positive("El id del punto seguro debe ser un número válido y positivo"),
});

// Middleware to validate request body against a schema
export const validate = (schema: z.ZodSchema) => {
  return (req: Request, res: Response, next: NextFunction) => {
    try {
      schema.parse(req.body);
      next();
    } catch (error) {
      if (error instanceof z.ZodError) {
        const errors = error.issues.map((issue) => ({
          field: issue.path[0],
          message: issue.message,
        }));
        return res.status(400).json({ message: "Validation error", errors });
      }
      res.status(500).json({ message: "Internal server error" });
    }
  };
};
