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
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AppGateway = void 0;
const websockets_1 = require("@nestjs/websockets");
const common_1 = require("@nestjs/common");
const ws_guard_1 = require("./ws.guard");
let AppGateway = class AppGateway {
    constructor() {
        this.logger = new common_1.Logger('AppGateway');
    }
    afterInit(server) {
        this.logger.debug(`Initialized`);
    }
    handleConnection(client, ...args) {
        this.logger.debug(`Connected ${client.id}`);
    }
    handleDisconnect(client) {
        this.logger.debug(`Disconnected ${client.id}`);
    }
    joinRoom(client, room) {
        this.logger.debug(`${client.id} joined ${room}`);
        client.join(room);
    }
    leaveRoom(client, room) {
        this.logger.debug(`${client.id} leaved ${room}`);
        client.leave(room);
    }
};
__decorate([
    websockets_1.WebSocketServer(),
    __metadata("design:type", Object)
], AppGateway.prototype, "server", void 0);
__decorate([
    common_1.UseGuards(ws_guard_1.WsGuard),
    websockets_1.SubscribeMessage('join'),
    __param(0, websockets_1.ConnectedSocket()),
    __param(1, websockets_1.MessageBody()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String]),
    __metadata("design:returntype", void 0)
], AppGateway.prototype, "joinRoom", null);
__decorate([
    common_1.UseGuards(ws_guard_1.WsGuard),
    websockets_1.SubscribeMessage('leave'),
    __param(0, websockets_1.ConnectedSocket()),
    __param(1, websockets_1.MessageBody()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String]),
    __metadata("design:returntype", void 0)
], AppGateway.prototype, "leaveRoom", null);
AppGateway = __decorate([
    websockets_1.WebSocketGateway(3001)
], AppGateway);
exports.AppGateway = AppGateway;
//# sourceMappingURL=app.gateway.js.map