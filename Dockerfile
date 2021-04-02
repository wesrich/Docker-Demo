FROM node:14.16-alpine
EXPOSE 3000
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci

COPY . .
RUN npm run build

ENTRYPOINT ["npm"]
CMD ["start"]
