import express from "express";
import { createEmployee, employeeContactCreate, addEmployeeMoreContact, employeeIdentificationDetailCreate } from "../controllers/employeeCreateDetailsController.js";
import { uploadSingle, uploadMultiple } from "../helpers/upload.js";


const employeeRouter = express.Router();

employeeRouter.post("/create", uploadSingle("avatar", "employeeProfile"), createEmployee); 
employeeRouter.post("/contact", employeeContactCreate);
employeeRouter.post("/contact/more", addEmployeeMoreContact);
// employeeRouter.post("/identificationdetials", uploadSingle("documentImage", "employeeDocument"), employeeIdentificationDetailCreate);
// Route Setup (Ensure to use multer middleware for handling file uploads)
employeeRouter.post("/identificationdetials", uploadMultiple("documents", "employeeDocument", 10), employeeIdentificationDetailCreate);




export default employeeRouter;

