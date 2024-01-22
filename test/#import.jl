begin "模块导入"
    # JuNarsese(Parsers)
    push!(LOAD_PATH, "../JuNarsese")
    # push!(LOAD_PATH, "../JuNarseseParsers") # !【2024-01-22 16:55:20】因「具体实现」向外迁移，现不再需要

    using JuNarsese
    # using JuNarseseParsers # !【2024-01-22 16:55:20】因「具体实现」向外迁移，现不再需要

    # 导入NAVM
    if !(@isdefined NAVM)
        push!(LOAD_PATH, "../NAVM.jl")
        using NAVM
        import NAVM: source_type, target_type, transform # 添加方法
        @info "NAVM导入成功！" names(NAVM)
    end

    # 导入测试专用库Test
    using Test
end


# 启用@debug
ENV["JULIA_DEBUG"] = "all"
