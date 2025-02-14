import prisma from "./prisma.js";

export const connectDatabase = async() =>{
    await prisma.$connect()
    .then(()=>{
        console.log("database connected")
    })
    .catch((error) => {
        console.error("Error connecting to the database:", error);
        prisma.$disconnect();
        process.on('SIGINT', async () => {
            console.log("shutting down the database connection")
            await prisma.$disconnect();
            process.exit(0);
        })
        process.exit(1);
    })

}