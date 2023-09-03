include("preloadJuN.jl")

# 按字符串的每个字符/字符串数组的每个元素，生成一系列同名变量名的词项
function generate_oneWord_terms(s, term_constructor::Union{Type,Function}=Word)
    for ss in s
        sss::Symbol = Symbol(ss)
        @eval $sss = ($term_constructor)($(QuoteNode(sss)))
    end

    return [
        @eval $(Symbol(sss))
        for sss in s
    ]
end

generate_A2z_terms(term_constructor::Union{Type,Function}=Word) = [
    generate_oneWord_terms('A':'Z', term_constructor)...,
    generate_oneWord_terms('a':'z', term_constructor)...,
]
