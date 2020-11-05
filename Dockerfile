FROM alpine:latest
LABEL maintainer "ilya@ilyaglotov.com"

ARG COMMIT=f65ac5f08e022dca108d5f9eb381f6c4fc5d4801
ENV PERL5LIB /regripper

RUN apk update \
  && apk add perl \
  && apk add --virtual .temp \
             perl-dev \
             make \
             wget \
             \
  && wget https://cpanmin.us/ -O /bin/cpanm \
  && chmod +x /bin/cpanm \
  && cpanm Parse::Win32Registry \
  && rm -rf /var/cache/apk/*

RUN adduser -D regripper \
  && wget https://github.com/keydet89/RegRipper3.0/archive/$COMMIT.tar.gz -O /regripper.tar.gz \
  && tar xvf /regripper.tar.gz \
  && mv /RegRipper* /regripper \
  && chown -R regripper /regripper \
  && apk del .temp \
  && cd /regripper \
  && rm -rf *.exe *.bat *.zip

VOLUME /data

USER regripper

WORKDIR /regripper

ENTRYPOINT ["perl", "rip.pl"]
