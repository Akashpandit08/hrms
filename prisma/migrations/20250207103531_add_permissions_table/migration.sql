/*
  Warnings:

  - You are about to drop the column `updatedAt` on the `EmployeeSocket` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Employee" ADD COLUMN     "hasAllPermissions" BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE "EmployeeSocket" DROP COLUMN "updatedAt";

-- CreateTable
CREATE TABLE "Permission" (
    "id" TEXT NOT NULL,
    "employeeId" TEXT NOT NULL,
    "permissionName" TEXT NOT NULL,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "Permission_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_EmployeePermissions" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL,

    CONSTRAINT "_EmployeePermissions_AB_pkey" PRIMARY KEY ("A","B")
);

-- CreateIndex
CREATE INDEX "Permission_employeeId_idx" ON "Permission"("employeeId");

-- CreateIndex
CREATE INDEX "_EmployeePermissions_B_index" ON "_EmployeePermissions"("B");

-- AddForeignKey
ALTER TABLE "Permission" ADD CONSTRAINT "Permission_employeeId_fkey" FOREIGN KEY ("employeeId") REFERENCES "Employee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_EmployeePermissions" ADD CONSTRAINT "_EmployeePermissions_A_fkey" FOREIGN KEY ("A") REFERENCES "Employee"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_EmployeePermissions" ADD CONSTRAINT "_EmployeePermissions_B_fkey" FOREIGN KEY ("B") REFERENCES "Permission"("id") ON DELETE CASCADE ON UPDATE CASCADE;
