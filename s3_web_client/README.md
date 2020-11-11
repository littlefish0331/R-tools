# README

更新時間: 2020-11-11

<!-- TOC -->

- [README](#readme)
  - [參考連結](#參考連結)
  - [前置作業](#前置作業)
  - [建立](#建立)
  - [END](#end)
    - [PR 訊息](#pr-訊息)
    - [類似功能關鍵字](#類似功能關鍵字)
  - [後記](#後記)

<!-- /TOC -->

--

建立一個 S3 web client 的服務窗口，方便大家在 HackMD 上面討論時，可以把資料上傳到計畫的 s3 中。

- 開源專案使用: mickael-kerjean/filestash + onlyoffice/documentserver
- 優點:
  - 討論窗口統一: 同時空間使用在同一專案下
  - 可線上直接編輯
- 缺點:
  - 是開源專案，雖然有鎖IP網域(140.110.XXX.XXX)，但是並竟是公開討論，不建議放機敏性過高的資料。

---

## 參考連結

- filestashv(對方網站有點不穩XD)

| feature               | link                                                                                                                       |
|-----------------------|----------------------------------------------------------------------------------------------------------------------------|
| official website demo | [S3 Explorer: An online client for Amazon S3 that rocks!](https://www.filestash.app/aws-s3-explorer.html)                  |
| official guide        | [Getting started](https://www.filestash.app/docs/)                                                                         |
| DockerHub             | [machines/filestash](https://hub.docker.com/r/machines/filestash/)                                                         |
| GitHub                | [mickael-kerjean/filestash](https://github.com/mickael-kerjean/filestash)                                                  |
| i18n problem          | [[Feature Request] i18n · Issue #248 · mickael-kerjean/filestash](https://github.com/mickael-kerjean/filestash/issues/248) |

--

- DocumentServer

| feature      | link                                                                                                                                        |
|--------------|---------------------------------------------------------------------------------------------------------------------------------------------|
| DockerHub    | [onlyoffice/documentserver](https://hub.docker.com/r/onlyoffice/documentserver)                                                             |
| GitHub       | [ONLYOFFICE/DocumentServer](https://github.com/ONLYOFFICE/DocumentServer)                                                                   |
| i18n problem | [Adding a new interface language to ONLYOFFICE Docs](https://helpcenter.onlyoffice.com/installation/docs-community-add-language-linux.aspx) |

--

:::danger
基本上這個做法後來失敗，因為我不會好好從 Github 來源去建立一個 Docker 的 image 檔，所以不管怎麼做，啟動 container 時，都會從原始的專案下拉取，畢竟它是一層一層(layer by layer)疊加上去的，所以目前我的解決方法是透過 docker volume 的方式做解決。
:::

因為兩個開源專案都只有設定偵測地區語系，也就是到 zh.json 階層，而非提供 zh-CN, zh-TW 的地區差異，所以我fork repo 到我的 Github 下做修改與測試。因為要做 javascript 的修改，所以我目前還在考慮要不要 PR 給原作者了(怕程式碼太醜XD)。或是開 issue 討論就好。

| feature                 | link                                                                              |
|-------------------------|-----------------------------------------------------------------------------------|
| DockerHub               | [littlefish0331's - Docker Hub](https://hub.docker.com/u/littlefish0331)          |
| GitHub - filestash      | [littlefish0331/filestash](https://github.com/littlefish0331/filestash)           |
| GitHub - documentserver | [littlefish0331/DocumentServer](https://github.com/littlefish0331/DocumentServer) |
| GitHub - web-apps       | [littlefish0331/web-apps](https://github.com/littlefish0331/web-apps)             |

--

- 關於 i18n: [簡介 i18n](https://openhome.cc/Gossip/Rails/i18n.html)
  - 地區資訊(Locale)可由一個語言編碥(Language code)與可選的區域編碼(Country code)來指定

---

## 前置作業

1. 在 TWCC 的 NCHC-MOD內部測試計畫下，開一個 ubuntu 的 VCS
2. 安裝 docker, docker-compose
3. 在 COS public 區域，建立一個 S3 bucket。(比如我建了一個 s3-web-client)
4. 修改網路安全群組，把 port 8834 打開。就可以做後續的設定了!!(介面語言會隨著瀏覽器做修改。)

---

## 建立

```{unix}
<!-- 重新開機 -->
sudo reboot

<!-- 安裝 docker -->
curl -sSL https://get.docker.com/ | sh
sudo usermod -aG docker ubuntu
exit

<!-- 安裝 docker-compose -->
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

<!-- 確認安裝 -->
docker -v
docker-compose version
```

```{unix}
<!-- 建立資料夾 -->
mkdir s3-web-client
cd s3-web-client
mkdir locales
chmod 777 locales
```

接著去把自己要的語言搬移進來。

--

:::danger
原本想從 Dockerfile 製作自己的 image，但這個的做法一直失敗(目前功力不夠)，  
所以最後我是用 Docker volume，開一個連動資料夾，把我想要提供語言的json檔放進去(包括 zh.json, en.json)。
:::

從 Dockerfile 製作自己的 image，  
去我的 Github-littlefish0331/filestash 有一個 docker/ 資料夾底下，有 Dockerfile，  
基本上我就是把所有資源從我那邊抓取。(改路徑就對了)

```{unix}
<!-- 第一行與第二行應該可以簡寫成 `docker build -t littlefish0331/my-s3-web-client . --no-cache` -->
docker build -t filestash . --no-cache
docker tag filestash littlefish0331/filestash
docker login
docker push littlefish0331/filestash
docker rmi filestash littlefish0331/filestash
```

--

```{unix}
<!-- 下載 filestash 官方的 docker-compose.yml -->
curl -O https://downloads.filestash.app/latest/docker-compose.yml
```

修改

```{docker-cpmpose.yml}
version: '2'
services:
  app:
    container_name: filestash
    image: machines/filestash
    restart: always
    volumes:
    - /home/ubuntu/s3-web-client/locales:/app/data/public/assets/locales
    environment:
    - APPLICATION_URL=
    - GDRIVE_CLIENT_ID=<gdrive_client>
    - GDRIVE_CLIENT_SECRET=<gdrive_secret>
    - DROPBOX_CLIENT_ID=<dropbox_key>
    - ONLYOFFICE_URL=http://onlyoffice
    ports:
    - "8334:8334"

  onlyoffice:
    container_name: filestash_oods
    image: onlyoffice/documentserver
    restart: always
```

```{unix}
<!-- 用 docker-compose 啟動 container -->
docker-compose up -d
```

---

## END

<!-- 一直嘗試會需要把 docker image, docker container 刪除乾淨的指令XD -->
<!-- docker stop $(docker ps -a -q) && 
docker rm $(docker ps -a -q) &&
docker rmi $(docker images -q) -->

### PR 訊息

follow i18n(internationalization rule) rule, add 'Language code' and 'Country code' for more precise demand.
change 'zh.json' to 'zh-CN.json' for China.  
And add new 'zh-TW.json' for Taiwan and HongKong.
update index.js#L98-function-translation() to detect above language.

p.s. I'm not familiar to javascript, so I'm not sure if I do it right!
I have check that. (snapshot is down below)
but maybt u can help me code review.

--

### 類似功能關鍵字

但我不確定是不是也有文件編輯功能。  
但基本上 filestash(內涵 DocumentServer) 提供文件管理與文件編輯，我覺得功能很完善!!

- nextcloud
- filebrowser

--

## 後記

其實我原本有更改下列資源，並存放到我自己位置，但是方法失敗，所以目前只剩下

- DockerHub: 刪除
- GitHub - filestash: 保留在 Github
- GitHub - documentserver: achive
- GitHub - web-apps: achive
