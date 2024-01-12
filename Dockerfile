FROM alpinelinux/golang as build
WORKDIR /app
COPY /app .
RUN go mod download
RUN go build -o go-logger

FROM alpinelinux/golang
WORKDIR /app
COPY --from=build /app/go-logger .
COPY --from=build /app/one_liners.json .
CMD ["./go-logger"]