import { Body, Controller, Get, Headers, Param, Post } from '@nestjs/common';
import { UserService } from './user.service';
import { UserGateway } from './user.gateway';
import { ChangeEmailDto, CreatedUserDto, CreateUserDto, GetUserDto, UpdatedUserDto } from 'shared-types';

@Controller('users')
export class UserController {
    constructor(private readonly userService: UserService, private readonly userGateway: UserGateway) {}

    @Post('')
    async create(@Body() createUserData: CreateUserDto): Promise<CreatedUserDto> {
        return this.userService.create(createUserData);
    }

    @Post(':username/emailverified')
    async emailVerified(@Param('username') username: string): Promise<void> {
        return this.userGateway.emitEmailVerified(username);
    }

    @Post(':username/smsverified')
    async smsVerified(@Param('username') username: string): Promise<void> {
        return this.userGateway.emitSmsVerified(username);
    }

    @Post('change-email')
    async changeEmail(@Body() changeEmailData: ChangeEmailDto, @Headers() headers: string): Promise<UpdatedUserDto> {
        return this.userService.changeEmail(changeEmailData, headers);
    }

    @Get('')
    async findAll(): Promise<GetUserDto[]> {
        return await this.userService.findAll();
    }

    @Get(':username')
    async findByUsername(@Param('username') username: string): Promise<GetUserDto> {
        return await this.userService.findByUsername(username);
    }
}
