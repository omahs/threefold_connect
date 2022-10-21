import { IsBase64, IsEmail, IsNotEmpty, IsString, MaxLength, MinLength, Validate } from 'class-validator';
import { EndsWith3Bot } from 'api/dist/validators';

export class CreateUserDto {
    @IsString()
    @IsNotEmpty()
    @IsEmail()
    email: string;

    @Validate(EndsWith3Bot)
    @MinLength(6)
    @MaxLength(55)
    @IsString()
    @IsNotEmpty()
    username: string;

    @IsString()
    @IsNotEmpty()
    @IsBase64()
    mainPublicKey: string;
}

export class UsernameDto {
    @Validate(EndsWith3Bot)
    @MinLength(6)
    @MaxLength(55)
    @IsString()
    @IsNotEmpty()
    username: string;
}

export class ChangeEmailDto {
    @IsString()
    @IsNotEmpty()
    @IsEmail()
    email: string;
}

export type GetUserDto = {
    userId: string;
    username: string;
    mainPublicKey: string;
    email: string;
};

export type CreatedUserDto = {
    userId: string;
};

export type UpdatedUserDto = {
    userId: string;
};
