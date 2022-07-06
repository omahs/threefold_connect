import { Body, Controller, Get, Param, Post, Put } from '@nestjs/common';
import { DigitalTwinService } from './digitaltwin.service';
import { decodeBase64ToString } from './utils/transform.util';
import { DigitalTwinDto } from './dtos/digitaltwin.dto';

@Controller('digitaltwin')
export class DigitalTwinController {
    constructor(private readonly digitalTwinService: DigitalTwinService) {}
    @Post(':username')
    async create(@Param('username') username: string, @Body() data: any) {
        return await this.digitalTwinService.create(username, data.toString());
    }

    @Put(':username')
    async update(@Param('username') username: string, @Body() data: string) {
        return await this.digitalTwinService.updateYggdrasilHandler(username, data);
    }

    @Get('')
    async findAll(): Promise<DigitalTwinDto[]> {
        return await this.digitalTwinService.findAll();
    }

    @Get(':username')
    async findByUsername(@Param('username') username: string): Promise<DigitalTwinDto[]> {
        return await this.digitalTwinService.findByUsername(username);
    }

    @Get(':username/:appId')
    async findByUsernameAndAppId(
        @Param('username') username: string,
        @Param('appId') appId: string
    ): Promise<DigitalTwinDto> {
        return await this.digitalTwinService.findByUsernameAndAppId(username, decodeBase64ToString(appId));
    }
}
