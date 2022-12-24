FROM ubuntu:20.04
# Set Timezone
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo 'Asia/Shanghai' >/etc/timezone

# Set Work directory
WORKDIR /mppl

RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections

# Install some prerequisites
RUN apt-get update && apt-get install -y \
        fontconfig \
        pandoc \
        texlive-xetex \
        ttf-mscorefonts-installer && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY fonts/* /usr/share/fonts/
COPY templates/* /templates/

RUN mkfontscale && \
    mkfontdir && \
    fc-cache && \
    fc-list

ENTRYPOINT [ "pandoc", "-f", "markdown-auto_identifiers",  "--listings", "--pdf-engine=xelatex", "--template=/templates/mppl.tex" ]