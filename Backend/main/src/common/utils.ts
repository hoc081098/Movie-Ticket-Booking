import { PaginationDto } from './pagination.dto';
import { UserPayload } from '../auth/get-user.decorator';
import { User } from '../users/user.schema';
import { BadRequestException, ForbiddenException, Logger } from '@nestjs/common';
import { Theatre } from "../theatres/theatre.schema";

export const constants = {
  maxDistanceInMeters: 30_000,
  defaultPage: 1,
  defaultPerPage: 16,
};

export interface LatLng {
  lat?: string | number | undefined | null;
  lng?: string | number | undefined | null;
}

export function getCoordinates(latLng: LatLng | null | undefined): [number, number] | null {
  if (!latLng) {
    return null;
  }
  const { lat, lng } = latLng;

  if (lat === null || lat === undefined || lng === null || lng === undefined) {
    return null;
  }

  const latF = typeof lat === 'string' ? parseFloat(lat) : lat;
  const lngF = typeof lng === 'string' ? parseFloat(lng) : lng;

  if (isNaN(latF) || isNaN(lngF)) {
    return null;
  }

  return latF < -90 || 90 < latF || lngF < -180 || 180 < lngF ? null : [lngF, latF];
}

export interface SkipAndLimit {
  skip: number;
  limit: number;
}

export function getSkipLimit(paginationDto: PaginationDto): SkipAndLimit {
  let page = Math.floor(paginationDto.page ?? constants.defaultPage);
  let perPage = Math.floor(paginationDto.per_page ?? constants.defaultPerPage);

  if (page < 1) page = constants.defaultPage;
  if (perPage < 1) perPage = constants.defaultPerPage;

  return {
    limit: perPage,
    skip: (page - 1) * perPage,
  };
}

/**
 * @throws ForbiddenException
 * @param userPayload
 * @returns User not null, not undefined.
 */
export function checkCompletedLogin(userPayload: UserPayload): User {
  const entity: User | undefined | null = userPayload.user_entity;

  if (!entity) {
    throw new ForbiddenException(`Not completed login!`);
  }

  return entity;
}

export function checkStaffPermission(userPayload: UserPayload, theatre_id: string | string | undefined) {
  const user = checkCompletedLogin(userPayload);

  if (user.role === 'STAFF') {
    if (!theatre_id) {
      throw new BadRequestException(`Missing theatre_id`);
    }

    const theatre: Theatre | undefined | null = user.theatre;
    if (!theatre) {
      throw new ForbiddenException(`Something was wrong!`);
    }

    if (theatre._id.toString() !== theatre_id) {
      throw new ForbiddenException(`Not a staff of ${theatre.name}!`);
    } else {
      Logger.debug(`${user.email} is staff of ${theatre.name}!`)
    }
  }
}