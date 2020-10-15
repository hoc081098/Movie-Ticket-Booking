import { CanActivate, ExecutionContext, Injectable, Logger, UnauthorizedException } from '@nestjs/common';
import { Socket } from 'socket.io';
import * as admin from 'firebase-admin';
import { FirebaseAuthenticationService } from '@aginix/nestjs-firebase-admin/dist';

@Injectable()
export class WsGuard implements CanActivate {
  private readonly logger = new Logger(WsGuard.name);

  constructor(
      private readonly firebaseAuth: FirebaseAuthenticationService,
  ) {}

  async canActivate(
      context: ExecutionContext,
  ): Promise<boolean> {
    const client = context.switchToWs().getClient<Socket>();
    const token = client.handshake?.query?.token;
    await this.decodeToken(token);
    return true;
  }

  /**
   * @throws UnauthorizedException
   * @param authHeaders
   */
  private async decodeToken(authHeaders: any): Promise<void> {
    this.logger.debug(`Headers: ${authHeaders}`);

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
  }
}
