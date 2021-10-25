# https://github.com/mholt/archiver/releases

FROM curlimages/curl AS curl
RUN curl -L -o /tmp/hugo.tar.gz https://github.com/gohugoio/hugo/releases/download/v0.88.1/hugo_0.88.1_Linux-64bit.tar.gz

FROM alpine AS tar
RUN apk --update add tar && rm -rvf /var/cache/apk*
COPY --from=curl /tmp/hugo.tar.gz ./
RUN tar xvf hugo.tar.gz hugo

FROM scratch AS hugo
COPY --from=tar /hugo ./
COPY source /source
RUN ["./hugo", "-s", "./source"]

FROM golang AS gomod
WORKDIR /go/src/
COPY go.mod go.sum ./
RUN go mod download

FROM golang AS go
WORKDIR /go/src/
COPY --from=gomod /go/pkg/mod /go/pkg/mod
COPY --from=hugo /source/public ./source/public
COPY go.mod go.sum main.go ./
RUN CGO_ENABLED=0 go install

FROM scratch
COPY --from=go /go/bin/main /main
ENTRYPOINT ["/main"]
