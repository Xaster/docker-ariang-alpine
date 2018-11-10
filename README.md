# docker-ariang-alpine
Docker: Aria2 With AriaNg (Based On Alpine)

# Usage
```
$ docker pull xaster/docker-ariang-alpine

$ docker run -d \
    --name docker-ariang-alpine \
    -v /DOWNLOAD_DIR:/aria2/downloads \
    -v /CONFIG_DIR:/aria2/conf \
    -p 6800:6800 \
    -p 6882:6882/udp \
    -p 51414:51414 \
    -p 9092:9092 \
    -e SECRET=YOUR_SECRET_CODE \
    -e TIMEZONE=YOUR_TIME_ZONE \
    xaster/docker-ariang-alpine
```

# Note
```
6800=rpc listen port
6882/udp=dht listen port
51414=bt listen port
9092=ariang listen port
```
