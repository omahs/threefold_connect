// export class CreateDigitalTwinDto {
//     @IsNotEmpty()
//     name: any;
//
//     @IsString()
//     @IsNotEmpty()
//     derivedPublicKey: string;
//
//     @IsString()
//     @IsNotEmpty()
//     appId: string;
// }

export interface CreateDigitalTwinDto {
    username?: string;
    derivedPublicKey: string;
    appId: string;
    yggdrasilIp: string;
}

export interface DigitalTwinDto {
    username: string;
    yggdrasilIp: string;
    appId: string;
}

export interface DigitalTwinDetailsDto extends DigitalTwinDto {
    id?: string;
    derivedPublicKey: string;
}
