---
output:
  pdf_document:
    latex_engine: xelatex
    pandoc_args: [--template=mppl.latex,--listings,-f,markdown-auto_identifiers]

title: "Markdown语法简明教程"
version: V0.1
author: "Dominic"
date: "2022-08"
company: COMPANYNAME
file-code: COMPANY-DEPARTMENT-00000000
logo: true
logo-url: ../img/Markdown-mark.png
lot: true
lof: true
history:
  - version: V0.1
    author: Dominic
    date: 2022年08月20日
    desc: 创建示例文档
---

# Markdown简介

## Markdown是什么？

**Markdown**是一种轻量级**标记语言**，它以纯文本形式(*易读、易写、易更改*)编写文档，并最终以HTML格式发布。    

**Markdown**也可以理解为将以MARKDOWN语法编写的语言转换成HTML内容的工具。    

##  谁创造了它？

它由[**Aaron Swartz**](http://www.aaronsw.com/)和**John 
**共同设计，**Aaron Swartz**就是那位于去年（*2013年1月11日*）自杀,有着**开挂**一般人生经历的程序员。维基百科对他的[介绍](http://zh.wikipedia.org/wiki/%E4%BA%9A%E4%BC%A6%C2%B7%E6%96%AF%E6%B2%83%E8%8C%A8)是：**软件工程师、作家、政治组织者、互联网活动家、维基百科人**。    

+ **14岁**参与RSS 1.0规格标准的制订。     
+ **2004**年入读**斯坦福**，之后退学。   
+ **2005**年创建[Infogami](http://infogami.org/)，之后与[Reddit](http://www.reddit.com/)合并成为其合伙人。   
+ **2010**年创立求进会（Demand Progress），积极参与禁止网络盗版法案（SOPA）活动，最终该提案被撤回。   
+ **2011**年7月19日，因被控从MIT和JSTOR下载480万篇学术论文并以免费形式上传于网络被捕。     
+ **2013**年1月自杀身亡。    


##  为什么要使用它？

+ 它是易读（看起来舒服）、易写（语法简单）、易更改**纯文本**。处处体现着**极简主义**的影子。
+ 兼容HTML，可以转换为HTML格式发布。
+ 跨平台使用。
+ 越来越多的网站支持Markdown。
+ 更方便清晰地组织你的电子邮件。（Markdown-here, Airmail）
+ 摆脱Word

##  怎么使用？

如果不算**扩展**，Markdown的语法绝对**简单**到让你爱不释手。

Markdown语法主要分为如下几大部分：

**标题**，**段落**，**区块引用**，**代码区块**，**强调**，**列表**，**分割线**，**链接**，**图片**，**反斜杠 `\`**，**符号'`'**。


## 谁在用？

Markdown的使用者：

- GitHub
- 简书
- Stack Overflow
- Apollo
- Moodle
- Reddit
- 等等

# 语法介绍

##  标题

两种形式：  
1. 使用`=`和`-`标记一级和二级标题。

    > 一级标题   
    > `=========`   
    > 二级标题    
    > `---------`

1. 使用`#`，可表示1-6级标题。

    > \# 一级标题   
    > \## 二级标题   
    > \### 三级标题   
    > \#### 四级标题   
    > \##### 五级标题   
    > \###### 六级标题    

##  段落

段落的前后要有空行，所谓的空行是指没有文字内容。若想在段内强制换行的方式是使用**两个以上**空格加上回车（引用中换行省略回车）。

##  区块引用

区块引用需要在被引用的文本前加上 `>` 符号。

```markdown
> 这是一个区块引用实例,

> Markdown.
```

> 这是一个区块引用实例,

> Markdown.

Markdown 也允许你偷懒只在整个段落的第一行最前面加上 `>` :

```markdown
> 平生不会相思,
才会相思,
便害相思。

> 空一缕余香在此,
盼千金游子何之。
```

> 平生不会相思,
才会相思,
便害相思。

> 空一缕余香在此,
盼千金游子何之。

### 引用的多层嵌套

区块引用可以嵌套（例如：引用内的引用）, 只要根据层次加上不同数量的 `>` :

```markdown
>>> 锄禾日当午, 汗滴禾下土。 - 李绅

>> 山有木兮木有枝, 心悦君兮君不知。 - 越人歌

> 去年今日此门中, 人面桃花相映红。 - 崔护
```

>>> 锄禾日当午, 汗滴禾下土。 - 李绅

>> 山有木兮木有枝, 心悦君兮君不知。 - 越人歌

> 去年今日此门中, 人面桃花相映红。 - 题都城南庄

## 锚点
网页中, 锚点其实就是页内超链接, 也就是链接本文档内部的某些元素, 实现当前页面中的跳转。比如我这里写下一个锚点, 点击跳转到指定章节。

```markdown
[点击跳转至区块引用](#区块引用)
```

[点击跳转至区块引用](#区块引用)

## 代码区块

代码区块的建立是在每行加上4个空格或者一个制表符（如同写代码一样）。如    
普通段落：

void main()    
{    
    printf("Hello, Markdown.");    
}    

代码区块：

    void main()
    {
        printf("Hello, Markdown.");
    }

**注意**:需要和普通段落之间存在空行。

## 强调

Markdown 使用星号`*`和底线`_`作为标记强调字词的符号。

### 斜体

```markdown
*花自飘零水自流*
```

> *花自飘零水自流*

### 粗体

```markdown
**花自飘零水自流**
```

> **花自飘零水自流**

### 删除线

```markdown
~~花自飘零水自流~~
```

> ~~花自飘零水自流~~

##  列表

使用`·`、`+`、或`-`标记无序列表，如：

> \-（+\*） 第一项
> \-（+\*） 第二项
> \- （+\*）第三项

**注意**：标记后面最少有一个_空格_或_制表符_。若不在引用区块中，必须和前方段落之间存在空行。

效果：

> + 第一项
> + 第二项
> + 第三项

有序列表的标记方式是将上述的符号换成数字,并辅以`.`，如：

> 1 . 第一项   
> 2 . 第二项    
> 3 . 第三项    

效果：

> 1. 第一项
> 2. 第二项
> 3. 第三项

##  分割线

分割线最常使用就是三个或以上`*`，还可以使用`-`和`_`。

---

##  链接

Markdown 支持两种形式的链接语法: 行内式和参考式两种形式, 行内式一般使用较多。

### 行内式

`[]`里写链接文字，`()`里写链接地址, `()`中的 `""` 中可以为链接指定title属性, title属性可加可不加。title属性的效果是鼠标悬停在链接上会出现指定的 title文字。`[链接文字](链接地址 "链接标题")` 这样的形式。链接地址与链接标题前有一个空格。

```markdown
[MPPL: Markdown to PDF with Pandoc via Latex](https://github.com/Dunky-Z/MPPL)
[MPPL: Markdown to PDF with Pandoc via Latex](https://github.com/Dunky-Z/MPPL "MPPL")
```

> [MPPL: Markdown to PDF with Pandoc via Latex](https://github.com/Dunky-Z/MPPL)
> 
> [MPPL: Markdown to PDF with Pandoc via Latex](https://github.com/Dunky-Z/MPPL "MPPL")

### 参考式

参考式超链接一般用在学术论文上面, 或者另一种情况, 如果某一个链接在文章中多处使用, 那么使用引用的方式创建链接将非常好, 它可以让你对链接进行统一的管理。

参考式链接分为两部分, 文中的写法 `[链接文字][链接标记]`，在文本的任意位置添加 `[链接标记]:链接地址 "链接标题"`, 链接地址与链接标题前有一个空格。

```markdown
全球最大的搜索引擎网站是[Google][1]。

[1]:http://www.google.com "Google"
```

> 全球最大的搜索引擎网站是 [Google][1]。
> <br />
>
> [1]:http://www.google.com "Google"



##  图片

图片的创建方式与超链接相似, 而且和超链接一样也有两种写法, 行内式和参考式写法。

语法中图片Alt的意思是如果图片因为某些原因不能显示, 就用定义的图片Alt文字来代替图片。 图片Title则和链接中的Title一样, 表示鼠标悬停与图片上时出现的文字。 Alt 和 Title 都不是必须的, 可以省略, 但建议写上。

### 图片行内式

`![图片Alt](图片地址 "图片Title")`

```markdown
![MarkdownLogo](../img/Markdown-mark.png "MarkdownLogo")
```

![MarkdownLogo](../img/Markdown-mark.png "MarkdownLogo")

### 图片参考式

在文档要插入图片的地方写 `![图片Alt][标记]`。

在文档的最后写上 `[标记]:图片地址 "Title"`。

```markdown
![MarkdownLogo][MarkdownLogo]

[MarkdownLogo]:../img/Markdown-mark.png "MarkdownLogo"
```

[MarkdownLogo]:../img/Markdown-mark.png "MarkdownLogo"


## 反斜杠`\`

相当于**反转义**作用。使符号成为普通符号。

## 代码

对于程序员来说这个功能是必不可少的, 插入程序代码的方式有两种, 一种是利用缩进(Tab), 另一种是利用 "`" 符号(一般在ESC键下方)包裹代码。

- 插入行内代码, 即插入一个单词或者一句代码的情况，使用 \`code\` 这样的形式插入。
- 插入多行代码, 可以使用缩进或者 \`\`\` code \`\`\`, 具体看示例。

### 代码行内式

```markdown
PHP打印堆栈信息 `debug_backtrace()`。
```

> PHP打印堆栈信息 `debug_backtrace()`。

### 缩进式多行代码

缩进 4 个空格或是 1 个制表符。

一个代码区块会一直持续到没有缩进的那一行(或是文件结尾)。

```markdown
    $closure = function () use($name) {
      return $name;
    }
```

    $closure = function () use($name) {
      return $name;
    }

### 用六个 ` 包裹多行代码

```markdown
> ```c # 为了能够在markdown里演示，所以加了>符号
#include <stdio.h>
int main()
{
    printf("Hello, World!\n");
    return 0;
}
> ```
```

```c
#include <stdio.h>
int main()
{
    printf("Hello, World!\n");
    return 0;
}
```

### 内容目录

在段落中填写 `[TOC]` 以显示全文内容的目录结构。

## 表格

1. 不管是哪种方式, 第一行为表头, 第二行分隔表头和主体部分, 第三行开始每一行为一个表格行。
1. 列于列之间用管道符`|`隔开。原生方式的表格每一行的两边也要有管道符。
1. 第二行还可以为不同的列指定对齐方向。默认为左对齐, 在`-`右边加上`:`就右对齐。

简单方式:

```markdown
诗名|作者|朝代
-|-|-
白头吟|卓文君|两汉
锦瑟|李商隐|唐代
登科后|孟郊|唐代
```

诗名|作者|朝代
-|-|-
白头吟|卓文君|两汉
锦瑟|李商隐|唐代
登科后|孟郊|唐代

原生方式:

```markdown
|诗名|作者|朝代|
|-|-|-|
|白头吟|卓文君|两汉|
|锦瑟|李商隐|唐代|
|登科后|孟郊|唐代|
```

|诗名|作者|朝代|
|-|-|-|
|白头吟|卓文君|两汉|
|锦瑟|李商隐|唐代|
|登科后|孟郊|唐代|

为表格第二列指定方向:

```markdown
诗名|名句
-|-:
梦微之|君埋泉下泥销骨。
上邪|上邪，我欲与君相知，长命无绝衰。
```

诗名|名句
-|-:
梦微之|君埋泉下泥销骨。
上邪|上邪，我欲与君相知，长命无绝衰。


## 注脚

在需要添加注脚的文字后加上脚注名字`[^注脚名字]`, 称为加注。 然后在文本的任意位置(一般在最后)添加脚注, 脚注前必须有对应的脚注名字。

```markdown
使用 Markdown[^1]可以效率的书写文档, 直接转换成 HTML[^2]。

[^1]: Markdown 是一种纯文本标记语言

[^2]: HyperText Markup Language 超文本标记语言
```

## LaTeX 公式

### $ 表示行内公式

```markdown
质能守恒方程可以用一个很简洁的方程式 $E=mc^2$ 来表达。
```

质能守恒方程可以用一个很简洁的方程式$E=mc^2$来表达。

### $$ 表示整行公式

```markdown
$$\sum_{i=1}^n a_i=0$$
$$f(x_1,x_x,\ldots,x_n) = x_1^2 + x_2^2 + \cdots + x_n^2 $$
$$\sum^{j-1}_{k=0}{\widehat{\gamma}_{kj} z_k}$$
```

$$\sum_{i=1}^n a_i=0$$

#  尝试一下

+ **Chrome**下的插件诸如`stackedit`与`markdown-here`等非常方便，也不用担心平台受限。
+ **在线**的dillinger.io评价也不错   
+ **Windowns**下的MarkdownPad也用过，不过免费版的体验不是很好。    
+ **Mac**下的Mou是国人贡献的，口碑很好。
+ **Linux**下的ReText不错。    

**当然，最终境界永远都是笔下是语法，心中格式化。**

****
**注意**：不同的Markdown解释器或工具对相应语法（扩展语法）的解释效果不尽相同，具体可参见工具的使用说明。
虽然有人想出面搞一个所谓的标准化的Markdown，[没想到还惹怒了健在的创始人John Gruber](http://blog.codinghorror.com/standard-markdown-is-now-common-markdown/ )。
****
以上基本是所有traditonal markdown的语法。


关于其它扩展语法可参见具体工具的使用说明。

# 参考资料

1. [Markdown 基本语法。](https://github.com/younghz/Markdown)
1. [cdoco/markdown-syntax: Markdown 语法详解。](https://github.com/cdoco/markdown-syntax)