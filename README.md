# ThreeFold Connect

### Development

**Start necessary docker containers**
```shell
docker-compose -f docker-compose.development.yml up -d
```

**Start application**
```shell
yarn && yarn dev
```

**Run migrations**
```shell
cd apps/api/ && yarn prisma:migrate-prod
```
