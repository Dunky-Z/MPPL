FROM ubuntu:20.04 AS texlive
# Set Timezone
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo 'Asia/Shanghai' >/etc/timezone

# Set Work directory
WORKDIR /mppl

# Install some prerequisites
RUN apt-get update && apt-get install -y \
        fontconfig \
        pandoc \
        texlive-latex-extra \
        texlive-xetex


FROM texlive AS pandoc

RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections && \
    apt-get install -y \
        ttf-mscorefonts-installer \
    && rm -rf /var/lib/apt/lists/*

COPY fonts/* /usr/share/fonts/
COPY templates/* /templates/

RUN mkfontscale && \
    mkfontdir && \
    fc-cache && \
    fc-list

ENTRYPOINT [ "pandoc", "-f", "markdown-auto_identifiers",  "--listings", "--pdf-engine=xelatex", "--template=/templates/mppl.tex" ]