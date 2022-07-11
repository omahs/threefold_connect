import {Body, Controller, Param, Post} from '@nestjs/common';
import {SignService} from "./sign.service";
import {UserGateway} from "../user/user.gateway";

@Controller('sign')
export class SignController {
    constructor(private readonly signService: SignService, private readonly userGateway: UserGateway) {
    }

    @Post(':username/cancel')
    async cancel(@Param('username') username: string) {
        return this.userGateway.emitCancelSignAttempt(username);
    }

    @Post('signed-attempt')
    async signedLoginAttemptHandler(@Body() data: string) {
        return this.signService.handleSignedSignAttempt(data);
    }
}
