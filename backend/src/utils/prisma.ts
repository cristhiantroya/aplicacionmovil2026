import { PrismaClient } from '@prisma/client';
import { PrismaMariaDb } from '@prisma/adapter-mariadb';
import 'dotenv/config';

// 1. Configuramos el adaptador pasándole el objeto directo como pide Prisma 7
const adapter = new PrismaMariaDb({
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '3306'),
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || ''
});

// 2. Encendemos el cliente con el adaptador nativo
const prisma = new PrismaClient({ adapter });

export default prisma;








