FROM node:16-alpine

WORKDIR /app
COPY ./app/ /app
RUN cd /app && npm install
EXPOSE 3000
CMD ["node", "server.js"]