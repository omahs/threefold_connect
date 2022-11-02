import { Body, Controller, Get, Headers, Param, Post, Put, Query } from '@nestjs/common';
import { UserService } from './user.service';
import { UserGateway } from './user.gateway';
import { ChangeEmailDto, CreatedUserDto, CreateUserDto, GetUserDto, UpdatedUserDto, UsernameDto } from 'shared-types';

@Controller('users')
export class UserController {
    constructor(private readonly userService: UserService, private readonly userGateway: UserGateway) {}

    @Post('')
    async create(@Body() createUserData: CreateUserDto): Promise<CreatedUserDto> {
        return this.userService.create(createUserData);
    }

    @Get('')
    async findAll(@Query() query): Promise<GetUserDto | GetUserDto[]> {
        if (query.publicKey) {
            return await this.userService.findByPublicKey(query.publicKey, true);
        }
        if (query.username) {
            return await this.userService.findByUsername(query.username, true);
        }

        return await this.userService.findAll();
    }

    @Get(':username')
    async findByUsername(@Param() username: UsernameDto): Promise<GetUserDto> {
        return await this.userService.findByUsername(username.username, true);
    }

    @Post(':username/email/verified')
    async emailVerified(@Param() username: UsernameDto): Promise<void> {
        return this.userGateway.emitEmailVerified(username.username);
    }

    @Post(':username/phone/verified')
    async smsVerified(@Param() username: UsernameDto): Promise<void> {
        return this.userGateway.emitSmsVerified(username.username);
    }

    @Put(':username/email')
    async changeEmail(
        @Param() username: UsernameDto,
        @Body() email: ChangeEmailDto,
        @Headers() headers: string
    ): Promise<UpdatedUserDto> {
        return this.userService.changeEmail(username.username, email.email, headers);
    }
}
