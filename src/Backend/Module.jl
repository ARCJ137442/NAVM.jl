#=
后端模块

提供一个抽象类，通过实现抽象类以使用后端接口
=#

# 导入
import ..Frontend: target_type, transform # 添加方法

# 导出
export BackendModule

"""
后端模块

- 提供抽象类，通过实现抽象类以使用后端接口
"""
abstract type BackendModule end

"""
后端模块的「目标类型」
- 从NAIR转换至「CIN指令」的「CIN指令类型」
- 一般是字符串
"""
target_type(::BackendModule) = error("未实现的`target_type`方法！")

"""
主转换过程
- 执行转换过程，从「NAIR中间语」转换成「目标对象」
"""
transform(bm::BackendModule, source::NAIR_CMD_TYPE) = error("未实现的`transform`方法！")
