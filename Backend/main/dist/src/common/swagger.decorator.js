"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ForAdminAndStaff = exports.ForStaff = exports.ForAdmin = void 0;
const swagger_1 = require("@nestjs/swagger");
exports.ForAdmin = () => swagger_1.ApiOperation({ summary: 'ADMIN' });
exports.ForStaff = () => swagger_1.ApiOperation({ summary: 'STAFF' });
exports.ForAdminAndStaff = () => swagger_1.ApiOperation({ summary: 'ADMIN, STAFF' });
//# sourceMappingURL=swagger.decorator.js.map