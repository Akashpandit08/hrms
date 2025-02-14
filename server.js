import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import bodyParser from "body-parser";
import { connectDatabase } from "./src/config/db.js";
import authRoutes from "./src/routes/authRouter.js";
import employeeRoutes from "./src/routes/employeeRouter.js";
dotenv.config();



const app = express();

app.use(express.json({ limit: "200mb" }));
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use('/uploads', express.static('uploads'));




// Establish database connection
connectDatabase()
    .then(() => {
        console.log("Database connected successfully");
    })
    .catch((error) => {
        console.error("Database connection failed:", error);
        process.exit(1);
    });

app.use(cors({
    origin: ["https://yourfrontend.com", "http://localhost:3000"],
    credentials: true
}));


app.use("/api/v1/auth", authRoutes);
app.use("/api/v1/employee", employeeRoutes);


app.get("/health-check", (req, res) => {
    return res.send("Server is healthy!");
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});

// Global error handlers
process.on("uncaughtException", (err) => {
    console.error("Uncaught Exception:", err);
});

process.on("unhandledRejection", (reason) => {
    console.error("Unhandled Rejection:", reason);
});
