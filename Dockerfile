FROM node:4.2

# update packages and grab pdftk for merging pdfs

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
      unoconv pdftk libglu1-mesa libxinerama1 \
  && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ONBUILD COPY package.json /usr/src/app/
ONBUILD RUN npm install
ONBUILD COPY . /usr/src/app

CMD [ "npm", "start" ]
