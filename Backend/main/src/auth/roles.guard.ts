import { CanActivate, ExecutionContext, Injectable, Logger, SetMetadata, UnauthorizedException } from '@nestjs/common';
import { UserPayload } from './get-user.decorator';
import { Reflector } from '@nestjs/core';

type RolesType = ('ADMIN' | 'USER' | 'STAFF')[];
export const Roles = (...roles: RolesType) => SetMetadata('roles', roles);

@Injectable()
export class RolesGuard implements CanActivate {
  private readonly logger = new Logger('RolesGuard');

  constructor(
      private readonly reflector: Reflector,
  ) {}

  async canActivate(
      context: ExecutionContext,
  ): Promise<boolean> {
    const roles = this.reflector.get<RolesType>('roles', context.getHandler());
    if (!roles || roles.length === 0) {
      return true;
    }

    const request = context.switchToHttp().getRequest();
    const user = (request.user as UserPayload)?.user_entity;
    if (!user) {
      throw new UnauthorizedException();
    }

    this.logger.debug(`roles=${JSON.stringify(roles)}, user.role=${user.role}`);
    return roles.includes(user.role);
  }
}
