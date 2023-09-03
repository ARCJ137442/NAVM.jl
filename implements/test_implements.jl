#=
测试前后端实现
=#

begin
    "模块导入"
    # JuNarsese(Parsers)
    push!(LOAD_PATH, "../JuNarsese")
    push!(LOAD_PATH, "../JuNarseseParsers")

    # 导入NAVM
    if !(@isdefined NAVM)
        push!(LOAD_PATH, "../NAVM")
        using NAVM
        import NAVM: source_type, target_type, transform # 添加方法
        @info "NAVM导入成功！" names(NAVM)
    end

    using JuNarseseParsers
    using JuNarsese

    include("Implements.jl")
    using .Implements

end

# 启用@debug
ENV["JULIA_DEBUG"] = "all"

# 前端测试
fea = FE_TextParser(StringParser_ascii)
fes = FE_TextParser(SExprParser)

@show transform(fea, "<A --> B>.")
@show fes([
    "(Inheritance (Word A) (Word B))"
    "12"
])

@show fea("/VOL 10")


# 后端测试
ben = BE_OpenNARS()
beo = BE_ONA()
bep = BE_NARS_Python()
bey = BE_PyNARS()
bej = BE_OpenJunars()

@show bej(filter!(
    !isnothing,
    [
        try_form_cmd(:REM, "这是一段不会被翻译的注释")
        try_form_cmd(:NSE, nse"<A --> B>.")
        CMD_NSE(nse"<B --> C>.")
        try_form_cmd(:CYC, 5)
        try_form_cmd(:UNK, 5, Operator, Int, :a123, r"123", nse"<A --> B>.")
    ]
))

# 前后端连接测试
chain_f::Function = chain(fea, bej)
@show chain_f
@show chain_f([
    # 多行文本测试
    """
    # 下面输入一段基本的三段论推理
    # 基本逻辑：「A是B」「B是C」⇒「A是C」
    """
    "<A -->B>."
    "<B--> C>."
    "<A--> C>?"
    "50"
])

for be in [ben, beo, bep, bey, bej]
    @info "从「$(fes)字串」到「$(be)命令」"
    join(
        (be ∘ fes)("""
        /RES memory
        /LOA memory *
        # 下面输入一段基本的三段论推理
        # 基本逻辑：「A是B」「B是C」⇒「A是C」
        (SentenceJudgement (Inheritance (Word A) (Word B)) )
        (SentenceJudgement (Inheritance (Word B) (Word C)) )
        (SentenceQuestion  (Inheritance (Word A) (Word C)) )
        /VOL 10
        50
        /CYC 50
        /INF memory
        /SAV memory *
        """),
        "\n"
    ) |> println
end
