import prisma from "../config/prisma.js";
import bcrypt from "bcrypt";

import { registerSchema } from '../types/auth.types.js';
import { employeeContactSchema, employeeMobileNoSchema } from '../types/employee.types.js'; 



const createEmployee = async (req, res) => {
    try {
        const { username, password, role, firstName, middleName, lastName, gender, fatherName, motherName, bloodGroup, dateOfBirth } = req.body;

        let avatarPath = req.file ? req.file.path : null; 

        const { error } = registerSchema.safeParse(req.body);
        if (error) {
            return res.status(400).json({
                message: "Validation Error",
                success: false,
                error: error.format(),
            });
        }

        const hashedPassword = await bcrypt.hash(password, 10);

        const result = await prisma.$transaction(async (prisma) => {
            const employee = await prisma.employee.create({
                data: { username, password: hashedPassword, role },
            });

            const employeePersonalDetails = await prisma.employeePersonalDetails.create({
                data: {
                    employeeId: employee.id,
                    firstName,
                    middleName,
                    lastName,
                    gender,
                    fatherName,
                    motherName,
                    bloodGroup,
                    avatar: avatarPath, // Storing the avatar correctly
                    dateOfBirth,
                },
            });

            return { employee, employeePersonalDetails };
        });

        return res.status(201).json({ success: true, ...result });

    } catch (err) {
        console.error(err);
        return res.status(500).json({ message: "Internal Server Error", success: false, error: err.message });
    }
};

const getEmployee = async (req, res) =>{
    try{
        const employees = await prisma.employee.findMany({
            include:{
                employeePersonalDetails:true,
            }
        })
        return res.status(200).json({success:true, employees})
    }catch(err){
        console.error(err);
        return res.status(500).json({message:"Internal Server Error", success:false, error:err.message})
    }
}

 const employeeContactCreate = async (req, res) =>{
    try{
        const {employeeId,email,mobileType,relation,mobileNo} = req.body;
        const {error} = employeeContactSchema.safeParse(req.body);
        if(error){
            return res.status(400).json({message:"Validation Error", success:false, error:error.format()})
        }
        const {error:mobileError} = employeeMobileNoSchema.safeParse(req.body);
        if(mobileError){
            return res.status(400).json({message:"Validation Error", success:false, error:mobileError.format()})
        }


        const employee = await prisma.employee.findUnique({
            where:{id:employeeId},
            select:{
                id:true,
            }
        })
        if(!employee){
            return res.status(404).json({message:"Employee not found", success:false})
        }

        const employeeContact = await prisma.employeeContact.create({
            data:{

                employeeId,

                email
                
            }
        })  
        const employeeMobileNo = await prisma.employeeMobileNo.create({
            data:{
                employeeContactId:employeeContact.id,
                mobileNo,
                mobileType,
                relation,
            }
        })
        return res.status(201).json({success:true, employeeContact, employeeMobileNo})

    }catch(err){
        console.error(err);
        return res.status(500).json({message:"Internal Server Error", success:false, error:err.message})
    }
 }
 const addEmployeeMoreContact = async (req, res) =>{
    try{
        const {employeeId,mobileType,relation,mobileNo} = req.body;
        
        if(!employeeId){
            return res.status(400).json({message:"Employee ID is required", success:false})
        }
        if(!mobileType){
            return res.status(400).json({message:"Mobile Type is required", success:false})
        }
        if(!relation){
            return res.status(400).json({message:"Relation is required", success:false})
        }
        if(!mobileNo){
            return res.status(400).json({message:"Mobile Number is required", success:false})
        }
        
        const employee = await prisma.employee.findUnique({
            where:{id:employeeId},
            select:{
                id:true,
            }
        })
        if(!employee){
            return res.status(404).json({message:"Employee not found", success:false})
        } 
        const employeeContactId = await prisma.employeeContact.findFirst({
            where:{
                employeeId:employeeId,
            },select:{
                id:true,
            }
        })
        if(!employeeContactId){
            return res.status(404).json({message:"Employee Contact not found", success:false})
        }
        const mobileNoCheck = await prisma.employeeMobileNo.findFirst({
            where:{
                mobileNo:mobileNo,
            }
        })
        if(mobileNoCheck){
            return res.status(400).json({message:"Employee Mobile Number already exists", success:false})
        }

        const employeeMobileNo = await prisma.employeeMobileNo.create({
            data:{
                
                employeeContactId:employeeContactId.id,
                mobileNo,
                mobileType,
                relation,
            }
        })
        return res.status(201).json({success:true, employeeMobileNo})
        
    }catch(err){    
        console.error(err); 
        return res.status(500).json({message:"Internal Server Error", success:false, error:err.message})
    }

 }
 const employeeIdentificationDetailCreate = async (req, res) => {
    try {
        const { employeeId, documentType, documentNumber, documentExpiryDate, documentIssuedDate, status } = req.body;

        if (!employeeId || !documentType || !documentNumber) {
            return res.status(400).json({ message: "Employee ID, document type, and document number are required." });
        }

        // Process uploaded files
        const documentImages = req.files ? req.files.map(file => file.path) : [];

        // Prepare data for database insertion
        const documentData = documentType.map((type, index) => ({
            employeeId,
            documentType: type,
            documentNumber: documentNumber[index],
            status: status ? status[index] : "PENDING",
            documentImage: documentImages[index] || null,
            documentExpiryDate: documentExpiryDate[index] ? new Date(documentExpiryDate[index]) : null,
            documentIssuedDate: documentIssuedDate[index] ? new Date(documentIssuedDate[index]) : null,
        }));

        // Insert into database
        const newDetails = await prisma.employeeIdentificationDetail.createMany({
            data: documentData
        });

        return res.status(201).json({ message: "Identification details added", data: newDetails });

    } catch (err) {
        console.error("Error creating identification details:", err);
        return res.status(500).json({ message: "Internal Server Error", error: err.message });
    }
};










export { createEmployee, getEmployee, employeeContactCreate, addEmployeeMoreContact, employeeIdentificationDetailCreate };
