
# 导入具体实现
push!(
    LOAD_PATH,
    "../",
    "../JuNarsese",
    "../JuNarseseParsers",
    "../NAVM",
    "implements",
)
using Implements

# 导入NAVM
if !(@isdefined NAVM)
    using NAVM
    import NAVM: source_type, target_type, transform # 添加方法
    @info "NAVM导入成功！" names(NAVM)
end

# JuNarsese(Parsers)

using JuNarseseParsers # 先导入，后面的导入可以复用前面的依赖
using JuNarsese
