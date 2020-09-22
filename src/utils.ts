export const constants = {
  maxDistanceInMeters: 30_000,
  defaultPage: 1,
  defaultPerPage: 16,
};

export function getSkipLimit(page: number, perPage: number): { skip: number, limit: number } {
  page = Math.floor(page ?? constants.defaultPage);
  perPage = Math.floor(perPage ?? constants.defaultPerPage);

  return {
    limit: perPage,
    skip: (page - 1) * perPage,
  };
}