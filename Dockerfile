FROM node:18

WORKDIR /app

EXPOSE 3000

COPY package.json ./

RUN npm install

CMD [ "node" , "server.js" ]

COPY . /app/code

