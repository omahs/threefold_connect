import { Body, Controller, Get, HttpCode, Post } from '@nestjs/common';
import { AppService } from './app.service';
import { FlagsmithService } from '../flagsmith/flagsmith.service';
import sodium from 'libsodium-wrappers';

export interface CreateUserDto {
    doubleName: string;
    email: string;
    publicKey: string;
}

@Controller()
export class AppController {
    constructor(private readonly appService: AppService, private readonly flagService: FlagsmithService) {}

    @Post('signedAttempt')
    async signedLoginAttemptHandler(@Body() data: string) {
        return this.appService.handleSignedLoginAttempt(data);
    }

    @Post('signedSignDataAttempt')
    async signedSignAttemptHandler(@Body() data: string) {
        return this.appService.handleSignedSignAttempt(data);
    }

    @HttpCode(200)
    @Post('mobileregistration')
    async create(@Body() createUserData: string) {
        return this.appService.create(createUserData);
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
}
