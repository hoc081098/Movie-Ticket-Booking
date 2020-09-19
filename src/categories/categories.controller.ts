import { Controller, Post } from '@nestjs/common';
import { CategoriesService } from './categories.service';
import { Observable } from 'rxjs';
import { Category } from './category.schema';

@Controller('categories')
export class CategoriesController {
  constructor(
      private readonly categoriesService: CategoriesService,
  ) {}

  @Post('seed')
  seed(): Observable<Category[]> {
    return this.categoriesService.seed();
  }
}
