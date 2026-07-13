-- AlterTable
ALTER TABLE `productos` ADD COLUMN `categoria` ENUM('electronica', 'celulares_tablets', 'videojuegos_consolas', 'electrodomesticos', 'ropa_accesorios', 'belleza_salud', 'muebles', 'hogar_jardin', 'herramientas', 'vehiculos', 'bicicletas_motos', 'deportes_fitness', 'libros_peliculas', 'musica_instrumentos', 'ninos_bebes', 'juguetes_hobbies', 'mascotas', 'oficina_papeleria', 'arte_coleccionables', 'servicios', 'otros') NULL,
    ADD COLUMN `ubicacion` VARCHAR(191) NULL;

-- CreateTable
CREATE TABLE `imagenes_producto` (
    `id_imagen` INTEGER NOT NULL AUTO_INCREMENT,
    `id_producto` INTEGER NOT NULL,
    `url` VARCHAR(191) NOT NULL,
    `creado_en` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id_imagen`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `imagenes_producto` ADD CONSTRAINT `imagenes_producto_id_producto_fkey` FOREIGN KEY (`id_producto`) REFERENCES `productos`(`id_producto`) ON DELETE RESTRICT ON UPDATE CASCADE;
