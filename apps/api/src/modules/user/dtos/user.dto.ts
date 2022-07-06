import { IsNotEmpty, IsString } from 'class-validator';

export class CreateUserDto {
    @IsString()
    @IsNotEmpty()
    email: string;

    @IsString()
    @IsNotEmpty()
    username: string;

    @IsString()
    @IsNotEmpty()
    mainPublicKey: string;
}

export interface ChangeEmailDto {
    username: string;
    email: string;
}

export interface AuthorizationHeaders {
    timestamp: string;
    intention: string;
}
