"""
一个CIN普遍通用的后端定义
"""
abstract type BE_CommonCIN <: BackendModule end

"JuNarsese中所有Narsese元素的类型"
TNarsese::Type = Union{ATerm,ASentence,ATask}

"目标类型：字符串数组（因为有可能「一指令多字串」）"
target_type(::BE_CommonCIN) = String

"统一实现注释"
function transform(::BE_CommonCIN, comment::CMD_REM)::Vector{String}
    @info comment
    String[] # 空数组
end

"对未注册指令的处理：静默失败"
function transform(be::BE_CommonCIN, cmd::NAIR_CMD)::Vector{String}
    @debug "$be: 未注册的指令「$cmd」，已自动返回空数组" # nothing
    String[] # 空数组
end
