import { ExpectationFailedException } from '../../../exceptions';
import { decodeBase64 } from 'tweetnacl-util';

export const decodeBase64ToString = (encodedAppId: string): string => {
    const decodedAppId = new TextDecoder().decode(decodeBase64(encodedAppId)).trim();

    if (!decodedAppId) {
        throw new ExpectationFailedException('AppId is empty or should be base64 encoded');
    }

    return decodedAppId;
};
