include("preloadJuN.jl")

include("util.jl")

module G2N

using JuNarsese
using NAVM

export graph2narsese, g2n

const DEFAULT_GRAPH_CRITERIA::Function = (x, i, j) -> x > 0

"""
由「邻接矩阵+词项组+陈述构造器」构造「陈述の图」
- 条件
- 默认条件(参数：矩阵元素值)：其内数值大于零
- 相当于把
"""
function graph2narsese(
    m::Matrix{<:Real}, terms::Vector{<:Term};
    statement_constructor::Union{Type,Function}=Inheritance,
    criteria::Function=DEFAULT_GRAPH_CRITERIA
)
    @assert size(m)[1] ≤ length(terms) && size(m)[2] ≤ length(terms) "词项数不够！$(size(m)) > $(length(terms))"
    # 遍历整个邻接矩阵，仅在条件满足的情况下构造陈述
    return [
        (@inbounds statement_constructor(terms[i], terms[j]))
        for i in 1:size(m)[1], j in 1:size(m)[2]
        if criteria(m[i, j], i, j)
    ]
end

const g2n = graph2narsese

"""
从图&词项数组直接到NSE指令
- 参数详见
"""
function graph2NSE(params...)::Vector{CMD_NSE}
    # 直接调用构造函数
    return g2n(params...) .|> CMD_NSE
end

end

# test #

# 启用@debug
ENV["JULIA_DEBUG"] = "all"

using .G2N
terms = generate_A2z_terms()

narseses = G2N.graph2narsese(
    [
        1 0 0 1
        0 0 1 0
        0 1 0 0
        0 0 0 0
    ],
    terms
)
@show narseses

NSEs = G2N.graph2NSE(
    [ # A B C D (后/先)
        1 1 1 1 # A-->ABCD
        0 0 1 0 # B-->C
        0 1 0 0 # C-->B
        1 0 0 0 # D-->A
    ],
    terms
)
@show NSEs
bep = BE_PyNARS()
@show bep(NSEs)
bep(NSEs) .|> println