---
title: "MPPL Mermaid 图表示例"
version: V1.0
author: "Dominic"
date: "2026-06"
company: MPPL
file-code: MPPL-SAMPLE-00000001
logo: false
lot: false
lof: true
history:
  - version: V1.0
    author: Dominic
    date: 2026 年 06 月 28 日
    desc: 新增 Mermaid 图表导出示例
---

# Mermaid 图表导出

本文档演示 MPPL 如何将 Markdown 中的 Mermaid 代码块渲染为 PDF 内的图片。图表中的中文标签使用 **Source Han Serif SC**（与 MPPL 模板默认中文字体一致）。

渲染后的 PNG 图片会缓存到工作目录下的 `.mppl-mermaid-cache/`，重复转换相同内容时可复用，加快构建速度。

## 流程图

下面的流程图展示了文档从 Markdown 到 PDF 的处理流程：

```mermaid
graph TD
    A[编写 Markdown 文档] --> B{包含 Mermaid 代码块?}
    B -->|是| C[mermaid-filter 渲染为 PNG]
    B -->|否| D[Pandoc 直接解析]
    C --> E[Pandoc 转为 LaTeX]
    D --> E
    E --> F[XeLaTeX 生成 PDF]
    F --> G[输出美化后的 PDF 文档]
```

## 时序图

以下时序图演示用户发起 PDF 转换时的交互过程：

```mermaid
sequenceDiagram
    participant U as 用户
    participant D as Docker 容器
    participant M as mermaid-filter
    participant P as Pandoc
    participant X as XeLaTeX

    U->>D: docker run mppl -o out.pdf doc.md
    D->>M: 检测 mermaid 代码块
    M->>M: mmdc 渲染 PNG（中文字体）
    M->>P: 替换为图片节点
    P->>X: 生成 LaTeX 并编译
    X-->>U: 输出 PDF 文件
```

## 状态图

```mermaid
stateDiagram-v2
    [*] --> 草稿
    草稿 --> 审阅: 提交审阅
    审阅 --> 草稿: 退回修改
    审阅 --> 已发布: 审阅通过
    已发布 --> [*]
```

## 甘特图

```mermaid
gantt
    title 文档编写计划
    dateFormat YYYY-MM-DD
    section 准备阶段
    需求分析       :a1, 2026-06-01, 3d
    模板配置       :a2, after a1, 2d
    section 编写阶段
    正文撰写       :b1, after a2, 5d
    图表绘制       :b2, after a2, 4d
    section 发布阶段
    审阅与修订     :c1, after b1, 3d
    导出 PDF       :c2, after c1, 1d
```

## 类图

```mermaid
classDiagram
    class Markdown文档 {
        +String 标题
        +String 作者
        +render()
    }
    class Mermaid图表 {
        +String 源码
        +toPNG()
    }
    class PDF输出 {
        +String 文件路径
        +save()
    }
    Markdown文档 --> Mermaid图表 : 包含
    Markdown文档 --> PDF输出 : 导出为
```

## 使用说明

在 Markdown 中使用 Mermaid 时，用三个反引号包裹，并标注 `mermaid` 语言标识即可：

````markdown
```mermaid
graph LR
    开始 --> 结束
```
````

如需调整单张图的宽度或分辨率，可在代码块属性中指定（Pandoc 扩展语法）：

````markdown
```{.mermaid width=1600 scale=3}
graph LR
    节点A --> 节点B
```
````

全局默认值：`MERMAID_FILTER_WIDTH=1400`、`MERMAID_FILTER_SCALE=2`。若仍觉得不够清晰，可尝试 `MERMAID_FILTER_SCALE=3`，修改后请删除 `.mppl-mermaid-cache/` 以重新渲染。

缓存目录默认为 `.mppl-mermaid-cache/`，可通过环境变量 `MERMAID_FILTER_LOC` 修改。
