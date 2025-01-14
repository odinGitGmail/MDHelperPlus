local addonName, mdhelper = ...
local muf = mdhelper.UI.Func

muf.Potin = {
    TOP = "TOP",
    BOTTOM = "BOTTOM",
    LEFT = "LEFT",
    RIGHT = "RIGHT",
    CENTER = "CENTER",
    TOPLEFT = "TOPLEFT",
    TOPRIGHT = "TOPRIGHT",
    BOTTOMLEFT = "BOTTOMLEFT",
    BOTTOMRIGHT = "BOTTOMRIGHT"
}

muf.RelativePoint = {
    TOP = "TOP",
    BOTTOM = "BOTTOM",
    LEFT = "LEFT",
    RIGHT = "RIGHT",
    CENTER = "CENTER",
    TOPLEFT = "TOPLEFT",
    TOPRIGHT = "TOPRIGHT",
    BOTTOMLEFT = "BOTTOMLEFT",
    BOTTOMRIGHT = "BOTTOMRIGHT"
}

----------------------------------------------------------------------------------------------------------------------
---mdhelper.UI.Func UI先关的扩展方法
----------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------
---清空frame的子元素 带递归
----------------------------------------------------------------------------------------------------------------------
function muf.ClearAllChildren(frame)
    for _, child in pairs({ frame:GetChildren() }) do
        muf.ClearAllChildren(child) -- 递归清理子控件
        child:Hide()                -- 隐藏当前子控件
        child:SetParent(nil)        -- 解除父子关系
    end
end

----------------------------------------------------------------------------------------------------------------------
---创建UI元素的potin
----------------------------------------------------------------------------------------------------------------------
function muf.createMdhPotin(mPoint, mrelativePoint, offx, offy)
    local pointModule = {
        point = mPoint,
        relativePoint = mrelativePoint,
        offx = offx,
        offy = offy
    }
    return pointModule
end

----------------------------------------------------------------------------------------------------------------------
---创建带职业颜色的字符串
----------------------------------------------------------------------------------------------------------------------
function muf.unitCareerColor(text, unit)
    if not text or not unit then return end
    if UnitIsPlayer(unit) then
        local _, class = UnitClass(unit)
        if not class then return ("|cffFF0000" .. text .. "|r") end
        local colorStr = RAID_CLASS_COLORS[class].colorStr
        return ("|c" .. colorStr .. text .. "|r")
    elseif UnitReaction(unit, "player") then
        local color = FACTION_BAR_COLORS and
            FACTION_BAR_COLORS[UnitReaction(unit, "player")]
        return ("|cff%.2x%.2x%.2x" .. text .. "|r"):format(color.r * 255,
            color.g * 255,
            color.b * 255)
    end
end
