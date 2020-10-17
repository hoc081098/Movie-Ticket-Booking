import { Logger } from '@nestjs/common';
import * as dotenv from 'dotenv';
import * as fs from 'fs';

export const enum ConfigKey {
  MONGODB_URL = 'MONGODB_URL',
  MOVIE_DB_API_KEY = 'MOVIE_DB_API_KEY',
  FIREBASE_API_KEY = 'FIREBASE_API_KEY',
  TEST_AUTH_GUARD = 'TEST_AUTH_GUARD', // USER, ADMIN OR otherwise
  WRITE_TOKEN_TO_FILE = 'WRITE_TOKEN_TO_FILE',
  STRIPE_SECRET_API = 'STRIPE_SECRET_API',
  EMAIL = 'EMAIL',
  EMAIL_PASSWORD = 'EMAIL_PASSWORD',
}

export class ConfigService {
  private readonly logger = new Logger('ConfigService');
  private readonly envConfig: Record<keyof ConfigKey, string>;

  constructor(filePath: string) {
    if (process.env.NODE_ENV === 'production') {
      this.envConfig = process.env as any;
    } else {
      this.envConfig = dotenv.parse(fs.readFileSync(filePath)) as Record<keyof ConfigKey, string>;
    }
    const stringify = JSON.stringify(this.envConfig);
    this.logger.log(`Load config: ${stringify}`)
  }

  get(key: ConfigKey): string {
    const value = this.envConfig[key];
    if (value === undefined) {
      throw Error(`Missing key ${key} in .env file`);
    }
    return value;
  }
}
