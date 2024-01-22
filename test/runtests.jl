# %% Jupyter Notebook | Julia 1.10.0 @ julia | format 2~4
# % language_info: {"file_extension":".jl","mimetype":"application/julia","name":"julia","version":"1.10.0"}
# % kernelspec: {"name":"julia-1.10","display_name":"Julia 1.10.0","language":"julia"}
# % nbformat: 4
# % nbformat_minor: 2

# %% [1] markdown
# # NAVM.jl 测试

# %% [2] markdown
# ✨Powered by [**IpynbCompile.jl**](https://github.com/ARCJ137442/IpynbCompile.jl)

# %% [3] markdown
# ## 模块导入

# %% [4] markdown
# 模块清单：
# 
# - JuNarsese
# - NAVM
# - Test

# %% [5] code
include("#import.jl")

# %% [6] markdown
# ## 测试 / 指令集

# %% [7] markdown
# ### 正常解析

# %% [8] markdown
# SAV

# %% [9] code
let cmd::CMD_SAV = parse_cmd("SAV NARS-1 test/nars1.nal"),
    # 有空格路径 可以
    cmd_allowed = tryparse_cmd("SAV NARS-1 C:\\Program Files\\NARS\\data.nal")
    @test cmd.target == "NARS-1"
    @test cmd.path == "test/nars1.nal"
    @test cmd_allowed.target == "NARS-1"
    @test cmd_allowed.path == raw"C:\Program Files\NARS\data.nal"
end

# %% [10] markdown
# LOA

# %% [11] code
let cmd::CMD_LOA = parse_cmd("LOA NARS-1 test/nars1.nal"),
    # 有空格路径 可以
    cmd_allowed = tryparse_cmd("LOA NARS-1 C:\\Program Files\\NARS\\data.nal")
    @test cmd.target == "NARS-1"
    @test cmd.path == "test/nars1.nal"
    @test cmd_allowed.target == "NARS-1"
    @test cmd_allowed.path == raw"C:\Program Files\NARS\data.nal"
end

# %% [12] markdown
# RES

# %% [13] code
let cmd::CMD_RES = parse_cmd("RES memory"),
    # 使用一个连续标识符 可以
    cmd_allowed::CMD_RES = parse_cmd("RES ^memory!"),
    # 有其它冗余参数 可以
    cmd_surplussed::CMD_RES = parse_cmd("RES memory test/nars1.nal")
    @test cmd.target isa String
    @test cmd.target == "memory"
    @test !isnothing(cmd_allowed)
    @test cmd_surplussed.target == "memory"
end

# %% [14] markdown
# NSE

# %% [15] code
let cmd::CMD_NSE = parse_cmd("NSE <A --> B>."),
    # 必须符合CommonNarsese语法
    cmd_allowed = tryparse_cmd("NSE A"),
    cmd_wrong = tryparse_cmd("NSE NARS-1 test/nars1.nal"),
    cmd_wrong2 = tryparse_cmd("NSE 1-1")
    @test cmd.narsese isa JuNarsese.Sentence
    @test !isnothing(cmd_allowed)
    @test isnothing(cmd_wrong)
    @test isnothing(cmd_wrong2)
end

# %% [16] markdown
# NEW

# %% [17] code
let cmd::CMD_NEW = parse_cmd("NEW reasoner-2"),
    # 多个空格可以
    cmd_allowed1 = tryparse_cmd("NEW    reasoner-?123"),
    # 附加尾缀可以
    cmd_allowed2 = tryparse_cmd("NEW 123123 ???"),
    # 用tab不行
    cmd_wrong1 = tryparse_cmd("NEW\treasoner"),
    # 用换行不行
    cmd_wrong2 = tryparse_cmd("NEW \n123123 ???")
    @test cmd.name == "reasoner-2"
    @test !isnothing(cmd_allowed1)
    @test !isnothing(cmd_allowed2)
    @test isnothing(cmd_wrong1)
    @test isnothing(cmd_wrong2)
end

# %% [18] markdown
# DEL

