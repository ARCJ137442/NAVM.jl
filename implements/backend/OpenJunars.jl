# # 导入OpenJunars
# (@isdefined Junars) || begin
#     push!(LOAD_PATH, "../../../OpenJunars/")
#     using Junars
# end

# @show names(Junars)

"实现一个后端"
struct BE_OpenJunars <: BackendModule end

"目标类型：字符串"
target_type(::BE_OpenJunars) = String

"实现OpenJunars的Narsese输入"
transform(::BE_OpenJunars, head::Val{:NSE}, narsese::AbstractString) = @show narsese

"实现OpenJunars的推理步进指令"
transform(::BE_OpenJunars, head::Val{:CYC}, n::Integer) = ":c $n"

"实现OpenJunars的信息打印"
transform(::BE_OpenJunars, head::Val{:INF}, ::Vararg) = ":p"

# 测试
beo = BE_OpenJunars()

@show beo.([
    Expr(:NSE, "<A --> B>.")
    Expr(:NSE, "<B --> C>.")
    Expr(:CYC, 5)
])
