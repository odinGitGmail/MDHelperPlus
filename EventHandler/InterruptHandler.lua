local addonName, mdhelper = ...
local mah = mdhelper.AddonsHelper
mdhelper.UI.components.Func.Progress = {}
local mucfp = mdhelper.UI.components.Func.Progress

----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------

-- 定义更新函数
local startTime, endTime, ticker
local currentProgress = 0

-- 施法进度条更新
function mucfp.UpdateCastingProgress(interruptProgressbar, progressText,
                                     timerText, icon)
    local name, text, texture, startTime, endTime, isTradeSkill, castID,
    notInterruptible, spellID = UnitCastingInfo("focus")
    if name and startTime and endTime then
        -- 转换时间单位
        startTime = startTime / 1000             -- 转换为秒
        endTime = endTime / 1000                 -- 转换为秒
        local duration = endTime - startTime     -- 总持续时间
        local elapsed = GetTime() - startTime    -- 已经经过的时间
        local remainingTime = duration - elapsed -- 剩余时间

        -- 更新进度条
        local percentage = (elapsed / duration) * 100
        currentProgress = math.min(math.max(percentage, 0), 100)
        interruptProgressbar:SetValue(currentProgress)

        -- 更新倒计时文字
        progressText:SetText(name)
        timerText:SetText(string.format("%.1fs", remainingTime)) -- 格式化为倒计时

        -- 更新图标
        local spellTexture = C_Spell.GetSpellTexture(spellID)
        if spellTexture ~= nil then
            icon.iconTexture:SetTexture(spellTexture) -- 设置法术图标纹理
        end

        -- 如果倒计时结束，停止更新
        if remainingTime <= 0 then
            if ticker then
                ticker:Cancel()
                ticker = nil
            end
            interruptProgressbar:SetValue(0)
            timerText:SetText("0.0s")
        end
    else
        -- 施法结束时隐藏进度条
        if ticker then
            ticker:Cancel()
            ticker = nil
        end
        interruptProgressbar:SetValue(0)
        timerText:SetText("0.0s")
    end
end

-- 引导施法进度条更新
function mucfp.UpdateChannelProgress(interruptProgressbar, progressText,
                                     timerText, icon)
    local name, text, texture, startTime, endTime, isTradeSkill,
    notInterruptible, spellID = UnitChannelInfo("focus")
    if name and startTime and endTime then
        -- 转换时间单位
        startTime = startTime / 1000             -- 转换为秒
        endTime = endTime / 1000                 -- 转换为秒
        local duration = endTime - startTime     -- 总持续时间
        local elapsed = GetTime() - startTime    -- 已经经过的时间
        local remainingTime = duration - elapsed -- 剩余时间

        -- 更新进度条
        local percentage = (elapsed / duration) * 100
        currentProgress = math.min(math.max(percentage, 0), 100)
        interruptProgressbar:SetValue(currentProgress)

        -- 更新倒计时文字
        progressText:SetText(name)
        timerText:SetText(string.format("%.1fs", remainingTime)) -- 格式化为倒计时

        -- 更新图标
        local spellTexture = C_Spell.GetSpellTexture(spellID)
        if spellTexture ~= nil then
            icon.iconTexture:SetTexture(spellTexture) -- 设置法术图标纹理
        end

        -- 如果倒计时结束，停止更新
        if remainingTime <= 0 then
            if ticker then
                ticker:Cancel()
                ticker = nil
            end
            interruptProgressbar:SetValue(0)
            timerText:SetText("0.0s")
        end
    else
        -- 施法结束时隐藏进度条
        if ticker then
            ticker:Cancel()
            ticker = nil
        end
        interruptProgressbar:SetValue(0)
        timerText:SetText("0.0s")
    end
end

-- 开始监控施法进度条
function mucfp.StartCastingProgress(interruptProgressbar, progressText,
                                    timerText, icon)
    if not ticker then
        currentProgress = 0
        interruptProgressbar:Show()
        mah.speekText("快打断")
        ticker = C_Timer.NewTicker(0.01, function()
            mucfp.UpdateCastingProgress(interruptProgressbar, progressText,
                timerText, icon)
        end) -- 每 0.1 秒调用更新函数
    end
end

-- 开始监控引导进度条
function mucfp.StartChannelProgress(interruptProgressbar, progressText,
                                    timerText, icon)
    if not ticker then
        currentProgress = 0
        interruptProgressbar:Show()
        mah.speekText("快打断")
        ticker = C_Timer.NewTicker(0.01, function()
            mucfp.UpdateChannelProgress(interruptProgressbar, progressText,
                timerText, icon)
        end) -- 每 0.1 秒调用更新函数
    end
end

-- 结束监控并隐藏打断进度条
function mucfp.HideProgress(interruptProgressbar, progressText, timerText, icon)
    if ticker then
        ticker:Cancel()
        ticker = nil
    end

    -- interruptProgressbar = nil
    -- progressText = nil
    -- timerText = nil
    -- icon = nil

    interruptProgressbar:Hide()
end
