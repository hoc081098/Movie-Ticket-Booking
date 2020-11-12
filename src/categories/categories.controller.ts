import { Controller, Get, Post, UseGuards } from '@nestjs/common';
import { CategoriesService } from './categories.service';
import { Observable } from 'rxjs';
import { Category } from './category.schema';
import { AuthGuard } from '../auth/auth.guard';
import { ApiOperation, ApiTags } from '@nestjs/swagger';

@ApiTags('categories')
@UseGuards(AuthGuard)
@Controller('categories')
export class CategoriesController {
  constructor(
      private readonly categoriesService: CategoriesService,
  ) {}

  @ApiOperation({ summary: 'PRIVATE' })
  @Post('seed')
  seed(): Observable<Category[]> {
    return this.categoriesService.seed();
  }

  @Get()
  getAll(): Promise<Category[]> {
    return this.categoriesService.getAll();
  }
}

