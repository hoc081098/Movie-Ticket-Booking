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
exports.CreateReservationDto = exports.CreateReservationProductDto = void 0;
const openapi = require("@nestjs/swagger");
const class_validator_1 = require("class-validator");
const class_transformer_1 = require("class-transformer");
class CreateReservationProductDto {
    static _OPENAPI_METADATA_FACTORY() {
        return { product_id: { required: true, type: () => String }, quantity: { required: true, type: () => Number, minimum: 1, maximum: 20 } };
    }
}
__decorate([
    class_validator_1.IsString(),
    class_validator_1.IsNotEmpty(),
    __metadata("design:type", String)
], CreateReservationProductDto.prototype, "product_id", void 0);
__decorate([
    class_validator_1.IsNumber(),
    class_validator_1.Min(1),
    class_validator_1.Max(20),
    __metadata("design:type", Number)
], CreateReservationProductDto.prototype, "quantity", void 0);
exports.CreateReservationProductDto = CreateReservationProductDto;
class CreateReservationDto {
    static _OPENAPI_METADATA_FACTORY() {
        return { show_time_id: { required: true, type: () => String }, phone_number: { required: true, type: () => String }, email: { required: true, type: () => String }, products: { required: true, type: () => [require("./reservation.dto").CreateReservationProductDto] }, original_price: { required: true, type: () => Number }, pay_card_id: { required: true, type: () => String }, ticket_ids: { required: true, type: () => [String] } };
    }
}
__decorate([
    class_validator_1.IsString(),
    class_validator_1.IsNotEmpty(),
    __metadata("design:type", String)
], CreateReservationDto.prototype, "show_time_id", void 0);
__decorate([
    class_validator_1.IsString(),
    class_validator_1.IsPhoneNumber('VN'),
    __metadata("design:type", String)
], CreateReservationDto.prototype, "phone_number", void 0);
__decorate([
    class_validator_1.IsString(),
    class_validator_1.IsNotEmpty(),
    class_validator_1.IsEmail(),
    __metadata("design:type", String)
], CreateReservationDto.prototype, "email", void 0);
__decorate([
    class_validator_1.IsArray(),
    class_validator_1.ValidateNested({ each: true }),
    class_transformer_1.Type(() => CreateReservationProductDto),
    __metadata("design:type", Array)
], CreateReservationDto.prototype, "products", void 0);
__decorate([
    class_validator_1.IsNumber(),
    __metadata("design:type", Number)
], CreateReservationDto.prototype, "original_price", void 0);
__decorate([
    class_validator_1.IsString(),
    class_validator_1.IsNotEmpty(),
    __metadata("design:type", String)
], CreateReservationDto.prototype, "pay_card_id", void 0);
__decorate([
    class_validator_1.IsArray(),
    class_validator_1.ArrayNotEmpty(),
    class_validator_1.IsString({ each: true }),
    class_validator_1.IsNotEmpty({ each: true }),
    __metadata("design:type", Array)
], CreateReservationDto.prototype, "ticket_ids", void 0);
exports.CreateReservationDto = CreateReservationDto;
//# sourceMappingURL=reservation.dto.js.map