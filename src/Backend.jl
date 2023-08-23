"""
NAVM后端：从NAIR到CIN输入
"""
module Backend

# 导入
# using Reexport

using ..Frontend # 导入前端

# 后端模块
include("Backend/module.jl")
# @reexport using .Module

end # module
