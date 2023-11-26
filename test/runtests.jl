begin
    "模块导入"
    # JuNarsese(Parsers)
    push!(LOAD_PATH, "../JuNarsese")
    push!(LOAD_PATH, "../JuNarseseParsers")

    # 导入NAVM
    if !(@isdefined NAVM)
        push!(LOAD_PATH, "../NAVM")
        using NAVM
        import NAVM: source_type, target_type, transform # 添加方法
        @info "NAVM导入成功！" names(NAVM)
    end

    using JuNarseseParsers
    using JuNarsese

end

# 启用@debug
ENV["JULIA_DEBUG"] = "all"

# 测试
@show parse_cmd("CYC    1")
@show parse_cmd("SAV NARS-1 test/nars1.nal")
@show parse_cmd("NSE <A --> B>.")
@assert tryparse_cmd("NSE NARS-1 test/nars1.nal") |> isnothing
@show tryparse_cmd("CYC This cmd may causes an error or be parsed to nothing.")
@assert string(parse_cmd("CYC    1")) === "CYC 1"
@assert string(parse_cmd("VOL 	  100")) === "VOL 100"
@assert string(parse_cmd("REM	这是一条注释。")) === "REM 这是一条注释。"
@assert string(parse_cmd("REG	操作名")) === "REG 操作名"
@assert startswith(
	@show(string(parse_cmd("NSE	(  	&&,<(&,矩形	,菱形	)		 -->	 正方形	>,<(|,	矩形	,菱形	)	 -->	 平行四边形	>	)."))), 
	"NSE (&&, <(" # * 后续外延交/内涵交的顺序可能不同
)
# @show parse_cmd("CUS This is my custom cmd.") # 【20230903 22:17:00】现在不再默许指令集之外的「自定义指令」

# 测试前后端实现
@info "开始测试前后端实现..."
include("../implements/test_implements.jl")
