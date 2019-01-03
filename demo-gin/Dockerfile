FROM registry-cn.scloud.letv.com/hean/golang-dev as builder
COPY src /go/src/demo-gin/src
COPY vendor /go/src/demo-gin/vendor
WORKDIR /go/src/demo-gin/src
RUN go build -ldflags "-s -w" -o /go/bin/demo-gin


FROM alpine:3.8
COPY --from=builder /go/bin/demo-gin /
ENTRYPOINT ["/demo-gin"]
