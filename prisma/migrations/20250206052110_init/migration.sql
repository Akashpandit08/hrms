-- CreateEnum
CREATE TYPE "Gender" AS ENUM ('MALE', 'FEMALE', 'OTHER');

-- CreateEnum
CREATE TYPE "Role" AS ENUM ('ADMIN', 'HR', 'EMPLOYEE');

-- CreateEnum
CREATE TYPE "MobileType" AS ENUM ('PERSONAL', 'EMERGENCY', 'OFFICIAL');

-- CreateEnum
CREATE TYPE "Relation" AS ENUM ('SELF', 'PARENT', 'SPOUSE', 'CHILD', 'OTHER');

-- CreateEnum
CREATE TYPE "CertificateType" AS ENUM ('TENTH', 'TWELTH', 'GRADUATE', 'POST_GRADUATE', 'OTHER');

-- CreateEnum
CREATE TYPE "SkillLevel" AS ENUM ('BEGINNER', 'INTERMEDIATE', 'ADVANCED', 'EXPERT');

-- CreateEnum
CREATE TYPE "DocumentType" AS ENUM ('AADHAR', 'PAN', 'DRIVING_LICENSE', 'VOTER_ID', 'PASSPORT', 'PHOTO_ID', 'OTHER');

-- CreateEnum
CREATE TYPE "DocumentStatus" AS ENUM ('PENDING', 'VERIFIED', 'REJECTED');

-- CreateEnum
CREATE TYPE "AddressType" AS ENUM ('CURRENT', 'PERMANENT');

-- CreateEnum
CREATE TYPE "BankAccountType" AS ENUM ('CURRENT', 'SAVINGS');

-- CreateEnum
CREATE TYPE "LeaveType" AS ENUM ('SICK', 'VACATION', 'CASUAL', 'MATERNITY', 'PARENTAL', 'BEREAVEMENT', 'WEDDING', 'ADOPTIVE_PARENT', 'OTHER');

-- CreateEnum
CREATE TYPE "LeaveStatus" AS ENUM ('PENDING', 'APPROVED', 'REJECTED', 'CANCELED');

-- CreateEnum
CREATE TYPE "AttendanceStatus" AS ENUM ('PRESENT', 'ABSENT', 'LEAVE', 'HOLIDAY', 'PARTIAL_PRESENT');

-- CreateEnum
CREATE TYPE "AttendanceType" AS ENUM ('HYBRID', 'WFH', 'OFFICE');

