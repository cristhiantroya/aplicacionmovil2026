-- CreateTable
CREATE TABLE `conversaciones` (
    `id_conversacion` INTEGER NOT NULL AUTO_INCREMENT,
    `id_producto` INTEGER NOT NULL,
    `id_comprador` INTEGER NOT NULL,
    `id_vendedor` INTEGER NOT NULL,
    `creado_en` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `conversaciones_id_producto_id_comprador_key`(`id_producto`, `id_comprador`),
    PRIMARY KEY (`id_conversacion`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `mensajes` (
    `id_mensaje` INTEGER NOT NULL AUTO_INCREMENT,
    `id_conversacion` INTEGER NOT NULL,
    `id_emisor` INTEGER NOT NULL,
    `contenido` TEXT NOT NULL,
    `leido` BOOLEAN NOT NULL DEFAULT false,
    `creado_en` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id_mensaje`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `conversaciones` ADD CONSTRAINT `conversaciones_id_producto_fkey` FOREIGN KEY (`id_producto`) REFERENCES `productos`(`id_producto`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `conversaciones` ADD CONSTRAINT `conversaciones_id_comprador_fkey` FOREIGN KEY (`id_comprador`) REFERENCES `usuarios`(`id_usuario`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `conversaciones` ADD CONSTRAINT `conversaciones_id_vendedor_fkey` FOREIGN KEY (`id_vendedor`) REFERENCES `usuarios`(`id_usuario`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `mensajes` ADD CONSTRAINT `mensajes_id_conversacion_fkey` FOREIGN KEY (`id_conversacion`) REFERENCES `conversaciones`(`id_conversacion`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `mensajes` ADD CONSTRAINT `mensajes_id_emisor_fkey` FOREIGN KEY (`id_emisor`) REFERENCES `usuarios`(`id_usuario`) ON DELETE RESTRICT ON UPDATE CASCADE;
