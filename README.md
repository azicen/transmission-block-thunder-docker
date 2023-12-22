# transmission-block-thunder-docker

transmission 屏蔽thunder等吸血客户端的构建容器

原项目为 [transmission-Block-Thunder](https://github.com/firedent/transmission-Block-Thunder)

## 使用

### 配置文件

下载`settings.json`配置文件，并将下载到的配置文件放置在对应的目录

! 除非你明确知道你在做什么，否则不要手动修改`settings.json`的内容 !

```sh
curl https://raw.githubusercontent.com/azicen/transmission-block-thunder-docker/main/settings.json -o settings.json

mv settings.json ./data/config/settings.json
```

### Docker
```sh
docker run -e TZ="Asia/Shanghai" \
           -p 9091:9091 \
           -p 51413:51413 \
           -v "./data/config:/app/config" \
           -v "./data/downloads:/downloads" \
           azicen/transmission-block-thunder:latest
```

### Docker Compose
```yaml
version: '3.2'

services:
  transmission-block-thunder:
    image: "azicen/transmission-block-thunder:latest"
    container_name: transmission-block-thunder
    environment:
      TZ: "Asia/Shanghai"
    ports:
      - "9091:9091"
      - "51413:51413"
    volumes:
      - ./data/config:/app/config
      - ./data/downloads:/downloads
```
