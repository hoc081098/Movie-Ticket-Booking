import { ApiOperation } from '@nestjs/swagger';

export const ForAdmin: () => MethodDecorator = () => ApiOperation({ summary: 'ADMIN' });

export const ForStaff: () => MethodDecorator = () => ApiOperation({ summary: 'STAFF' });

export const ForAdminAndStaff: () => MethodDecorator = () => ApiOperation({ summary: 'ADMIN, STAFF' });