FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Set Timezone
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo 'Asia/Shanghai' >/etc/timezone

WORKDIR /mppl

RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections

# Install Pandoc, LaTeX, Node.js, Chromium 依赖及中文字体包
RUN apt-get update && apt-get install -y \
        ca-certificates \
        curl \
        gnupg \
        fontconfig \
        pandoc \
        texlive-xetex \
        texlive-lang-chinese \
        ttf-mscorefonts-installer \
        fonts-wqy-microhei \
        fonts-noto-cjk \
        fonts-liberation \
        libasound2 \
        libatk-bridge2.0-0 \
        libatk1.0-0 \
        libcups2 \
        libdbus-1-3 \
        libdrm2 \
        libgbm1 \
        libgtk-3-0 \
        libnspr4 \
        libnss3 \
        libx11-xcb1 \
        libxcomposite1 \
        libxdamage1 \
        libxrandr2 \
        xdg-utils && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 安装 mermaid-filter（含 @mermaid-js/mermaid-cli 与 Puppeteer Chromium）
RUN npm install -g @xuanphuc/mermaid-filter && \
    npm cache clean --force

COPY fonts/ /usr/share/fonts/mppl/
COPY templates/ /templates/
COPY config/ /etc/mppl/mermaid/
COPY scripts/mppl-entrypoint.sh /usr/local/bin/mppl-entrypoint.sh

RUN sed -i 's/\r$//' /usr/local/bin/mppl-entrypoint.sh && \
    chmod +x /usr/local/bin/mppl-entrypoint.sh && \
    cd /usr/share/fonts/mppl && mkfontscale && mkfontdir && \
    fc-cache -fv

ENTRYPOINT ["/usr/local/bin/mppl-entrypoint.sh"]
