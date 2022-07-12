import {Injectable} from '@nestjs/common';
import {UserService} from "../user/user.service";
import {UserGateway} from "../user/user.gateway";
import {BadRequestException, NotFoundException} from "../../exceptions";
import {verifySignature} from "../../utils/crypto.util";
import {decodeBase64} from "tweetnacl-util";
import {SignedSignAttemptDto} from "./dtos/sign.dto";

@Injectable()
export class SignService {
    constructor(private readonly userService: UserService, private readonly userGateway: UserGateway) {
    }

    async handleSignedSignAttempt(data: string): Promise<void>  {
        const signedSignAttempt: SignedSignAttemptDto = JSON.parse(JSON.stringify(data));

        const username = signedSignAttempt.doubleName;

        const user = await this.userService.findByUsername(username);
        if (!user) {
            throw new NotFoundException('User not found');
        }

        const signedData = await verifySignature(signedSignAttempt.signedAttempt, decodeBase64(user.mainPublicKey));
        if (!signedData) {
            throw new BadRequestException('Signature mismatch');
        }

        const readableMessage = JSON.parse(new TextDecoder().decode(signedData));

        let room = readableMessage['randomRoom'].toLowerCase();
        if (!room) {
            room = username.toLowerCase();
        }

        await this.userGateway.emitSignedSignAttempt(room, signedSignAttempt);
    }
}
