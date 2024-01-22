#=
NAIR的数据结构接口
- 定义所有「NAIR指令」的表征、处理方法
- 后续指令处理均可随类型分派
=#

# 导入
"""
表征JuNarsese可能解析出的数据类型
- 包含：词项、语句、任务
- 后续`NSE`指令需要用到
"""
const NarseseObject = Union{ATerm,ASentence,ATask}

# 导出
export form_cmd, get_head
export NAIR_CMD

"""
    NAIR_CMD
所有指令基于的指令类型
"""
abstract type NAIR_CMD end

"""
    form_cmd(::Val{指令头}, 解析前字串, 参数...)
【抽象】根据符号分派「解析」函数
- 📌与「字串解析」`parse_cmd`的区别：不一定用到字符串
- @method `form_cmd(::Val{指令头}, 解析前字串, 参数...)`
    - 📌【2024-01-22 14:18:57】先前「参数检查」将内化于此
        - 原先的逻辑将被【内联】
    - @param ::Val{指令头} 基于其中的`指令头::Symbol`进行分派
    - @param 解析前字串::AbstractString 从解析器处传递的原字符串
        - 如`"NSE <A --> B>."`
    - @param ...参数 指令使用的附加参数
        - 📌所有参数均【非空】
        - ⚠️参数可能是其它类型
            - 如`NSE`会使用`JuNarsese.jl`中的数据类型
"""
function form_cmd end

"""
    form_cmd(args::Vector)::NAIR_CMD
多参数模式：通过一个单一的、可空的「参数数组」抽取指令对象
- 忽略其中的空值`nothing`
- 首个非空参数被视作指令头
"""
function form_cmd(args::Vector)::NAIR_CMD
    # 过滤
    params::Vector = filter(!isnothing, args)
    # 取头
    head::Symbol = popfirst!(params)
    # 构建
    form_cmd(
        head,
        params...
    )
end

"""
【抽象】指令头：表达式⇒表达式头
- @param cmd::NAIR_CMD 指令
- @returns Symbol 以「符号」表示的指令头
"""
function get_head end
"重定向：对象实例⇒类型"
get_head(cmd::NAIR_CMD) = get_head(typeof(cmd))

"""
    parser_params(::Type{<:NAIR_CMD})
【抽象】【内部】指令参数类型列表（解析用）
- @method parser_params(指令类型::Type{<:NAIR_CMD})
- @param 指令类型 指令的类别（Type对象）
- @returns Vector{Symbol} 参数类型列表（符号）
- 🎯用于语法解析器解析
    - 如：`[:identifier, :file_path]` => "指令头 标识符 文件路径"
- 📌一般只与类型有关
"""
function parser_params end
"重定向：对象实例⇒类型"
parser_params(cmd::NAIR_CMD) = parser_params(typeof(cmd))

# !【2024-01-22 14:20:39】弃用`get_args`：现在已解析的「指令」类型不会存储「参数列表」

# !【2024-01-22 14:22:00】弃用`verify_cmd`：现在「是否合法」仅取决于「能否构造」

"""
【快速开发】快速直观添加`get_head`和`parser_params`方法
- 📌格式：`指令头 参数1 参数2 ……`

@example `@reg_cmd SAV identifier file_path`

```julia
get_head(::Type{CMD_SAV}) = :SAV
parser_params(::Type{CMD_SAV}) = [:identifier, :file_path]
```
"""
macro reg_cmd(head::Symbol, args...)
    # 使用串拼接自动获取类名 # * 类名统一格式`CMD_指令名`
    local class_symbol::Symbol = Symbol("CMD_$head")

    return quote
        # 第一行 例：`get_head(::CMD_NSE) = :NSE`
        get_head(::Type{$(class_symbol)}) = $(QuoteNode(head))
        # 第二行
        parser_params(::Type{$(class_symbol)}) = $(args|>collect) # 剩下的内容都给CommonNarsese解析器解析
    end |> esc
end
