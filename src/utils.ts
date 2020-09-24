export const constants = {
  maxDistanceInMeters: 30_000,
  defaultPage: 1,
  defaultPerPage: 16,
};

export function getCoordinates(raw: { lat: string, lng: string }): [number, number] | null {
  const { lat, lng } = raw;

  if (!lat || !lng) {
    return null;
  }

  const latF = parseFloat(lat);
  const lngF = parseFloat(lng);

  if (isNaN(latF) || isNaN(lngF)) {
    return null;
  }

  return latF < -90 || 90 < latF || lngF < -180 || 180 < lngF ? null : [lngF, latF];
}

export function getSkipLimit(page: number, perPage: number): { skip: number, limit: number } {
  page = Math.floor(page ?? constants.defaultPage);
  perPage = Math.floor(perPage ?? constants.defaultPerPage);

  return {
    limit: perPage,
    skip: (page - 1) * perPage,
  };
}