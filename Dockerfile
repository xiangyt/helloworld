FROM golang:1.19.6-alpine3.17 AS builder

WORKDIR /helloworld

ENV GOPROXY https://goproxy.cn
COPY . /helloworld

RUN cd /helloworld && go mod tidy && CGO_ENABLED=0 GOARCH=amd64 GOOS=linux go build -a -o helloworld .

FROM alpine:3.17 AS final

WORKDIR /app
COPY --from=builder /helloworld/helloworld /app/

ENTRYPOINT ["/app/helloworld"]