#=
实现PyNARS的输入格式
=#

# 导出
export BE_PyNARS

"实现一个后端"
struct BE_PyNARS <: BE_CommonCIN end

begin "方法实现"

    "实现PyNARS的Narsese输入: CommonNarsese"
    @nair_rule NSE(be::BE_PyNARS, narsese::TNarsese) narsese2data(StringParser_ascii, narsese)

    "实现PyNARS的推理步进指令"
    @nair_rule CYC(be::BE_PyNARS, n::Integer) string(n)

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
