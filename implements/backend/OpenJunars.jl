#=
实现OpenJunars的输入格式
=#

# 导出
export BE_OpenJunars

"实现一个后端"
struct BE_OpenJunars <: BE_CommonCIN end

"实现OpenJunars的Narsese输入"
transform(::BE_OpenJunars, cmd::CMD_NSE) = String[string(cmd.narsese)]

"实现OpenJunars的推理步进指令"
transform(::BE_OpenJunars, cmd::CMD_CYC) = String[":c $(cmd.steps)"]

"实现OpenJunars的信息打印"
transform(::BE_OpenJunars, cmd::CMD_INF) = String[":p"]
