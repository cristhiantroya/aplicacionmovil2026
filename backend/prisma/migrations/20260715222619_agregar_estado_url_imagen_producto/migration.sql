-- AlterTable
ALTER TABLE `imagenes_producto` ADD COLUMN `estado` ENUM('procesando', 'completada') NOT NULL DEFAULT 'procesando',
    MODIFY `url` VARCHAR(191) NULL;
