# 导出
export NAIR_INSTRUCTION_SET, NAIR_INSTRUCTIONS, NAIR_INSTRUCTION_INF_KEYS

"""
# NAIR的基础指令集
- 用于前端将数据翻译成对象
- 也用于将其翻译成后端代码


## 基础指令集架构

### 分类

1. 数据存取
2. IO
3. CIN控制
4. 其它

### 数据存取

- `SAV` 保存
- `LOA` 加载

### IO

- `NSE` 输入Narsese语句

### CIN控制

- `NEW` 创建新推理器
- `CYC` 控制CIN步进
- `VOL` 控制CIN输出的「音量」（OpenNARS/ONA）
- `DEL` 删除(停止)推理器

### 其它

- `HLP` 显示帮助文档
- `REM` 注释

## 数据集存储语法

```
:指令名 => Dict(
    :params => (参数列表...),
    :help_inf => "帮助文档",
)
```

"""
const NAIR_INSTRUCTION_SET::Dict{Symbol,Dict} = Dict([
    #= 数据存取 =#
    :SAV => Dict(
        :params   => [:identifier, :file_path],
        :help_inf => """
            保存当前数据（记忆）到文件
            """, # 这里的「行首」对齐末尾三引号左侧，在此例中将解析出没有行首空白符的文本
        :fold_f   => (head::Symbol, str::AbstractString, name::AbstractString, path::AbstractString) -> begin
            form_cmd(head, name, path)
        end,
        :check_f  => (::AbstractString, path="") -> true,
    )
    :LOA => Dict(
        :params   => [:identifier, :file_path],
        :help_inf => """
            从文件加载数据（记忆）
            """,
        :fold_f   => (head::Symbol, str::AbstractString, name::AbstractString, path::AbstractString) -> begin
            form_cmd(head, name, path)
        end,
        :check_f  => (::AbstractString, path="") -> true,
    )
    :RES => Dict(
        :params   => [:identifier],
        :help_inf => """
            清除CIN数据（记忆）
            """,
        :fold_f   => (head::Symbol, str::AbstractString, name::AbstractString) -> begin
            form_cmd(head, name)
        end,
        :check_f  => (::AbstractString, name="") -> true,
    )
    #= IO =#
    :NSE => Dict(
        :params   => [:raw_line], # 剩下的内容都给CommonNarsese解析器解析
        :help_inf => """
            输入「CommonNarsese」语句
            - 不换行
            - 遵循CommonNarsese语法
            """,
        :fold_f   => (head::Symbol, str::AbstractString, narsese) -> begin
            form_cmd(
                head, 
                JuNarsese.StringParser_ascii( # 自动解析成词项
                    string(narsese)
                )
            )
        end,
        :check_f  => (narsese::Union{ATerm,ASentence,ATask}) -> true,
    )
    #= CIN控制 =#
    :NEW => Dict(
        :params   => [],
        :help_inf => """
            创建新推理器
            """,
        :fold_f   => (head::Symbol, str::AbstractString, arg...) -> begin
            @info "$head: WIP!" arg
        end,
        :check_f  => (arg...) -> (@show "WIP!" true),
    )
    :DEL => Dict(
        :params   => [],
        :help_inf => """
            删除(停止)推理器
            """,
        :fold_f   => (head::Symbol, str::AbstractString, arg...) -> begin
            @info "$head: WIP!" arg
        end,
        :check_f  => (arg...) -> (@show "WIP!" true),
    )
    :CYC => Dict(
        :params   => [:uint],
        :help_inf => """
            控制CIN步进
            """,
        :fold_f   => (head::Symbol, str::AbstractString, cycles::Integer) -> begin
            form_cmd(
                head,
                cycles,
            )
        end,
        :check_f  => (::Integer) -> true,
    )
    :VOL => Dict(
        :params   => [:uint],
        :help_inf => """
            控制CIN输出音量
            """,
        :fold_f   => (head::Symbol, str::AbstractString, vol::Integer) -> begin
            form_cmd(
                head,
                vol
            )
        end,
        :check_f  => (::Integer) -> true,
    )
    :INF => Dict(
        :params   => [:identifier],
        :help_inf => """
            让CIN输出某类信息
            """,
        :fold_f   => (head::Symbol, str::AbstractString, flag) -> begin
            form_cmd(
                head,
                flag
            )
        end,
        :check_f  => (arg...) -> true,
    )
    #= 其它 =#
    :HLP => Dict(
        :params   => [:identifier],
        :help_inf => """
            打印帮助文档
            """,
        :fold_f   => (head::Symbol, str::AbstractString, arg...) -> begin
            @info "$head: WIP!" arg
        end,
        :check_f  => (arg...) -> (@show :HLP true),
    )
    :REM => Dict(
        :params   => [:raw_line],
        :help_inf => """
            内容仅作为注释，永不执行
            """,
        :fold_f   => (head::Symbol, str::AbstractString, arg...) -> nothing, # 不解析
        :check_f  => (arg...) -> true,
    )
])

"""
上述指令集中的所有指令KeySet
- 会随着指令集的更新而更新
"""
NAIR_INSTRUCTIONS::Base.KeySet = keys(NAIR_INSTRUCTION_SET)

"""
上述指令集中「信息字典」的所有键
- 要求的参数集
- 帮助文档
"""
const NAIR_INSTRUCTION_INF_KEYS::Vector{Symbol} = Symbol[
    :help_inf   # 帮助文档
    :params     # 字串解析参数集
    :fold_f     # 字串解析处理函数
    :check_f    # 创建后的检查函数
]
