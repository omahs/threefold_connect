import { nanoid } from 'nanoid';
import { ISocketJoin, ISocketLeave, ISocketSign } from 'types/src';
import { emitJoin, emitLeave, emitSign } from '@/modules/Core/services/socket.service';
import { appId, redirectUrl, state, username } from '@/modules/Initial/data';
import { dataHash, dataUrl, friendlyName, isJson } from '@/modules/InitialSign/data';
import { getPublicKeyOfUsername } from '@/modules/Login/services/external.service';
import { encrypt } from '@/modules/Core/utils/crypto.util';

export type QueryOptionsSigning = {
    username: string;
    friendlyName: string;
    appId: string;
    isJson: boolean;
    state: string;
    redirectUrl: string;
    dataHash: string;
    dataUrl: string;
};

export const signUserMobile = () => {
    const randomRoom = nanoid().toLowerCase();
    const roomToJoin: ISocketJoin = { room: randomRoom };
    emitJoin(roomToJoin);

    const uniLinkUrl = `threebot://sign/?state=${state.value}&appId=${appId.value}&randomRoom=${randomRoom}&dataUrl=${dataUrl.value}&redirecturl=${redirectUrl.value}&dataHash=${dataHash.value}&isJson=${isJson.value}&friendlyName=${friendlyName.value}`;

    window.open(uniLinkUrl);
};

export const signUserWeb = async () => {
    const doubleName = username.value + '.3bot';

    const roomToJoinUser: ISocketJoin = { room: doubleName };
    emitJoin(roomToJoinUser);

    const pk = await getPublicKeyOfUsername(doubleName);

    if (pk.length === 1) return;

    const randomRoom = nanoid();

    const objectToEncrypt = JSON.stringify({
        doubleName: doubleName,
        state: state.value,
        isJson: isJson.value,
        appId: appId.value,
        dataUrl: dataUrl.value,
        randomRoom: randomRoom,
        dataUrlHash: dataHash.value,
        friendlyName: friendlyName.value,
        redirectUrl: redirectUrl.value,
    });

    const encryptedAttempt = encrypt(objectToEncrypt, pk);

    const roomToLeaveUser: ISocketLeave = { room: doubleName };
    emitLeave(roomToLeaveUser);

    const roomToJoinRandom: ISocketJoin = { room: randomRoom };
    emitJoin(roomToJoinRandom);

    const signAttempt: ISocketSign = { doubleName: doubleName, encryptedSignAttempt: encryptedAttempt };
    emitSign(signAttempt);
};
