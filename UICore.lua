local addonName, mdhelper = ...
local muc = mdhelper.UI.components
local muf = mdhelper.UI.Func
local mspells = mdhelper.Spells
local eventFrame = CreateFrame("Frame")
-- 注册 PLAYER_LOGIN 事件
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        -- 玩家成功登录时触发的代码
        print(UnitName("player") .. " 登录游戏！")

        ----------------------------------------------------------------------------------------------------------------------
        ---创建主框架 面板
        ----------------------------------------------------------------------------------------------------------------------
        local MDHelperFrame = CreateFrame("Frame", "MDHelperFrame", UIParent, "BackdropTemplate")
        MDHelperFrame:SetPoint("CENTER") -- 设置位置居中
        MDHelperFrame:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
            edgeSize = 16
        })
        MDHelperFrame:SetBackdropColor(0, 0, 0, 1) -- 设置背景颜色
        MDHelperFrame:EnableMouse(true)            -- 允许鼠标交互
        MDHelperFrame:Hide()

        ----------------------------------------------------------------------------------------------------------------------
        ---注册创建主框架面板到addonCategory
        ----------------------------------------------------------------------------------------------------------------------
        local registerMainCategory = muc.registerCanvasLayoutCategory({
            frame = MDHelperFrame,
            text = "大秘境助手"
        })

        -- 注册斜杠命令
        SLASH_MDHELPER1 = "/mdh"
        SlashCmdList["MDHELPER"] = function()
            Settings.OpenToCategory(registerMainCategory:GetID())
        end

        -- 标题
        local MDHelperTitle = muc.createFont(MDHelperFrame, muf.createMdhPotin(
            muf.Potin.TOPLEFT,
            muf.RelativePoint.TOPLEFT, 16,
            -10), "大秘境助手", 30)
        -- 子标题
        local MDHelperSubTitle = muc.createFont(MDHelperFrame,
            muf.createMdhPotin(
                muf.Potin.TOPLEFT,
                muf.RelativePoint.TOPLEFT,
                170, -15),
            "大秘境增强功能", 20)
        -- 功能描述
        local MDHelperDescription = muc.createFont(MDHelperFrame,
            muf.createMdhPotin(
                muf.Potin.TOPLEFT,
                muf.RelativePoint.TOPLEFT,
                16, -50),
            "大部分功能改动后需要重载界面",
            15)
        -- 重载按钮
        local reloadBtn = muc.createButton("reloadBtn", "重载", MDHelperFrame,
            70, 30, muf.createMdhPotin(
                muf.Potin.TOPLEFT,
                muf.RelativePoint.TOPLEFT, 450,
                -40),
            function(btnSelf) ReloadUI() end)

        -- 职业选择label
        local unitCareerlbl = muc.createFont(MDHelperFrame, muf.createMdhPotin(
            muf.Potin.TOPLEFT,
            muf.RelativePoint.TOPLEFT, 16,
            -90), "当前职业:", 15)
        local _, class = UnitClass("player")
        local ucc = muf.unitCareerColor(mdhelper.Career[string.lower(class)],
            "player")
        local unitCareer = muc.createFont(MDHelperFrame, muf.createMdhPotin(
                muf.Potin.TOPLEFT,
                muf.RelativePoint.TOPLEFT, 90, -90),
            ucc, 15)

        -- 打断法术ID label
        local interruptSpellIDlbl = muf.unitCareerColor(
            mdhelper.Career[string.lower(class)],
            "player")
        local unitCareer = muc.createFont(MDHelperFrame, muf.createMdhPotin(
            muf.Potin.TOPLEFT,
            muf.RelativePoint.TOPLEFT, 180,
            -90), "打断法术ID", 15)

        -- 打断法术ID选择
        local interruptSpellIDTxtBox = muc.createTextBox(
            "interruptSpellIDTxtBox",
            MDHelperFrame, 120, 45,
            muf.createMdhPotin(muf.Potin.TOPLEFT,
                muf.RelativePoint
                .TOPLEFT, 270,
                -75),
            mdhelperDB["playerInfo"]["interruptSpellID"])

        -- 重载按钮
        local saveInterruptSpellIDBtn = muc.createButton(
            "saveInterruptSpellIDBtn", "确定",
            MDHelperFrame, 70, 30,
            muf.createMdhPotin(
                muf.Potin.TOPLEFT,
                muf.RelativePoint.TOPLEFT, 400,
                -80), function(btnSelf)
                mdhelper.UICore.saveInterruptSpellIDBtnClick(
                    interruptSpellIDTxtBox, mdhelperDB)
            end)

        -- 大秘境功能
        local mdhItemlbl = muc.createFont(MDHelperFrame, muf.createMdhPotin(
            muf.Potin.TOPLEFT,
            muf.RelativePoint.TOPLEFT, 20,
            -120), "大秘境功能", 15)

        -- 开启打断提醒
        local useInterrupt = muc.createCheckboxBy3Column("chk_Interrupt",
            MDHelperFrame, 1,
            "打断提醒",
            "打断提醒进度条",
            mdhelperDB.mdhUser
            .interrupt,
            function(chkBox)
                mdhelperDB.mdhUser.interrupt = chkBox:GetChecked()
            end)

        -- 减伤提醒
        local useAvoidance = muc.createCheckboxBy3Column("chk_Avoidance",
            MDHelperFrame, 2,
            "减伤提醒",
            "被怪点名减伤提醒",
            mdhelperDB.mdhUser
            .avoidance,
            function(chkBox)
                mdhelperDB.mdhUser.avoidance = chkBox:GetChecked()
            end)

        ----------------------------------------------------------------------------------------------------------------------
        ---打断提醒子面板
        ----------------------------------------------------------------------------------------------------------------------

        local interruptSubPanel = CreateFrame("Frame", "interruptSubPanel", UIParent, "BackdropTemplate")
        interruptSubPanel.name = "interruptSubPanel"

        -- 添加标题
        local interruptSubTitle = interruptSubPanel:CreateFontString(nil,
            "OVERLAY",
            "GameFontNormalLarge")
        interruptSubTitle:SetPoint("TOPLEFT", 0, -16)
        interruptSubTitle:SetText("打断提醒")

        -- 打断提醒进度条
        local interruptProgressbar, timerTexts, iconFrams =
            muc.createProgressBar("interruptProgressBar", UIParent,
                mdhelperDB.mdhUser.interruptProgressBar.width,
                mdhelperDB.mdhUser.interruptProgressBar.height,
                "Interface\\Addons\\AddUI\\UI\\Textures\\colorbar.tga",
                muf.createMdhPotin(
                    mdhelperDB.mdhUser.interruptProgressBar
                    .point, mdhelperDB.mdhUser
                    .interruptProgressBar.relativePoint,
                    mdhelperDB.mdhUser.interruptProgressBar
                    .offx, mdhelperDB.mdhUser
                    .interruptProgressBar.offy), 0, 100,
                {
                    drag = mdhelperDB.mdhUser.interruptProgressBar.drag,
                    show = mdhelperDB.mdhUser.interruptProgressBar.show
                }, {
                    {
                        point = muf.Potin.LEFT,
                        relativePoint = muf.RelativePoint.LEFT,
                        offx = mdhelperDB.mdhUser.interruptProgressBar.height + 10,
                        offy = 0,
                        text = ""
                    }, {
                    point = muf.Potin.RIGHT,
                    relativePoint = muf.RelativePoint.RIGHT,
                    offx = -10,
                    offy = 0,
                    text = ""
                }
                }, {
                    {
                        point = muf.Potin.LEFT,
                        relativePoint = muf.RelativePoint.LEFT,
                        offx = 0,
                        offy = 0,
                        width = mdhelperDB.mdhUser.interruptProgressBar.height,
                        height = mdhelperDB.mdhUser.interruptProgressBar.height
                    }
                })
        muc.interruptProgressbar = interruptProgressbar
        muc.interruptProgressbarTimerTexts = timerTexts
        muc.interruptProgressbarIconFrams = iconFrams

        -- 显示锚点按钮
        local interruptProgressbarBtnTxt = ""
        if (mdhelperDB.mdhUser.interruptProgressBar.show) then
            interruptProgressbarBtnTxt = "隐藏锚点"
        else
            interruptProgressbarBtnTxt = "显示锚点"
        end

        -- 显示锚点/隐藏锚点 按钮
        local interruptProgressbarBtn = muc.createButton(
            "interruptProgressbarBtn",
            interruptProgressbarBtnTxt,
            interruptSubPanel, 70, 30,
            muf.createMdhPotin(
                muf.Potin.TOPLEFT,
                muf.RelativePoint.TOPLEFT, 0,
                -40), function(btnSelf)
                mdhelper.UICore.interruptProgressbarBtnClick(btnSelf,
                    interruptProgressbar,
                    mdhelperDB)
            end)

        -- 进度条设置宽 文本
        local interruptProgressbarWidthlbl =
            muc.createFont(interruptSubPanel, muf.createMdhPotin(
                muf.Potin.TOPLEFT, muf.RelativePoint.TOPLEFT, 80,
                -50), "进度条宽", 15)

        -- 进度条设置宽 滑动条
        local interruptProgressbarWidthSilderBar =
            muc.createHorizontalSliderBar("interruptProgressbarWidthSilderBar",
                interruptSubPanel, 180, 20,
                muf.createMdhPotin(muf.Potin.TOPLEFT,
                    muf.RelativePoint
                    .TOPLEFT, 160,
                    -45),
                function(self, value)
                    mdhelper.UICore.interruptProgressbarWidthSilderBarSilder(self,
                        value,
                        interruptProgressbar,
                        mdhelperDB)
                end)

        -- 进度条设置高 文本
        local interruptProgressbarHeightlbl =
            muc.createFont(interruptSubPanel, muf.createMdhPotin(
                muf.Potin.TOPLEFT, muf.RelativePoint.TOPLEFT,
                360, -50), "进度条高", 15)

        -- 进度条设置高 滑动条
        local interruptProgressbarHeightSilderBar =
            muc.createHorizontalSliderBar("interruptProgressbarHeightSilderBar",
                interruptSubPanel, 180, 20,
                muf.createMdhPotin(muf.Potin.TOPLEFT,
                    muf.RelativePoint
                    .TOPLEFT, 440,
                    -45),
                function(self, value)
                    mdhelper.UICore.interruptProgressbarHeightSilderBarSilder(self,
                        value,
                        interruptProgressbar,
                        iconFrams,
                        timerTexts,
                        mdhelperDB)
                end)

        ----------------------------------------------------------------------------------------------------------------------
        ---tab
        ---ceshi
        ----------------------------------------------------------------------------------------------------------------------
        -- 创建父Frame，容器框架
        -- 创建主界面Frame
        -- 创建主背景框架
        local settingPanelFrame = CreateFrame("Frame", "settingPanelFrame", interruptSubPanel, "BackdropTemplate")
        settingPanelFrame:SetSize(680, 500)
        settingPanelFrame:SetPoint("TOPLEFT", -15, -90)
        settingPanelFrame:SetBackdropColor(0, 0, 0, 0)

        local settingLeftPanelFrame = CreateFrame("Frame", "settingLeftPanelFrame", settingPanelFrame, "BackdropTemplate")
        settingLeftPanelFrame:SetSize(200, 500)
        settingLeftPanelFrame:SetPoint("TOPLEFT", 5, 0)
        settingLeftPanelFrame:SetBackdrop({
            bgFile = nil,                                             -- 背景纹理
            edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", -- 边框纹理
            edgeSize = 10,
            insets = { left = 2, right = 2, top = 2, bottom = 2 },
        })
        settingLeftPanelFrame:SetBackdropColor(0, 0, 0, 0.2) -- 背景颜色（黑色，透明度0.8）
        settingLeftPanelFrame:SetBackdropBorderColor(0.2, 0.2, 0.2, 0.0)

        local rightFrams = {}
        -- 创建右侧主框架
        local rightInterruptSpellsFrame = CreateFrame("Frame", "rightInterruptSpellsFrame", settingPanelFrame)
        rightInterruptSpellsFrame:SetSize(460, 500)
        rightInterruptSpellsFrame:SetPoint("TOPLEFT", 200, 0)
        rightFrams["interruptSpells"] = rightInterruptSpellsFrame


        -- 创建 右侧打断法术滚动框架
        local rightInterruptSpellsScrollFrame = CreateFrame(
            "ScrollFrame",
            "rightInterruptSpellsScrollFrame",
            rightInterruptSpellsFrame,
            "UIPanelScrollFrameTemplate")
        rightInterruptSpellsScrollFrame:SetSize(460, 450)
        rightInterruptSpellsScrollFrame:SetPoint("BOTTOMRIGHT", rightInterruptSpellsFrame, "BOTTOMRIGHT", 0, 0)


        -- 右侧打断法术滚动内容容器
        local rightInterruptSpellsScrollContentFrame = CreateFrame(
            "Frame",
            "rightInterruptSpellsScrollContentFrame",
            rightInterruptSpellsScrollFrame)
        rightInterruptSpellsScrollContentFrame:SetSize(460, 800) -- 内容高度需大于 ScrollFrame 高度
        rightInterruptSpellsScrollFrame:SetScrollChild(rightInterruptSpellsScrollContentFrame)

        -- 初始化滚动条
        local rightInterruptSpellsScrollbar = rightInterruptSpellsScrollFrame.ScrollBar
        rightInterruptSpellsScrollbar:SetMinMaxValues(0,
            rightInterruptSpellsScrollContentFrame:GetHeight() - rightInterruptSpellsScrollFrame:GetHeight())
        rightInterruptSpellsScrollbar:SetValueStep(1)
        rightInterruptSpellsScrollbar:SetValue(0)

        -- 动态调整滚动条范围
        rightInterruptSpellsScrollFrame:SetScript("OnSizeChanged", function()
            rightInterruptSpellsScrollbar:SetMinMaxValues(0,
                math.max(0,
                    rightInterruptSpellsScrollContentFrame:GetHeight() - rightInterruptSpellsScrollFrame:GetHeight()))
        end)

        -- 添加滚动内容
        local enableMaps = {}
        for key, value in pairs(mdhelper.mdMaps) do
            if value.enable then
                enableMaps[key] = value.name
            end
        end

        local numRows = #mdhelper.interruptSpellArray
        local numCols = 4
        local rowHeight = 30
        local cellWidth = 100
        local cellHeight = 30
        local rowPadding = 2
        local rows = {}
        local function UpdateTable()
            for i, row in ipairs(rows) do
                row:ClearAllPoints()
                row:SetPoint("TOP", rightInterruptSpellsScrollContentFrame, "TOP", 0,
                    -((i - 1) * (rowHeight + rowPadding)) - 10)
            end
        end

        -- 创建行函数
        local function CreateRow(rowData)
            local row = CreateFrame("Frame", nil, rightInterruptSpellsScrollContentFrame)
            row:SetSize(rightInterruptSpellsScrollContentFrame:GetWidth() - 20, rowHeight)

            -- 行背景
            local rowBg = row:CreateTexture(nil, "BACKGROUND")
            rowBg:SetAllPoints()
            rowBg:SetColorTexture(0, 0, 0, 0) -- 默认透明背景

            row:SetScript("OnEnter", function()
                rowBg:SetColorTexture(0.2, 0.4, 0.8, 0.5) -- 鼠标移入背景色
            end)
            row:SetScript("OnLeave", function()
                rowBg:SetColorTexture(0, 0, 0, 0) -- 鼠标移出恢复透明
            end)

            -- 创建列
            for j, cellData in pairs(rowData) do
                local cell = CreateFrame("Frame", nil, row)
                cell:SetSize(cellWidth, rowHeight)
                cell:SetPoint("LEFT", row, "LEFT", (j - 1) * cellWidth, 0)

                local cellText = cell:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                cellText:SetText(cellData)
                cellText:SetPoint("CENTER")
            end
