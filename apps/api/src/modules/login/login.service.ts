import {Injectable} from '@nestjs/common';
import {BadRequestException, NotFoundException} from "../../exceptions";
import {verifySignature} from "../../utils/crypto.util";
import {UserService} from "../user/user.service";
import {decodeBase64} from "tweetnacl-util";
import {UserGateway} from "../user/user.gateway";
import {SignedLoginAttemptDto} from "./dtos/login.dto";

@Injectable()
export class LoginService {
    constructor(private readonly userService: UserService, private readonly userGateway: UserGateway) {
    }

    async handleSignedLoginAttempt(data: string): Promise<void> {
        const signedLoginAttempt: SignedLoginAttemptDto = JSON.parse(JSON.stringify(data));

        const username = signedLoginAttempt.doubleName;

        const user = await this.userService.findByUsername(username);
        if (!user) {
            throw new NotFoundException('User not found');
        }

        const signedData = await verifySignature(signedLoginAttempt.signedAttempt, decodeBase64(user.mainPublicKey));
        if (!signedData) {
            throw new BadRequestException('Signature mismatch');
        }

        const readableMessage = JSON.parse(new TextDecoder().decode(signedData));

        let room = readableMessage['randomRoom'].toLowerCase();
        if (!room) {
            room = username.toLowerCase();
        }

        await this.userGateway.emitSignedLoginAttempt(room, signedLoginAttempt);
    }

}
