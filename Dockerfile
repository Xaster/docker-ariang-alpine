FROM alpine:latest

RUN apk upgrade --no-cache \
    && apk add --no-cache --virtual .build-deps \
         curl \
         wget \
         sed \
    && mkdir -p \
        /etc/aria2 \
        /etc/aria2_default \
        /usr/share/aria2 \
        /usr/share/ariang \ 
    && ARIANG_VERSION=$(curl -sS --fail https://github.com/mayswind/AriaNg/releases | \
        grep -o '/AriaNg/archive/[a-zA-Z0-9.]*[.]tar[.]gz' | \
        sed -e 's~^/AriaNg/archive/~~' -e 's~\.tar\.gz$~~' | \
        sed '/alpha.*/Id' | \
        sed '/pre.*/Id' | \
        sed '/beta.*/Id' | \
        sed '/rc.*/Id' | \
        sort -t '.' -k 1,1 -k 2,2 -k 3,3 -k 4,4 -g | \
        tail -n 1) \
    && wget --no-check-certificate https://github.com/mayswind/AriaNg/releases/download/${ARIANG_VERSION}/AriaNg-${ARIANG_VERSION}.zip \
    && unzip AriaNg-${ARIANG_VERSION}.zip -d /usr/share/ariang \
    && rm -rf AriaNg-${ARIANG_VERSION}.zip \
    && wget --no-check-certificate -O /etc/aria2_default/aria2.conf https://raw.githubusercontent.com/Xaster/docker-ariang-alpine/master/aria2.conf \
    && wget --no-check-certificate -O /etc/aria2_default/Complete https://raw.githubusercontent.com/Xaster/docker-ariang-alpine/master/Complete \
    && wget --no-check-certificate -O /usr/bin/CMD-Shell https://raw.githubusercontent.com/Xaster/docker-ariang-alpine/master/CMD-Shell \
    && chmod +x /etc/aria2_default/Complete \
    && chmod +x /usr/bin/CMD-Shell \
    && apk del .build-deps \
    && apk add --no-cache aria2 darkhttpd tzdata

VOLUME ["/usr/share/aria2", "/etc/aria2"]
EXPOSE 6800 6882/udp 51414 9092
ENV SECRET="" TIMEZONE=""

CMD ["CMD-Shell"]
