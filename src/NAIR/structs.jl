#=
NAIR的数据结构
=#

# 导出
export NARSESE_TYPE
export NAIR_CMD
export CMD_SAV, CMD_LOA, CMD_RES, CMD_NSE, CMD_REG, CMD_NEW, CMD_DEL, CMD_CYC, CMD_VOL, CMD_INF, CMD_HLP, CMD_REM

"""
NAVM认为的Narsese类型
- 基于JuNarsese
"""
const NARSESE_TYPE::Type = Union{ATerm,ASentence,ATask}

"""
抽象的一个指令形式，表示为一个抽象类型，利用Julia对象优化机制，避免额外的资源浪费
"""
abstract type NAIR_CMD end

#= 数据存取 =#
struct CMD_SAV <: NAIR_CMD
    object::String
    to::String
end
struct CMD_LOA <: NAIR_CMD
    object::String
    to::String
end
struct CMD_RES <: NAIR_CMD
    object::String
end

#= IO =#
struct CMD_NSE <: NAIR_CMD
    narsese::NARSESE_TYPE
end

struct CMD_REG <: NAIR_CMD
    operator_name::String
end

#= CIN控制 =#
struct CMD_NEW <: NAIR_CMD end
struct CMD_DEL <: NAIR_CMD end
struct CMD_CYC <: NAIR_CMD
    steps::UInt
end
struct CMD_VOL <: NAIR_CMD
    volume::UInt
end
struct CMD_INF <: NAIR_CMD
    object::String
end

#= 其它 =#
struct CMD_HLP <: NAIR_CMD
    object::String
end
struct CMD_REM <: NAIR_CMD
    comment::String
end