# %% [19] code
let cmd::CMD_DEL = parse_cmd("DEL reasoner-2"),
    # 多个空格可以
    cmd_allowed1 = tryparse_cmd("DEL    reasoner-?123"),
    # 附加尾缀可以
    cmd_allowed2 = tryparse_cmd("DEL 123123 ???"),
    # 用tab不行
    cmd_wrong1 = tryparse_cmd("DEL\treasoner"),
    # 用换行不行
    cmd_wrong2 = tryparse_cmd("DEL \n123123 ???")
    @test cmd.name == "reasoner-2"
    @test !isnothing(cmd_allowed1)
    @test !isnothing(cmd_allowed2)
    @test isnothing(cmd_wrong1)
    @test isnothing(cmd_wrong2)
end

# %% [20] markdown
# CYC

# %% [21] code
let cmd::CMD_CYC = parse_cmd("CYC 1"),
    # 多长度 可以
    cmd_allowed = parse_cmd("CYC    1"),
    # 零步长 可以
    cmd_allowed2 = parse_cmd("CYC 0"),
    # 字符串 不可以
    cmd_wrong = tryparse_cmd("CYC This cmd may causes an error."),
    # 浮点数 只取整数部分
    cmd_wrong2 = tryparse_cmd("CYC 1.123"),
    # 负数 不可以
    cmd_wrong3 = tryparse_cmd("CYC -1")
    @test cmd.cycles isa Integer
    @test cmd.cycles == 1
    @test isnothing(cmd_wrong)
    @test cmd_wrong2.cycles == 1
    @test isnothing(cmd_wrong3)
end

# %% [22] markdown
# VOL

# %% [23] code
let cmd::CMD_VOL = parse_cmd("VOL 1"),
    # 多长度 可以
    cmd_allowed = parse_cmd("VOL    1"),
    # 零大小 可以
    cmd_allowed2 = parse_cmd("VOL 0"),
    # 字符串 不可以
    cmd_wrong = tryparse_cmd("VOL This cmd may causes an error."),
    # 浮点数 只取整数部分
    cmd_wrong2 = tryparse_cmd("VOL 1.123"),
    # 负数 不可以
    cmd_wrong3 = tryparse_cmd("VOL -1")
    @test cmd.volume isa Integer
    @test cmd.volume == 1
    @test isnothing(cmd_wrong)
    @test cmd_wrong2.volume == 1
    @test isnothing(cmd_wrong3)
end

# %% [24] markdown
# INF

# %% [25] code
let cmd::CMD_INF = parse_cmd("INF buffer"),
    # 使用一个连续标识符 可以
    cmd_allowed::CMD_INF = parse_cmd("INF ^buffer!"),
    # 有其它冗余参数 可以
    cmd_surplussed::CMD_INF = parse_cmd("INF buffer test/nars1.nal")
    @test cmd.flag isa String
    @test cmd.flag == "buffer"
    @test !isnothing(cmd_allowed)
    @test cmd_surplussed.flag == "buffer"
end

# %% [26] markdown
# HLP

# %% [27] code
let cmd::CMD_HLP = parse_cmd("HLP NSE"),
    # 使用一个连续标识符 可以
    cmd_allowed::CMD_HLP = parse_cmd("HLP ^NSE!"),
    # 有其它冗余参数 可以
    cmd_surplussed::CMD_HLP = parse_cmd("HLP NSE test/nars1.nal")
    @test cmd.flag isa String
    @test cmd.flag == "NSE"
    @test !isnothing(cmd_allowed)
    @test cmd_surplussed.flag == "NSE"
end

# %% [28] markdown
# REM

# %% [29] code
let cmd::CMD_REM = parse_cmd("REM 这是一段注释"),
    # 其它特殊符号 可以
    cmd_allowed::CMD_REM = parse_cmd("REM ^这是一段注释!"),
    # 有空格 可以
    cmd_surplussed::CMD_REM = parse_cmd("REM 这是一段注释 这是冗余的部分")
    @test cmd.content isa String
    @test cmd.content == "这是一段注释"
    @test !isnothing(cmd_allowed)
    @test cmd_surplussed.content == "这是一段注释"
end

# %% [30] markdown
# ## 自定义指令 扩展支持

# %% [31] code
# 自定义指令
import NAVM.NAIR: form_cmd
struct CMD_CUS <: NAIR_CMD
    args
end
function form_cmd(::Val{:CUS}, args...)
    @info "自定义指令已捕获！" args
    CMD_CUS(args)
end
let cus = parse_cmd("CUS This is my custom cmd.")
    @test cus isa NAIR_CMD
    @test cus.args isa Tuple
end

# %% [32] markdown
# ## 尝试自编译


