local addonName,mdhelper = ...
local mcore = mdhelper.Core
local mspells = mdhelper.Spells
local muc = mdhelper.UI.components
local mucf = mdhelper.UI.components.Func
local muf = mdhelper.UI.Func


----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------



--mdhelper.Core  基础lua相关方法

-- 循环表结构
function mcore.loopTable(tb)
    for key, value in pairs(tb) do
        if type(value)=="table" then
                loopTable(value)
        else
            print("key",key,"value",value)
        end
    end
end

-- 判断元素是否在数组中存在
function mcore.containsElement(array, element)
    for i, value in pairs(array) do
        if string.format(element)==string.format(value) then
            return true
        end
    end
    return false
end



----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------


-- mdhelper.Spell 法术相关方法

-- 检查法术是否冷却
function mspells.CheckSpellCooldown(spellID)
    local spellInfo = C_Spell.GetSpellCooldown(spellID)
    if not spellInfo.isEnabled then
        --print("法术不可用")
        return false
    end

    if spellInfo.duration > 0 then
        -- local remainingTime = (startTime + duration - GetTime()) / modRate
        --print(string.format("法术冷却中，剩余时间：%.2f 秒", remainingTime))
        return false
    else
        -- print("法术已就绪")
        return true
    end
end


-- 获取指定player的所有增益buff
function mspells.GetAllHelpFulBuffs(unitPlay)
    local buffs = {} -- 用于存储增益/减益效果
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


-- 获取指定player的所有增益buff
function mspells.GetAllHarmFulBuffs(unitPlay)
    local debuffs = {} -- 用于存储增益/减益效果
    -- 获取增益
    local i = 1
    while true do
        local debuff = C_UnitAuras.GetAuraDataByIndex(unitPlay, i, "HELPFUL")
        if debuff then
            table.insert(debuffs, debuff.spellId)
        else
            break
        end
        i = i + 1
    end
    return debuffs
end

