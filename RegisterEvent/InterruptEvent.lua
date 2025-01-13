local addonName,mdhelper = ...
local mcore = mdhelper.Core
local mspells = mdhelper.Spells
local muc = mdhelper.UI.components
local mucf = mdhelper.UI.components.Func
local muf = mdhelper.UI.Func
local mucfp = mdhelper.UI.components.Func.Progress




----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------




-- 创建事件框架
local eventFrameInterrupt = CreateFrame("Frame")
eventFrameInterrupt:RegisterEvent("UNIT_SPELLCAST_START")
eventFrameInterrupt:RegisterEvent("UNIT_SPELLCAST_STOP")
eventFrameInterrupt:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
eventFrameInterrupt:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
eventFrameInterrupt:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")



-- 事件处理函数
eventFrameInterrupt:SetScript("OnEvent", function(self, event, unit)
    if mdhelperDB.mdhUser.interrupt then
        if unit ~= "focus" then return end  -- 只处理焦点目标的事件
        local interruptProgressbar = muc.interruptProgressbar
        local timerTexts = muc.interruptProgressbarTimerTexts
        local icons = muc.interruptProgressbarIconFrams

        if event == "UNIT_SPELLCAST_START" then
            local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible, spellID = UnitCastingInfo("focus")
            -- 检测到法术 且 在打断法术列表中 且 法术可以打断
            if name and mcore.containsElement(mdhelper.interruptSpellArray,spellID) and notInterruptible==false then
                -- 如果可以检测到打断法术
                if  mdhelperDB.playerInfo.interruptSpellID~="" then
                    -- 打断法术不在冷却中
                    if mspells.CheckSpellCooldown(mdhelperDB.playerInfo.interruptSpellID) then
                        mucfp.StartCastingProgress(interruptProgressbar, timerTexts[1], timerTexts[2],icons[1]) -- 开始施法时启动更新
                    end
                else
                    mucfp.StartCastingProgress(interruptProgressbar, timerTexts[1], timerTexts[2],icons[1]) -- 开始施法时启动更新
                end
            end
        elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
            local name, text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellID = UnitChannelInfo("focus")
            -- 检测到法术 且 在打断法术列表中 且 法术可以打断
            if name and mcore.containsElement(mdhelper.interruptSpellArray,spellID) and notInterruptible==false then
                -- 如果可以检测到打断法术
                if  mdhelperDB.playerInfo.interruptSpellID~="" then
                    if mspells.CheckSpellCooldown(mdhelperDB.playerInfo.interruptSpellID) then
                        -- 打断法术不在冷却中
                        mucfp.StartCastingProgress(interruptProgressbar, timerTexts[1], timerTexts[2],icons[1]) -- 开始施法时启动更新
                    end
                else
                    mucfp.StartCastingProgress(interruptProgressbar, timerTexts[1], timerTexts[2],icons[1]) -- 开始施法时启动更新
                end
            end
        elseif event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_CHANNEL_STOP" or event == "UNIT_SPELLCAST_INTERRUPTED" then

            -- 施法结束、失败或被打断时停止更新
            mucfp.HideProgress(interruptProgressbar, timerTexts[1], timerTexts[2],icons[1]);
        end
    end
end)