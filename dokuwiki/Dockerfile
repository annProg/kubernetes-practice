FROM alpine:3.8 as builder
RUN	sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk add --no-cache wget unzip
WORKDIR /wiki
RUN wget https://github.com/splitbrain/dokuwiki/archive/release_stable_2018-04-22a.tar.gz -O stable.tar.gz
RUN tar zxvf stable.tar.gz
RUN rm -f dokuwiki-release_stable_2018-04-22a/install.php
# data目录需要挂载volume
RUN mv dokuwiki-release_stable_2018-04-22a/data /tmp/

RUN mkdir plugins tpl

# markdowku插件
RUN wget https://komkon2.de/markdowku/markdowku.tgz
RUN tar zxvf markdowku.tgz
RUN mv markdowku plugins

# dokuwiki-plot插件
RUN wget https://github.com/annProg/dokuwiki-plot/archive/v2.3.4.tar.gz -O plot.tar.gz
RUN tar zxvf plot.tar.gz
RUN mv dokuwiki-plot-2.3.4 plugins/plot

# catlist插件
RUN wget https://github.com/xif-fr/dokuwiki-plugin-catlist/zipball/master -O catlist.zip
RUN unzip catlist.zip
RUN mv xif-fr-dokuwiki-plugin-catlist-* plugins/catlist

# csv插件
RUN wget https://github.com/cosmocode/csv/zipball/master -O csv.zip
RUN unzip csv.zip
RUN mv cosmocode-csv-* plugins/csv

# dw2pdf插件
RUN wget https://github.com/annProg/dokuwiki-plugin-dw2pdf/archive/ann-v1.0.tar.gz -O dw2pdf.tar.gz
RUN tar zxvf dw2pdf.tar.gz
RUN mv dokuwiki-plugin-dw2pdf-* plugins/dw2pdf

# imgPaste插件
RUN wget https://github.com/cosmocode/dokuwiki-plugin-imgpaste/zipball/master -O imgpaste.zip
RUN unzip imgpaste.zip
RUN mv cosmocode-dokuwiki-plugin-imgpaste-* plugins/imgpaste

# mathjax插件
RUN wget https://github.com/liffiton/dokuwiki-plugin-mathjax/archive/master.zip -O mathjax.zip
RUN unzip mathjax.zip
RUN mv dokuwiki-plugin-mathjax-master plugins/mathjax

# move插件
RUN wget https://github.com/michitux/dokuwiki-plugin-move/zipball/master -O move.zip
RUN unzip move.zip
RUN mv michitux-dokuwiki-plugin-move-* plugins/move

# todo插件
RUN wget https://github.com/leibler/dokuwiki-plugin-todo/archive/stable.zip -O todo.zip
RUN unzip todo.zip
RUN mv dokuwiki-plugin-todo-stable plugins/todo

# epub插件
RUN wget https://github.com/turnermm/epub/archive/master.zip -O epub.zip
RUN unzip epub.zip
RUN mv epub-master plugins/epub

# wrap插件
RUN wget https://github.com/selfthinker/dokuwiki_plugin_wrap/archive/stable.zip -O wrap.zip
RUN unzip wrap.zip
RUN mv dokuwiki_plugin_wrap-stable plugins/wrap

# bookcreator插件
RUN wget https://github.com/Klap-in/dokuwiki-plugin-bookcreator/archive/master.zip -O bookcreator.zip
RUN unzip bookcreator.zip
RUN mv dokuwiki-plugin-bookcreator-master plugins/bookcreator

# gitbacked插件
RUN wget https://github.com/woolfg/dokuwiki-plugin-gitbacked/archive/master.zip -O gitbacked.zip
RUN unzip gitbacked.zip
RUN mv dokuwiki-plugin-gitbacked-master plugins/gitbacked

# bootstrap3模板
RUN wget https://github.com/LotarProject/dokuwiki-template-bootstrap3/zipball/master -O bootstrap3.zip
RUN unzip bootstrap3.zip
RUN mv LotarProject-dokuwiki-template-bootstrap3-* tpl/bootstrap3

# tag插件
RUN wget https://github.com/dokufreaks/plugin-tag/tarball/master -O tag.tar.gz
RUN tar zxvf tag.tar.gz
RUN mv dokufreaks-plugin-tag-* plugins/tag

# syntaxhighlightjs插件
RUN wget https://github.com/annProg/dokuwiki-plugin-syntaxhighlightjs/archive/master.zip -O syntaxhighlightjs.zip
RUN unzip syntaxhighlightjs.zip
RUN mv dokuwiki-plugin-syntaxhighlightjs-master plugins/syntaxhighlightjs


# dokuwiki镜像
FROM registry.cn-beijing.aliyuncs.com/kubebase/php7-nginx:1.3

RUN apk add --no-cache git openssh-client
RUN apk add --no-cache php7-xml
COPY conf/default.conf /etc/nginx/conf.d/default.conf
COPY conf/dokuwiki_rewrite.conf /etc/nginx/dokuwiki_rewrite.conf

COPY --from=builder /wiki/dokuwiki-release_stable_2018-04-22a/ /home/wwwroot/default/
COPY --from=builder /wiki/tpl/ /home/wwwroot/default/lib/tpl/
COPY --from=builder /wiki/plugins/ /home/wwwroot/default/lib/plugins/

COPY app.sh /app.sh
WORKDIR /home/wwwroot/default
