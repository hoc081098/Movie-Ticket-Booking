import { CanActivate, ExecutionContext, Injectable, Logger, UnauthorizedException } from '@nestjs/common';
import { Request } from 'express';
import { FirebaseAuthenticationService } from '@aginix/nestjs-firebase-admin/dist';
import * as admin from 'firebase-admin';
import { User } from '../users/user.schema';
import { UsersService } from '../users/users.service';
import { UserPayload } from './get-user.decorator';
import { validate } from 'class-validator';

@Injectable()
export class AuthGuard implements CanActivate {
  private readonly logger = new Logger('AuthGuard');

  constructor(
      private readonly firebaseAuth: FirebaseAuthenticationService,
      private readonly usersService: UsersService,
  ) {
    this.logger.debug(`Created AuthGuard`);
  }

  async canActivate(
      context: ExecutionContext,
  ): Promise<boolean> {
    const request = context.switchToHttp().getRequest<Request>();
    const decodedIdToken = await this.decodeToken(request);

    this.logger.debug(`Token: ${JSON.stringify(decodedIdToken)}`);

    let user: User;
    try {
      user = await this.usersService.findByUid(decodedIdToken.uid);
    } catch (e) {
      this.logger.error(`Error when finding user: ${e}`);
      throw new UnauthorizedException();
    }

    const merged = {
      ...decodedIdToken,
      ...(user ?? {}),
    };
    const payload = new UserPayload(merged as { uid: string, email: string });

    try {
      const errors = await validate(payload);
      this.logger.debug(`Errors: ${JSON.stringify(errors)}`);

      if (errors === null || errors === undefined || errors.length === 0) {
        (request as any).user = payload;
        this.logger.debug(`Payload: ${JSON.stringify(payload)}`);
        return true;
      }
    } catch (e) {
      this.logger.error(`Error when validating payload: ${e}`);
      throw new UnauthorizedException();
    }
  }

  /**
   * @throws UnauthorizedException
   * @param request
   */
  private async decodeToken(request: Request): Promise<admin.auth.DecodedIdToken> {
    const authHeaders = request.headers.authorization;
    if (!authHeaders) {
      this.logger.error('Missing authHeaders');
      throw new UnauthorizedException();
    }

    const token = authHeaders.split(' ')[1];
    if (!token) {
      this.logger.error('Missing token');
      throw new UnauthorizedException();
    }

    let decodedIdToken: admin.auth.DecodedIdToken;
    try {
      decodedIdToken = await this.firebaseAuth.verifyIdToken(token);
    } catch (e) {
      this.logger.error(`Error when verifying token: ${e}`);
      throw new UnauthorizedException('Error when verifying token');
    }
    if (!(decodedIdToken?.uid)) {
      this.logger.error('Error: missing decodedIdToken or decodedIdToken.uid');
      throw new UnauthorizedException('Error invalid decoded token');
    }

    return decodedIdToken;
  }
}
