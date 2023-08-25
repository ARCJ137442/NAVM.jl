#=
NAIR解析器
- 使用PikaParser提供PEG语法支持
=#

# 导入
import PikaParser as P

# 导出
export NAIR_RULES, NAIR_GRAMMAR, NAIR_FOLDS
export parse_cmd, tryparse_cmd

"""
在参数中间隔插入空格
[参数1, 参数2,...] ⇒ [参数1, 空格, 参数2, 空格,...]
"""
function _join_args_by(iterator, delim)
    result::Vector = []
    local first::Bool = true
    for item in iterator
        # 第一个⇒为下一个设否；非第一个⇒插入分隔符
        first ? (first = false) : push!(result, delim)
        push!(result, item)
    end
    return result
end

"""
判断字符是否非换行符
"""
_not_newline_char(x::AbstractChar) = (
    x != '\r' &&
    x != '\n'
)

"""
使用PEG文法定义的NAIR语法规则

语法示例：
```NAIR
LOA run.nal
NSE <A --> B>.
CYC 50
SAV test.nal
```
"""
const NAIR_RULES::Dict = Dict(
    #= 基础数据类型: 用于对接指令集识别 =#
    # 空白: 不限量个空白字符
    # :ws => P.many(P.satisfy(isspace)),
    # 非空白: 匹配连续的非空白符号
    :not_ws => P.some(P.satisfy(!isspace)),
    # 空格符串：至少一个空格符
    :spaces => P.some(P.token(' ')), # 至少一个空格符
    # 换行符：至少一个CR/LF
    :new_line => P.some(
        P.first(
            P.token('\r'),
            P.token('\n'),
        ),
    ),
    # 数字
    :digit => P.satisfy(isdigit), # 直接传递不解析
    :uint => P.some(:digit), # 【20230816 16:11:12】some：至少有一个
    # :unsigned_number => P.first(
    #     P.seq( # `XXX[.XXX]`
    #         P.some(:digit), # 【20230816 16:31:36】many：有多个/没有
    #         P.first(
    #             P.seq( # `.XXXXXX`
    #                 P.token('.'), 
    #                 P.some(:digit)
    #             ), 
    #             P.epsilon # 或者为空
    #         ),
    #     ),
    #     P.seq( # `.XXX` (优先匹配长的)
    #         P.token('.'), 
    #         P.some(:digit),
    #     ),
    # ),
    # 标识符
    # :var_name => P.seq( # 与Julia变量名标准一致
    #     P.satisfy(Base.is_id_start_char), # 调用Julia内部识别变量名的方法
    #     P.many(
    #         P.satisfy(Base.is_id_char), # 调用Julia内部识别变量名的方法
    #     )
    # ),
    :identifier => P.seq( # 与Julia变量名标准一致的标识符
        P.satisfy(Base.is_id_start_char), # 调用Julia内部识别变量名的方法
        :not_ws # 非空字符串
    ),
    # 一行的剩余部分: 不限个数的非换行符（包括空白符）
    :raw_line => P.some(
        P.satisfy(_not_newline_char),
    ),
    # 路径：暂时使用「一行剩余部分」编码
    :file_path => P.seq(:raw_line),
    #= 元：开头/忽略 =#
    # 入口：NAIR指令 = 头 分隔符 内容 终止符
        # 通过指令集自动生成规则
    :instruction => P.first(
        (
            instruction_cmd => P.seq(
                P.tokens(string(instruction_cmd)), # 指令头(特定)
                :spaces, # 分隔符
                _join_args_by(dict[:params], :spaces)..., # 批量导入
                P.first( # 换行符/输入结束(指令必须限定在一行以内)
                    :new_line,
                    P.end_of_input
                ),
            )
            for (instruction_cmd, dict) in NAIR_INSTRUCTION_SET
        )...,
        # 默认（用户自定义）指令
        :_DEFAULT => P.seq(
            :identifier, # 指令头(通用)
            :spaces, # 分隔符
            :raw_line, # 内容
            P.first( # 换行符/输入结束
                :new_line,
                P.end_of_input
            ),
        )
    ),
)

"""
默认的NAIR打包器：遍历语法树，将其打包成NAIR指令
"""
const NAIR_FOLDS::Dict = Dict(
    #= 基础数据类型 =#
    # 空值直接返回第一个
    :ws         => (str, subvals) -> nothing,
    :spaces     => (str, subvals) -> nothing,
    :new_line   => (str, subvals) -> nothing,
    # 变量名/标识符直接返回字符串
    :var_name => (str, subvals) -> str,
    :identifier => (str, subvals) -> str,
    # 数值
    :uint            => (str, subvals) -> parse(Int, str),
    :unsigned_number => (str, subvals) -> parse(Float64, str),
    # 特殊格式文本
    :raw_line        => (str, subvals) -> str,
    :file_path       => (str, subvals) -> str, # 暂时原路返回
    #= NAIR指令 =#
    # subvals: **NAIR对象**
    :instruction => (str, subvals) -> begin
        return subvals[1]
    end,
    # 各个指令的解析函数
    # subvals: **指令头(字符串)** 空格 **因指令而异的自定义参数...** 换行符
    (
        instruction_cmd => (str, subvals) -> dict[:fold_f](
            instruction_cmd,
            str, 
            filter!(!isnothing, subvals)... # 自动过滤并展开
        ) # 自动展开
        for (instruction_cmd, dict) in NAIR_INSTRUCTION_SET
    )...,
    # 默认（用户自定义）指令
    :_DEFAULT => (str, subvals::Vector) -> begin
        @info "自定义指令通道：" str subvals
        args::Vector = filter!(!isnothing, subvals) # 自动过滤
        return form_cmd(Symbol(args[1]), args[2:end]...) # 不会溢出
    end,
)

"规则入口"
const NAIR_RULE_START::Symbol = :instruction

"""
NAIR语法
"""
const NAIR_GRAMMAR::P.Grammar = P.make_grammar(
    [NAIR_RULE_START], # 入口(此处限制到只有一个)
    P.flatten(NAIR_RULES, Char) # 扁平化
)

"""
默认Fold
"""
function _default_fold(str, subvals)
    # @info "default_fold!"
    # @show  str subvals
    for element in subvals # 不使用findfirst
        !isnothing(element) && return element
    end
    nothing # 默认空值
end

"""
解析「NAIR字符串」为「单个NAIR指令」的主函数

【20230825 15:16:55】Pika解析器不支持在SubString上解析！
"""
function parse_cmd(str::String)::NAIR_CMD_TYPE

    state::P.ParserState = P.parse(NAIR_GRAMMAR, str)

    match::Union{Integer, Nothing} = P.find_match_at!(state, NAIR_RULE_START, 1)
                
    (isnothing(match) || match < 1) && error("NAIR: 解析「$str」失败！match = $match")

    return P.traverse_match(
        state, match;
        fold = (m, p, s) -> get(
            NAIR_FOLDS, m.rule, 
            _default_fold
        )(m.view, s),
    )
end
parse_cmd(str::AbstractString)::NAIR_CMD_TYPE = parse_cmd(string(str))

"""
软解析：报错时返回nothing
"""
function tryparse_cmd(str::String)::Union{NAIR_CMD_TYPE, Nothing}
    try
        return parse_cmd(str)
    catch
        return nothing
    end
end
tryparse_cmd(str::AbstractString)::Union{NAIR_CMD_TYPE, Nothing} = tryparse_cmd(string(str))
