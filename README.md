# NAVM - NAL's Additional Virtual Mechine

[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-%23FE5196?logo=conventionalcommits&logoColor=white)](https://conventionalcommits.org)

该项目使用[语义化版本 2.0.0](https://semver.org/)进行版本号管理。

对接前端用户输入（终端语言、NAL脚本等）与后端NARS实现（OpenNARS、ONA、NARS-Python、PyNARS、OpenJunars、Narjure、NARS-Swift……）的语言编译库

- 为其它使用Narsese的库提供数据结构表征、存取、互转支持

## 概念

### 前端、后端

前端：处理各类输入（例如终端、脚本）数据，将其翻译成中间语

后端：处理中间语对象，将其翻译成对应CIN命令

### 中间语 NAIR

- 所有前端转换成的目标语言
- 所有后端派发命令的源头语言

### CIN (Computer Implement of NARS)

- 「NARS计算机实现」之英文缩写
- 指代所有**实现NARS**的计算机软件系统
  - 不要求完整实现NAL 1~9

### ***CommonNarsese***

- 由[Narsese Grammar (IO Format)](https://github.com/opennars/opennars/wiki/Narsese-Grammar-(Input-Output-Format))定义，
- 在各类NARS(Narsese)实现中，
- 最先产生规范，并最为广泛接受的一种语法

与其它方言、超集的不同点举例：

- 原子词项：
  - 一律使用`$`、`#`、`?`、`^`区分「独立变量」「非独变量」「查询变量」「操作」
  - 一律使用单独的`_`表示「像占位符」
- 复合词项：
  - 一律使用特殊括弧`{词项...}`、`[词项...]`表示「外延集」「内涵集」
  - 一律使用「圆括号+前缀表达式」`(连接符, 词项...)`形式表示「非外延集、内涵集的复合词项」
    - 如`(&, <A --> B>, ^op)`
    - 对「否定」不使用前缀表达式
    - 对其它「二元复合词项」不使用中缀表达式
- 陈述：
  - 一律使用尖括号表示陈述，没有其他选项
    - 如`<A --> B>`
  - 不使用「回顾性等价」`<\>`系词
    - 一律用表义能力等同的「预测性等价」`</>`系词代替
    - 如`<A <\> B>`将表示为`<B </> A>`

## 安装

作为一个**Julia包**，您只需：

1. 在安装`Pkg`包管理器的情况下，
2. 在REPL(`julia.exe`)运行如下代码：

```julia
using Pkg
Pkg.add(url="https://github.com/ARCJ137442/NAVM.jl")
```

## 代码目录概览

`src`: API源码

`implements`: 具体实现

`test`: 测试用例

## 作者注

1. 此项目目前仅用于学习，不建议用于生产环境
2. 此项目最初从另一个接口项目「JuNEI」中分离出来，API、文档等资料可能欠缺
3. 此项目是**JuNarsese**、**JuNarseseParsers**的进阶应用

## 参考

### CIN

- [OpenNARS (Java)](https://github.com/opennars/opennars)
- [ONA (C)](https://github.com/opennars/OpenNARS-for-Applications)
- [NARS-Python (Python)](https://github.com/ccrock4t/NARS-Python)
- [PyNARS (Python)](https://github.com/bowen-xu/PyNARS)
- [OpenJunars (Julia)](https://github.com/AIxer/OpenJunars)
- [Narjure (Clojure)](https://github.com/opennars/Narjure)
- [NARS-Swift (Swift)](https://github.com/maxeeem/NARS-Swift)

### 依赖

- [JuNarsese](https://github.com/ARCJ137442/JuNarsese.jl)
- [JuNarsese-Parsers](https://github.com/ARCJ137442/JuNarseseParsers.jl)
