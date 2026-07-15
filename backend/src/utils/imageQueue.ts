import prisma from "./prisma";
import cloudinary from "./cloudinary";

type ImagenJob = {
  id_imagen: number;
  id_producto: number;
  buffer: Buffer;
};

const queue: ImagenJob[] = [];
let workerStarted = false;

const extractPublicId = (url: string): string | null => {
  try {
    const last = url.split("/").pop();
    if (!last) return null;
    return last.split(".")[0] ?? null;
  } catch {
    return null;
  }
};

const processOne = async (): Promise<void> => {
  const job = queue.shift();
  if (!job) return;

  // 1) subir a Cloudinary
  const uploadResult = await new Promise<any>((resolve, reject) => {
    const uploadStream = cloudinary.uploader.upload_stream(
      { folder: "comprasegura/productos" },
      (error, result) => {
        if (error) reject(error);
        else resolve(result);
      }
    );
    uploadStream.end(job.buffer);
  });

  const secureUrl = uploadResult?.secure_url;
  if (!secureUrl) {
    // Si no hay URL, marcamos como completada igual para no dejar registros “colgados”.
    // Alternativamente podrías agregar un estado “error”, pero no se solicitó.
    await prisma.imagenProducto.update({
      where: { id_imagen: job.id_imagen },
      data: { estado: "completada" },
    });
    return;
  }

  // 2) actualizar registro con url real + estado completada
  await prisma.imagenProducto.update({
    where: { id_imagen: job.id_imagen },
    data: {
      url: secureUrl,
      estado: "completada",
    },
  });
};

export const enqueueImagenProducto = async (job: ImagenJob): Promise<void> => {
  queue.push(job);

  // start worker on first enqueue
  if (!workerStarted) {
    workerStarted = true;
    const intervalMs = 500;

    setInterval(async () => {
      // procesar una sola tarea a la vez
      if (queue.length === 0) return;
      try {
        await processOne();
      } catch (err) {
        console.error("imageQueue worker error:", err);
      }
    }, intervalMs);
  }
};

// util para tests/manual
export const getImageQueueSize = () => queue.length;

// (no se usa por ahora, pero queda útil para futuras invalidaciones)
export const publicIdFromUrl = (url: string) => extractPublicId(url);
