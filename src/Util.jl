"""
存储模块无关的工具函数
"""
module Util

export @defined

"""
扩展自Base.@isdefined
- 可以接受多个符号，并返回一个元组
"""
macro defined(symbols...)
    return Expr(
        :tuple,
        (
            Expr(:escape, Expr(:isdefined, symbol))
            for symbol in symbols
        )...
    )
end

end
