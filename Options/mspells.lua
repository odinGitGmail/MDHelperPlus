local addonName, mdhelper = ...
local mspells = mdhelper.Spells

--[[
mdhelper.Spells 法术相关方法
]] --

----------------------------------------------------------------------------------------------------------------------
---检查法术是否冷却
function mspells.CheckSpellCooldown(spellID)
    local spellInfo = C_Spell.GetSpellCooldown(spellID)
    if not spellInfo.isEnabled then
        -- print("法术不可用")
        return false
    end

    if spellInfo.duration > 0 then
        -- local remainingTime = (startTime + duration - GetTime()) / modRate
        -- print(string.format("法术冷却中，剩余时间：%.2f 秒", remainingTime))
        return false
    else
        -- print("法术已就绪")
        return true
    end
end

----------------------------------------------------------------------------------------------------------------------
---获取指定player的所有增益buff
function mspells.GetAllHelpFulBuffs(unitPlay)
    local buffs = {} -- 用于存储增益buff
    -- 获取增益
    local i = 1
    while true do
        local buff = C_UnitAuras.GetAuraDataByIndex(unitPlay, i, "HELPFUL")
        if buff then
            table.insert(buffs, buff.spellId)
        else
            break
        end
        i = i + 1
    end
    return buffs
end

----------------------------------------------------------------------------------------------------------------------
---获取指定player的所有减益buff
function mspells.GetAllHarmFulBuffs(unitPlay)
    local debuffs = {} -- 用于存储减益buff
    -- 获取减益
    local i = 1
    while true do
        local debuff = C_UnitAuras.GetAuraDataByIndex(unitPlay, i, "HARMUL")
        if debuff then
            table.insert(debuffs, debuff.spellId)
        else
            break
        end
        i = i + 1
    end
    return debuffs
end

----------------------------------------------------------------------------------------------------------------------
---获取指定法术的名称
function mspells.GetSepllName(spellID)
    if not spellID then
        --print("Error: Spell ID is nil.")
        return ""
    end

    if type(spellID) ~= "number" and type(spellID) ~= "string" then
        --print("Error: Spell ID must be a number or string.", spellID)
        return ""
    end

    local spellInfo = C_Spell.GetSpellInfo(spellID)
    if spellInfo then
        return spellInfo.name
    else
        --print("Error: Invalid Spell ID or Spell Name -", spellID)
        return ""
    end
end
