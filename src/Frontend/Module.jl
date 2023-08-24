#=
NAVM的前端模块
=#

# 导入
import ..NAVM: transform # 添加方法

# 导出
export FrontendModule
export source_type

"""
前端模块 FrontendModule

作为抽象类，定义了前端模块的接口
"""
abstract type FrontendModule end

"""
(抽象)获取前端模块面向的「源类型」
- 例 字符串解析器：字符串文本
"""
source_type(::FrontendModule)::Type = error("未实现的`source_type`方法！")

"""
(抽象)主转换过程
- 执行转换过程，从「源对象」转换成NAIR中间语
"""
transform(::FrontendModule, source)::NAIR_CMD_TYPE = error("未实现的`transform`方法！")

"""
函数调用⇒转换
"""
(fm::FrontendModule)(source::Any)::NAIR_CMD_TYPE = transform(fm, source::source_type(fm))::NAIR_CMD_TYPE
