import { Injectable } from '@nestjs/common';
import { PrismaService } from 'nestjs-prisma';
import { Prisma } from '@prisma/client';
import { AuthorizationHeaders, ChangeEmailDto } from './dtos/user.dto';
import { BadRequestException, ExpectationFailedException, NotFoundException } from '../../exceptions';
import { verifySignature } from 'custom-crypto';
import { decodeBase64 } from 'tweetnacl-util';
import { findUserByUsernameQuery, updateEmailOfUserQuery } from './queries/user.queries';

@Injectable()
export class UserService {
    constructor(private _prisma: PrismaService) {}

    async create(payload: Prisma.UserCreateInput) {
        return this._prisma.user.create({ data: payload });
    }

    async findAll() {
        return this._prisma.user.findMany();
    }

    async findByUsername(username: string) {
        return this._prisma.user.findUnique(findUserByUsernameQuery(username));
    }

    async updateEmail(userId: string, email: string) {
        return this._prisma.user.update(updateEmailOfUserQuery(userId, email));
    }

    async changeEmail(data: string, requestHeaders: string) {
        const headers = JSON.parse(JSON.stringify(requestHeaders));
        const emailObject: ChangeEmailDto = JSON.parse(JSON.stringify(data));

        const sign = headers['jimber-authorization'];
        if (!sign) {
            throw new ExpectationFailedException('No Jimber Authorization header available');
        }

        if (!emailObject.email || !emailObject.username) {
            throw new ExpectationFailedException('Username and email required');
        }

        const user = await this.findByUsername(emailObject.username);
        if (!user) {
            throw new NotFoundException('Username not found');
        }

        const signedData = await verifySignature(sign, decodeBase64(user.mainPublicKey));
        if (!signedData) {
            throw new BadRequestException('Signature mismatch');
        }

        const readableMessage = new TextDecoder().decode(signedData);
        const verifiedHeaders: AuthorizationHeaders = JSON.parse(readableMessage);

        if (verifiedHeaders.intention != 'change-email') {
            throw new BadRequestException('Wrong intention');
        }

        return this.updateEmail(user.userId, emailObject.email);
    }
}
