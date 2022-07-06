import axios from 'axios';
import { decodeBase64 } from 'tweetnacl-util';
import { Config } from '@/modules/Core/configs/config';

export const getPublicKeyOfUsername = async (username: string): Promise<Uint8Array> => {
    try {
        return decodeBase64((await axios.get(`${Config.API_BACKEND_URL}api/users/${username}`))?.data.publicKey);
    } catch (err) {
        console.error('Username of external API not found / Not valid');
        return Uint8Array.of(0);
    }
};
