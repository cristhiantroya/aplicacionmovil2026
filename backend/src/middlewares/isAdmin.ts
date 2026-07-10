import { Response, NextFunction } from "express";
import { AuthRequest } from "./auth";

export const isAdmin = (req: AuthRequest, res: Response, next: NextFunction) => {
    console.log("Usuario en la petición:", req.user);
  if (!req.user || req.user.rol !== "admin") {
    return res.status(403).json({ message: "Admin access required" });
  }
  next();
};