import {Body, Controller, Get, Headers, Param, Post} from '@nestjs/common';
import {UserService} from './user.service';
import {User as UserModel} from '@prisma/client';
import {UserGateway} from './user.gateway';

@Controller('users')
export class UserController {
    constructor(private readonly userService: UserService, private readonly userGateway: UserGateway) {
    }


    @Post('')
    async create(@Body() createUserData: string) {
        return this.userService.create(createUserData);
    }

    @Post(':username/emailverified')
    async emailVerified(@Param('username') username: string) {
        return this.userGateway.emitEmailVerified(username);
    }

    @Post(':username/smsverified')
    async smsVerified(@Param('username') username: string) {
        return this.userGateway.emitSmsVerified(username);
    }

    @Post('change-email')
    async changeEmail(@Body() data: string, @Headers() headers) {
        return this.userService.changeEmail(data, headers);
    }

    @Get('')
    async findAll(): Promise<UserModel[]> {
        return await this.userService.findAll();
    }

    @Get(':username')
    async findByUsername(@Param('username') username: string): Promise<UserModel> {
        return await this.userService.findByUsername(username);
    }
}
