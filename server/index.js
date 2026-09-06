import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import path from "path";
import { fileURLToPath } from "url";
import apiRouter from "./routes/api.js";

dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const PORT = process.env.PORT || 5001;

// Middleware
app.use(cors());
app.use(express.json());

// API Endpoints
app.use("/api", apiRouter);

// Root information endpoint
app.get("/", (req, res) => {
  res.json({
    product: "ACADDIE",
    tagline: "Think. Simulate. Decide.",
    version: "1.0.0",
    docs: "/api/curriculum, /api/demo-scenarios, /api/simulate, /api/history"
  });
});

// Start Express Server
app.listen(PORT, () => {
  console.log(`====================================================`);
  console.log(`  ACADDIE Academic Change Impact Simulator Server`);
  console.log(`  Running at: http://localhost:${PORT}`);
  console.log(`  API Base:   http://localhost:${PORT}/api`);
  console.log(`====================================================`);
});
