import multer from "multer";

const storage = multer.memoryStorage(); // Store file in memory temporarily to upload to Cloudinary

const upload = multer({
  storage: storage,
  limits: { fileSize: 5 * 1024 * 1024 }, // Limit to 5MB per file
});

export default upload;
