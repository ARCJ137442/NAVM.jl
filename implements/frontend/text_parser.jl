#=
用于从JuNarsese(Parsers)的文本解析器中获得语法解析支持
- 一个解析器就相当于一个前端
=#

# 导出
export FE_TextParser

"""
定义统一的解析器结构
"""
struct FE_TextParser <: NAVM.FrontendModule

    "字符串解析器"
    parser::JuNarsese.TAbstractParser
    
end

source_type(::FE_TextParser)::Type = AbstractString

"扩展的解析函数"
function transform(m::FE_TextParser, source::AbstractString)::Vector{NAIR_CMD_TYPE}
    # 如果分多行，按序列再解析
    splits::Vector{AbstractString} = split(source, r"[\r\n]+")
    length(splits) > 1 && return vcat((
        try_transform(m, s) # Pike解析器不支持
        for s::AbstractString in splits
        if !isempty(s)
    )...)
    # 尝试解析出Python/Julia风格的注释
    startswith(source, '#') && return [
        NAVM.form_cmd(
            :REM, # 注释
            source[2:end] # 井号之后
        )
    ]
    # 以「/」开头：使用NAIR解析器解析其余字符串
    startswith(source, '/') && return [
        NAVM.parse_cmd(source[2:end])
    ]
    # 尝试解析出循环步进
    n::Union{Int, Nothing} = tryparse(Int, source)
    isnothing(n) || return [
        NAVM.form_cmd(
            :CYC, # 输入循环步进
            n,
        )
    ]
    # 最后再尝试解析成Narsese输入
    return [
        NAVM.form_cmd(
            :NSE, # 输入Narsese
            m.parser(string(source)) # 自动解析
        )
    ]
end
