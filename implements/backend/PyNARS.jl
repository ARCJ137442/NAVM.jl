#=
实现PyNARS的输入格式
=#

# 导出
export BE_PyNARS

"实现一个后端"
struct BE_PyNARS <: BE_CommonCIN end

begin # 方法实现

    "实现PyNARS的Narsese输入: CommonNarsese"
    transform(::BE_PyNARS, cmd::CMD_NSE) = String[narsese2data(StringParser_ascii, cmd.narsese)]

    "（基于现有版本的ConsolePlus）实现PyNARS的操作符注册（无附加作用）"
    transform(::BE_PyNARS, cmd::CMD_REG) = String["/reg $(cmd.operator_name)"]

    "实现PyNARS的推理步进指令"
    transform(::BE_PyNARS, cmd::CMD_CYC) = String[string(cmd.steps)]

    # "实现PyNARS的记忆存储" # 不一定有「存储路径」
    # function transform(::BE_PyNARS, ::Val{:SAV}, object::AbstractString, path::AbstractString="")::Vector{String}
    #     # 暂时不使用参数
    #     return String["save"]
    # end

    # "实现PyNARS的记忆读取" # 不一定有「存储路径」
    # function transform(::BE_PyNARS, ::Val{:LOA}, object::AbstractString, path::AbstractString="")::Vector{String}
    #     # 暂时不使用参数
    #     object == "input" || return String["load_input"]
    #     return String["load"]
    # end

end
