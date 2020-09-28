import { Controller, UseGuards } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { AuthGuard } from '../auth/auth.guard';

@ApiTags('promotions')
@UseGuards(AuthGuard)
@Controller('promotions')
export class PromotionsController {}
