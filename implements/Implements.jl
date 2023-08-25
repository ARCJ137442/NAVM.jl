"""
存储与前端、CIN有关的具体实现
- 前端：JuNarsese-Native
- CIN：如OpenNARS、ONA、NARS-Python……
"""

module Implements

using JuNarsese
using JuNarseseParsers

# 导入NAVM
using NAVM
import NAVM: source_type, target_type, transform # 添加方法


include("frontends.jl")
include("backends.jl")

end
