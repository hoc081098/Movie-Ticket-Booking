import { createParamDecorator } from '@nestjs/common';
import { IsEmail, IsNotEmpty, IsString } from 'class-validator';

export class UserPayload {
  @IsString()
  @IsNotEmpty()
  uid: string;

  @IsString()
  @IsEmail()
  email: string;

  constructor(uid: string, email: string) {
    this.uid = uid;
    this.email = email;
  }
}

export const GetUser = createParamDecorator(
    (data: string, req: any) => data ? req.user?.[data] : req.user
);

