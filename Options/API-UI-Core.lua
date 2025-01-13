local addonName,mdhelper = ...
local mcore = mdhelper.Core
local mspells = mdhelper.Spells
local muc = mdhelper.UI.components
local mucf = mdhelper.UI.components.Func
local muf = mdhelper.UI.Func



----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------




muf.Potin = {
    TOP = "TOP",
    BOTTOM = "BOTTOM",
    LEFT = "LEFT",
    RIGHT = "RIGHT",
    CENTER = "CENTER",
    TOPLEFT = "TOPLEFT",
    TOPRIGHT = "TOPRIGHT",
    BOTTOMLEFT = "BOTTOMLEFT",
    BOTTOMRIGHT = "BOTTOMRIGHT",
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
    BOTTOMRIGHT = "BOTTOMRIGHT",
}


-- 创建UI元素 设定potin
function muf.createMdhPotin(mPoint,mrelativePoint,offx,offy)
    local pointModule = {
        point = mPoint,
        relativePoint = mrelativePoint,
        offx = offx,
        offy = offy
    }
    return pointModule
end


-- 带职业颜色文本
function muf.unitCareerColor(text,unit)
    if not text or not unit then return end
    if UnitIsPlayer(unit) then
        local _,class = UnitClass(unit)
        if not class then return ("|cffFF0000"..text.."|r") end
        local colorStr = RAID_CLASS_COLORS[class].colorStr
        return ("|c"..colorStr..text.."|r")
    elseif UnitReaction(unit, "player") then
        local color = FACTION_BAR_COLORS and FACTION_BAR_COLORS[UnitReaction(unit, "player")]
        return ("|cff%.2x%.2x%.2x"..text.."|r"):format(color.r * 255, color.g * 255, color.b * 255)
    end
end

-- TTF语音功能
function muf.speekText(text)
    C_VoiceChat.SpeakText(C_TTSSettings.GetVoiceOptionID(1), text, 1,C_TTSSettings.GetSpeechRate(), C_TTSSettings.GetSpeechVolume())
end

