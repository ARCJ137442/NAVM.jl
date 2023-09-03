"""
NAIR: NAVM的中间语言
- 为各类前端输入提供统一的翻译目标
- 为各类后端输出提供统一的源头语言
"""
module NAIR

# 导入
using JuNarsese

# 数据结构
include("structs.jl")

# 方法集
include("methods.jl")

# 指令集
include("instruction_set.jl")

# 解析器
include("parser.jl")

end # NAIR
