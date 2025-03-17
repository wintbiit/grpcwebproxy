ARG SRC_REPO=https://github.com/improbable-eng/grpc-web.git

FROM golang:1.23-alpine AS builder
ARG SRC_REPO

RUN apk add --no-cache git

WORKDIR /go/src/github.com/improbable-eng/grpc-web

RUN git clone ${SRC_REPO} .

RUN go mod download && \
    cd ./go/grpcwebproxy && \
    go build -o /go/bin/grpcwebproxy

FROM alpine:3.20

RUN apk add --no-cache ca-certificates tzdata

COPY --from=builder /go/bin/grpcwebproxy /usr/local/bin/grpcwebproxy

EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/grpcwebproxy"]