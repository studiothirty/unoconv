FROM node:4.2

# update packages and grab pdftk for merging pdfs
RUN apt-get update && apt-get install -y \
    pdftk unoconv

# get libreoffice - version 4.4.4x is supported by unoconv
ENV LIBREOFFICE_VERSION 4.4.4.3
ENV LIBREOFFICE_ARCHIVE LibreOffice_4.4.4.3_Linux_x86-64_deb.tar.gz
RUN apt-get update \
    && apt-get install -y \
        curl \
    && gpg --keyserver pool.sks-keyservers.net --recv-keys AFEEAEA3 \
    && curl -SL "https://downloadarchive.documentfoundation.org/libreoffice/old/$LIBREOFFICE_VERSION/deb/x86_64/$LIBREOFFICE_ARCHIVE" -o $LIBREOFFICE_ARCHIVE \
    && curl -SL "https://downloadarchive.documentfoundation.org/libreoffice/old/$LIBREOFFICE_VERSION/deb/x86_64/$LIBREOFFICE_ARCHIVE.asc" -o $LIBREOFFICE_ARCHIVE.asc \
    && gpg --verify "$LIBREOFFICE_ARCHIVE.asc" \
    && mkdir /tmp/libreoffice \
    && tar -xvf "$LIBREOFFICE_ARCHIVE" -C /tmp/libreoffice/ --strip-components=1 \
    && dpkg -i /tmp/libreoffice/**/*.deb \
    && rm $LIBREOFFICE_ARCHIVE* \
    && rm -Rf /tmp/libreoffice \
    && apt-get clean \
    && apt-get autoremove -y \
        curl \
    && rm -rf /var/lib/apt/lists/*

# Grab the latest unoconv - it hasn't been updated so just the master from github will do
ADD https://raw.githubusercontent.com/dagwieers/unoconv/master/unoconv /usr/bin/unoconv
RUN chmod +xr /usr/bin/unoconv

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ONBUILD COPY package.json /usr/src/app/
ONBUILD RUN npm install
ONBUILD COPY . /usr/src/app

CMD [ "npm", "start" ]
