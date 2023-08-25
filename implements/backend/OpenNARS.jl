#=
实现OpenNARS的输入格式
=#

# 导出
export BE_OpenNARS

"实现一个后端"
struct BE_OpenNARS <: BE_CommonCIN end

begin "方法实现"

    "实现OpenNARS的Narsese输入: CommonNarsese"
    @nair_rule NSE(be::BE_OpenNARS, narsese::TNarsese) narsese2data(StringParser_ascii, narsese)

    "实现OpenNARS的推理步进指令"
    @nair_rule CYC(be::BE_OpenNARS, n::Integer) string(n)

    "实现OpenNARS的音量调节"
    @nair_rule VOL(be::BE_OpenNARS, n::Integer) "*volume=$n"

    # "实现OpenNARS的记忆存储" # 不一定有「存储路径」
    # function transform(::BE_OpenNARS, ::Val{:SAV}, object::AbstractString, path::AbstractString="")::Vector{String}
    #     # 暂时不使用参数
    #     return String["save"]
    # end

    # "实现OpenNARS的记忆读取" # 不一定有「存储路径」
    # function transform(::BE_OpenNARS, ::Val{:LOA}, object::AbstractString, path::AbstractString="")::Vector{String}
    #     # 暂时不使用参数
    #     object == "input" || return String["load_input"]
    #     return String["load"]
    # end

end
