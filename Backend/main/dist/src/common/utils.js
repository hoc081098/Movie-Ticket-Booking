"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.checkCompletedLogin = exports.getSkipLimit = exports.getCoordinates = exports.constants = void 0;
const common_1 = require("@nestjs/common");
exports.constants = {
    maxDistanceInMeters: 30000,
    defaultPage: 1,
    defaultPerPage: 16,
};
function getCoordinates(latLng) {
    const { lat, lng } = latLng;
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
exports.getCoordinates = getCoordinates;
function getSkipLimit(paginationDto) {
    var _a, _b;
    let page = Math.floor((_a = paginationDto.page) !== null && _a !== void 0 ? _a : exports.constants.defaultPage);
    let perPage = Math.floor((_b = paginationDto.per_page) !== null && _b !== void 0 ? _b : exports.constants.defaultPerPage);
    if (page < 1)
        page = exports.constants.defaultPage;
    if (perPage < 1)
        perPage = exports.constants.defaultPerPage;
    return {
        limit: perPage,
        skip: (page - 1) * perPage,
    };
}
exports.getSkipLimit = getSkipLimit;
function checkCompletedLogin(userPayload) {
    const entity = userPayload.user_entity;
    if (!entity) {
        throw new common_1.ForbiddenException(`Not completed login!`);
    }
    return entity;
}
exports.checkCompletedLogin = checkCompletedLogin;
//# sourceMappingURL=utils.js.map