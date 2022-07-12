FROM alpine:3.16.0 AS builder

ARG VERSION=0.2.4

RUN apk add --no-cache wget unzip

WORKDIR /srv

RUN wget https://github.com/pocketbase/pocketbase/releases/download/v${VERSION}/pocketbase_${VERSION}_linux_arm64.zip
RUN unzip pocketbase_${VERSION}_linux_arm64.zip

FROM alpine:3.16.0 AS app

WORKDIR /srv

RUN mkdir pb_data \
          pb_public

COPY app pb_public
COPY --from=builder /srv/pocketbase .

CMD ["/srv/pocketbase", "serve"]

FROM nginx:1.23.0 AS proxy

WORKDIR /usr/share/nginx/html
COPY proxy/nginx.conf /etc/nginx/conf.d/default.conf
