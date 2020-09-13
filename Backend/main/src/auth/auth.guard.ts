import { CanActivate, ExecutionContext, Injectable, Logger, UnauthorizedException } from '@nestjs/common';
import { Request } from 'express';
import { FirebaseAuthenticationService } from '@aginix/nestjs-firebase-admin/dist';
import * as admin from 'firebase-admin';
import { User } from '../users/user.schema';
import { UsersService } from '../users/users.service';

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

    let user: User;
    try {
      user = await this.usersService.findByUid(decodedIdToken.uid);
    } catch (e) {
      this.logger.error(`Error when finding user: ${e}`);
      throw new UnauthorizedException();
    }
    if (!user) {
      throw new UnauthorizedException('User not found');
    }

    (request as any).user = {
      ...decodedIdToken,
      ...user,
    };

    return true;
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
    if (!decodedIdToken || !decodedIdToken.uid) {
      this.logger.error('Error: missing decodedIdToken or decodedIdToken.uid');
      throw new UnauthorizedException('Cannot decode token');
    }

    return decodedIdToken;
  }
}
