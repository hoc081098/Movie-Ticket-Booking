import { Controller, Get, Param, Post, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { AuthGuard } from '../auth/auth.guard';
import { GetUser, UserPayload } from '../auth/get-user.decorator';
import { PromotionsService } from './promotions.service';
import { Promotion } from './promotion.schema';

@ApiTags('promotions')
@UseGuards(AuthGuard)
@Controller('promotions')
export class PromotionsController {

  constructor(
      private readonly promotionsService: PromotionsService,
  ) {}


  @ApiOperation({ summary: 'PRIVATE' })
  @Post('/seed')
  seed(
      @GetUser() userPayload: UserPayload,
  ) {
    return this.promotionsService.seed(userPayload);
  }

  @Get('/show-times/:show_time_id')
  getByShowTimeIdForCurrentUser(
      @GetUser() userPayload: UserPayload,
      @Param('show_time_id') showTimeId: string,
  ): Promise<Promotion[]> {
    return this.promotionsService.getByShowTimeIdForCurrentUser(userPayload, showTimeId);
  }
}
