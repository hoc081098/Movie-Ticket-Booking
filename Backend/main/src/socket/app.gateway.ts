import {
  ConnectedSocket,
  MessageBody,
  OnGatewayConnection,
  OnGatewayDisconnect,
  OnGatewayInit,
  SubscribeMessage,
  WebSocketGateway,
  WebSocketServer
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { Logger, UseGuards } from '@nestjs/common';
import { WsGuard } from './ws.guard';

@WebSocketGateway({ path: '/socket' })
export class AppGateway implements OnGatewayInit, OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;

  private readonly logger = new Logger('AppGateway');

  afterInit(server: Server) {
    this.logger.debug(`Initialized`);
  }

  handleConnection(client: Socket, ...args: any[]) {
    this.logger.debug(`Connected ${client.id}`);
  }

  handleDisconnect(client: Socket) {
    this.logger.debug(`Disconnected ${client.id}`);
  }

  @UseGuards(WsGuard)
  @SubscribeMessage('join')
  joinRoom(
      @ConnectedSocket() client: Socket,
      @MessageBody() room: string
  ) {
    this.logger.debug(`${client.id} joined ${room}`);
    client.join(room);
  }

  @UseGuards(WsGuard)
  @SubscribeMessage('leave')
  leaveRoom(
      @ConnectedSocket() client: Socket,
      @MessageBody() room: string
  ) {
    this.logger.debug(`${client.id} leaved ${room}`);
    client.leave(room);
  }
}