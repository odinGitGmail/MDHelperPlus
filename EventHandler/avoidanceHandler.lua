local addonName, mdhelper = ...
local mah = mdhelper.AddonsHelper
local mspells = mdhelper.Spells



function mspells.HandleCombatLogEvent(subevent, sourceGUID, sourceName, destGUID, destName, spellID, spellName,
                                      isInterruptible)
    if subevent == "SPELL_CAST_START" and UnitGUID("player") == destGUID then
        -- 怪物开始施放技能
        mah.speekText("开减伤")
    end
end
