"""
前端模块
"""
module Module

# 导入

# 导出
export FrontendModule
export source_type, transform

"""
前端模块 FrontendModule

作为抽象类，定义了前端模块的接口
"""
abstract type FrontendModule end

"""
获取前端模块面向的「源类型」
- 例 字符串解析器：字符串文本
"""
source_type(::FrontendModule)::Type = error("未实现的`source_type`方法！")

"""
主转换过程
- 执行转换过程，从「源对象」转换成NAIR中间语
"""
transform(fm::FrontendModule, source)::CMD_TYPE = error("未实现的`transform`方法！")

end # module
