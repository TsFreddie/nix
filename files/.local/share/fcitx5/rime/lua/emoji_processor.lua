local function startswith(str, start)
    return string.sub(str, 1, string.len(start)) == start
end

local function endswith(str, ending)
    return ending == "" or str:sub(-#ending) == ending
end

local function init(env)
    local context = env.engine.context
    env.was_auto_commit = context:get_option("_auto_commit")
    env.prompt = "〔❤〕 "
    env.prompt_len = #env.prompt
    env.trigger = "🆗"
end

local function enter_emoji_mode(env)
    local context = env.engine.context
    env.was_auto_commit = context:get_option("_auto_commit")
    env.engine.context:set_option("_auto_commit", false)
    context:push_input(env.prompt)
    local composition = context.composition
    local prompt_segment = Segment(0, env.prompt_len)
    prompt_segment.status = "kSelected"
    composition:push_back(prompt_segment)
end

local function exit_emoji_mode(env)
    local context = env.engine.context
    env.engine.context:set_option("_auto_commit", env.was_auto_commit)
    context:clear()
end

local function confirm_emoji(env)
    local context = env.engine.context
    local candidate = context:get_selected_candidate()
    local emoji = nil
    if candidate then
        emoji = candidate.text
    end
    exit_emoji_mode(env)
    if emoji then
        env.engine:commit_text(emoji)
    end
end

local function trigger_emoji(env)
    local context = env.engine.context
    context:confirm_current_selection()
    context:push_input(env.trigger)
end

local function untrigger_emoji(env)
    local context = env.engine.context
    context:pop_input(#env.trigger)
end

local function processor(key_event, env)
    local config = env.engine.schema.config
    local context = env.engine.context

    local is_emoji_mode = startswith(context.input, env.prompt)
    local is_triggered = endswith(context.input, env.trigger)

    -- Skip modified or release
    if not is_emoji_mode and (key_event:release() or key_event:ctrl() or key_event:alt() or key_event:super() or key_event:caps() or key_event:shift()) then
        return 2
    end

    -- Check F24
    -- Reference http://svn.python.org/projects/external/tk-8.4.18.x/generic/ks_names.h
    if key_event.keycode == 0xFFD5 then
        if context:is_composing() then
            return 2
        end
        -- Push emoji mode
        enter_emoji_mode(env)
        return 1
    end

    if is_emoji_mode then
        if key_event.keycode > 0x20 and key_event.keycode < 0x7f then
            -- char handler
            if is_triggered then untrigger_emoji(env) end
            return 2
        end

        if not key_event:release() then
            if key_event.keycode == 0xFF08 then
                if is_triggered then untrigger_emoji(env) end

                -- Backspace
                if context.input == env.prompt or context.caret_pos < env.prompt_len then
                    exit_emoji_mode(env)
                else
                    return 2
                end
            elseif key_event.keycode == 0xFFFF then
                if is_triggered then untrigger_emoji(env) end

                -- Delete
                if context.caret_pos < env.prompt_len then
                    exit_emoji_mode(env)
                else
                    return 2
                end
            elseif key_event.keycode == 0x20 then
                -- Space
                if is_triggered then
                    confirm_emoji(env)
                else
                    trigger_emoji(env)
                end
            elseif key_event.keycode == 0xFF1B then
                -- Esc
                exit_emoji_mode(env)
            elseif key_event.keycode == 0xFF0D then
                -- Enter/Return
                confirm_emoji(env)
            end
        end
        
        return 1
    end

    return 2
end

return { init = init, func = processor }