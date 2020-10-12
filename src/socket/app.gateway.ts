import {
  OnGatewayConnection,
  OnGatewayDisconnect,
  OnGatewayInit,
  WebSocketGateway,
  WebSocketServer
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { Logger } from '@nestjs/common';

@WebSocketGateway(3001)
export class AppGateway implements OnGatewayInit, OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;

  private readonly logger = new Logger('AppGateway');

  afterInit(server: Server) {
    this.logger.debug(`Initialized`);
  }

  handleConnection(client: Socket, ...args: any[]) {
    this.logger.debug(`Connected ${client.id}`);

    client.on('join', (room: string) => {
      this.logger.debug(`${client.id} joined ${room}`);
      client.join(room);
    });

    client.on('leave', (room: string) => {
      this.logger.debug(`${client.id} leaved ${room}`);
      client.leave(room);
    });
  }

  handleDisconnect(client: Socket) {
    this.logger.debug(`Disconnected ${client.id}`);
  }
}