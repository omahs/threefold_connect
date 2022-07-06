export enum SocketTypes {
    'CONNECT' = 'connect',
    'DISCONNECT' = 'disconnect',
    'JOIN' = 'JOIN',
    'LEAVE' = 'LEAVE',
    'CHECK_NAME' = 'CHECK_NAME',
    'SIGN' = 'SIGN',
    'LOGIN' = 'LOGIN',
    'NAME_KNOWN' = 'NAME_KNOWN',
    'NAME_UNKNOWN' = 'NAME_UNKNOWN',
    'LOGIN_CANCEL' = 'LOGIN_CANCEL',
    'LOGIN_CALLBACK' = 'LOGIN_CALLBACK',
    'SIGN_CANCEL' = 'SIGN_CANCEL',
    'SIGN_CALLBACK' = 'SIGN_CALLBACK',
    'EMAIL_VERIFIED' = 'EMAIL_VERIFIED',
    'PHONE_VERIFIED' = 'PHONE_VERIFIED',
}

export enum SocketEvents {
    'SIGN' = 'SIGN',
    'LOGIN' = 'LOGIN',
    'LOGIN_ATTEMPT' = 'LOGIN_ATTEMPT',
    'SIGN_ATTEMPT' = 'SIGN_ATTEMPT',
}

export interface ISocketLeave {
    room: string;
}

export interface ISocketJoin {
    room: string;
    app?: boolean;
}

export interface ISocketLogin {
    doubleName: string;
    encryptedLoginAttempt: string;
    created?: number;
    type?: string;
}

export interface ISocketSign {
    doubleName: string;
    encryptedSignAttempt: string;
}

export interface ISocketCheckName {
    username: string;
}

export interface ISocketLoginResult {
    doubleName: string;
    signedAttempt: string;
}

export interface ISocketSignedAttempt {
    signedState: string;
    data: ISocketSignedData;
    doubleName: string;
    randomRoom: string;
    appId: string;
    selectedImageId: number;
}

export interface ISocketSignedData {
    nonce: string;
    ciphertext: string;
}

export enum MobilePlatforms {
    'ANDROID' = 'ANDROID',
    'IOS' = 'IOS',
}
