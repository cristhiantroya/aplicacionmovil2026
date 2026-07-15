import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import swaggerJsdoc from "swagger-jsdoc";
import swaggerUi from "swagger-ui-express";
import authRoutes from "./routes/authRoutes";
import productRoutes from "./routes/productRoutes";
import transactionRoutes from "./routes/transactionRoutes";
import ratingRoutes from "./routes/ratingRoutes";
import verificationRoutes from "./routes/verificationRoutes";
import pointRoutes from "./routes/pointRoutes";
import notificationRoutes from "./routes/notificationRoutes";
import chatRoutes from "./routes/chatRoutes";

dotenv.config();

// Validate required environment variables
const requiredEnvVars = ["JWT_SECRET", "CLOUDINARY_CLOUD_NAME", "CLOUDINARY_API_KEY", "CLOUDINARY_API_SECRET"];
const missingEnvVars = requiredEnvVars.filter((varName) => !process.env[varName]);

if (missingEnvVars.length > 0) {
  console.error(
    `Error: Missing required environment variables: ${missingEnvVars.join(", ")}`
  );
  process.exit(1);
}

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

// Swagger configuration
const swaggerOptions = {
  definition: {
    openapi: "3.0.0",
    info: {
      title: "CompraSegura API",
      version: "1.0.0",
      description: "API para la aplicación CompraSegura",
    },
    servers: [
      {
        url: `http://localhost:${PORT}`,
      },
    ],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: "http",
          scheme: "bearer",
          bearerFormat: "JWT",
        },
      },
    },
    security: [{ bearerAuth: [] }],
  },
  apis: ["./src/routes/*.ts"], // Rutas a los archivos de rutas con comentarios JSDoc
};

const swaggerDocs = swaggerJsdoc(swaggerOptions);
app.use("/api-docs", swaggerUi.serve, swaggerUi.setup(swaggerDocs));

app.use("/api/auth", authRoutes);
app.use("/api/products", productRoutes);
app.use("/api/transactions", transactionRoutes);
app.use("/api/ratings", ratingRoutes);
app.use("/api/verifications", verificationRoutes);
app.use("/api/points", pointRoutes);
app.use("/api/notifications", notificationRoutes);
app.use("/api/chat", chatRoutes);

app.get("/", (req, res) => {
  res.json({ message: "CompraSegura API is running!" });
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
  console.log(`Swagger documentation available at http://localhost:${PORT}/api-docs`);
});
