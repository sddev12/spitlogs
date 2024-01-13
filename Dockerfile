FROM alpinelinux/golang as build
WORKDIR /app
COPY /app .
RUN go mod download
RUN go build -o spitlog

FROM alpinelinux/golang
WORKDIR /app
COPY --from=build /app/spitlog .
COPY --from=build /app/one_liners.json .
CMD ["./spitlog"]