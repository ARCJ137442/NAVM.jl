"""
NAIR: NAVM的中间语言
- 为各类前端输入提供统一的翻译目标
- 为各类后端输出提供统一的源头语言
"""
module NAIR

# 导入
push!(LOAD_PATH, "../JuNarsese") # 否则找不到路径
using JuNarsese

# 数据结构
include("NAIR/structs.jl")

# 指令集
include("NAIR/instruction_set.jl")

# 解析器
include("NAIR/parser.jl")

end # NAIR
