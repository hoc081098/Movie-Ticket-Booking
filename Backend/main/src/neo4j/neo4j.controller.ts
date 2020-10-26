import { Controller, Post, UseGuards } from '@nestjs/common';
import { Neo4jService } from './neo4j.service';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { AuthGuard } from '../auth/auth.guard';
import { Roles, RolesGuard } from '../auth/roles.guard';

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
}
