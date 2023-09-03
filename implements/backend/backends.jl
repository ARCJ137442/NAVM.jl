#=
集成一些后端实现
=#


# 导入
using JuNarsese

import NAVM: transform # 修改方法

include("common.jl")
include("OpenNARS.jl")
include("ONA.jl")
include("NARS-Python.jl")
include("PyNARS.jl")
include("OpenJunars.jl")
