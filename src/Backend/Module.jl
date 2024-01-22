#=
后端模块

提供一个抽象类，通过实现抽象类以使用后端接口
=#

# 导入
import ..NAVM: NAVM_Module, 
               source_type, target_type, transform # 添加方法
import ..NAIR: NAIR_CMD,
               get_head
# 导出
export BackendModule
export target_type

"""
后端模块

- 提供抽象类，通过实现抽象类以使用后端接口
"""
abstract type BackendModule <: NAVM_Module end

"""
所有后端模块的「源类型」都是「指令」
"""
source_type(::BackendModule)::Type = NAIR_CMD

#= # ! 后端模块的「目标类型」仍然抽象，其已于`general.jl/target_type`中定义
"""
(抽象)后端模块的「目标类型」
- 从NAIR转换至「CIN指令」的「CIN指令类型」
"""
target_type(::BackendModule)::Type = error("未实现的`target_type`方法！")
=#

#= # ! 后端模块的「转换函数」仍然抽象，其已于`general.jl/transform`中定义
"""
    transform(bm::BackendModule, cmd::NAIR_CMD)
主转换过程 @ 后端
- 📌针对「后端」与「指令」进行分派
- 执行转换过程，从「NAIR中间语」转换成「目标对象」
- 分派到对应的`Val{头符号}`方法
- 返回「Vector{目标对象}」：可能一对多，因此需要统一成「目标对象序列」
    - 一个「目标对象」基本对应一行CIN命令
- ⚠可能返回空数组，表示无解析结果
"""
function transform end =#
