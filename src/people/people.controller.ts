import { Controller } from '@nestjs/common';
import { PeopleService } from './people.service';

@Controller('people')
export class PeopleController {
  constructor(
      private readonly peopleService: PeopleService,
  ) {}

}
