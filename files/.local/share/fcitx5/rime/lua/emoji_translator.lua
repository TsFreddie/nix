local function translator(input, seg, env)
    if input == "🆗" then
        yield(Candidate("emoji", seg.start, seg._end, "😁", "大笑"))
    end
end

local function init(env)
end

return { init = init, func = translator }