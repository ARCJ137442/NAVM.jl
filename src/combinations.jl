#=
这个文件在定义前端、后端之后，定义一些总体性的东西
=#

# 导出
export chain

"""
为转换函数添加方法
- 将源对象转换成中间语言，再由中间对象转换成目标对象
"""
transform(fe::FrontendModule, be::BackendModule, source) = transform(be, transform(fe, source))

"""
将前后端串联起来，组成一个函数
- 直接将源对象组装成目标对象
"""
chain(fe::FrontendModule, be::BackendModule) = source -> transform(fe, be, source)
