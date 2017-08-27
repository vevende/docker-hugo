FROM alpine:3.6

ENV GOPATH /go
ENV PATH $GOPATH/bin:$PATH

RUN set -ex \
  && adduser -h /site -s /sbin/nologin -u 1000 -D hugo \
  && apk add --no-cache dumb-init git openssh-client rsync \
  && apk add --no-cache --virtual .build-deps gcc musl-dev go \
  && go get github.com/kardianos/govendor \
  && govendor get github.com/gohugoio/hugo \
  && go install github.com/gohugoio/hugo  \
  && go install -ldflags '-s -w' \
  && cd $GOPATH \
  && rm -rf pkg src .cache bin/govendor \
  apk del .build-deps

USER    hugo

WORKDIR /site
VOLUME  /site

EXPOSE  1313

ENTRYPOINT ["/usr/bin/dumb-init", "--", "hugo"]

CMD [ "--help" ]
