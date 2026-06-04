FROM golang:1.22-alpine AS builder

WORKDIR /user/src/app

COPY . .

RUN go mod download
RUN go build -o product-catalog .

FROM alpine:latest

WORKDIR /app

COPY --from=builder /user/src/app/product-catalog .
COPY ./products ./products

ENV PRODUCT_CATALOG_PORT=8088
EXPOSE 8088

ENTRYPOINT ["./product-catalog"]