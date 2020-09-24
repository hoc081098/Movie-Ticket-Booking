import { Controller, UseGuards } from '@nestjs/common';
import { PeopleService } from './people.service';
import { AuthGuard } from '../auth/auth.guard';
import { ApiTags } from '@nestjs/swagger';

@ApiTags('people')
@UseGuards(AuthGuard)
@Controller('people')
export class PeopleController {
  constructor(
      private readonly peopleService: PeopleService,
  ) {}

}
