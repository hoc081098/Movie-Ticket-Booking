"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.LocationDto = void 0;
const openapi = require("@nestjs/swagger");
const class_validator_1 = require("class-validator");
const class_transformer_1 = require("class-transformer");
class LocationDto {
    static _OPENAPI_METADATA_FACTORY() {
        return { lat: { required: false, type: () => Number, minimum: -90, maximum: 90 }, lng: { required: false, type: () => Number, minimum: -180, maximum: 180 } };
    }
}
__decorate([
    class_validator_1.IsOptional(),
    class_validator_1.IsNumber(),
    class_validator_1.Min(-90),
    class_validator_1.Max(90),
    class_transformer_1.Type(() => Number),
    __metadata("design:type", Number)
], LocationDto.prototype, "lat", void 0);
__decorate([
    class_validator_1.IsOptional(),
    class_validator_1.IsNumber(),
    class_validator_1.Min(-180),
    class_validator_1.Max(180),
    class_transformer_1.Type(() => Number),
    __metadata("design:type", Number)
], LocationDto.prototype, "lng", void 0);
exports.LocationDto = LocationDto;
//# sourceMappingURL=location.dto.js.map