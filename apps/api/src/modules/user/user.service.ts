import { Injectable } from '@nestjs/common';
import { PrismaService } from 'nestjs-prisma';
import {
    AuthorizationHeaders,
    ChangeEmailDto,
    CreatedUserDto,
    CreateUserDto,
    GetUserDto,
    UpdatedUserDto,
    UserIntentions,
} from 'shared-types';
import { BadRequestException, ExpectationFailedException, NotFoundException } from '../../exceptions';
import { decodeBase64 } from 'tweetnacl-util';
import { findUserByUsernameQuery, updateEmailOfUserQuery } from './queries/user.queries';
import { verifyMessage } from '../../utils/crypto.utils';
import { User as UserModel } from '@prisma/client';
import { isBase64 } from 'class-validator';

@Injectable()
export class UserService {
    constructor(private _prisma: PrismaService) {}

    async findAll(): Promise<GetUserDto[]> {
        const users = await this._prisma.user.findMany();
        return users.map((user: UserModel) => {
            return {
                userId: user.userId,
                username: user.username,
                mainPublicKey: user.mainPublicKey,
                email: user.email,
            };
        });
    }

    async findByUsername(username: string): Promise<GetUserDto> {
        const user = await this._prisma.user.findUnique(findUserByUsernameQuery(username));
        if (!user) return null;

        return {
            userId: user.userId,
            username: user.username,
            mainPublicKey: user.mainPublicKey,
            email: user.email,
        };
    }

    async changeEmail(username: string, email: string, requestHeaders: string): Promise<UpdatedUserDto> {
        const headers = JSON.parse(JSON.stringify(requestHeaders));

        const signedHeader = headers['jimber-authorization'];
        if (!signedHeader) {
            console.error(`No Jimber Authorization header available for ${username}`);
            throw new ExpectationFailedException(`No Jimber Authorization header available for ${username}`);
        }

        username = username.trim().toLowerCase();
        const user = await this.findByUsername(username);
        if (!user) {
            console.error(`Username ${username} not found`);
            throw new NotFoundException(`Username ${username} not found`);
        }

        if (!isBase64(signedHeader)) {
            console.error(`Signed header ${signedHeader} is not Base64 encoded`);
            throw new ExpectationFailedException(`Signed header ${signedHeader} is not Base64 encoded`);
        }

        const signedData = verifyMessage(decodeBase64(signedHeader), decodeBase64(user.mainPublicKey));
        if (!signedData) {
            console.error(`Signature mismatch for ${user.mainPublicKey}`);
            throw new BadRequestException(`Signature mismatch for ${user.mainPublicKey}`);
        }

        const verifiedHeaders: AuthorizationHeaders = JSON.parse(signedData);
        if (verifiedHeaders.intention != UserIntentions.CHANGE_EMAIL) {
            console.error(`Wrong intention: ${verifiedHeaders.intention}`);
            throw new BadRequestException(`Wrong intention: ${verifiedHeaders.intention}`);
        }

        const updatedUser = await this.updateEmail(user.userId, email);

        return {
            userId: updatedUser.userId,
        };
    }

    async create(user: CreateUserDto): Promise<CreatedUserDto> {
        const username = user.username.toLowerCase().trim();
        const email = user.email.trim();
        const publicKey = user.mainPublicKey;

        const isFound = await this.findByUsername(username);
        if (isFound) {
            console.error(`User ${username} already exists`);
            throw new BadRequestException(`User ${username} already exists`);
        }

        const createdUser = await this._prisma.user.create({
            data: { username: username, email: email, mainPublicKey: publicKey },
        });

        return {
            userId: createdUser.userId,
        };
    }

    async doesUserExist(username: string): Promise<boolean> {
        const user = await this._prisma.user.findUnique(findUserByUsernameQuery(username));
        return !!user;
    }

    async updateEmail(userId: string, email: string) {
        return this._prisma.user.update(updateEmailOfUserQuery(userId, email));
    }
}
