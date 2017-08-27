FROM alpine:3.6

ENV GOPATH /go
ENV PATH $GOPATH/bin:$PATH

RUN set -ex \
  && adduser -h /site -s /sbin/nologin -u 1000 -D hugo \
  && apk add --no-cache dumb-init openssh-client rsync git go hugo

USER    hugo

WORKDIR /site
VOLUME  /site

EXPOSE  1313

ENTRYPOINT ["/usr/bin/dumb-init", "--", "hugo"]

CMD [ "--help" ]
