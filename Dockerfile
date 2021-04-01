FROM node:14.16-alpine
EXPOSE 3000
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci

COPY . .

ENTRYPOINT ["npm"]
CMD ["run", "dev"]
