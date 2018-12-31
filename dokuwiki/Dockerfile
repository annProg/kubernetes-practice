FROM alpine:3.8 as builder
RUN	sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk add --no-cache wget unzip
WORKDIR /wiki
RUN wget https://github.com/splitbrain/dokuwiki/archive/release_stable_2018-04-22a.tar.gz -O stable.tar.gz
RUN tar zxvf stable.tar.gz
RUN rm -f dokuwiki-release_stable_2018-04-22a/install.php
# data目录需要挂载volume
RUN mv dokuwiki-release_stable_2018-04-22a/data /tmp/

# markdowku插件
RUN wget https://komkon2.de/markdowku/markdowku.tgz
RUN tar zxvf markdowku.tgz

# dokuwiki-plot插件
RUN wget https://github.com/annProg/dokuwiki-plot/archive/v2.3.4.tar.gz -O plot.tar.gz
RUN tar zxvf plot.tar.gz
RUN mv dokuwiki-plot-2.3.4 plot

# catlist插件
RUN wget https://github.com/xif-fr/dokuwiki-plugin-catlist/zipball/master -O catlist.zip
RUN unzip catlist.zip
RUN mv xif-fr-dokuwiki-plugin-catlist-* catlist

# csv插件
RUN wget https://github.com/cosmocode/csv/zipball/master -O csv.zip
RUN unzip csv.zip
RUN mv cosmocode-csv-* csv

# dw2pdf 插件
RUN wget https://github.com/annProg/dokuwiki-plugin-dw2pdf/archive/ann-v1.0.tar.gz -O dw2pdf.tar.gz
RUN tar zxvf dw2pdf.tar.gz
RUN mv dokuwiki-plugin-dw2pdf-* dw2pdf

# imgPaste插件
RUN wget https://github.com/cosmocode/dokuwiki-plugin-imgpaste/zipball/master -O imgpaste.zip
RUN unzip imgpaste.zip
RUN mv cosmocode-dokuwiki-plugin-imgpaste-* imgpaste

# mathjax插件
RUN wget https://github.com/liffiton/dokuwiki-plugin-mathjax/archive/master.zip -O mathjax.zip
RUN unzip mathjax.zip
RUN mv dokuwiki-plugin-mathjax-master mathjax

FROM registry.cn-beijing.aliyuncs.com/kubebase/php7-nginx:1.2
COPY --from=builder /wiki/dokuwiki-release_stable_2018-04-22a/ /home/wwwroot/default/
COPY --from=builder /wiki/markdowku /home/wwwroot/default/lib/plugins/markdowku
COPY --from=builder /wiki/plot /home/wwwroot/default/lib/plugins/plot
COPY --from=builder /wiki/catlist /home/wwwroot/default/lib/plugins/catlist
COPY --from=builder /wiki/csv /home/wwwroot/default/lib/plugins/csv
COPY --from=builder /wiki/dw2pdf /home/wwwroot/default/lib/plugins/dw2pdf
COPY --from=builder /wiki/imgpaste /home/wwwroot/default/lib/plugins/imgpaste
COPY --from=builder /wiki/mathjax /home/wwwroot/default/lib/plugins/mathjax

COPY conf/default.conf /etc/nginx/conf.d/default.conf
COPY conf/dokuwiki_rewrite.conf /etc/nginx/dokuwiki_rewrite.conf
COPY app.sh /app.sh

