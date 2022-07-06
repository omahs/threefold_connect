import axios from 'axios';
import { Config } from '@/modules/Core/configs/config';

export interface RetrieveSpiDto {
    user_id: string;
    verification_code: string;
}

export const getSignedPhoneIdentifier = async (phoneData: RetrieveSpiDto) => {
    try {
        return (await axios.post(`${Config.API_KYC_URL}verification/verify-sms`, phoneData))?.data;
    } catch (err) {
        return null;
    }
};

export const getSignedPhoneIdentifierSigner = async (spi: string) => {
    try {
        return (
            await axios.post(`${Config.API_KYC_URL}verification/verify-spi`, {
                signedPhoneIdentifier: spi,
            })
        )?.data;
    } catch (err) {
        return null;
    }
};

export const setPhoneVerified = async (username: string) => {
    try {
        return await axios.post(`${Config.API_BACKEND_URL}api/users/${username}/smsverified`);
    } catch (err) {
        return null;
    }
};
