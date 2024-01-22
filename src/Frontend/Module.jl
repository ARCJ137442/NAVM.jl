#=
NAVM的前端模块
=#

# 导入
import ..NAVM: NAVM_Module, 
               source_type, target_type, transform # 添加方法
import ..NAIR: NAIR_CMD,
               form_cmd

# 导出
export FrontendModule

"""
前端模块 FrontendModule

作为抽象类，定义了前端模块的接口
"""
abstract type FrontendModule <: NAVM_Module end

#= # ! 前端模块的「源类型」仍然抽象，其已于`general.jl/source_type`中定义
"""
(抽象)获取前端模块面向的「源类型」
- 例 字符串解析器：字符串文本
"""
source_type(::FrontendModule)::Type = error("未实现的`source_type`方法！")
=#


#= # ! 前端模块的「目标类型」仍然抽象，其已于`general.jl/target_type`中定义
"""
所有前端模块的「目标类型」都是「指令」
"""
target_type(::FrontendModule)::Type = NAIR_CMD =#

#= # ! 前端模块的「转换函数」仍然抽象，其已于`general.jl/transform`中定义
"""
(抽象)主转换过程
- 执行转换过程，从「源对象」转换成NAIR中间语
- 返回「Vector{中间语}」：可能一对多，因此需要统一成「中间语序列」
"""
transform(::FrontendModule, ::Any)::Vector{NAIR_CMD} = error("未实现的`transform`方法！")
=#
