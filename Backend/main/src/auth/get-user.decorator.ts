import { createParamDecorator, ExecutionContext } from '@nestjs/common';
import { IsEmail, IsNotEmpty, IsOptional, IsString } from 'class-validator';
import { User } from '../users/user.schema';
import { Request } from 'express';

export type RawUserPayload = {
  uid: string,
  email?: string,
  user_entity?: User | undefined | null;
};

export class UserPayload {
  @IsString()
  @IsNotEmpty()
  readonly uid: string;

  @IsString()
  @IsEmail()
  readonly email: string;

  @IsOptional()
  readonly user_entity?: User | undefined | null;

  constructor(payload: RawUserPayload) {
    this.uid = payload.uid;
    this.email = payload.email;
    this.user_entity = payload.user_entity;
  }
}

export const GetUser = createParamDecorator(
    (data: unknown, ctx: ExecutionContext) => {
      const req: { user?: UserPayload | null } = ctx.switchToHttp().getRequest();
      return data && typeof data === 'string' ? req.user?.[data] : req.user;
    }
);

export const GetFcmToken = createParamDecorator(
    (data: unknown, ctx: ExecutionContext) => ctx.switchToHttp().getRequest<Request>().header('fcm_token'),
);