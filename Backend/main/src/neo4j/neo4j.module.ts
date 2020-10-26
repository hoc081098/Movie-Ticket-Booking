import { Module } from '@nestjs/common';
import { Neo4jService } from './neo4j.service';
import { ConfigModule } from '../config/config.module';
import { Neo4jController } from './neo4j.controller';
import { AuthModule } from '../auth/auth.module';
import { UsersModule } from '../users/users.module';
import { MongooseModule } from '@nestjs/mongoose';
import { User, UserSchema } from '../users/user.schema';

@Module({
  imports: [
    MongooseModule.forFeature([
      {
        name: User.name,
        schema: UserSchema,
      }
    ]),
    ConfigModule,
    AuthModule,
    UsersModule,
  ],
  providers: [Neo4jService],
  controllers: [Neo4jController]
})
export class Neo4jModule {}
