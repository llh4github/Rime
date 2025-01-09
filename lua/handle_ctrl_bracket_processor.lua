-- 处理vim回普通模式的快捷键
-- vim 回普通模式时 切为英文状态，会清空rime的输入内容
-- 只处理了 ctrl [  组合键
local handle_ctrl_bracket_processor = {}

function handle_ctrl_bracket_processor.init(env)
    -- 初始化代码
    print("处理器初始化")
end

function handle_ctrl_bracket_processor.func(key, env)
    local ctx = env.engine.context
    local is_ascii_mode = ctx:get_option("ascii_mode")
    if (key:repr() == "Control+bracketleft" and (not is_ascii_mode)) then
        ctx:set_option("ascii_mode", true)
        -- 清空输入内容
        env.engine:commit_text()
        return 1 -- 表示已处理
    end
    return 2     -- 表示未处理
end

return handle_ctrl_bracket_processor
