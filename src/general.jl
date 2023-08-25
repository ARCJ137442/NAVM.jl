#=
这个文件在总体上定义NAVM的主要的、模块无关的行为
=#

export NAVM_Module
export source_type, target_type, 
       transform, try_transform


"""
所有NAVM模块的基类
- 具有「源类型」与「目标类型」
- 具有「转换函数」与「尝试转换函数」
"""
abstract type NAVM_Module end

"""
获取模块的「源类型」
"""
function source_type end
source_type(::NAVM_Module) = error("未实现的`source_type`方法！")

"""
获取模块的「目标类型」
"""
function target_type end
target_type(::NAVM_Module) = error("未实现的`target_type`方法！")

"""
(抽象)转换函数
"""
function transform end
transform(::NAVM_Module, ::Any) = error("未实现的`transform`方法！")

"""
针对「源序列」的转换
- 按序列执行转换，并过滤掉其中的nothing(失败值)
"""
function transform(m::NAVM_Module, args::Vector)
    local sT::Type, tT::Type = source_type(m), target_type(m)
    local result::Vector{tT} = tT[]
    local target::Vector{tT} # 有可能一对多

    for arg::sT in args
        push!(result, transform(m, arg)...)
    end

    return result
end

"""
尝试转换函数
类似tryparse
- 使用`try-catch`避免执行出错
- 出错⇒静默返回空数组
"""
function try_transform(m::NAVM_Module, arg::Any)
    try
        return transform(m, arg)::Vector{target_type(m)}
    catch e
        @debug e Base.showerror(stdout, e) Base.show_backtrace(stdout, Base.catch_backtrace())
        return target_type(m)[]
    end
end

"""
针对「源序列」的尝试转换
"""
function try_transform(m::NAVM_Module, args::Vector)
    local sT::Type, tT::Type = source_type(m), target_type(m)
    local result::Vector{tT} = tT[]
    local target::Union{Vector{tT}, Nothing} # 有可能一对多

    for arg::sT in args
        r = try_transform(m, arg)
        isnothing(r) || push!(result, r...)
    end

    return result
end

"""
函数调用⇒转换
"""
(m::NAVM_Module)(source) = transform(m, source) # 类型断言在`transform`实现
