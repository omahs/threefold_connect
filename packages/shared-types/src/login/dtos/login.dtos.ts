import { IsNotEmpty, IsString, MaxLength, MinLength, Validate } from 'class-validator';
import { EndsWith3Bot } from 'api/dist/validators';

export class SignedLoginAttemptDto {
    @IsString()
    @IsNotEmpty()
    state: string;

    @IsString()
    @IsNotEmpty()
    room: string;

    @IsString()
    @IsNotEmpty()
    appId: string;

    selectedImageId: number | null;

    scopeData: any;
}

export class LoginAttemptDto {
    @Validate(EndsWith3Bot)
    @MinLength(6)
    @MaxLength(55)
    @IsString()
    @IsNotEmpty()
    username: string;

    @IsNotEmpty()
    signedAttempt: SignedLoginAttemptDto;
}
