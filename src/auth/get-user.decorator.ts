import { createParamDecorator, ExecutionContext } from '@nestjs/common';
import { IsEmail, IsNotEmpty, IsString } from 'class-validator';

export class UserPayload {
  @IsString()
  @IsNotEmpty()
  uid: string;

  @IsString()
  @IsEmail()
  email: string;

  constructor(payload: { uid: string, email: string }) {
    this.uid = payload.uid;
    this.email = payload.email;
  }
}

export const GetUser = createParamDecorator(
    (data: unknown, ctx: ExecutionContext) => {
      const req: { user?: UserPayload | null } = ctx.switchToHttp().getRequest();
      return data && typeof data === 'string' ? req.user?.[data] : req.user;
    }
);

