import {Injectable} from '@nestjs/common';
import {PrismaService} from 'nestjs-prisma';
import {UserService} from '../user/user.service';
import {BadRequestException, ConflictException, ExpectationFailedException, NotFoundException,} from '../../exceptions';
import {decodeBase64} from 'tweetnacl-util';
import {CreateDigitalTwinDto, DigitalTwinDetailsDto, DigitalTwinDto} from './dtos/digitaltwin.dto';
import {CreateTwinResponseEnum} from './enums/response.enum';
import {
    deleteTwinByIdQuery,
    findAllTwinsByUsernameQuery,
    findAllTwinsQuery,
    findTwinByUsernameAndAppIdQuery,
    updateTwinYggdrasilIpQuery,
} from './queries/digitaltwin.queries';
import sodium from 'libsodium-wrappers';
import {verifySignature} from "../../utils/crypto.util";

@Injectable()
export class DigitalTwinService {
    constructor(private _prisma: PrismaService, private readonly userService: UserService) {}

    async create(username: string, payload: string) {
        const encodedPayload = JSON.parse(payload);

        const user = await this.userService.findByUsername(username);
        if (!user) {
            throw new NotFoundException(`Username ${username} doesn't exist`);
        }

        const signedData = await verifySignature(encodedPayload['data'], decodeBase64(user.mainPublicKey));
        if (!signedData) {
            throw new BadRequestException('Signature mismatch');
        }

        const readableMessage = new TextDecoder().decode(signedData);
        const messageData: CreateDigitalTwinDto = JSON.parse(readableMessage);

        if (username != messageData.username) {
            throw new ConflictException('Username mismatch');
        }

        const existingTwins = await this.findByUsernameAndAppId(user.username, messageData.appId);
        if (existingTwins) {
            console.log(`Skip the creation part since the combination of appId and username already exists`);
            return CreateTwinResponseEnum.ALREADY_CREATED;
        }

        const twin = {
            derivedPublicKey: messageData.derivedPublicKey,
            appId: messageData.appId,
            userId: user.userId,
        };

        const createdTwin = await this._prisma.digitalTwin.create({data: twin});
        return createdTwin.id
    }

    async updateYggdrasilHandler(username: string, payload: string) {
        const data = JSON.parse(JSON.stringify(payload));

        const signedIp = data.signedYggdrasilIpAddress;
        const appId = data.appId;

        if (!signedIp) {
            throw new ExpectationFailedException('Signed IP is needed');
        }

        if (!appId) {
            throw new ExpectationFailedException('AppId is required');
        }

        const twin = await this.findByUsernameAndAppId(username, appId);
        if (!twin) {
            throw new NotFoundException('Twin does not exist');
        }

        const verifiedMessage = sodium.crypto_sign_open(decodeBase64(signedIp), decodeBase64(twin.derivedPublicKey));

        const verifiedIp = new TextDecoder().decode(verifiedMessage);

        const updatedTwin = await this.update(verifiedIp, twin.id);
        return updatedTwin.id;
    }

    async update(yggdrasilIp: string, twinId: string) {
        return this._prisma.digitalTwin.update(updateTwinYggdrasilIpQuery(yggdrasilIp, twinId));
    }

    async delete(twinId: string) {
        return this._prisma.digitalTwin.delete(deleteTwinByIdQuery(twinId));
    }

    async findAll(): Promise<DigitalTwinDto[]> {
        const t = await this._prisma.digitalTwin.findMany(findAllTwinsQuery);

        return t.map(twin => {
            return {
                yggdrasilIp: twin.yggdrasilIp,
                appId: twin.appId,
                username: twin.user.username,
            };
        });
    }

    async findByUsername(username: string): Promise<DigitalTwinDetailsDto[]> {
        const user = await this.userService.findByUsername(username);
        if (!user) {
            throw new NotFoundException(`Username ${username} doesn't exist`);
        }

        const t = await this._prisma.digitalTwin.findMany(findAllTwinsByUsernameQuery(user.userId));

        if (!t || t.length == 0) {
            throw new NotFoundException('No twins found for username ' + username);
        }

        return t.map(twin => {
            return {
                yggdrasilIp: twin.yggdrasilIp,
                appId: twin.appId,
                username: twin.user.username,
                derivedPublicKey: twin.derivedPublicKey,
            };
        });
    }

    async findByUsernameAndAppId(username: string, appId: string): Promise<DigitalTwinDetailsDto> {
        const user = await this.userService.findByUsername(username);
        if (!user) {
            throw new NotFoundException(`Username ${username} doesn't exist`);
        }

        const t = await this._prisma.digitalTwin.findFirst(findTwinByUsernameAndAppIdQuery(user.userId, appId));
        if (!t) {
            return;
        }

        return {
            id: t.id,
            yggdrasilIp: t.yggdrasilIp,
            appId: t.appId,
            username: t.user.username,
            derivedPublicKey: t.derivedPublicKey,
        };
    }
}
