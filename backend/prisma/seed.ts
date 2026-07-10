import "dotenv/config";
import { PrismaClient } from '@prisma/client';
import { PrismaMariaDb } from '@prisma/adapter-mariadb';

const adapter = new PrismaMariaDb({
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '3306'),
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || ''
});

const prisma = new PrismaClient({ adapter });




async function main() {
  // Create initial safe points
  const safePoints = [
    {
      nombre: 'Centro Comercial El Dorado',
      direccion: 'Av. 6 de Diciembre N27-123',
      ciudad: 'Quito',
      latitud: -0.1807,
      longitud: -78.4678,
    },
    {
      nombre: 'Mall del Sol',
      direccion: 'Av. Principal y Calle 10',
      ciudad: 'Guayaquil',
      latitud: -2.1709,
      longitud: -79.9223,
    },
    {
      nombre: 'Centro Comercial El Prado',
      direccion: 'Av. 9 de Octubre 1234',
      ciudad: 'Cuenca',
      latitud: -2.9006,
      longitud: -79.0044,
    },
    {
      nombre: 'UPC - Campus Central',
      direccion: 'Av. 12 de Octubre 1550',
      ciudad: 'Quito',
      latitud: -0.1761,
      longitud: -78.4788,
    },
    {
      nombre: 'Centro Comercial City Mall',
      direccion: 'Av. Juan Tanca Marengo KM 5.5',
      ciudad: 'Guayaquil',
      latitud: -2.1308,
      longitud: -79.8973,
    },
  ];

  for (const point of safePoints) {
    await prisma.puntoSeguro.create({
      data: point,
    });
  }

  console.log('Seeding completed! Added initial safe points.');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });


