import prisma from "../config/prisma.js";
import { registerSchema, loginSchema } from "../types/auth.types.js";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken"



const register = async (req, res) => {
    console.log('Request Content-Type:', req.headers['content-type']);
    console.log('Request body:', req.body);
    const {  username, password, role  } = req.body;
    console.log(req.body);
    const { error} = registerSchema.safeParse(req.body);
    if (error){
        return res.status(400).json({
            message: error.message,
            success: false,
            error: error.format(),
        })
    }
    const existingUser = await prisma.employee.findUnique({
        where: { username },
    });
    if (existingUser) {
        return res.status(400).json({
            message: "User already exists",
            success: false,
        });
    }
    const hashedPassword = await bcrypt.hash(password, 10);
    const user = await prisma.employee.create({
        data: {
             username,
            role,
             password: hashedPassword },
    });
    const token = jwt.sign({ userId: user.id ,role: user.role}, process.env.JWT_SECRET, { expiresIn: "1h" });
    res.status(201).json({
        message: "User created successfully",
        success: true,
        user,
        token,
    });
};

const login = async (req, res) => {
    const { username, password } = req.body;
    const { error } = loginSchema.safeParse(req.body);
    if (error) {        
        return res.status(400).json({
            message: error.message,
            success: false,
            error: error.format(),
        });
    }   
    const user = await prisma.employee.findUnique({
        where: { username },
    });
    if (!user) {
        return res.status(400).json({   
            message: "Invalid credentials",
            success: false,
        });
    }
    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) { 
        return res.status(400).json({
            message: "Invalid credentials",
            success: false,
        });
    }
    const token = jwt.sign({ userId: user.id , role:user.role }, process.env.JWT_SECRET, { expiresIn: "1h" });   
    res.status(200).json({
        message: "Login successful",
        success: true,
        user,
        token,
    });
};  

const logout = async (req, res) => {
    res.clearCookie("token");
    res.status(200).json({
        message: "Logout successful",
        success: true,
    });
};  

const verifyToken = async (req, res) => {
    const token = req.headers.authorization;
    if (!token) {
        return res.status(401).json({
            message: "Unauthorized",    
            success: false,
        });
    }
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next();
};  

const getCurrentUser = async (req, res) => {
    res.status(200).json({
        message: "Current user fetched successfully",
        success: true,
        user: req.user,
    });
};

const updatePassword = async (req, res) => {
    const { password } = req.body;
    const { error } = updatePasswordSchema.safeParse(req.body);
    if (error) {
        return res.status(400).json({   
            message: error.message,
            success: false,
            error: error.format(),
        });
    }
    const hashedPassword = await bcrypt.hash(password, 10); 
    const user = await prisma.employee.update({     
        where: { id: req.user.userId },
        data: { password: hashedPassword },
    });
    res.status(200).json({
        message: "Password updated successfully",
        success: true,
        user,
    });
};

const resetPassword = async (req, res) => {
    const { username } = req.body;
    const { error } = resetPasswordSchema.safeParse(req.body);
    if (error) {
        return res.status(400).json({
            message: error.message,  
            success: false,
            error: error.format(),
        });
    }
    const user = await prisma.employee.findUnique({
        where: { username },
    }); 
    if (!user) {
        return res.status(400).json({
            message: "User not found",
            success: false,
        });
    }
    const hashedPassword = await bcrypt.hash(password, 10);
    const updatedUser = await prisma.employee.update({
        where: { username },
        data: { password: hashedPassword },
    });
    res.status(200).json({
        message: "Password reset successfully",
        success: true,
        user: updatedUser,
    });
};






export { register, login, logout, verifyToken, getCurrentUser, updatePassword, resetPassword };
