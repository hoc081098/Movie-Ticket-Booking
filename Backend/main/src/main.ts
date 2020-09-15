import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import * as admin from 'firebase-admin';
import * as serviceAccount from '../serviceAccountKey.json';
import { Logger, ValidationPipe } from '@nestjs/common';

async function bootstrap() {
  const port = 3000;
  const logger = new Logger('main');

  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount as admin.ServiceAccount),
    databaseURL: 'https://datn-ca929.firebaseio.com',
  });

  const app = await NestFactory.create(AppModule);
  app.useGlobalPipes(
      new ValidationPipe({
        whitelist: true,
        transform: true,
        forbidNonWhitelisted: true,
      })
  );
  await app.listen(port);

  logger.log(`App running at port: ${port}`);
}

bootstrap();
