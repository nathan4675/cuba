FROM --platform=${TARGETPLATFORM} alpine:latest

WORKDIR /root
ARG TARGETPLATFORM
ARG TAG
COPY install.sh /root/install.sh
COPY config-http2.json /root/config-http2.json
COPY config-tcp.json /root/config-tcp.json
COPY config-ws.json /root/config-ws.json


RUN set -ex \
    && apk add --no-cache tzdata openssl ca-certificates \
    && mkdir -p /usr/local/share/xray /var/log/xray \
    && cp config*.json /usr/local/share/xray/ \
    && chmod +x /root/install.sh \
    && /root/install.sh "${TARGETPLATFORM}" "v1.5.3"

# RUN install -d /usr/local/etc/xray
# ADD config-http2.json /usr/local/etc/xray/config-http2.json
# ADD config-tcp.json /usr/local/etc/xray/config-tcp.json
# ADD config-ws.json /usr/local/etc/xray/config-ws.json

ADD start.sh /start.sh

RUN chmod +x /start.sh


EXPOSE ${YOUR_PORT}

CMD ["/start.sh"]