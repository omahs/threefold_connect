export type Configuration = {
    DEBOUNCE_NAME_SOCKET: number;
    API_BACKEND_URL: string;
    API_KYC_URL: string;
    SUPPORT_URL: string;
    PAGE_TITLE: string;
};

export const Config: Configuration = {
    DEBOUNCE_NAME_SOCKET: 500,
    API_BACKEND_URL: 'http://localhost:3001/',
    API_KYC_URL: 'http://192.168.68.115:5005/',
    SUPPORT_URL: 'https://support.grid.tf/',
    PAGE_TITLE: 'ThreeFold Connect Authenticator',
};
