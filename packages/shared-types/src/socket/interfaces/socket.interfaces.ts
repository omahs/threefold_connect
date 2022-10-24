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
    created?: number;
    type?: string;
}

export interface ISocketCheckName {
    username: string;
}

export interface ISocketLoginResult {
    doubleName: string;
    signedAttempt: string;
}

export interface ISocketSignResult {
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
