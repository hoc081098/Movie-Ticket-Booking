import { Controller, Get, Post, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { AuthGuard } from '../auth/auth.guard';
import { ProductsService } from './products.service';
import { Product } from './product.schema';

@ApiTags('products')
@UseGuards(AuthGuard)
@Controller('products')
export class ProductsController {
  constructor(
      private readonly productsService: ProductsService,
  ) {}

  @ApiOperation({ summary: 'PRIVATE' })
  @Post('seed')
  seed(): Promise<Product[]> {
    return this.productsService.seed();
  }

  @Get()
  getAll(): Promise<Product[]> {
    return this.productsService.getAll();
  }
}
