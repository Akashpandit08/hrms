import { z } from "zod";

export const employeeContactSchema = z.object({
    employeeId:z.string(),
    email:z.string(),
    
})  


export const MobileType = {
    PERSONAL: "PERSONAL",
    EMERGENCY: "EMERGENCY", 
    OFFICIAL: "OFFICIAL",
};

export const Relation = {
    SELF: "SELF",
    PARENT: "PARENT", 
    SPOUSE: "SPOUSE",
    CHILD: "CHILD",
    OTHER:"OTHER",
}

export const employeeMobileNoSchema = z.object({
    mobileNo: z.string().length(10, "Mobile number must be exactly 10 digits"),
    mobileType: z.nativeEnum(MobileType),
    relation: z.nativeEnum(Relation),
});

