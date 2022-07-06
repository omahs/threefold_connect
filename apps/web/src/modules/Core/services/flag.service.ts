import flagsmith from 'flagsmith';
import axios from 'axios';

export const initFlags = async () => {
    const isDev: boolean = process.env.NODE_ENV === 'development';
    const override = 'VGR7Kmd6qWqnYaZxXU7Gyw';

    const environmentID = override;
    console.log({ flagsmithEnv: environmentID });

    await flagsmith.init({
        environmentID,
        api: 'https://flagsmith.jimber.io/api/v1/',
    });

    await flagsmith.getFlags();

    console.table({ flags: flagsmith.getAllFlags() });
};
