import { Module } from '@nestjs/common';
import { Neo4jService } from './neo4j.service';

@Module({
  providers: [Neo4jService]
})
export class Neo4jModule {}
