import { Controller, Get, Post, Query, UseGuards } from '@nestjs/common';
import { Neo4jService } from './neo4j.service';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { AuthGuard } from '../auth/auth.guard';
import { Roles, RolesGuard } from '../auth/roles.guard';
import { LocationDto } from '../common/location.dto';

@UseGuards(AuthGuard, RolesGuard)
@ApiTags('neo4j')
@Controller('neo4j')
export class Neo4jController {
  constructor(
      private readonly neo4jService: Neo4jService,
  ) {}

  @Roles('ADMIN')
  @ApiOperation({ summary: 'PRIVATE' })
  @Post('transfer')
  transfer() {
    return this.neo4jService.transferData();
  }

  @Get()
  getRecommendedMovies(
      @Query() dto: LocationDto,
  ) {
    return this.neo4jService.getRecommendedMovies(dto);
  }
}
