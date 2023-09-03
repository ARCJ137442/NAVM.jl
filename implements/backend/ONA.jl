#=
实现ONA的输入格式
=#

# 导出
export BE_ONA

"实现一个后端"
struct BE_ONA <: BE_CommonCIN end

begin
    "方法实现"

    "实现ONA的Narsese输入" # 📌ONA
    transform(::BE_ONA, cmd::CMD_NSE) = [narsese2data(StringParser_ascii, cmd.narsese)]

    "实现ONA的推理步进指令"
    transform(::BE_ONA, n::CMD_CYC) = [string(n)]

    "实现ONA的音量调节"
    transform(::BE_ONA, n::Integer) = ["*volume=$n"]

    # # 参考自`InputChannel.py`
    # "实现ONA的信息打印"
    # function transform(::BE_ONA, ::Val{:INF}, flag::AbstractString)::Vector{String}
    #     f::String = lowercase(flag)
    #     if f == "cycle"
    #         return String["cycle"]
    #     elseif startswith("memory", f)  || startswith("count", f)
    #         return String["count"]
    #     end
    # end

    "实现ONA的记忆存储" # 参见`NAR_language.py`
    transform(::BE_ONA, ::CMD_SAV) = String["*save"]

    "实现ONA的记忆读取" # 参见`NAR_language.py`
    transform(::BE_ONA, ::CMD_LOA) = String["*load"]

    "实现ONA的记忆清除" # 参见`NAR_language.py`
    transform(::BE_ONA, ::CMD_RES) = String["*reset"]

end
