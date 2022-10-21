import { ExpectationFailedException } from '../exceptions';
import { decodeBase64 } from 'tweetnacl-util';

export const decodeBase64ToString = (message: string): string => {
    const decodedAppId = new TextDecoder().decode(decodeBase64(message)).trim();
    if (!decodedAppId) {
        throw new ExpectationFailedException('Message is not base64 encoded');
    }

    return decodedAppId;
};
