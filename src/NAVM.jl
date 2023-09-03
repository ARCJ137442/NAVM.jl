"""
NAVM的模块入口

整体模块架构：
用户终端输入 ==(前端模块)=> NAIR
NAIR        ==(后端模块)=> CIN命令
"""
module NAVM

# 导入
using Reexport

# 工具函数(不导出)
include("Util.jl")

# 总体定义
include("general.jl")

# 中间语NAIR
include("NAIR/NAIR.jl")
@reexport using .NAIR

# 前端
include("Frontend/Frontend.jl")
@reexport using .Frontend

# 后端
include("Backend/Backend.jl")
@reexport using .Backend

# 二者结合
include("combinations.jl")

end # module NAVM
