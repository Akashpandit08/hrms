import multer from "multer";
import path from "path";
import fs from "fs";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const uploadDir = path.join(__dirname, "../uploads");
if (!fs.existsSync(uploadDir)) {
    fs.mkdirSync(uploadDir, { recursive: true });
}

const storage = (folderName) =>
    multer.diskStorage({
        destination: function (req, file, cb) {
            // Use the passed folderName or fallback to req.body.folderName
            const finalFolder = folderName || req.body.folderName || "default";
            const targetDir = path.join(uploadDir, finalFolder);

            // Ensure the folder exists
            if (!fs.existsSync(targetDir)) {
                fs.mkdirSync(targetDir, { recursive: true });
            }

            cb(null, targetDir);
        },
        filename: function (req, file, cb) {
            const uniqueSuffix = Date.now() + "-" + Math.round(Math.random() * 1e9);
            const fileName = file.fieldname + "-" + uniqueSuffix + path.extname(file.originalname);
            cb(null, fileName);
        }
    });

export const uploadSingle = (fieldName, folderName = null) => (req, res, next) => {
    const upload = multer({ storage: storage(folderName) }).single(fieldName);

    upload(req, res, (err) => {
        if (err) return res.status(400).json({ error: err.message });
        next();
    });
};

export const uploadMultiple = (fieldName, folderName = null) => (req, res, next) => {
    const upload = multer({ storage: storage(folderName) }).array(fieldName);

    upload(req, res, (err) => {
        if (err) return res.status(400).json({ error: err.message });
        next();
    });
};
