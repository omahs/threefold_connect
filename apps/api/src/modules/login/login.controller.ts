import { Body, Controller, Param, Post } from '@nestjs/common';
import { LoginService } from './login.service';
import { UserGateway } from '../user/user.gateway';
import { LoginAttemptDto, UsernameDto } from 'shared-types';

@Controller('login')
export class LoginController {
    constructor(private readonly loginService: LoginService, private readonly userGateway: UserGateway) {}

    @Post(':username/cancel')
    async cancel(@Param('') username: UsernameDto): Promise<void> {
        return this.userGateway.emitCancelLoginAttempt(username.username);
    }

    @Post(':username')
    async signedLoginAttemptHandler(
        @Param('') username: UsernameDto,
        @Body() loginAttempt: LoginAttemptDto
    ): Promise<void> {
        return this.loginService.handleSignedLoginAttempt(username.username, loginAttempt);
    }
}
