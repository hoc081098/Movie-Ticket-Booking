import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import * as admin from 'firebase-admin';
import * as serviceAccount from '../serviceAccountKey.json';
import { Logger, ValidationPipe } from '@nestjs/common';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import * as mongoose from 'mongoose';
import * as morgan from 'morgan';

async function bootstrap() {
  const port = process.env.PORT ?? 3000;
  const logger = new Logger('main');

  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount as admin.ServiceAccount),
    databaseURL: 'https://datn-ca929.firebaseio.com',
  });
  mongoose.set('debug', true);

  const app = await NestFactory.create(AppModule);
  app.useGlobalPipes(
      new ValidationPipe({
        whitelist: true,
        transform: true,
        forbidNonWhitelisted: true,
      })
  );
  app.use(morgan('common'));

  const options = new DocumentBuilder()
      .setTitle('DATN API')
      .setDescription('DATN API description')
      .setVersion('1.0')
      .addTag('datn')
      .build();
  const document = SwaggerModule.createDocument(app, options);
  SwaggerModule.setup('api', app, document);

  await app.listen(port);

  logger.log(`App running at port: ${port}`);
}

bootstrap();
