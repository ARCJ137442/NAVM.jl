#=
后端模块

提供一个抽象类，通过实现抽象类以使用后端接口
=#

# 导入
import ..NAVM: transform # 添加方法

# 导出
export BackendModule
export target_type

"""
后端模块

- 提供抽象类，通过实现抽象类以使用后端接口
"""
abstract type BackendModule end

"""
(抽象)后端模块的「目标类型」
- 从NAIR转换至「CIN指令」的「CIN指令类型」
- 一般是字符串
"""
target_type(::BackendModule) = error("未实现的`target_type`方法！")

"""
主转换过程
- 执行转换过程，从「NAIR中间语」转换成「目标对象」
"""
transform(bm::BackendModule, source::NAIR_CMD_TYPE) = transform(bm, Val(get_head(source)), get_args(source)...)

"""
(抽象)针对具体指令的转换
使用带Val的分派，分离对具体命令的解析
"""
transform(bm::BackendModule, head::Val, args::Vararg) = error("未实现的`transform@$head($args)`方法！")::target_type(bm)

"""
函数调用⇒转换
"""
(bm::BackendModule)(source::NAIR_CMD_TYPE) = transform(bm, source)::target_type(bm)
