FROM node:4.2

# update packages and grab pdftk for merging pdfs
RUN apt-get update && apt-get install -y \
    pdftk unoconv

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ONBUILD COPY package.json /usr/src/app/
ONBUILD RUN npm install
ONBUILD COPY . /usr/src/app

CMD [ "npm", "start" ]
