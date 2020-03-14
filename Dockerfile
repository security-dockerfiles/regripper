FROM alpine
LABEL maintainer "ilya@ilyaglotov.com"

ENV PERL5LIB /regripper

RUN apk update \
  && apk add perl \
  && apk add --virtual .temp \
             perl-dev \
             make \
             git \
  && rm -rf /var/cache/apk/*

RUN git clone https://github.com/gitpan/Parse-Win32Registry.git /opt/win32registry \
&& cd /opt/win32registry \
# Fix bug 124514 https://rt.cpan.org/Public/Bug/Display.html?id=124514
&& sed -i "s/my \$epoch_offset = timegm(0, 0, 0, 1, 0, 70);/my \$epoch_offset = timegm(0, 0, 0, 1, 0, 1970);/" /opt/win32registry/lib/Parse/Win32Registry/Base.pm \
&& sed -i "s/my \$epoch_offset = timegm(0, 0, 0, 1, 0, 70);/my \$epoch_offset = timegm(0, 0, 0, 1, 0, 1970);/" /opt/win32registry/t/misc.t \
&& perl Makefile.PL && make && make test && make install

RUN adduser -D regripper \
  && git clone --branch=master \
              --depth=1 \
              https://github.com/keydet89/RegRipper2.8.git /regripper \
  && chown -R regripper /regripper \
  && apk del .temp \
  && rm -rf /regripper/.git

VOLUME /data

USER regripper

WORKDIR /regripper

ENTRYPOINT ["perl", "rip.pl"]
