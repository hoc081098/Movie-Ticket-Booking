import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import * as admin from 'firebase-admin';
import * as serviceAccount from '../serviceAccountKey.json';

async function bootstrap() {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount as admin.ServiceAccount),
    databaseURL: 'https://datn-ca929.firebaseio.com',
  });

  const app = await NestFactory.create(AppModule);
  await app.listen(3000);
}

bootstrap();
