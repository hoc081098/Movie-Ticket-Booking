import { Module } from '@nestjs/common';
import { UsersModule } from '../users/users.module';
import { AuthGuard } from './auth.guard';
import { ConfigModule } from '../config/config.module';
import { RolesGuard } from './roles.guard';

@Module({
  imports: [
    UsersModule,
    ConfigModule,
  ],
  providers: [AuthGuard, RolesGuard],
  exports: [AuthGuard, RolesGuard],
})
export class AuthModule {}
