# https://github.com/mholt/archiver/releases

FROM curlimages/curl AS curl
RUN curl -L -o /tmp/arc https://github.com/mholt/archiver/releases/download/v3.5.0/arc_3.5.0_linux_amd64
RUN chmod +x /tmp/arc
RUN curl -L -o /tmp/hugo.tar.gz https://github.com/gohugoio/hugo/releases/download/v0.88.1/hugo_0.88.1_Linux-64bit.tar.gz

FROM scratch AS arc
COPY --from=curl /tmp/arc ./
COPY --from=curl /tmp/hugo.tar.gz ./
RUN ["./arc", "extract", "hugo.tar.gz", "hugo"]

FROM scratch AS hugo
COPY --from=arc /hugo ./
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
