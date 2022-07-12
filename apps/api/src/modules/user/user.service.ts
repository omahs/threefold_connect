import {Injectable} from '@nestjs/common';
import {PrismaService} from 'nestjs-prisma';
import {AuthorizationHeaders, ChangeEmailDto, CreateUserDto, GetUserDto} from './dtos/user.dto';
import {BadRequestException, ExpectationFailedException, NotFoundException} from '../../exceptions';
import {decodeBase64} from 'tweetnacl-util';
import {findUserByUsernameQuery, updateEmailOfUserQuery} from './queries/user.queries';
import {verifySignature} from "../../utils/crypto.util";
import {User as UserModel} from '@prisma/client';

@Injectable()
export class UserService {
    constructor(private _prisma: PrismaService) {
    }

    async findAll(): Promise<GetUserDto[]> {
        const users = await this._prisma.user.findMany();
        return users.map((user: UserModel) => {
            return {
                userId: user.userId,
                username: user.username,
                mainPublicKey: user.mainPublicKey,
                email: user.email
            }
        })
    }

    async findByUsername(username: string): Promise<GetUserDto> {
        const user = await this._prisma.user.findUnique(findUserByUsernameQuery(username));
        if (!user) throw new NotFoundException('Username not found');

        return {
            userId: user.userId,
            username: user.username,
            mainPublicKey: user.mainPublicKey,
            email: user.email
        }
    }

    async doesUserExist(username: string): Promise<boolean> {
        const user = await this._prisma.user.findUnique(findUserByUsernameQuery(username));
        return !!user;
    }

    async updateEmail(userId: string, email: string) {
        return this._prisma.user.update(updateEmailOfUserQuery(userId, email));
    }

    async changeEmail(data: string, requestHeaders: string): Promise<string> {
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

        const updatedUser = await this.updateEmail(user.userId, emailObject.email);
        return updatedUser.userId
    }

    async create(createUserData: string): Promise<string> {
        const userData: CreateUserDto = JSON.parse(JSON.stringify(createUserData));

        const username = userData.username.toLowerCase();
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

        const createdUser = await this._prisma.user.create({data: createObject});
        return createdUser.userId;
    }

}
