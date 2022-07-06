FROM node:14-alpine as builder
WORKDIR /app
COPY . .
RUN yarn install --frozen-lockfile
RUN yarn run build --scope=api

FROM node:14-alpine
USER root
RUN apk add --no-cache bash
WORKDIR /app
COPY --from=builder /app/apps/api/package.json /app/package.json
COPY --from=builder /app/apps/api/node_modules/ /app/node_modules/
COPY --from=builder /app/apps/api/dist/ /app/dist/
COPY apps/api/wait-for-it.sh wait-for-it.sh
COPY apps/api/start.sh start.sh
RUN npm install pm2 -g

RUN chmod +x /app/start.sh
RUN chmod +x /app/wait-for-it.sh
CMD ["./start.sh"]