#=
NAIR数据结构的方法
=#

export form_cmd, try_form_cmd, load_cmds

"""
通过「表达式头+参数集」的形式，提供指令组装API
- 此处的`head`应为指令集中的一个有效指令
"""
function form_cmd(head::Symbol, params...)::NAIR_CMD
    # 确保在指令集内
    head in NAIR_INSTRUCTIONS || throw(ArgumentError("指令头「$head」不在指令集中。完整的指令集：$(collect(NAIR_INSTRUCTIONS))"))
    # 直接构建
    NAIR_INSTRUCTION_SET[head][:type](params...)
end

"""
通过一个单一的、可空的「参数数组」抽取指令对象
- 忽略其中的空值
- 首个非空参数被视作指令头
"""
function form_cmd(args::Vector)::NAIR_CMD
    # 过滤
    params::Vector = filter(!isnothing, args)
    # 取头
    head::Symbol = popfirst!(params)
    # 构建
    form_cmd(
        head,
        params...
    )
end

"""
尝试解析，不行的话返回空值
"""
function try_form_cmd(params...)::Union{NAIR_CMD,Nothing}
    try
        return form_cmd(params...)
    catch
        return nothing
    end
end

"""
组装多个命令：迭代器形式
- 返回：数组
"""
load_cmds(cmd_iter::Union{Vector,Tuple,Base.Generator})::Vector{NAIR_CMD} = collect(cmd_iter)

"扩充：多参数形式"
load_cmds(cmds::Vararg{NAIR_CMD})::Vector{NAIR_CMD} = load_cmds(cmds)

# 【20230903 22:19:16】暂不再是「一个指令对应一个参数集」
"""
指令头：默认是其类名的最后三个字符
- 协议：类名最后三个字符与指令头相同
"""
get_head(cmd::NAIR_CMD)::Symbol = Symbol(string(typeof(cmd).name.name)[end-2:end])
