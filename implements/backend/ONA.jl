#=
实现ONA的输入格式
=#

# 导出
export BE_ONA

"实现一个后端"
struct BE_ONA <: BE_CommonCIN end

begin "方法实现"

    "实现ONA的Narsese输入" # 📌ONA
    @nair_rule NSE(::BE_ONA, narsese::TNarsese) narsese2data(StringParser_ascii, narsese)

    "实现ONA的推理步进指令"
    @nair_rule CYC(::BE_ONA, n::Integer) string(n)

    "实现ONA的音量调节"
    @nair_rule VOL(::BE_ONA, n::Integer) ["*volume=$n"]

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
    @nair_rule SAV(::BE_ONA, object::AbstractString, path::AbstractString="") "*save"

    "实现ONA的记忆读取" # 参见`NAR_language.py`
    @nair_rule LOA(::BE_ONA, object::AbstractString, path::AbstractString="") "*load"

    "实现ONA的记忆清除" # 参见`NAR_language.py`
    @nair_rule RES(::BE_ONA, object::AbstractString, path::AbstractString="") "*reset"

end
