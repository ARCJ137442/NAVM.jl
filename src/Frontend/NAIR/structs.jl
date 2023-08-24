#=
NAIR的数据结构
=#

# 导出
export NAIR_CMD_TYPE
export form_cmd, load_cmds, get_head, get_args

"""
直接使用「表达式(Julia的Expr)数组」实现NAIR语句（串）
- Expr.head: 指令标识符
- Expr.args: 指令参数
"""
const NAIR_CMD_TYPE::DataType = Expr

"""
通过「表达式头+参数集」的形式，提供指令组装API
- 此处的`head`应为指令集中的一个有效指令
"""
function form_cmd(head::Symbol, params...)::NAIR_CMD_TYPE
    # 检查
    if head in NAIR_INSTRUCTIONS
        NAIR_INSTRUCTION_SET[head][:check_f](params...) || error("$head: 参数集「$params」非法！")
    end
    # 构建
    Expr(head, params...)
end

"""
通过一个单一的、可空的「参数数组」抽取指令对象
- 忽略其中的空值
- 首个非空参数被视作指令头
"""
function form_cmd(args::Vector)::NAIR_CMD_TYPE
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
组装多个命令：迭代器形式
"""
load_cmds(cmd_iter::Union{Vector,Tuple,Base.Generator})::Vector{NAIR_CMD_TYPE} = collect(cmd_iter)

"扩充：多参数形式"
load_cmds(cmds::Vararg{NAIR_CMD_TYPE})::Vector{NAIR_CMD_TYPE} = load_cmds(cmds)

"""
指令头：表达式⇒表达式头
"""
get_head(expr::NAIR_CMD_TYPE)::Symbol = expr.head

"""
参数集：表达式⇒表达式参数
"""
get_args(expr::NAIR_CMD_TYPE)::Vector{Any} = expr.args

"""
检测单个NAIR命令是否合法
- 指令头是否在指令集内
"""
verify_cmd(cmd::NAIR_CMD_TYPE)::Bool = get_head(cmd) in NAIR_INSTRUCTION_SET

"扩充：迭代器形式"
verify_cmd(iter::Union{Vector,Tuple,Base.Generator})::Bool = all(verify_cmd, iter)

"扩充：多参数形式"
verify_cmd(cmds::Vararg{NAIR_CMD_TYPE})::Bool = verify_cmd(cmds)
