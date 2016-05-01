FROM golang:1.6.2-alpine

ENV        BOSUN_VERSION="0.5.0-rc2"

RUN        apk add --update go git
RUN        go get -d bosun.org/cmd/bosun

WORKDIR    /go/src/bosun.org/cmd/bosun
RUN        git checkout ${BOSUN_VERSION}

WORKDIR    /go
RUN        go install bosun.org/cmd/bosun
RUN        mkdir -p /bosun
COPY       run.sh /bosun/

EXPOSE     8070

CMD ["/bosun/run.sh"]
