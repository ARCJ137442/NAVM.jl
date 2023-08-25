begin "模块导入"
    # JuNarsese(Parsers)
    push!(LOAD_PATH, "../JuNarsese")
    push!(LOAD_PATH, "../JuNarseseParsers")

    using JuNarsese
    using JuNarseseParsers

    # 导入NAVM
    if !(@isdefined NAVM)
        push!(LOAD_PATH, "../NAVM")
        using NAVM
        import NAVM: source_type, target_type, transform # 添加方法
        @info "NAVM导入成功！" names(NAVM)
    end

end

# 启用@debug
ENV["JULIA_DEBUG"] = "all"

# 测试
@show parse_cmd("CYC    1")
@show parse_cmd("SAV NARS-1 test/nars1.nal")
@show parse_cmd("NSE <A --> B>.")
@assert tryparse_cmd("NSE NARS-1 test/nars1.nal") |> isnothing
@show tryparse_cmd("CYC This cmd may causes an error.")
@show parse_cmd("CUS This is my custom cmd.")

# 测试前后端实现
@info "开始测试前后端实现..."
include("../implements/test_implements.jl")
