export interface CreateDigitalTwinDto extends DigitalTwinDto {
    derivedPublicKey: string;
}

export interface DigitalTwinDto {
    username: string;
    yggdrasilIp: string;
    appId: string;
}

export interface DigitalTwinDetailsDto extends DigitalTwinDto {
    id: string;
    derivedPublicKey: string;
}
