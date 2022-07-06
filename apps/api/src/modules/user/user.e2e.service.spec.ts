import * as request from 'supertest';
import { Test } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import { UserModule } from './user.module';
import { UserService } from './user.service';

describe('User', () => {
    let app: INestApplication;
    let userService = { findAll: () => [''] };

    beforeAll(async () => {
        const moduleRef = await Test.createTestingModule({
            imports: [UserModule],
        })
            .overrideProvider(UserService)
            .useValue(userService)
            .compile();

        app = moduleRef.createNestApplication();
        await app.init();
    });

    it(`/GET allUsers`, () => {
        return request(app.getHttpServer()).get('/users').expect(200).expect(userService.findAll());
    });

    afterAll(async () => {
        await app.close();
    });
});
