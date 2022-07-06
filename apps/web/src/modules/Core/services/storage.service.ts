import { QueryOptions } from '@/modules/Initial/services/query.service';
import { RouteLocationNormalizedLoaded } from 'vue-router';
import { appId, appPublicKey, redirectUrl, scope, state, username } from '@/modules/Initial/data';

export const setLocalStorageData = (route: RouteLocationNormalizedLoaded) => {
    const queryParams: QueryOptions = route.query as QueryOptions;

    if (queryParams.username) {
        username.value = queryParams.username;
    }

    appId.value = queryParams.appid;
    scope.value = queryParams.scope;
    state.value = queryParams.state;
    appPublicKey.value = queryParams.publickey;
    redirectUrl.value = queryParams.redirecturl;
};
