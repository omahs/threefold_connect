import {
    getSignedPhoneIdentifier,
    getSignedPhoneIdentifierSigner,
    RetrieveSpiDto,
    setPhoneVerified,
} from '@/modules/Phone/services/external.service';

// Status 0: CHECKING
// Status 1: SUCCESS
// Status 2: FAILURE
export const validatePhone = async (username: string, code: string): Promise<number> => {
    if (!username || !code) {
        return 2;
    }

    const phoneData: RetrieveSpiDto = {
        user_id: username,
        verification_code: code,
    };

    const signedPhoneIdentifier = await getSignedPhoneIdentifier(phoneData);
    if (!signedPhoneIdentifier) {
        return 2;
    }

    const signer = await getSignedPhoneIdentifierSigner(signedPhoneIdentifier);
    if (!signer) {
        return 2;
    }

    if (signer.identifier !== username) {
        return 2;
    }

    const verified = await setPhoneVerified(username);
    if (!verified) {
        return 2;
    }

    return 1;
};
