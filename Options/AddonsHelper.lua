local addonName, mdhelper = ...
local mah = mdhelper.AddonsHelper

----------------------------------------------------------------------------------------------------------------------
---TTF语音功能
----------------------------------------------------------------------------------------------------------------------
function mah.speekText(text)
    C_VoiceChat.SpeakText(C_TTSSettings.GetVoiceOptionID(1), text, 1,
        C_TTSSettings.GetSpeechRate(),
        C_TTSSettings.GetSpeechVolume())
end
