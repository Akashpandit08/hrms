import jwt from 'jsonwebtoken';
import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();

const checkRole = (roles) => {
    return async (req, res, next) => {
        try {
            
            const token = req.headers.authorization?.split(" ")[1]; 

            if (!token) {
                return res.status(403).json({ message: "No token provided!" });
            }

            // Verify the token
            const decoded = jwt.verify(token, process.env.JWT_SECRET);

            // Find the user by ID from the token
            const user = await prisma.user.findUnique({
                where: { id: decoded.userId },
            });

            if (!user) {
                return res.status(404).json({ message: "User not found!" });
            }

            // Check if user role matches the required role(s)
            if (!roles.includes(user.role)) {
                return res.status(403).json({ message: "Forbidden: Insufficient permissions" });
            }

            // Add user info to request object for use in other middleware/routes
            req.user = user;
            next();
        } catch (error) {
            console.error("Error checking role:", error);
            return res.status(500).json({ message: "Internal server error" });
        }
    };
};

export default checkRole;
