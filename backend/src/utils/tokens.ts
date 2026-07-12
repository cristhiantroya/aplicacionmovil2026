import crypto from "crypto";
import jwt, { SignOptions } from "jsonwebtoken";

// Genera el access token (JWT de vida corta) incluyendo id y rol
export const generateAccessToken = (id_usuario: number, rol: string) => {
  const signOptions: SignOptions = {
    expiresIn: (process.env.ACCESS_TOKEN_EXPIRES_IN as any) || "15m",
  };
  return jwt.sign(
    { id: id_usuario, rol },
    process.env.JWT_SECRET as string,
    signOptions
  );
};

// Genera el refresh token: NO es un JWT, es un valor aleatorio opaco.
// Solo se guarda su hash en la base de datos (nunca el valor real).
export const generateRefreshToken = () => {
  return crypto.randomBytes(40).toString("hex");
};

// Hashea el refresh token para guardarlo/compararlo en la base de datos
export const hashToken = (token: string) => {
  return crypto.createHash("sha256").update(token).digest("hex");
};

// Calcula la fecha de expiración del refresh token (por defecto 30 días)
export const getRefreshExpiryDate = () => {
  const days = Number(process.env.REFRESH_TOKEN_EXPIRES_DAYS) || 30;
  const date = new Date();
  date.setDate(date.getDate() + days);
  return date;
};