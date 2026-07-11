import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import authRoutes from "./routes/authRoutes";
import productRoutes from "./routes/productRoutes";
import transactionRoutes from "./routes/transactionRoutes";
import ratingRoutes from "./routes/ratingRoutes";
import verificationRoutes from "./routes/verificationRoutes";
import pointRoutes from "./routes/pointRoutes";
import notificationRoutes from "./routes/notificationRoutes";

dotenv.config();
console.log("Duración configurada del access token:", process.env.ACCESS_TOKEN_EXPIRES_IN);

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());
app.use((req, res, next) => {
  console.log(`➡️  ${req.method} ${req.path}`);
  res.on("finish", () => {
    console.log(`⬅️  ${req.method} ${req.path} - ${res.statusCode}`);
  });
  next();
});

app.use("/api/auth", authRoutes);
app.use("/api/products", productRoutes);
app.use("/api/transactions", transactionRoutes);
app.use("/api/ratings", ratingRoutes);
app.use("/api/verifications", verificationRoutes);
app.use("/api/points", pointRoutes);
app.use("/api/notifications", notificationRoutes);

app.get("/", (req, res) => {
  res.json({ message: "CompraSegura API is running!" });
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
