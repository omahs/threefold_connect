import sodium, { crypto_box_seal, crypto_sign_ed25519_pk_to_curve25519 } from 'libsodium-wrappers';
import { encodeBase64 } from 'tweetnacl-util';
import { ExpectationFailedException } from '../exceptions';

export const verifyMessage = (signedData: Uint8Array, publicKey: Uint8Array): string => {
    try {
        const verifiedMessage = sodium.crypto_sign_open(signedData, publicKey);
        return new TextDecoder().decode(verifiedMessage);
    } catch (e) {
        throw new ExpectationFailedException(
            `Signature mismatch for publicKey ${encodeBase64(publicKey)} with data ${encodeBase64(signedData)}`
        );
    }
};

export const encrypt = (message: string, publicKey: Uint8Array): string => {
    const encryptionKey: Uint8Array = crypto_sign_ed25519_pk_to_curve25519(publicKey);
    return encodeBase64(crypto_box_seal(message, encryptionKey, 'uint8array'));
};