if rowData[1]
            -- 删除按钮
            local deleteButton = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
            deleteButton:SetSize(60, rowHeight - 10)
            deleteButton:SetPoint("RIGHT", row, "RIGHT", -10, 0)
            deleteButton:SetText("删除")
            deleteButton:SetScript("OnClick", function()
                for i, r in ipairs(rows) do
                    if r == row then
                        -- 删除对应的行
                        table.remove(rows, i)
                        row:Hide()
                        break
                    end
                end
                UpdateTable()
            end)

            table.insert(rows, row)
            UpdateTable()
        end

        -- 创建初始行
        local data = { { "序号", "法术ID", "法术名称" } }
        for index = 1, #mdhelperDB.addonData.interruptSpellArray do
            local spellID = mdhelperDB.addonData.interruptSpellArray[index]
            table.insert(data, { index - 1, spellID, mspells.GetSepllName(spellID) })
        end

        for key, value in pairs(data) do
            -- bodyQuota
            CreateRow(data[key])
        end




        -- 可选：设置背景颜色
        local bg = rightInterruptSpellsScrollFrame:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints(rightInterruptSpellsScrollFrame)
        bg:SetColorTexture(0.1, 0.1, 0.1, 0.5)

        -- 调整滚动行为
        rightInterruptSpellsScrollbar:SetScript("OnValueChanged", function(self, value)
            rightInterruptSpellsScrollFrame:SetVerticalScroll(value)
        end)

        local interruptSpellsBtn = muc.createButton(
            "interruptSpellsBtn",
            "打断列表",
            settingLeftPanelFrame, 150, 30,
            muf.createMdhPotin(
                muf.Potin.TOP,
                muf.RelativePoint.TOP,
                5,
                -5),
            function(btnSelf)
                for k, v in pairs(rightFrams) do
                    if btnSelf.Tip == k then
                        rightFrams[k]:Show()
                    else
                        rightFrams[k]:Hide()
                    end
                end
            end)
        interruptSpellsBtn.Tip = "interruptSpells"



















        -- 创建右侧主框架
        local rightAvoidanceSpellsFrame = CreateFrame("Frame", "rightAvoidanceSpellsFrame", settingPanelFrame)
        rightAvoidanceSpellsFrame:SetSize(460, 500)
        rightAvoidanceSpellsFrame:SetPoint("TOPLEFT", 200, 0)
        rightFrams["avoidanceSpells"] = rightAvoidanceSpellsFrame
        rightAvoidanceSpellsFrame:Hide()

        -- 创建 右侧打断法术滚动框架
        local rightAvoidanceSpellsScrollFrame = CreateFrame(
            "ScrollFrame",
            "rightAvoidanceSpellsScrollFrame",
            rightAvoidanceSpellsFrame,
            "UIPanelScrollFrameTemplate")
        rightAvoidanceSpellsScrollFrame:SetSize(460, 450)
        rightAvoidanceSpellsScrollFrame:SetPoint("BOTTOMRIGHT", rightAvoidanceSpellsFrame, "BOTTOMRIGHT", 0, 0)


        -- 右侧打断法术滚动内容容器
        local rightAvoidanceSpellsScrollContentFrame = CreateFrame(
            "Frame",
            "rightAvoidanceSpellsScrollContentFrame",
            rightAvoidanceSpellsScrollFrame)
        rightAvoidanceSpellsScrollContentFrame:SetSize(460, 800) -- 内容高度需大于 ScrollFrame 高度
        rightAvoidanceSpellsScrollFrame:SetScrollChild(rightAvoidanceSpellsScrollContentFrame)

        -- 初始化滚动条
        local rightAvoidanceSpellsScrollbar = rightAvoidanceSpellsScrollFrame.ScrollBar
        rightAvoidanceSpellsScrollbar:SetMinMaxValues(0,
            rightAvoidanceSpellsScrollContentFrame:GetHeight() - rightAvoidanceSpellsScrollFrame:GetHeight())
        rightAvoidanceSpellsScrollbar:SetValueStep(1)
        rightAvoidanceSpellsScrollbar:SetValue(0)

        -- 动态调整滚动条范围
        rightAvoidanceSpellsScrollFrame:SetScript("OnSizeChanged", function()
            rightAvoidanceSpellsScrollbar:SetMinMaxValues(0,
                math.max(0,
                    rightAvoidanceSpellsScrollContentFrame:GetHeight() - rightAvoidanceSpellsScrollFrame:GetHeight()))
        end)

        -- 添加滚动内容
        for i = 1, 100 do
            local item = rightAvoidanceSpellsScrollContentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            item:SetPoint("TOPLEFT", 10, -20 * (i - 1))
            item:SetText("Item Item Item " .. i)
        end

        -- 可选：设置背景颜色
        local bg = rightAvoidanceSpellsScrollFrame:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints(rightAvoidanceSpellsScrollFrame)
        bg:SetColorTexture(0.1, 0.1, 0.1, 0.5)

        -- 调整滚动行为
        rightAvoidanceSpellsScrollbar:SetScript("OnValueChanged", function(self, value)
            rightAvoidanceSpellsScrollFrame:SetVerticalScroll(value)
        end)

        local avoidanceSpellsBtn = muc.createButton(
            "avoidanceSpellsBtn",
            "减伤列表",
            settingLeftPanelFrame, 150, 30,
            muf.createMdhPotin(
                muf.Potin.TOP,
                muf.RelativePoint.TOP,
                5,
                -40),
            function(btnSelf)
                for k, v in pairs(rightFrams) do
                    if btnSelf.Tip == k then
                        rightFrams[k]:Show()
                    else
                        rightFrams[k]:Hide()
                    end
                end
            end)
        avoidanceSpellsBtn.Tip = "avoidanceSpells"




        ----------------------------------------------------------------------------------------------------------------------
        ---更新日志面板
        ----------------------------------------------------------------------------------------------------------------------
        local updateSubPanel = CreateFrame("Frame", "updateSubPanel", UIParent, "BackdropTemplate")
        updateSubPanel.name = "updateSubPanel"

        -- 标题
        local updateSubPanelTitle = muc.createFont(updateSubPanel,
            muf.createMdhPotin(
                muf.Potin.TOPLEFT,
                muf.RelativePoint.TOPLEFT,
                16, -10), "更新日志",
            30)

        local OpenUpDate = CreateFrame("Button", "OpenUpDate", updateSubPanel,
            "UIPanelButtonTemplate")
        OpenUpDate:SetText("返回设置")
        OpenUpDate:SetWidth(120)
        OpenUpDate:SetHeight(22)
        OpenUpDate:SetPoint("TOPRIGHT", -5, -5)
        OpenUpDate:SetScript("OnClick", function()
            Settings.OpenToCategory(registerMainCategory:GetID())
        end)

        -- 滚动框架
        local updatescroll = CreateFrame("ScrollFrame", nil, updateSubPanel,
            "UIPanelScrollFrameTemplate")
        updatescroll:SetPoint("TOPLEFT", updateSubPanel, "TOPLEFT", 0, -40)
        updatescroll:SetPoint("BOTTOMRIGHT", updateSubPanel, "BOTTOMRIGHT", -20,
            0)
        -- 滚动内容
        local ConFrame = CreateFrame("Frame", nil, updatescroll)
        ConFrame:SetSize(670, 480)
        updatescroll:SetScrollChild(ConFrame)
        mdhelper.updateY = 0 -- 设置起始位置

        local Yoffset = -10
        local textcolor = { 0.8, 0.8, 0.8, 0.9 }
        local function AddUpdate(name)
            local rowFrame = CreateFrame("Frame", nil, ConFrame)

            rowFrame:SetPoint("TOPLEFT", 10, Yoffset)
            rowFrame:SetSize(630, 26)
            local SliderBackground = rowFrame:CreateTexture(nil, "BACKGROUND")
            SliderBackground:SetTexture(130937)
            SliderBackground:SetPoint("TOPLEFT", rowFrame, "TOPLEFT", 0, 0)
            SliderBackground:SetColorTexture(0.5, 0.5, 0.5, 0.1) -- 设置背景颜色为黑色，透明度为0.5
            SliderBackground:SetScript("OnEnter", function(self)
                self:SetColorTexture(0.5, 0.5, 0.5, .3)
            end)
            SliderBackground:SetScript("OnLeave", function(self)
                self:SetColorTexture(0.5, 0.5, 0.5, 0.1)
            end)

            local lefttext = rowFrame:CreateFontString(nil, "ARTWORK",
                "GameFontHighlight")
            lefttext:SetPoint("LEFT", SliderBackground, "LEFT", 5, -1)
            lefttext:SetText(name)
            lefttext:SetFont("fonts\\ARHei.ttf", 18, "OUTLINE")
            lefttext:SetJustifyH("LEFT")
            lefttext:SetWordWrap(true)                               -- 换行
            lefttext:SetWidth(623)
            lefttext:SetSpacing(6)                                   -- 间距
            lefttext:SetTextColor(unpack(textcolor))                 -- 颜色
            SliderBackground:SetSize(630, lefttext:GetHeight() + 15) -- 背景颜色根据字体框架高度设置

            Yoffset = Yoffset - 25 - lefttext:GetHeight()            -- 后面的位置

            textcolor = { 0.6, 0.6, .6, 0.6 }
            mdhelper.updateY = mdhelper.updateY + 1
        end

        -- 收集更新表格
        local keys = {}
        for k in pairs(mdhelper.update) do table.insert(keys, k) end

        -- 对表格进行排序
        table.sort(keys, function(a, b) return a > b end)

        -- 根据排序后的表格创建文本
        for _, k in ipairs(keys) do
            AddUpdate("|cff00FFFF" .. k .. " : |r" .. mdhelper.update[k])
        end

        ----------------------------------------------------------------------------------------------------------------------
        --- 注册打断提醒子面板到addonCategory 注册打断提醒子面板到addonCategory
        ----------------------------------------------------------------------------------------------------------------------
        muc.registerSubCanvasLayoutCategory(registerMainCategory, {
            { frame = interruptSubPanel, text = "打断提醒" },
            { frame = updateSubPanel, text = "更新日志" }
        })
    end
end)
