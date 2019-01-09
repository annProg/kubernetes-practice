FROM alpine:3.8

ENV GOPATH /go

RUN	sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk add --no-cache gcc make go libc-dev git
