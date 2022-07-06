import { Injectable } from '@nestjs/common';
import { UserService } from '../user/user.service';
import { BadRequestException, ExpectationFailedException, NotFoundException } from '../../exceptions';
import { verifySignature } from 'custom-crypto';
import { decodeBase64 } from 'tweetnacl-util';
import { UserGateway } from '../user/user.gateway';
import { CreateUserDto } from './app.controller';
import { PrismaService } from 'nestjs-prisma';

export interface SignedLoginAttemptDto {
    doubleName: string;
    signedAttempt: any;
}

export interface SignedSignAttemptDto {
    doubleName: string;
    signedAttempt: any;
}

@Injectable()
export class AppService {
    constructor(private _prisma: PrismaService, private userService: UserService, private userGateway: UserGateway) {}

    async create(createUserData: string) {
        const userData: CreateUserDto = JSON.parse(JSON.stringify(createUserData));

        const username = userData.doubleName.toLowerCase();
        const email = userData.email.trim();
        const publicKey = userData['public_key'];

        if (!publicKey || !username || !email) {
            throw new ExpectationFailedException('Not all required parameters are given');
        }

        if (username.length > 55 || !username.endsWith('.3bot')) {
            throw new ExpectationFailedException('Username is not valid');
        }

        const createObject = {
            username: username,
            email: email,
            mainPublicKey: publicKey,
        };

        return this._prisma.user.create({ data: createObject });
    }

    async handleSignedLoginAttempt(data: string) {
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

    async handleSignedSignAttempt(data: string) {
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
