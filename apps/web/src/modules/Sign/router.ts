import { Router } from 'vue-router';
import Sign from '@/modules/Sign/views/Sign.vue';

export const signRoutes = [
    {
        name: 'sign',
        path: '/sign',
        component: Sign,
    },
];

export default async (router: Router) => {
    for (const route of signRoutes) {
        router.addRoute(route);
    }
};
