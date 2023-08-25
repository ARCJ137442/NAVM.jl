#=
实现NARS-Python的输入格式
- 最大特点：其陈述只使用圆括号
=#

# 导出
export BE_NARS_Python

"实现一个后端"
struct BE_NARS_Python <: BE_CommonCIN end

begin "NARS库"
    
    """
    新建一个NARS-Python字串解析器
    - 深拷贝原有解析器，并修改其内容
        - 不会影响原解析器
    """
    const StringParser_python::JuNarsese.Conversion.StringParser = deepcopy(JuNarsese.StringParser_ascii)
    # 修改属性
    StringParser_python.compound_brackets[Statement] = ("(", ")")
    # 修改自动生成的其它项
    empty!(StringParser_python.brackets_compound)
    push!(StringParser_python.brackets_compound, reverse.(collect(StringParser_python.compound_brackets))...) # 翻转字典
    empty!(StringParser_python.bracket_openers)
    push!(StringParser_python.bracket_openers, (left for (left,_) in values(StringParser_python.compound_brackets))...)
    empty!(StringParser_python.bracket_closures)
    push!(StringParser_python.bracket_closures, (right for (_,right) in values(StringParser_python.compound_brackets))...)

end

begin "方法实现"

    "实现NARS-Python的Narsese输入"
    @nair_rule NSE(::BE_NARS_Python, narsese::TNarsese) narsese2data(StringParser_python, narsese)

    "实现NARS-Python的推理步进指令" # 📌注：NARS-Python中没有「强制推理器步进」的入口
    @nair_rule CYC(::BE_NARS_Python, n::Integer) []

    # 参考自`InputChannel.py`
    "实现NARS-Python的信息打印"
    @nair_rule INF(::BE_NARS_Python, flag::AbstractString) begin
        f::String = lowercase(flag)
        if f == "cycle"
            return String["cycle"]
        elseif startswith("memory", f)  || startswith("count", f)
            return String["count"]
        end
    end

    "实现NARS-Python的记忆存储" # 不一定有「存储路径」
    @nair_rule SAV(::BE_NARS_Python, name::AbstractString, path::AbstractString="") begin
        # 暂时不使用参数
        return String["save"]
    end

    "实现NARS-Python的记忆读取" # 不一定有「存储路径」
    @nair_rule LOA(::BE_NARS_Python, name::AbstractString, path::AbstractString="") begin
        # 暂时不使用参数
        name == "input" || return String["load_input"]
        return String["load"]
    end

end
