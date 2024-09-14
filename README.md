# NAVM - NAL's Additional Virtual Machine

![GitHub License](https://img.shields.io/github/license/ARCJ137442/NAVM.jl?style=for-the-badge&color=a270ba)
![Code Size](https://img.shields.io/github/languages/code-size/ARCJ137442/NAVM.jl?style=for-the-badge&color=a270ba)
![Lines of Code](https://www.aschey.tech/tokei/github.com/ARCJ137442/NAVM.jl?style=for-the-badge&color=a270ba)
[![Language](https://img.shields.io/badge/language-Julia%201.8+-purple?style=for-the-badge&color=a270ba)](https://cn.julialang.org/)

开发状态：

![Created At](https://img.shields.io/github/created-at/ARCJ137442/NAVM.jl?style=for-the-badge)
![Last Commit](https://img.shields.io/github/last-commit/ARCJ137442/NAVM.jl?style=for-the-badge)

[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-%23FE5196?style=for-the-badge)](https://conventionalcommits.org)

## 简介

用于统一CIN（NARS计算机实现）输入输出的**抽象语法支持库**

- 🏗️提供一套抽象**指令**接口
  - 为其它使用Narsese的库提供「指令表征」「指令存取」「基本字符串指令解析」等**支持性功能**
  - 基于[OpenNARS](https://github.com/opennars/opennars)，抽象并提供一套**基础指令集合**
    - 包括：NSE（输入Narsese文本）、CYC（循环指定周期数）、REM（注释）等
  - 针对CIN的具体实现可参考[NAVM_Implements.jl](https://github.com/ARCJ137442/NAVM_Implements.jl)
- 📌采用「前端用户输入⇒统一中间语转译⇒后端NARS实现」的**前后端框架**
  - 前端 如：终端文本、NAL脚本等
    - 可以是字符串，也可为其它数据结构
  - 后端 如：OpenNARS、ONA、NARS-Python、PyNARS、OpenJunars、Narjure、NARS-Swift……
    - 主要基于**程序纯文本输入输出**
- 🎯可能后续会发展成一套CIN通用的表征、控制、转换**DSL**（领域特定语言）

## 概念

### CIN (Computer Implement of NARS)

- 「NARS计算机实现」之英文缩写
- 指代所有**实现NARS**的计算机软件系统
  - 不要求完整实现NAL 1~9

### 前端、后端

前端：处理各类输入（例如终端、脚本）数据，将其翻译成中间语(NAIR)

后端：处理中间语对象，将其翻译成对应CIN命令

### 中间语 NAIR

- 所有前端转换成的目标语言
- 所有后端分派命令的源头语言

### ***CommonNarsese***

🔗参考[**JuNarsese.jl**的相关部分](https://github.com/ARCJ137442/JuNarsese.jl?tab=readme-ov-file#commonnarsese)

## 安装

作为一个**Julia包**，您只需：

1. 在安装`Pkg`包管理器的情况下，
2. 在REPL(`julia.exe`)运行如下代码：

```julia
using Pkg
Pkg.add(url="https://github.com/ARCJ137442/NAVM.jl")
```

## 使用

🔗参考[NAVM_Implements](https://github.com/ARCJ137442/NAVM_Implements)的具体实现

## 代码目录概览

- `src`: API源码
  - `Frontend`: 前端模组API
  - `Backend`: 后端模组API
  - `NAIR`: 中间语言NAIR
- `test`: 测试用例

## 作者注

1. 此项目目前仅用于学习，不建议用于生产环境
2. 此项目最初从另一个接口项目「JuNEI」中分离出来，API、文档等资料可能欠缺
3. 此项目是**JuNarsese**、**JuNarseseParsers**的进阶应用

## 参考

### 依赖

- [JuNarsese](https://github.com/ARCJ137442/JuNarsese.jl)
- [PikaParser](https://github.com/LCSB-BioCore/PikaParser.jl)
