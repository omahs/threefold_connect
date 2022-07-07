import {crypto_box_seal, crypto_sign_ed25519_pk_to_curve25519, crypto_sign_open} from "libsodium-wrappers";
import {decodeBase64, encodeBase64} from "tweetnacl-util";

export const verifySignature = async (signedData: string, publicKey: Uint8Array) => {
    try {
        return crypto_sign_open(decodeBase64(signedData), publicKey);
    } catch (e) {
        console.log(e)
        return null;
    }
};

export const encrypt = (message: string, publicKey: Uint8Array): string => {
    const encryptionKey: Uint8Array = crypto_sign_ed25519_pk_to_curve25519(publicKey);
    return encodeBase64(crypto_box_seal(message, encryptionKey, 'uint8array'));
};
