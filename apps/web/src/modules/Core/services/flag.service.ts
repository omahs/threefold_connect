import axios from "axios";
import {Config} from "@/modules/Core/configs/config";

export const initializeConfiguration = async () => {
    let t;

    try {
        t = (await axios.get('/api/env')).data;

        Config.DEBOUNCE_NAME_SOCKET = t['debounce-name-socket'].value
        Config.SUPPORT_URL = t['support-url'].value
        Config.API_KYC_URL = t['openkyc-url'].value

    } catch (e) {
        console.error(e)
        console.log('Could not get flagsmith configs of backend')
    }

    console.table(t)

};
