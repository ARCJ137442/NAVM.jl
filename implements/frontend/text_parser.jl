#=
用于从JuNarsese(Parsers)的文本解析器中获得语法解析支持
- 一个解析器就相当于一个前端
=#

"""
定义统一的解析器结构
"""
struct TextParserModule <: NAVM.FrontendModule

    parser::JuNarsese.TAbstractParser
    
end

source_type(::TextParserModule)::Type = AbstractString

"扩展的解析函数"
function transform(m::TextParserModule, source::AbstractString)
    # 尝试解析出循环步进
    n::Union{Int, Nothing} = tryparse(Int, source)
    isnothing(n) || return NAVM.form_cmd(
        :CYC, # 输入循环步进
        n,
    )
    # 最后再尝试解析成Narsese输入
    NAVM.form_cmd(
        :NSE, # 输入Narsese
        m.parser(source) # 自动解析
    )
end

# 测试
p = TextParserModule(StringParser_ascii)
p2 = TextParserModule(SExprParser)

@show transform(p, "<A --> B>.")
@show p2.([
    "(Inheritance (Word A) (Word B))"
    "12"
])
