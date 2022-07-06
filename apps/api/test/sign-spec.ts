import { Test, TestingModule } from '@nestjs/testing';
import * as request from 'supertest';
import { AppModule } from '../src/modules/app/app.module';
import { generateMnemonic } from '@jimber/simple-bip39';

describe('Signing', () => {
    const sampleBase64Data = 'aGFsbG9pa2Jlbmxlbm5lcnQK';

    const mnemonic = generateMnemonic(256);
    console.log(mnemonic);

    it('/ (GET)', () => {
        console.log('h');
    });
});
