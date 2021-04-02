FROM node:14.16-alpine as base
EXPOSE 3000
WORKDIR /app

FROM base as dev-deps
COPY package.json package-lock.json ./
RUN npm ci

FROM base as node-deps
COPY package.json package-lock.json ./
RUN npm ci --only=production

FROM base as next-build
COPY --from=dev-deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

FROM base as tests
COPY --from=dev-deps /app/node_modules ./node_modules
COPY . .
RUN npm test

FROM base as service
COPY --from=node-deps /app/node_modules ./node_modules
COPY --from=next-build /app/.next ./.next
COPY package.json package-lock.json ./
COPY public ./public
HEALTHCHECK CMD wget -q http://localhost:3000 -O /dev/null
ENTRYPOINT ["npm"]
CMD ["start"]
