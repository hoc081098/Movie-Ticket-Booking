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
exports.AddCardDto = exports.Card = void 0;
const openapi = require("@nestjs/swagger");
const class_validator_1 = require("class-validator");
class Card {
    constructor(raw) {
        Object.assign(this, raw);
    }
    static _OPENAPI_METADATA_FACTORY() {
        return { id: { required: true, type: () => String }, brand: { required: true, type: () => String }, country: { required: true, type: () => String }, exp_month: { required: true, type: () => Number }, exp_year: { required: true, type: () => Number }, funding: { required: true, type: () => String }, last4: { required: true, type: () => String }, card_holder_name: { required: true, type: () => String } };
    }
}
exports.Card = Card;
class AddCardDto {
    static _OPENAPI_METADATA_FACTORY() {
        return { card_holder_name: { required: true, type: () => String }, number: { required: true, type: () => String }, exp_year: { required: true, type: () => Number, minimum: 20, maximum: 99 }, exp_month: { required: true, type: () => Number, minimum: 1, maximum: 12 }, cvc: { required: true, type: () => String } };
    }
}
__decorate([
    class_validator_1.IsString(),
    class_validator_1.IsNotEmpty(),
    __metadata("design:type", String)
], AddCardDto.prototype, "card_holder_name", void 0);
__decorate([
    class_validator_1.IsString(),
    class_validator_1.Length(16, 16),
    class_validator_1.Matches(/^[0-9]{16}$/),
    __metadata("design:type", String)
], AddCardDto.prototype, "number", void 0);
__decorate([
    class_validator_1.IsNumber(),
    class_validator_1.Min(20),
    class_validator_1.Max(99),
    __metadata("design:type", Number)
], AddCardDto.prototype, "exp_year", void 0);
__decorate([
    class_validator_1.IsNumber(),
    class_validator_1.Min(1),
    class_validator_1.Max(12),
    __metadata("design:type", Number)
], AddCardDto.prototype, "exp_month", void 0);
__decorate([
    class_validator_1.IsString(),
    class_validator_1.Length(3, 3),
    class_validator_1.Matches(/^[0-9]{3}$/),
    __metadata("design:type", String)
], AddCardDto.prototype, "cvc", void 0);
exports.AddCardDto = AddCardDto;
//# sourceMappingURL=card.dto.js.map