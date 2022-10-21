import { Injectable } from '@nestjs/common';
import { PrismaService } from 'nestjs-prisma';
import { UserService } from '../user/user.service';
import {
    BadRequestException,
    ConflictException,
    ExpectationFailedException,
    NotFoundException,
} from '../../exceptions';
import { decodeBase64 } from 'tweetnacl-util';
import { CreateDigitalTwinDto, DigitalTwinDetailsDto, DigitalTwinDto } from 'shared-types';
import {
    findAllTwinsByUsernameQuery,
    findAllTwinsQuery,
    findTwinByUsernameAndAppIdQuery,
    updateTwinYggdrasilIpQuery,
} from './queries/digitaltwin.queries';
import { verifyMessage } from '../../utils/crypto.utils';

@Injectable()
export class DigitalTwinService {
    constructor(private _prisma: PrismaService, private readonly userService: UserService) {}

    async create(username: string, payload: string): Promise<string> {
        const encodedPayload = JSON.parse(payload);

        const user = await this.userService.findByUsername(username);
        if (!user) {
            throw new NotFoundException(`Username ${username} doesn't exist`);
        }

        const signedData = verifyMessage(decodeBase64(encodedPayload['data']), decodeBase64(user.mainPublicKey));
        if (!signedData) throw new BadRequestException('Signature mismatch');

        const messageData: CreateDigitalTwinDto = JSON.parse(signedData);

        if (username != messageData.username) {
            throw new ConflictException('Username mismatch');
        }

        const existingTwins = await this.findByUsernameAndAppId(user.username, messageData.appId);
        if (existingTwins) {
            return 'Combination of username and appId already exists';
        }

        const twin = {
            derivedPublicKey: messageData.derivedPublicKey,
            appId: messageData.appId,
            userId: user.userId,
        };

        const createdTwin = await this._prisma.digitalTwin.create({ data: twin });
        return createdTwin.id;
    }

    async updateYggdrasilOfTwin(username: string, payload: string): Promise<string> {
        const { signedIp, appId } = JSON.parse(JSON.stringify(payload));

        if (!signedIp) throw new ExpectationFailedException('Yggdrasil IP is required');
        if (!appId) throw new ExpectationFailedException('AppId is required');

        const twin = await this.findByUsernameAndAppId(username, appId);
        if (!twin) throw new NotFoundException(`There is no twin named ${username} with appId ${appId}`);

        const verifiedIp = verifyMessage(decodeBase64(signedIp), decodeBase64(twin.derivedPublicKey));

        const updatedTwin = await this.update(verifiedIp, twin.id);
        return updatedTwin.id;
    }

    async update(yggdrasilIp: string, twinId: string) {
        return this._prisma.digitalTwin.update(updateTwinYggdrasilIpQuery(yggdrasilIp, twinId));
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
            throw new NotFoundException(`Username ${username} does not exists`);
        }

        const t = await this._prisma.digitalTwin.findMany(findAllTwinsByUsernameQuery(user.userId));
        if (!t || t.length == 0) {
            throw new NotFoundException(`No twins found for username ${username}`);
        }

        return t.map(twin => {
            return {
                id: twin.id,
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
            throw new NotFoundException(`Username ${username} does not exists`);
        }

        const t = await this._prisma.digitalTwin.findFirst(findTwinByUsernameAndAppIdQuery(user.userId, appId));
        if (!t) throw new NotFoundException(`No twins found for username ${username} in combination with ${appId}`);

        return {
            id: t.id,
            yggdrasilIp: t.yggdrasilIp,
            appId: t.appId,
            username: t.user.username,
            derivedPublicKey: t.derivedPublicKey,
        };
    }
}
