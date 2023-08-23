"""
NAVM前端：从文本/代码到NAIR
- 中间表示语言NAIR
- 外接API「前端模块」支持
"""
module Frontend

# 导入
using Reexport

# NAIR
include("Frontend/NAIR.jl")
@reexport using .NAIR

# 前端模块
include("Frontend/Module.jl")
@reexport using .Module

end # module
