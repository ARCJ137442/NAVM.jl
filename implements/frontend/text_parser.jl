#=
用于从JuNarsese(Parsers)的文本解析器中获得语法解析支持
- 一个解析器就相当于一个前端
=#

"""
定义统一的解析器结构
"""
struct TextParserModule <: NAVM.FrontendModule

    parser::JuNarsese.AbstractParser
    
end

source_type(::TextParserModule)::Type = AbstractString

transform(m::TextParserModule, source::AbstractString) = @show m.parser NAVM.form_cmd(
    :NSE, # 只有Narsese输入
    m.parser(m) # 自动解析
)

p = TextParserModule(StringParser_ascii)

@show transform(p, "<A --> B>.")
