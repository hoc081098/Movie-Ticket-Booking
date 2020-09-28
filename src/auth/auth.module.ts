import { Module } from '@nestjs/common';
import { UsersModule } from '../users/users.module';
import { AuthGuard } from './auth.guard';
import { ConfigModule } from '../config/config.module';

@Module({
  imports: [
    UsersModule,
    ConfigModule,
  ],
  providers: [AuthGuard],
  exports: [AuthGuard],
})
export class AuthModule {}
