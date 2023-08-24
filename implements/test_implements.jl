"""
存储与前端、CIN有关的具体实现
- 前端：JuNarsese-Native
- CIN：如OpenNARS、ONA、NARS-Python……
"""

module Implements

# 导入JuNarsese及其解析器
if !all(
        isdefined(Main, s)
        for s in [:JuNarsese, :JuNarseseParsers]
    )
    push!(LOAD_PATH, "../JuNarsese")
    push!(LOAD_PATH, "../JuNarseseParsers/")

    # 自动导入JuNarsese模块
    using JuNarseseParsers
    using JuNarseseParsers.JuNarsese
    
end

# 导入NAVM
if !(@isdefined NAVM)
    push!(LOAD_PATH, "../NAVM")
    using NAVM
    import NAVM: source_type, target_type, transform # 添加方法
end


include("frontends.jl")
include("backends.jl")

end
