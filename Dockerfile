FROM node:6.10

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
ONBUILD COPY yarn.lock /usr/src/app/
ONBUILD RUN yarn install
ONBUILD COPY . /usr/src/app

# Startup
ENTRYPOINT /usr/bin/unoconv --listener --server=0.0.0.0 --port=2002 && yarn start
