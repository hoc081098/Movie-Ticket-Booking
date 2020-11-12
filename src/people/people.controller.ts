import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { PeopleService } from './people.service';
import { AuthGuard } from '../auth/auth.guard';
import { ApiTags } from '@nestjs/swagger';
import { Person } from './person.schema';

@ApiTags('people')
@UseGuards(AuthGuard)
@Controller('people')
export class PeopleController {
  constructor(
      private readonly peopleService: PeopleService,
  ) {}

  @Get('search')
  searchByName(
      @Query('name') name: string,
  ): Promise<Person[]> {
    return this.peopleService.searchByName(name);
  }
}
