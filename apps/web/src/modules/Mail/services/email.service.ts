import {
    getSignedEmailIdentifier,
    getSignedEmailIdentifierSigner,
    RetrieveSeiDto,
    setEmailVerified,
} from '@/modules/Mail/services/external.service';

// Status 0: CHECKING
// Status 1: SUCCESS
// Status 2: FAILURE
export const validateEmail = async (username: string, code: string): Promise<number> => {
    if (!username || !code) {
        return 2;
    }

    const emailData: RetrieveSeiDto = {
        user_id: username,
        verification_code: code,
    };

    const signedEmailIdentifier = await getSignedEmailIdentifier(emailData);
    if (!signedEmailIdentifier) {
        return 2;
    }

    const signer = await getSignedEmailIdentifierSigner(signedEmailIdentifier);
    if (!signer) {
        return 2;
    }

    if (signer.identifier !== username) {
        return 2;
    }

    const verified = await setEmailVerified(username);
    if (!verified) {
        return 2;
    }

    return 1;
};
