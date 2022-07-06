import axios from 'axios';
import { Config } from '@/modules/Core/configs/config';

export interface RetrieveSeiDto {
    user_id: string;
    verification_code: string;
}

export const getSignedEmailIdentifier = async (emailData: RetrieveSeiDto) => {
    try {
        return (await axios.post(`${Config.API_KYC_URL}verification/verify-email`, emailData))?.data;
    } catch (err) {
        return null;
    }
};

export const getSignedEmailIdentifierSigner = async (sei: string) => {
    try {
        return (
            await axios.post(`${Config.API_KYC_URL}verification/verify-sei`, {
                signedEmailIdentifier: sei,
            })
        )?.data;
    } catch (err) {
        return null;
    }
};

export const setEmailVerified = async (username: string) => {
    try {
        return await axios.post(`${Config.API_BACKEND_URL}api/users/${username}/emailverified`);
    } catch (err) {
        return null;
    }
};
