local addonName,mdhelper = ...

local mcore = mdhelper.Core
local mspells = mdhelper.Spells
local muc = mdhelper.UI.components
local mucf = mdhelper.UI.components.Func
local muf = mdhelper.UI.Func



function mspells.HandleCombatLogEvent(subevent, sourceGUID, sourceName, destGUID, destName, spellID, spellName, isInterruptible)
    if subevent == "SPELL_CAST_START" and UnitGUID("player") == destGUID then
        -- 怪物开始施放技能
        muf.speekText("开减伤")
    end
end