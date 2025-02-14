-- DropIndex
DROP INDEX "EmployeeIdentificationDetail_employeeId_key";

-- CreateTable
CREATE TABLE "EmployeeSocket" (
    "id" TEXT NOT NULL,
    "employeeId" TEXT NOT NULL,
    "socketId" TEXT NOT NULL,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "EmployeeSocket_pkey" PRIMARY KEY ("id")
);
