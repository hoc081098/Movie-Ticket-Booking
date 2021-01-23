import { CanActivate, ExecutionContext, Injectable, Logger, UnauthorizedException } from '@nestjs/common';
import { Request } from 'express';
import { FirebaseAuthenticationService } from '@aginix/nestjs-firebase-admin/dist';
import * as admin from 'firebase-admin';
import { User } from '../users/user.schema';
import { UsersService } from '../users/users.service';
import { RawUserPayload, UserPayload } from './get-user.decorator';
import { validate } from 'class-validator';

// let written = false;

@Injectable()
export class AuthGuard implements CanActivate {
  private readonly logger = new Logger('AuthGuard');

  constructor(
      private readonly firebaseAuth: FirebaseAuthenticationService,
      private readonly usersService: UsersService  ) {
    this.logger.debug(`Created AuthGuard`);
  }

  async canActivate(
      context: ExecutionContext,
  ): Promise<boolean> {
    // const test = this.configService.get(ConfigKey.TEST_AUTH_GUARD);
    // if (test === 'USER' || test === 'ADMIN') {
    //   // const me = (await this.usersService.findByUid('l9StgzQlR1h3XpaWCf3juyYgG772'))?.toJSON() ?? {};
    //   const me = (await this.usersService.findByUid(test === 'USER' ? 'l9StgzQlR1h3XpaWCf3juyYgG772' : 'NePOX4o5zhPqLUlHR9IY8eigNd92'))?.toJSON() ?? {};
    //   // const me = (await this.usersService.findByUid('g6OqSdG6XpQfCBr5k7v0O5Evkb93'))?.toJSON() ?? {};
    //   context.switchToHttp().getRequest().user = new UserPayload({ ...me, user_entity: me });
    //   this.logger.debug(`>>> TEST ${test}`);
    //   this.logger.debug(me);

    //   return true;
    // }

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

    const merged: RawUserPayload = {
      ...decodedIdToken,
      ...(user?.toObject() ?? {}),
      user_entity: user,
    };
    const payload = new UserPayload(merged);

    try {
      const errors = await validate(payload);
      this.logger.debug(`Errors: ${JSON.stringify(errors)} ${payload.user_entity?._id}`);

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
    // this.debugToken(token);

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

  // private debugToken(token: string) {
    // if (this.configService.get(ConfigKey.WRITE_TOKEN_TO_FILE) !== 'true') {
    //   return;
    // }

    // if (written) return;

    // written = true;
    // fs.writeFile('./token.txt', token, {}, (error) => {
    //   if (error) {
    //     throw error;
    //   }
    // });
  // }
}