-- CreateTable
CREATE TABLE "Employee" (
    "id" TEXT NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "username" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "role" "Role" NOT NULL DEFAULT 'EMPLOYEE',
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "Employee_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Department" (
    "id" TEXT NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "Department_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Position" (
    "id" TEXT NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "Position_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DepartmentPosition" (
    "id" TEXT NOT NULL,
    "departmentId" TEXT NOT NULL,
    "positionId" TEXT NOT NULL,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "DepartmentPosition_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EmployeePersonalDetails" (
    "id" TEXT NOT NULL,
    "employeeId" TEXT NOT NULL,
    "firstName" VARCHAR(255) NOT NULL,
    "middleName" VARCHAR(255),
    "lastName" VARCHAR(255),
    "gender" "Gender" NOT NULL,
    "fatherName" VARCHAR(255),
    "motherName" VARCHAR(255),
    "bloodGroup" VARCHAR(5),
    "avatar" TEXT,
    "dateOfBirth" TEXT NOT NULL,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "EmployeePersonalDetails_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EmployeeContact" (
    "id" TEXT NOT NULL,
    "employeeId" TEXT NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "EmployeeContact_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EmployeeMobileNo" (
    "id" TEXT NOT NULL,
    "employeeContactId" TEXT NOT NULL,
    "mobileNo" TEXT NOT NULL,
    "mobileType" "MobileType" NOT NULL DEFAULT 'PERSONAL',
    "relation" "Relation" NOT NULL DEFAULT 'PARENT',
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "EmployeeMobileNo_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EmergencyContact" (
    "id" TEXT NOT NULL,
    "employeeId" TEXT NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "relation" "Relation" NOT NULL DEFAULT 'PARENT',
    "phoneNumber" VARCHAR(15) NOT NULL,
    "isPrimary" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "EmergencyContact_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Certificate" (
    "id" TEXT NOT NULL,
    "employeeId" TEXT NOT NULL,
    "certificateName" TEXT NOT NULL,
    "certificateNumber" TEXT NOT NULL,
    "certificateType" "CertificateType" NOT NULL DEFAULT 'OTHER',
    "image" TEXT,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "Certificate_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EmployeeSkills" (
    "id" TEXT NOT NULL,
    "employeeId" TEXT NOT NULL,
    "skillName" VARCHAR(255) NOT NULL,
    "proficiency" "SkillLevel" NOT NULL DEFAULT 'BEGINNER',
    "yearsOfExperience" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "EmployeeSkills_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EmployeeHierarchy" (
    "id" TEXT NOT NULL,
    "employeeId" TEXT NOT NULL,
    "managerId" TEXT,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "EmployeeHierarchy_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EmployeeJobDetails" (
    "id" TEXT NOT NULL,
    "employeeId" TEXT NOT NULL,
    "joiningDate" DATE NOT NULL,
    "probationEndDate" DATE,
    "confirmationDate" DATE,
    "departmentId" TEXT NOT NULL,
    "positionId" TEXT NOT NULL,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "EmployeeJobDetails_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EmployeeIdentificationDetail" (
    "id" TEXT NOT NULL,
    "employeeId" TEXT NOT NULL,
    "documentType" "DocumentType" NOT NULL DEFAULT 'AADHAR',
    "status" "DocumentStatus" NOT NULL DEFAULT 'PENDING',
    "documentNumber" VARCHAR(255) NOT NULL,
    "documentImage" TEXT,
    "documentExpiryDate" DATE,
    "documentIssuedDate" DATE,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "EmployeeIdentificationDetail_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EmployeeHistory" (
    "id" TEXT NOT NULL,
    "employeeId" TEXT NOT NULL,
    "previousCompanyOfferLetter" TEXT,
    "previousCompanyJoiningLetter" TEXT,
    "previousCompanyExperienceLetter" TEXT,
    "previousCompanySalarySlip" TEXT,
    "previousCompanyRelievingLetter" TEXT,
    "coverLetter" TEXT,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "EmployeeHistory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EmployeePaySlip" (
    "id" TEXT NOT NULL,
    "employeeId" TEXT NOT NULL,
    "basicSalary" INTEGER NOT NULL DEFAULT 0,
    "allowances" INTEGER NOT NULL DEFAULT 0,
    "deductions" INTEGER NOT NULL DEFAULT 0,
    "overtimePay" INTEGER DEFAULT 0,
    "tax" INTEGER DEFAULT 0,
    "providentFund" INTEGER DEFAULT 0,
    "healthInsurance" INTEGER DEFAULT 0,
    "loanDeduction" INTEGER DEFAULT 0,
    "bonus" INTEGER DEFAULT 0,
    "workingDays" INTEGER NOT NULL DEFAULT 0,
    "leaveDays" INTEGER DEFAULT 0,
    "overtimeHours" INTEGER DEFAULT 0,
    "taxableIncome" INTEGER DEFAULT 0,
    "netSalary" INTEGER NOT NULL,
    "salaryMonth" TEXT NOT NULL,
    "remarks" TEXT,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "EmployeePaySlip_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EmployeeSalary" (
    "id" TEXT NOT NULL,
    "employeeId" TEXT NOT NULL,
    "ctc" TEXT NOT NULL,
    "basicSalary" INTEGER NOT NULL DEFAULT 0,
    "allowances" INTEGER NOT NULL DEFAULT 0,
    "deductions" INTEGER NOT NULL DEFAULT 0,
    "hra" INTEGER DEFAULT 0,
    "medicalAllowance" INTEGER DEFAULT 0,
    "conveyanceAllowance" INTEGER DEFAULT 0,
    "dearnessAllowance" INTEGER DEFAULT 0,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "EmployeeSalary_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SalaryDeduction" (
    "id" TEXT NOT NULL,
    "deductionName" VARCHAR(255) NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "deductionAmount" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "SalaryDeduction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EmployeeSalaryDeduction" (
    "id" TEXT NOT NULL,
    "employeeSalaryId" TEXT NOT NULL,
    "salaryDeductionId" TEXT NOT NULL,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "EmployeeSalaryDeduction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SalaryBonus" (
    "id" TEXT NOT NULL,
    "bonusName" VARCHAR(255) NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "bonusAmount" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "SalaryBonus_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EmployeeSalaryBonus" (
    "id" TEXT NOT NULL,
    "employeeSalaryId" TEXT NOT NULL,
    "salaryBonusId" TEXT NOT NULL,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "EmployeeSalaryBonus_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EmployeeBankDetails" (
    "id" TEXT NOT NULL,
    "employeeId" TEXT NOT NULL,
    "bankName" TEXT,
    "bankAccountNumber" TEXT,
    "bankIfscCode" TEXT,
    "bankBranchName" TEXT,
    "bankAccountHolderName" TEXT,
    "bankAccountType" "BankAccountType" NOT NULL DEFAULT 'CURRENT',
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "EmployeeBankDetails_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EmployeeAddress" (
    "id" TEXT NOT NULL,
    "employeeId" TEXT NOT NULL,
    "addressLine1" VARCHAR(255) NOT NULL,
    "addressLine2" VARCHAR(255),
    "city" VARCHAR(100) NOT NULL,
    "state" VARCHAR(100) NOT NULL,
    "country" VARCHAR(100) NOT NULL,
    "zipCode" VARCHAR(10) NOT NULL,
    "addressType" "AddressType" NOT NULL DEFAULT 'CURRENT',
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "EmployeeAddress_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EmployeeLeave" (
    "id" TEXT NOT NULL,
    "employeeId" VARCHAR(255) NOT NULL,
    "leaveType" "LeaveType" NOT NULL DEFAULT 'SICK',
    "startDate" DATE NOT NULL,
    "endDate" DATE NOT NULL,
    "leaveDays" INTEGER NOT NULL DEFAULT 0,
    "reason" TEXT,
    "status" "LeaveStatus" NOT NULL DEFAULT 'PENDING',
    "isPaidLeave" BOOLEAN NOT NULL DEFAULT true,
    "approvedBy" TEXT,
    "decisionDate" TIMESTAMP(3),
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "EmployeeLeave_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Attendance" (
    "id" TEXT NOT NULL,
    "employeeId" TEXT NOT NULL,
    "date" DATE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "attendanceStatus" "AttendanceStatus" NOT NULL DEFAULT 'PRESENT',
    "attendanceType" "AttendanceType" NOT NULL DEFAULT 'OFFICE',
    "inTime" TIME NOT NULL,
    "outTime" TIME NOT NULL,
    "totalHours" INTEGER NOT NULL,
    "totalMinutes" INTEGER NOT NULL,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "Attendance_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Employee_username_key" ON "Employee"("username");

-- CreateIndex
CREATE UNIQUE INDEX "EmployeePersonalDetails_employeeId_key" ON "EmployeePersonalDetails"("employeeId");

-- CreateIndex
CREATE UNIQUE INDEX "EmployeeContact_employeeId_key" ON "EmployeeContact"("employeeId");

-- CreateIndex
CREATE UNIQUE INDEX "EmployeeJobDetails_employeeId_key" ON "EmployeeJobDetails"("employeeId");

-- CreateIndex
CREATE UNIQUE INDEX "EmployeeIdentificationDetail_employeeId_key" ON "EmployeeIdentificationDetail"("employeeId");

-- CreateIndex
CREATE UNIQUE INDEX "EmployeeHistory_employeeId_key" ON "EmployeeHistory"("employeeId");

-- CreateIndex
CREATE UNIQUE INDEX "EmployeeSalary_employeeId_key" ON "EmployeeSalary"("employeeId");

-- CreateIndex
CREATE UNIQUE INDEX "EmployeeBankDetails_employeeId_key" ON "EmployeeBankDetails"("employeeId");

-- CreateIndex
CREATE INDEX "Attendance_employeeId_idx" ON "Attendance"("employeeId");

-- AddForeignKey
ALTER TABLE "DepartmentPosition" ADD CONSTRAINT "DepartmentPosition_departmentId_fkey" FOREIGN KEY ("departmentId") REFERENCES "Department"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DepartmentPosition" ADD CONSTRAINT "DepartmentPosition_positionId_fkey" FOREIGN KEY ("positionId") REFERENCES "Position"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EmployeePersonalDetails" ADD CONSTRAINT "EmployeePersonalDetails_employeeId_fkey" FOREIGN KEY ("employeeId") REFERENCES "Employee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EmployeeContact" ADD CONSTRAINT "EmployeeContact_employeeId_fkey" FOREIGN KEY ("employeeId") REFERENCES "Employee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EmployeeMobileNo" ADD CONSTRAINT "EmployeeMobileNo_employeeContactId_fkey" FOREIGN KEY ("employeeContactId") REFERENCES "EmployeeContact"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EmergencyContact" ADD CONSTRAINT "EmergencyContact_employeeId_fkey" FOREIGN KEY ("employeeId") REFERENCES "Employee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Certificate" ADD CONSTRAINT "Certificate_employeeId_fkey" FOREIGN KEY ("employeeId") REFERENCES "Employee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EmployeeSkills" ADD CONSTRAINT "EmployeeSkills_employeeId_fkey" FOREIGN KEY ("employeeId") REFERENCES "Employee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EmployeeHierarchy" ADD CONSTRAINT "EmployeeHierarchy_employeeId_fkey" FOREIGN KEY ("employeeId") REFERENCES "Employee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EmployeeHierarchy" ADD CONSTRAINT "EmployeeHierarchy_managerId_fkey" FOREIGN KEY ("managerId") REFERENCES "Employee"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EmployeeJobDetails" ADD CONSTRAINT "EmployeeJobDetails_employeeId_fkey" FOREIGN KEY ("employeeId") REFERENCES "Employee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EmployeeJobDetails" ADD CONSTRAINT "EmployeeJobDetails_departmentId_fkey" FOREIGN KEY ("departmentId") REFERENCES "Department"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EmployeeJobDetails" ADD CONSTRAINT "EmployeeJobDetails_positionId_fkey" FOREIGN KEY ("positionId") REFERENCES "Position"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EmployeeIdentificationDetail" ADD CONSTRAINT "EmployeeIdentificationDetail_employeeId_fkey" FOREIGN KEY ("employeeId") REFERENCES "Employee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EmployeeHistory" ADD CONSTRAINT "EmployeeHistory_employeeId_fkey" FOREIGN KEY ("employeeId") REFERENCES "Employee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EmployeePaySlip" ADD CONSTRAINT "EmployeePaySlip_employeeId_fkey" FOREIGN KEY ("employeeId") REFERENCES "Employee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EmployeeSalary" ADD CONSTRAINT "EmployeeSalary_employeeId_fkey" FOREIGN KEY ("employeeId") REFERENCES "Employee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EmployeeSalaryDeduction" ADD CONSTRAINT "EmployeeSalaryDeduction_employeeSalaryId_fkey" FOREIGN KEY ("employeeSalaryId") REFERENCES "EmployeeSalary"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EmployeeSalaryDeduction" ADD CONSTRAINT "EmployeeSalaryDeduction_salaryDeductionId_fkey" FOREIGN KEY ("salaryDeductionId") REFERENCES "SalaryDeduction"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EmployeeSalaryBonus" ADD CONSTRAINT "EmployeeSalaryBonus_employeeSalaryId_fkey" FOREIGN KEY ("employeeSalaryId") REFERENCES "EmployeeSalary"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EmployeeSalaryBonus" ADD CONSTRAINT "EmployeeSalaryBonus_salaryBonusId_fkey" FOREIGN KEY ("salaryBonusId") REFERENCES "SalaryBonus"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EmployeeBankDetails" ADD CONSTRAINT "EmployeeBankDetails_employeeId_fkey" FOREIGN KEY ("employeeId") REFERENCES "Employee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EmployeeAddress" ADD CONSTRAINT "EmployeeAddress_employeeId_fkey" FOREIGN KEY ("employeeId") REFERENCES "Employee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EmployeeLeave" ADD CONSTRAINT "EmployeeLeave_employeeId_fkey" FOREIGN KEY ("employeeId") REFERENCES "Employee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Attendance" ADD CONSTRAINT "Attendance_employeeId_fkey" FOREIGN KEY ("employeeId") REFERENCES "Employee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
