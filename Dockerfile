FROM alpine:latest

RUN apk upgrade --no-cache \
    && apk add --no-cache --virtual .build-deps \
         curl \
         wget \
         sed \
    && mkdir -p /aria2/conf /aria2/downloads /ariang \ 
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
    && unzip AriaNg-${ARIANG_VERSION}.zip -d /ariang \
    && wget --no-check-certificate -O /aria2/Complete.sh.default https://raw.githubusercontent.com/Xaster/docker-ariang-alpine/master/Complete.sh \
    && wget --no-check-certificate -O /aria2/aria2.conf.default https://raw.githubusercontent.com/Xaster/docker-ariang-alpine/master/aria2.conf \
    && wget --no-check-certificate -O /aria2/Run.sh https://raw.githubusercontent.com/Xaster/docker-ariang-alpine/master/Run.sh \
    && chmod +x /aria2/Run.sh \
    && apk del .build-deps \
    && apk add --no-cache aria2 darkhttpd tzdata \
    && rm -rf AriaNg-${ARIANG_VERSION}.zip

VOLUME ["/aria2/downloads", "/aria2/conf"]
EXPOSE 6800 6882/udp 51414 9092
ENV SECRET="" TIMEZONE=""

CMD ["/aria2/Run.sh"]
