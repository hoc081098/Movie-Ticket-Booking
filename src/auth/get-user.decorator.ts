import { createParamDecorator } from '@nestjs/common';
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
    (data: string, req: any) => data ? req.user?.[data] : req.user
);

