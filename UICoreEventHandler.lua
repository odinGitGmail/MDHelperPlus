local addonName, mdhelper = ...

mdhelper.UICore = {}

function mdhelper.UICore.saveInterruptSpellIDBtnClick(interruptSpellIDTxtBox,
                                                      mdhelperdb)
    local ssid = interruptSpellIDTxtBox:GetText()
    mdhelperdb["playerInfo"]["interruptSpellID"] = ssid
end

function mdhelper.UICore.interruptProgressbarBtnClick(btnSelf,
                                                      interruptProgressbar,
                                                      mdhelperdb)
    -- 显示状态去反并控制进度条显示和隐藏
    mdhelperdb.mdhUser.interruptProgressBar.show =
        not mdhelperdb.mdhUser.interruptProgressBar.show
    mdhelperdb.mdhUser.interruptProgressBar.drag = mdhelperdb.mdhUser
        .interruptProgressBar
        .show
    if mdhelperdb.mdhUser.interruptProgressBar.show then
        interruptProgressbar:Show()
        btnSelf:SetText("隐藏锚点")
    else
        interruptProgressbar:Hide()
        btnSelf:SetText("显示锚点")
    end

    -- 调整打断进度条是否可以被拖拽
    interruptProgressbar:SetMovable(mdhelperdb.mdhUser.interruptProgressBar.drag)
    interruptProgressbar:EnableMouse(mdhelperdb.mdhUser.interruptProgressBar
        .drag)
end

function mdhelper.UICore.interruptProgressbarWidthSilderBarSilder(self, value,
                                                                  interruptProgressbar,
                                                                  mdhelperdb)
    local bs = math.floor(value)
    if mdhelperdb.mdhUser.interruptProgressBar.width < 300 then
        mdhelperdb.mdhUser.interruptProgressBar.width = 300
    end
    if mdhelperdb.mdhUser.interruptProgressBar.width > 400 then
        mdhelperdb.mdhUser.interruptProgressBar.width = 400
    end
    -- self.Value:SetText(bs.."  -  "..mdhelperDB.mdhUser.interruptProgressBar.width)
    self.Value:SetText(bs)
    mdhelperdb.mdhUser.interruptProgressBar.width = mdhelperdb.mdhUser
        .interruptProgressBar
        .width + (bs);
    interruptProgressbar:SetWidth(mdhelperdb.mdhUser.interruptProgressBar.width)
end

function mdhelper.UICore.interruptProgressbarHeightSilderBarSilder(self, value,
                                                                   interruptProgressbar,
                                                                   iconFrams,
                                                                   timerTexts,
                                                                   mdhelperdb)
    local bs = math.floor(value)
    if mdhelperdb.mdhUser.interruptProgressBar.height < 40 then
        mdhelperdb.mdhUser.interruptProgressBar.height = 40
    end
    if mdhelperdb.mdhUser.interruptProgressBar.height > 60 then
        mdhelperdb.mdhUser.interruptProgressBar.height = 60
    end
    -- self.Value:SetText(bs.."  -  "..mdhelperDB.mdhUser.interruptProgressBar.height)
    self.Value:SetText(bs)
    mdhelperdb.mdhUser.interruptProgressBar.height = mdhelperdb.mdhUser
        .interruptProgressBar
        .height +
        (20 * bs / 100) - 10;
    interruptProgressbar:SetHeight(mdhelperdb.mdhUser.interruptProgressBar
        .height)
    if #iconFrams > 0 and iconFrams[1] ~= nil then
        iconFrams[1]:SetWidth(mdhelperdb.mdhUser.interruptProgressBar.height)
        iconFrams[1]:SetHeight(mdhelperdb.mdhUser.interruptProgressBar.height)
    end

    if #timerTexts > 0 and timerTexts[1] ~= nil then
        if timerTexts[1] ~= nil then
            local point, relativeTo, relativePoint, _, offsetY =
                timerTexts[1]:GetPoint()
            timerTexts[1]:ClearAllPoints()
            timerTexts[1]:SetPoint(point, relativeTo, relativePoint,
                mdhelperdb.mdhUser.interruptProgressBar
                .height + 10, offsetY)
        end
    end
end
