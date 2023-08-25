"""
一个CIN普遍通用的后端定义
"""
abstract type BE_CommonCIN <: BackendModule end

"JuNarsese中所有Narsese元素的类型"
TNarsese::Type = Union{ATerm, ASentence, ATask}

"目标类型：字符串"
target_type(::BE_CommonCIN) = String

"实现注释"
function transform(::BE_CommonCIN, ::Val{:REM}, comment::AbstractString)::Vector{String}
    @info comment
    String[] # 空数组
end

"对未知指令的处理：静默失败"
function transform(be::BE_CommonCIN, ::Val{head}, args::Vararg)::Vector{String} where head
    @debug "$be: 未知的指令「$head $(join(args, ' '))」" # nothing
    String[] # 空数组
end
