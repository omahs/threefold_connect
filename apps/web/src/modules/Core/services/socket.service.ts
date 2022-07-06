import { inject, reactive } from 'vue';

import { userKnown } from '@/modules/Initial/data';
import { socketCallbackCancel, socketCallbackLogin } from '@/modules/Login/services/callback.service';

import {
    ISocketCheckName,
    ISocketJoin,
    ISocketLeave,
    ISocketLogin,
    ISocketLoginResult,
    ISocketSign,
    SocketTypes,
} from 'custom-types/src';

const state = reactive<State>({
    socket: '',
});

export const initializeSockets = () => {
    state.socket = inject('socket');

    state.socket.on(SocketTypes.CONNECT, () => {
        console.log('[SOCKET:RECEIVE]: CONNECTED');
    });

    state.socket.on(SocketTypes.DISCONNECT, () => {
        console.log('[SOCKET:RECEIVE]: DISCONNECTED');
    });

    state.socket.on(SocketTypes.NAME_KNOWN, () => {
        console.log('[SOCKET:RECEIVE]: NAME KNOWN');
        userKnown.value = true;
    });

    state.socket.on(SocketTypes.NAME_UNKNOWN, () => {
        console.log('[SOCKET:RECEIVE]: NAME UNKNOWN');
        userKnown.value = false;
    });

    state.socket.on(SocketTypes.LOGIN_CANCEL, () => {
        console.log('[SOCKET:RECEIVE]: LOGIN CANCEL');
        socketCallbackCancel();
    });

    state.socket.on(SocketTypes.LOGIN_CALLBACK, async (data: ISocketLoginResult) => {
        console.log('[SOCKET:RECEIVE]: LOGIN_CALLBACK');
        await socketCallbackLogin(data);
    });
};

export const emitCheckName = (name: ISocketCheckName) => {
    console.log('[SOCKET:SEND]: CHECK NAME');
    state.socket.emit(SocketTypes.CHECK_NAME, name);
};

export const emitJoin = (room: ISocketJoin) => {
    state.socket.connect();
    console.log('[SOCKET:SEND]: JOIN ROOM');
    state.socket.emit(SocketTypes.JOIN, room);
};

export const emitLeave = (room: ISocketLeave) => {
    console.log('[SOCKET:SEND]: LEAVE ROOM');
    state.socket.emit(SocketTypes.LEAVE, room);
};

export const emitLogin = (login: ISocketLogin) => {
    console.log('[SOCKET:SEND]: LOGIN');
    state.socket.emit(SocketTypes.LOGIN, login);
};

export const emitSign = (sign: ISocketSign) => {
    console.log('[SOCKET:SEND]: SIGN');
    state.socket.emit(SocketTypes.SIGN, sign);
};

interface State {
    socket: any;
}
