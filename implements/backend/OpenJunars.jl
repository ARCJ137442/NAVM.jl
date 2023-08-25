#=
实现OpenJunars的输入格式
=#

# 导出
export BE_OpenJunars

"实现一个后端"
struct BE_OpenJunars <: BE_CommonCIN end

"实现OpenJunars的Narsese输入"
@nair_rule NSE(::BE_OpenJunars, narsese::TNarsese) string(narsese)

"实现OpenJunars的推理步进指令"
@nair_rule CYC(::BE_OpenJunars, n::Integer) ":c $n"

"实现OpenJunars的信息打印"
@nair_rule INF(::BE_OpenJunars, ::Vararg) ":p"
