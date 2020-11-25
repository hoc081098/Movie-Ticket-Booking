import { Controller, Get, Param, Post, Query, UseGuards } from '@nestjs/common';
import { MovieAndExtraInfo, Neo4jService } from './neo4j.service';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { AuthGuard } from '../auth/auth.guard';
import { Roles, RolesGuard } from '../auth/roles.guard';
import { LocationDto } from '../common/location.dto';
import { GetUser, UserPayload } from '../auth/get-user.decorator';
import { SearchMoviesDto } from './search-movies.dto';
import { Observable } from 'rxjs';

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
      @GetUser() userPayload: UserPayload,
  ): Observable<MovieAndExtraInfo[]> {
    return this.neo4jService.getRecommendedMovies(dto, userPayload);
  }

  @Get('search-movies')
  searchMovies(
      @Query() dto: SearchMoviesDto,
      @GetUser() userPayload: UserPayload,
  ): Observable<MovieAndExtraInfo[]> {
    return this.neo4jService.searchMovies(userPayload, dto);
  }

  @Get('related-movies/:movie_id')
  getRelatedMovies(
      @Param('movie_id') movieId: string
  ) {
    return this.neo4jService.getRelatedMovies(movieId);
  }

  @Post('seed/:id')
  seed(@Param('id') id: string) {
    return this.neo4jService.test(id);
  }
}
