import { z } from "zod";

export const registerSchema = z.object({
    username: z.string().email(),
    password: z.string().min(8),
    role: z.enum(["ADMIN", "HR", "EMPLOYEE"]),
});


export const loginSchema = z.object({
    username: z.string().email(),
    password: z.string().min(8),
});                                 







