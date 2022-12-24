---
title: "MPPL"
version: "0.1"
subtitle: "Markdown to PDF with Pandoc via LaTeX"
date: "2022-08"
author: "Dominic"
company: COMPANYNAME
file-code: COMPANY-DEPARTMENT-00000000
logo: true
logo-url: ./img/logo.png
lot: false
lof: false
history:
  - version: V0.1
    author: Dominic
    date: 2022-08-19
    desc: 创建文档
---

# MPPL

MPPL(Markdown to PDF with Pandoc via \LaTeX{}) 提供了一种将 Markdown 转换为 PDF 的解决方案。你可以使用 Docker 镜像免去安装依赖，也可以自行按照以下文档部署，将其作为 Pandoc 的一个模板使用。

# 使用 Docker

```bash
# 拉取镜像
docker pull ghcr.io/dunky-z/mppl/mppl:latest
# 进入文档目录
cd MPPL/samples
# 转换文档
$ docker run --rm -v $(pwd)/:/mppl mppl -o mppl-sample.pdf  mppl-sample.md        
```

# 自行部署

Markdown 生成 PDF 主要需要使用 Pandoc 和 Latex(texlive) 两个工具，具体安装方式如下：

## Pandoc 的安装

Pandoc 是由 John MacFarlane 开发的标记语言转换工具，可实现不同标记语言间的格式转换。

- Windows 下的安装：
  - 下载[安装包](https://github.com/jgm/pandoc/releases)直接安装即可
  - 如果安装了 Chocolate：`choco install pandoc`
  - 如果安装了 winget：`winget install pandoc`

- Linux/FreeBSD下的安装：
  - Pandoc 已经包含在大部分 Linux 发行版的官方仓库中，直接使用诸如`apt/dnf/yum/pacman`之类的安装工具直接安装即可
  
- MacOS 下的安装：
  - `brew install pandoc`

> 详细的安装说明参见：[官方安装文档](https://pandoc.org/installing.html)

## LaTex 的安装

LaTex 工具，在 windows 下建议安装 miktex，Linux 和 MacOS 下建议安装 texlive

- Windows 下的安装：
  - [参考该文章](https://zhuanlan.zhihu.com/p/41855480)下载完整 texlive，注意安装后需要再安装 cjk，cjk-fonts 等相关 package
- Linux/FreeBSD下的安装：
  - 使用 `apt/dnf/yum/pacman/pkg` 等安装工具安装 texlive、texlive-latex 等相关软件包
- MacOS 下的安装：
  - 使用 HomeBrew 安装 texlive 即可

## 字体安装

### Windows

```bash
# 复制字体文件到 C:\Windows\Fonts 目录
copy MPPL\fonts\* C:\Windows\Fonts

# 重新加载字体缓存
fc-cache -fv
```

如果无法生效，将`fonts`目录下的字体拖动到`C:\Windows\Fonts`目录。

### Ubuntu

```bash
$ echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
$ apt-get install -y \
        fontconfig \
        ttf-mscorefonts-installer

$ cp MPPL/fonts/* /usr/share/fonts/

$ mkfontscale &&  mkfontdir &&  fc-cache && fc-list
```

# 模板配置

## 配置 Pandoc 模板

为保证生成的 pdf 格式（自动插入封面、目录页、页眉页脚等信息），在本地环境中安装模板，具体步骤是：

- 下载本仓库
- 将`template/mppl.tex`拷贝到`*/pandoc/templates`目录下
  - Window 下：`C:/Users/USERNAME/AppData/Roaming/pandoc/templates`，如果`Roaming`没有`pandoc`目录，请手动创建
  - Linux/FreeBSD/MacOS：`~/.pandoc/templates/`

## 配置 LaTex 模板

模板定制主要修改模板最前面的**模板基础配置**相关内容，主要可修改的包括：

- 公司和组织，目前默认是"MPPL"
- 正文缩进，目前默认是`0em`
- 主要中文字体和英文字体：目前都是微软雅黑
- 页眉、页脚展示内容，目前是：
  - 左页眉：标题
  - 右页眉："企业机密 - 禁止外传"
  - 左页脚：company
  - 右页脚：页码

# 生成 PDF

## PDF 文件指定 metadata 信息

在每个 markdown 最前面增加以下主要 metadata 信息，metadata 内容开始行和结束行为三个“-”，示例如下：

```yml
---
title: "Markdown 语法简明教程"
version: V0.1
author: "Dominic"
date: "2022-08"
company: COMPANYNAME
file-code: COMPANY-DEPARTMENT-00000000
logo: true
logo-url: ./img/Markdown-mark.png
lot: true
lof: true
history:
  - version: V0.1
    author: Dominic
    date: 2022 年 08 月 20 日
    desc: 创建示例文档
---
```

其他可选配置项目如下：

- header-left: 左页眉
- header-right: 右页眉
- footer-left: 左页脚
- footer-right: 右页脚
- CJKmainfont: 主要中文字体
- mainfont: 主要英文字体
- monofont: 主要代码字体
- lot: 是否创建表格目录
- lof: 是否创建图片目录

> 可选配置项中，建议除了 subtitle 外，全部在模板中定制，不在 markdown 文件中定制

## 生成文件

```bash
cd samples
pandoc --listings --pdf-engine=xelatex --template=mppl.tex mppl-sample.md -o mppl-sample.pdf
```

# 参考

模板主要修改自[eppdev/eppdev-pandoc-template](https://github.com/eppdev/eppdev-pandoc-template)
