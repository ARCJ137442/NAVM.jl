#= NAVM.jl 指令的数据结构定义
- 定义一系列内置的常用数据结构
=#

export CMD_SAV, CMD_LOA, CMD_RES, 
       CMD_NSE, 
       CMD_NEW, CMD_DEL, 
       CMD_CYC, CMD_VOL, CMD_INF, 
       CMD_HLP, CMD_REM
export NAIR_INSTRUCTION_SET

#= 数据存取 =#

"""
    CMD_SAV <: NAIR_CMD
指令：保存当前数据（记忆）到文件
"""
struct CMD_SAV <: NAIR_CMD
    target::String
    path::String
end

@reg_cmd SAV identifier file_path
form_cmd(::Val{:SAV}, ::AbstractString, target::AbstractString, path::AbstractString) = CMD_SAV(
    String(target), String(path)
)

"""
    CMD_LOA <: NAIR_CMD
指令：从文件加载数据（记忆）
"""
struct CMD_LOA <: NAIR_CMD
    target::String
    path::String
end

@reg_cmd LOA identifier file_path
form_cmd(::Val{:LOA}, ::AbstractString, target::AbstractString, path::AbstractString) = CMD_LOA(
    String(target), String(path)
)

"""
    CMD_RES <: NAIR_CMD
指令：清除CIN数据
- 如：记忆区、缓冲区……
"""
struct CMD_RES <: NAIR_CMD
    target::String
end

@reg_cmd RES identifier
form_cmd(::Val{:RES}, ::AbstractString, target::AbstractString) = CMD_RES(target)


#= IO =#

"""
    CMD_NSE <: NAIR_CMD
指令：输入「CommonNarsese」语句
- 不换行
- 遵循CommonNarsese语法
"""
struct CMD_NSE <: NAIR_CMD
    narsese::NarseseObject
end

@reg_cmd NSE raw_line # 剩下的内容都给CommonNarsese解析器解析
form_cmd(::Val{:NSE}, ::AbstractString, narsese_str::AbstractString) = CMD_NSE(
    JuNarsese.StringParser_ascii( # 自动解析成词项
        string(narsese)
    )
)


#= CIN控制 =#

"""
    CMD_NEW <: NAIR_CMD
指令：创建新推理器
"""
struct CMD_NEW <: NAIR_CMD
    name::String
end

@reg_cmd NEW
form_cmd(::Val{:NEW}, str::AbstractString, name::AbstractString) = CMD_NEW(String(name))

"""
    CMD_DEL <: NAIR_CMD
指令：删除(停止)推理器
"""
struct CMD_DEL <: NAIR_CMD
    name::String
end

@reg_cmd DEL
form_cmd(::Val{:DEL}, str::AbstractString, name::AbstractString) = CMD_DEL(String(name))

"""
    CMD_CYC <: NAIR_CMD
指令：控制CIN步进
"""
struct CMD_CYC <: NAIR_CMD
    cycles::Int # * 不设置成 `UInt` 是为了避免「1-2 = 0xffffffffffffffff」这样的疏漏
end

@reg_cmd CYC uint
form_cmd(::Val{:CYC}, str::AbstractString, cycles::Integer) = CMD_CYC(Int(cycles))

"""
    CMD_VOL <: NAIR_CMD
指令：控制CIN输出音量
"""
struct CMD_VOL <: NAIR_CMD
    volume::Int # * 不设置成 `UInt` 理由同上
end

@reg_cmd VOL uint
form_cmd(::Val{:VOL}, str::AbstractString, volume::Integer) = CMD_VOL(Int(volume))


#= 其它 =#

"""
    CMD_INF <: NAIR_CMD
指令：让CIN输出某类信息
"""
struct CMD_INF <: NAIR_CMD
    flag::String
end

@reg_cmd INF identifier
form_cmd(::Val{:INF}, str::AbstractString, flag::AbstractString) = CMD_INF(String(flag))

"""
    CMD_HLP <: NAIR_CMD
指令：打印（CIN的）帮助文档
"""
struct CMD_HLP <: NAIR_CMD
    flag::String
end

@reg_cmd HLP identifier
form_cmd(::Val{:HLP}, str::AbstractString, flag::AbstractString) = CMD_HLP(String(flag))

"""
    CMD_REM <: NAIR_CMD
指令：注释
- 📌仅存储内容，后续通常翻译为空字串
"""
struct CMD_REM <: NAIR_CMD
    content::String
end

@reg_cmd REM raw_line
form_cmd(::Val{:REM}, str::AbstractString, comment::AbstractString) = CMD_REM(String(content))

#= 所有内置指令 =#

"""
指令集：所有的内置指令
"""
const NAIR_INSTRUCTION_SET::Vector{Type} = [
    CMD_SAV, CMD_LOA, CMD_RES, 
    CMD_NSE, 
    CMD_NEW, CMD_DEL, 
    CMD_CYC, CMD_VOL, CMD_INF, 
    CMD_HLP, CMD_REM
]
