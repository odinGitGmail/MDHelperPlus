local addonName, mdhelper = ...
local mcore = mdhelper.Core
local mspells = mdhelper.Spells

--[[
减伤提醒相关事件
]] --

----------------------------------------------------------------------------------------------------------------------
---创建事件框架
local eventFrameAvoidance = CreateFrame("Frame")
-- 注册进入战斗和脱离战斗事件
eventFrameAvoidance:RegisterEvent("PLAYER_REGEN_DISABLED")
eventFrameAvoidance:RegisterEvent("PLAYER_REGEN_ENABLED")
-- eventFrameAvoidance:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")


----------------------------------------------------------------------------------------------------------------------
---创建一个子框架，用于监听战斗日志事件
local combatLogFrame = CreateFrame("Frame")
combatLogFrame:Hide() -- 默认隐藏，避免不必要的监听
combatLogFrame:SetScript("OnEvent", function(self, event, ...)
    if mdhelperDB.mdhUser.avoidance then
        local timestamp, subevent, _, sourceGUID, sourceName, _, _, destGUID,
        destName, _, _, spellID, spellName, _, _, isInterruptible =
            CombatLogGetCurrentEventInfo()
        -- 如果法术在需要减伤提醒的法术列表中
        if mcore.containsElement(mdhelper.avoidanceSpellArray, spellID) then
            -- 监控战斗相关逻辑
            mspells.HandleCombatLogEvent(subevent, sourceGUID, sourceName,
                destGUID, destName, spellID, spellName,
                isInterruptible)
        end
    end
end)


----------------------------------------------------------------------------------------------------------------------
---创建一个子框架，用于监听进入战斗和脱离战斗事件
eventFrameAvoidance:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_REGEN_DISABLED" then
        -- 进入战斗，开始监控 COMBAT_LOG_EVENT_UNFILTERED
        combatLogFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        combatLogFrame:Show()
    elseif event == "PLAYER_REGEN_ENABLED" then
        -- 脱离战斗，停止监控 COMBAT_LOG_EVENT_UNFILTERED
        combatLogFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        combatLogFrame:Hide()
    end
end)
