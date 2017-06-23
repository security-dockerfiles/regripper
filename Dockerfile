FROM alpine
LABEL maintainer "ilya@ilyaglotov.com"

RUN apk update \
  && apk add perl \
  && apk add --virtual .temp \
             perl-dev \
             make \
             git \
             wget \
             \
  && wget https://cpanmin.us/ -O /bin/cpanm \
  && chmod +x /bin/cpanm \
  && cpanm Parse::Win32Registry

RUN git clone --branch=master \
              --depth=1 \
              https://github.com/keydet89/RegRipper2.8.git /regripper

RUN apk del .temp \
  && rm -rf /var/cache/apk/*

VOLUME /data

WORKDIR /regripper
