FROM node:20 AS base

RUN npm i -g pnpm

FROM base AS dependecies

WORKDIR /usr/src/app

COPY package.json pnpm-lock.yaml ./

RUN pnpm install

FROM base AS build

WORKDIR /usr/src/app

COPY . .
COPY --from=dependecies /usr/src/app/node_modules ./node_modules

RUN pnpm build
RUN pnpm prune --prod

FROM node:20-alpine3.19 AS deploy

WORKDIR /usr/src/app

RUN apk update && apk add bash
RUN npm i -g pnpm

COPY --from=build /usr/src/app/dist ./dist 
COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/package.json ./package.json

EXPOSE 3001
EXPOSE 3021
EXPOSE 3022

CMD [ "pnpm", "start" ]