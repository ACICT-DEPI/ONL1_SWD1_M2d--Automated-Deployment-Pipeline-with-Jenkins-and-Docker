FROM node:alpine AS app

WORKDIR /web-app

COPY ./web-app .

RUN npm install

RUN npm run build


FROM nginx:alpine

EXPOSE 80

COPY  --from=app /web-app/build /usr/share/nginx/html 

