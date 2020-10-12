"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const core_1 = require("@nestjs/core");
const app_module_1 = require("./app.module");
const admin = require("firebase-admin");
const serviceAccount = require("../serviceAccountKey.json");
const common_1 = require("@nestjs/common");
const swagger_1 = require("@nestjs/swagger");
const mongoose = require("mongoose");
const morgan = require("morgan");
async function bootstrap() {
    const port = 3000;
    const logger = new common_1.Logger('main');
    admin.initializeApp({
        credential: admin.credential.cert(serviceAccount),
        databaseURL: 'https://datn-ca929.firebaseio.com',
    });
    mongoose.set('debug', true);
    const app = await core_1.NestFactory.create(app_module_1.AppModule);
    app.useGlobalPipes(new common_1.ValidationPipe({
        whitelist: true,
        transform: true,
        forbidNonWhitelisted: true,
    }));
    app.use(morgan('common'));
    const options = new swagger_1.DocumentBuilder()
        .setTitle('DATN API')
        .setDescription('DATN API description')
        .setVersion('1.0')
        .addTag('datn')
        .build();
    const document = swagger_1.SwaggerModule.createDocument(app, options);
    swagger_1.SwaggerModule.setup('api', app, document);
    await app.listen(port);
    logger.log(`App running at port: ${port}`);
}
bootstrap();
//# sourceMappingURL=main.js.map