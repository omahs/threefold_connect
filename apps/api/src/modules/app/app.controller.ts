import {Controller, Get} from '@nestjs/common';
import {AppService} from './app.service';
import {FlagsmithService} from '../flagsmith/flagsmith.service';

export interface CreateUserDto {
    doubleName: string;
    email: string;
    publicKey: string;
}

@Controller()
export class AppController {
    constructor(private readonly appService: AppService, private readonly flagService: FlagsmithService) {
    }

    @Get('maintenance')
    async isInMaintenance() {
        const maintenance = await this.flagService.isInMaintenance();
        return { maintenance: maintenance };
    }

    @Get('minimumversion')
    async getMinimumVersion() {
        return await this.flagService.getMinimumVersions();
    }

    @Get('env')
    async getEnvironmentVariables() {
        return await this.flagService.getEnvironmentVariables();
    }
}
