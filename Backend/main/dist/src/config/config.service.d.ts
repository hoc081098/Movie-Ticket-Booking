export declare const enum ConfigKey {
    MONGODB_URL = "MONGODB_URL",
    MOVIE_DB_API_KEY = "MOVIE_DB_API_KEY",
    FIREBASE_API_KEY = "FIREBASE_API_KEY",
    TEST_AUTH_GUARD = "TEST_AUTH_GUARD",
    WRITE_TOKEN_TO_FILE = "WRITE_TOKEN_TO_FILE",
    STRIPE_SECRET_API = "STRIPE_SECRET_API"
}
export declare class ConfigService {
    private readonly logger;
    private readonly envConfig;
    constructor(filePath: string);
    get(key: ConfigKey): string;
}
