import { PaginationDto } from './pagination.dto';

export const constants = {
  maxDistanceInMeters: 30_000,
  defaultPage: 1,
  defaultPerPage: 16,
};

export interface LatLng {
  lat?: string | number | undefined | null;
  lng?: string | number | undefined | null;
}

export function getCoordinates(raw: LatLng): [number, number] | null {
  const { lat, lng } = raw;

  if (!lat || !lng) {
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