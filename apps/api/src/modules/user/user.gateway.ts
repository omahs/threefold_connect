import { MessageBody, SubscribeMessage, WebSocketGateway, WebSocketServer } from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';

// @ts-ignore
import { ISocketCheckName, ISocketJoin, ISocketLeave, ISocketLogin, SocketEvents, SocketTypes } from 'custom-types';
import { UserService } from './user.service';
import { SignedLoginAttemptDto, SignedSignAttemptDto } from '../app/app.service';

export interface IQueueMessage {
    event: string;
    data: Object;
}

@WebSocketGateway({ cors: true })
export class UserGateway {
    constructor(private _userService: UserService) {}

    private _messageQueue = {};
    private _socketRoom = {};

    @WebSocketServer()
    server: Server;

    @SubscribeMessage(SocketTypes.CHECK_NAME)
    async checkName(@MessageBody() data: ISocketCheckName) {
        const exist = await this._userService.findByUsername(data.username);
        return this.server.emit(exist ? SocketTypes.NAME_KNOWN : SocketTypes.NAME_UNKNOWN);
    }

    @SubscribeMessage(SocketTypes.LOGIN)
    async handleLogin(@MessageBody() data: ISocketLogin) {
        if (!data.encryptedLoginAttempt) return;

        data.type = SocketEvents.LOGIN;
        data.created = new Date().getTime();

        const m: IQueueMessage = {
            event: SocketEvents.LOGIN,
            data: data,
        };

        this._emitOrQueue(m, data.doubleName);
    }

    @SubscribeMessage(SocketTypes.JOIN)
    async handleJoinRoom(client: Socket, data: ISocketJoin) {
        if (client.id == null) return;
        if (data.room == null) return;

        const socketId = client.id;

        const room = data.room.toLowerCase();

        console.log('User ', room, ' joined the room');
        client.join(room);

        // User joined + we are sure he can get notifications inside the app
        if (data.app) {
            this._socketRoom[socketId] = room;
        }

        if (Object.keys(this._messageQueue).includes(room) && Object.values(this._socketRoom).includes(room)) {
            this._sendQueuedMessages(room);
        }
    }

    @SubscribeMessage(SocketTypes.LEAVE)
    async handleLeaveRoom(client: Socket, data: ISocketLeave) {
        if (client.id == null) return;
        if (data.room == null) return;

        const socketId = client.id;

        if (Object.keys(this._socketRoom).includes(socketId)) {
            const room = this._socketRoom[socketId];
            this._socketRoom[socketId] = null;

            console.log('User ', room, ' left the room');
            client.leave(room);
        }
    }

    async emitCancelLoginAttempt(username: string) {
        this.server.to(username).emit(SocketTypes.LOGIN_CANCEL, { scanned: true });
    }

    async emitCancelSignAttempt(username: string) {
        this.server.to(username).emit(SocketTypes.SIGN_CANCEL, { scanned: true });
    }

    async emitEmailVerified(username: string) {
        this.server.to(username).emit(SocketTypes.EMAIL_VERIFIED, '');
    }

    async emitSmsVerified(username: string) {
        this.server.to(username).emit(SocketTypes.EMAIL_VERIFIED, '');
    }

    async emitSignedLoginAttempt(room: string, data: SignedLoginAttemptDto) {
        this.server.to(room).emit(SocketEvents.LOGIN_ATTEMPT, data);
    }

    async emitSignedSignAttempt(room: string, data: SignedSignAttemptDto) {
        this.server.to(room).emit(SocketEvents.SIGN_ATTEMPT, data);
    }

    private _sendQueuedMessages(room: string) {
        console.log('Firing queue for ', room);

        this._messageQueue[room].forEach((m: IQueueMessage) => {
            this.server.to(room).emit(m.event, m.data);
        });

        this._messageQueue[room] = [];
    }

    private _emitOrQueue(message: IQueueMessage, room: string) {
        if (Object.values(this._socketRoom).includes(room)) {
            console.log('Sending message to ', room);
            return this.server.to(room).emit(message.event, message.data);
        }

        console.log('Putting message in queue');
        let q = this._messageQueue[room] ? this._messageQueue[room] : [];
        q.push(message);

        return (this._messageQueue[room] = q);
    }
}
