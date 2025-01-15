local addonName, mdhelper = ...
local muc = mdhelper.UI.components
local muf = mdhelper.UI.Func
local mspells = mdhelper.Spells
local mf = mdhelper.fonts
--[[
UI界面生成
]] --

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
        local registerMainCategory = muc.registerCanvasLayoutCategory(
            {
                frame = MDHelperFrame,
                text = "大秘境助手"
            })

        -- 注册斜杠命令
        SLASH_MDHELPER1 = "/mdh"
        SlashCmdList["MDHELPER"] = function()
            Settings.OpenToCategory(registerMainCategory:GetID())
        end

        -- 标题
        local MDHelperTitle = muc.createFont(
            MDHelperFrame,
            nil,
            nil,
            nil,
            { "TOPLEFT", "TOPLEFT", 16, -10 },
            "大秘境助手", 30)
        -- 子标题
        local MDHelperSubTitle = muc.createFont(
            MDHelperFrame,
            nil,
            nil,
            nil,
            { "TOPLEFT", "TOPLEFT", 170, -15 },
            "大秘境增强功能", 20)
        -- 功能描述
        local MDHelperDescription = muc.createFont(
            MDHelperFrame,
            nil,
            nil,
            nil,
            { "TOPLEFT", "TOPLEFT", 16, -50 },
            "大部分功能改动后需要重载界面",
            15)
        -- 重载按钮
        local reloadBtn = muc.createButton(
            "reloadBtn", "重载", MDHelperFrame, "UIPanelButtonTemplate",
            { 70, 30 },
            { "TOPLEFT", "TOPLEFT", 450, -40 },
            function(btnSelf) ReloadUI() end)

        -- 职业选择label
        local unitCareerlbl = muc.createFont(
            MDHelperFrame,
            nil,
            nil,
            nil,
            { "TOPLEFT", "TOPLEFT", 16, -90 },
            "当前职业:", 15)

        local _, class = UnitClass("player")
        local ucc = muf.unitCareerColor(mdhelper.Career[string.lower(class)],
            "player")
        local unitCareer = muc.createFont(
            MDHelperFrame,
            nil,
            nil,
            nil,
            { "TOPLEFT", "TOPLEFT", 90, -90 },
            ucc, 15)

        -- 打断法术ID label
        local interruptSpellIDlbl = muf.unitCareerColor(
            mdhelper.Career[string.lower(class)],
            "player")
        local unitCareer = muc.createFont(
            MDHelperFrame,
            nil,
            nil,
            nil,
            { "TOPLEFT", "TOPLEFT", 180, -90 },
            "打断法术ID", 15)

        -- 打断法术ID选择
        local interruptSpellIDTxtBox = muc.createTextBox(
            "interruptSpellIDTxtBox",
            MDHelperFrame,
            nil,
            { 120, 45 },
            { "TOPLEFT", reloadBtn = "TOPLEFT", 270, -75 },
            mdhelperDB["playerInfo"]["interruptSpellID"])

        -- 重载按钮
        local saveInterruptSpellIDBtn = muc.createButton(
            "saveInterruptSpellIDBtn", "确定",
            MDHelperFrame, "UIPanelButtonTemplate",
            { 70, 30 },
            { "TOPLEFT", "TOPLEFT", 400, -80 },
            function(btnSelf)
                mdhelper.UICore.saveInterruptSpellIDBtnClick(
                    interruptSpellIDTxtBox, mdhelperDB)
            end)

        -- 大秘境功能
        local mdhItemlbl = muc.createFont(
            MDHelperFrame,
            nil,
            nil,
            nil,
            { "TOPLEFT", "TOPLEFT", 20, -120 },
            "大秘境功能", 15)

        -- 开启打断提醒
        local useInterrupt = muc.createCheckboxBy3Column(
            "chk_Interrupt",
            MDHelperFrame,
            1,
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
        local interruptSubTitle = muc.createFont(
            interruptSubPanel,
            nil,
            "OVERLAY",
            "GameFontNormalLarge",
            { "TOPLEFT", "TOPLEFT", 0, -16 },
            "打断提醒", 20
        )

        local saveReloadBtn = muc.createButton(
            "saveReloadBtn", "保存重载", interruptSubPanel, "UIPanelButtonTemplate",
            { 70, 30 },
            { "TOPLEFT", "TOPLEFT", 100, -10 },
            function(btnSelf) ReloadUI() end)

        -- 打断提醒进度条
        local interruptProgressbar, timerTexts, iconFrams =
            muc.createProgressBar(
                "interruptProgressBar",
                UIParent,
                nil,
                {
                    mdhelperDB.mdhUser.interruptProgressBar.width, mdhelperDB.mdhUser.interruptProgressBar.height
                },
                "Interface\\Addons\\AddUI\\UI\\Textures\\colorbar.tga",
                {
                    mdhelperDB.mdhUser.interruptProgressBar.point,
                    mdhelperDB.mdhUser.interruptProgressBar.relativePoint,
                    mdhelperDB.mdhUser.interruptProgressBar.offx,
                    mdhelperDB.mdhUser.interruptProgressBar.offy
                },
                0, 100,
                {
                    drag = mdhelperDB.mdhUser.interruptProgressBar.drag,
                    show = mdhelperDB.mdhUser.interruptProgressBar.show
                },
                {
                    {
                        uiPoint = { "LEFT", "LEFT", mdhelperDB.mdhUser.interruptProgressBar.height + 10, 0, },
                        text = "",
                    },
                    {
                        uiPoint = { "RIGHT", "RIGHT", -10, 0, },
                        text = ""
                    }
                },
                {
                    {
                        uiPoint = { "LEFT", "LEFT", 0, 0, },
                        size = {
                            mdhelperDB.mdhUser.interruptProgressBar.height,
                            mdhelperDB.mdhUser.interruptProgressBar.height
                        },
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
            interruptSubPanel, "UIPanelButtonTemplate",
            { 70, 30 },
            { "TOPLEFT", "TOPLEFT", 0, -40 },
            function(btnSelf)
                mdhelper.UICore.interruptProgressbarBtnClick(btnSelf,
                    interruptProgressbar,
                    mdhelperDB)
            end)

        -- 进度条设置宽 文本
        local interruptProgressbarWidthlbl =
            muc.createFont(
                interruptSubPanel,
                nil,
                nil,
                nil,
                { "TOPLEFT", "TOPLEFT", 80, -50 },
                "进度条宽",
                15)

        -- 进度条设置宽 滑动条
        local interruptProgressbarWidthSilderBar =
            muc.createHorizontalSliderBar(
                "interruptProgressbarWidthSilderBar",
                interruptSubPanel,
                "OptionsSliderTemplate",
                { 180, 20 },
                { "TOPLEFT", "TOPLEFT", 160, -45 },
                function(self, value)
                    mdhelper.UICore.interruptProgressbarWidthSilderBarSilder(self,
                        value,
                        interruptProgressbar,
                        mdhelperDB)
                end)

        -- 进度条设置高 文本
        local interruptProgressbarHeightlbl =
            muc.createFont(
                interruptSubPanel,
                nil,
                nil,
                nil,
                { "TOPLEFT", "TOPLEFT", 360, -50 },
                "进度条高", 15)

        -- 进度条设置高 滑动条
        local interruptProgressbarHeightSilderBar =
            muc.createHorizontalSliderBar(
                "interruptProgressbarHeightSilderBar",
                interruptSubPanel,
                "OptionsSliderTemplate",
                { 180, 20 },
                { "TOPLEFT", "TOPLEFT", 440, -45 },
                function(self, value)
                    mdhelper.UICore.interruptProgressbarHeightSilderBarSilder(self,
                        value,
                        interruptProgressbar,
                        iconFrams,
                        timerTexts,
                        mdhelperDB)
                end)

        ----------------------------------------------------------------------------------------------------------------------
        ---打断提醒窗体 左右Frame
        ---左侧Frame 有 打断法术 按钮 和  减伤提醒 按钮 点击不同的按钮右侧将会出现不同的法术面板
        ---右侧frame 结构基本相同，包括一个添加法术的 文本框和按钮 以及 一个带有滚动条的table。table中包含 序号 法术ID 法术名称 以及一个可以删除的按钮
        ---点击每一行的删除按钮则删除当前法术，并同步 SavedVariables 的 mdhelperDB
        ----------------------------------------------------------------------------------------------------------------------
        -- 创建主界面Frame
        local settingPanelFrame = muc.createFrame(
            nil,
            "settingPanelFrame",
            interruptSubPanel,
            "BackdropTemplate",
            { "TOPLEFT", -15, -90 },
            { 680, 500 },
            nil,
            {
                backdropColor = { 0, 0, 0, 0 }
            }
        )

        ---创建左侧按钮列表面板
        local settingLeftPanelFrame = muc.createFrame(
            nil,
            "settingLeftPanelFrame",
            settingPanelFrame,
            "BackdropTemplate",
            { "TOPLEFT", "TOPLEFT", 5, 0 },
            { 200, 500 },
            {
                bgFile = nil,                                             -- 背景纹理
                edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", -- 边框纹理
                edgeSize = 10,
                insets = { left = 2, right = 2, top = 2, bottom = 2 },
            },
            {
                backdropColor = { 0, 0, 0, 0.2 },
                backdropBorderColor = { 0.2, 0.2, 0.2, 0.0 }
            }
        )


        local rightFrams = {}
        ----------------------------------------------------------------------------------------------------------------------
        --- 右侧打断法术UI
        ----------------------------------------------------------------------------------------------------------------------
        ---右侧打断法术框架
        local rightInterruptSpellsFrame = muc.createFrame(
            nil,
            "rightInterruptSpellsFrame",
            settingPanelFrame,
            nil,
            { "TOPLEFT", "TOPLEFT", 200, 0 },
            { 460, 500 }
        )
        rightFrams["interruptSpells"] = rightInterruptSpellsFrame
        -- 右侧打断法术滚动框架
        local rightInterruptSpellsScrollFrame = muc.createFrame(
            "ScrollFrame",
            "rightInterruptSpellsScrollFrame",
            rightInterruptSpellsFrame,
            "UIPanelScrollFrameTemplate",
            { "BOTTOMRIGHT", rightInterruptSpellsFrame, "BOTTOMRIGHT", 0, 0 },
            { 460, 450 },
            nil,
            nil
        )
        -- 右侧打断法术滚动内容容器
        local rightInterruptSpellsScrollContentFrame = muc.createFrame(
            nil,
            "rightInterruptSpellsScrollContentFrame",
            rightInterruptSpellsScrollFrame,
            nil,
            { "TOPLEFT", rightInterruptSpellsScrollFrame, "TOPLEFT", 0, 0 },
            { 460, 800 } -- 内容高度需大于 ScrollFrame 高度
        )
        -- 设置滚动面板的子滚动元素 以及 初始化滚动条，并且处理OnSizeChanged
        muc.scrollFrameSetScrollChildAndScrollFrameScrollBarInitScroll(
            rightInterruptSpellsScrollFrame,
            rightInterruptSpellsScrollContentFrame,
            {
                minValue = 0, step = 1, defaultValue = 0
            },
            nil
        )



        local rowHeight = 30
        local cellWidth = 100
        local rowPadding = 2
        local cellCount = 4
        local interruptSpellsRows = {}
        local interruptSpells = {
            { "序号", "法术ID", "法术名称", "删除" }
        }
        for i, v in pairs(mdhelperDB.addonData.interruptSpellArray) do
            table.insert(interruptSpells, { i, v, mspells.GetSepllName(v) })
        end

        local function UpdateTableRightInterruptSpellsScrollContentFrame()
            for i, row in pairs(interruptSpellsRows) do
                row:ClearAllPoints()
                row:SetPoint(
                    "TOP",
                    rightInterruptSpellsScrollContentFrame,
                    "TOP",
                    0,
                    -((i - 1) * (rowHeight + rowPadding)) - 10
                )
            end
        end

        for index, value in pairs(interruptSpells) do
            local rowData = value
            local row = muc.createTableRow(
                rightInterruptSpellsScrollContentFrame,
                rowData,
                rowHeight,
                { defaultColor = { 0, 0, 0, 0 }, enterColor = { 0.2, 0.4, 0.8, 0.5 } },
                { cellWidth, rowHeight },
                cellWidth,
                { "CENTER" },
                {
                    btnText = "删除",
                    xmlTemplate = "UIPanelButtonTemplate",
                    size = { 60, rowHeight - 10 },
                    point = { "RIGHT", "RIGHT", -10, 0 },
                    btnClickHandler = function(btn)
                        for i, row in pairs(interruptSpellsRows) do
                            if row.rowIndex == btn.Tip then
                                -- 删除对应的行
                                table.remove(interruptSpellsRows, i)
                                row:Hide()
                                break
                            end
                        end
                        UpdateTableRightInterruptSpellsScrollContentFrame()
                    end
                },
                index,
                cellCount
            )
            table.insert(interruptSpellsRows, row)
            UpdateTableRightInterruptSpellsScrollContentFrame()
        end


        ----------------------------------------------------------------------------------------------------------------------
        --- 右侧减伤提醒UI
        ----------------------------------------------------------------------------------------------------------------------
        ---右侧减伤提醒框架
        local rightAvoidanceSpellsFrame = muc.createFrame(
            nil,
            "rightAvoidanceSpellsFrame",
            settingPanelFrame,
            nil,
            { "TOPLEFT", 200, 0 },
            { 460, 500 }
        )
        rightAvoidanceSpellsFrame:Hide() -- 默认隐藏
        rightFrams["avoidanceSpells"] = rightAvoidanceSpellsFrame
        -- 右侧减伤法术滚动框架
        local rightAvoidanceSpellsScrollFrame = muc.createFrame(
            "ScrollFrame",
            "rightAvoidanceSpellsScrollFrame",
            rightAvoidanceSpellsFrame,
            "UIPanelScrollFrameTemplate",
            { "BOTTOMRIGHT", rightAvoidanceSpellsFrame, "BOTTOMRIGHT", 0, 0 },
            { 460, 450 },
            nil,
            nil
        )
        -- 右侧打断法术滚动内容容器
        local rightAvoidanceSpellsScrollContentFrame = muc.createFrame(
            nil,
            "rightAvoidanceSpellsScrollContentFrame",
            rightAvoidanceSpellsScrollFrame,
            nil,
            { "TOPLEFT", rightAvoidanceSpellsScrollFrame, "TOPLEFT", 0, 0 },
            { 460, 800 } -- 内容高度需大于 ScrollFrame 高度
        )
        -- 设置滚动面板的子滚动元素 以及 初始化滚动条，并且处理OnSizeChanged
        muc.scrollFrameSetScrollChildAndScrollFrameScrollBarInitScroll(
            rightAvoidanceSpellsScrollFrame,
            rightAvoidanceSpellsScrollContentFrame,
            {
                minValue = 0, step = 1, defaultValue = 0
            },
            nil
        )

        local avoidanceSpellsRows = {}
        local avoidanceSpells = {
            { "序号", "法术ID", "法术名称", "删除" }
        }
        for i, v in pairs(mdhelperDB.addonData.avoidanceSpellArray) do
            table.insert(avoidanceSpells, { i, v, mspells.GetSepllName(v) })
        end

        local function UpdateTableRightAvoidanceSpellsScrollContentFrame()
            for i, row in pairs(avoidanceSpellsRows) do
                row:ClearAllPoints()
                row:SetPoint(
                    "TOP",
                    rightAvoidanceSpellsScrollContentFrame,
                    "TOP",
                    0,
                    -((i - 1) * (rowHeight + rowPadding)) - 10
                )
            end
        end

        for index, value in pairs(avoidanceSpells) do
            local rowData = value
            local row = muc.createTableRow(
                rightAvoidanceSpellsScrollContentFrame,
                rowData,
                rowHeight,
                { defaultColor = { 0, 0, 0, 0 }, enterColor = { 0.2, 0.4, 0.8, 0.5 } },
                { cellWidth, rowHeight },
                cellWidth,
                { "CENTER" },
                {
                    btnText = "删除",
                    xmlTemplate = "UIPanelButtonTemplate",
                    size = { 60, rowHeight - 10 },
                    point = { "RIGHT", "RIGHT", -10, 0 },
                    btnClickHandler = function(btn)
                        for i, row in pairs(avoidanceSpellsRows) do
                            if row.rowIndex == btn.Tip then
                                -- 删除对应的行
                                table.remove(avoidanceSpellsRows, i)
                                row:Hide()
                                break
                            end
                        end
                        UpdateTableRightAvoidanceSpellsScrollContentFrame()
                    end
                },
                index,
                cellCount
            )
            table.insert(avoidanceSpellsRows, row)
            UpdateTableRightAvoidanceSpellsScrollContentFrame()
        end










        ----------------------------------------------------------------------------------------------------------------------
        --- 左侧按钮列表
        ----------------------------------------------------------------------------------------------------------------------
        ---左侧打断列表按钮
        local interruptSpellsBtn = muc.createButton(
            "interruptSpellsBtn",
            "打断列表",
            settingLeftPanelFrame,
            "UIPanelButtonTemplate",
            { 150, 30 },
            { "TOP", "TOP", 5, -5 },
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
        ---左侧法减伤列表按钮
        local avoidanceSpellsBtn = muc.createButton(
            "avoidanceSpellsBtn",
            "减伤列表",
            settingLeftPanelFrame,
            "UIPanelButtonTemplate",
            { 150, 30 },
            { "TOP", "TOP", 5, -40 },
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
        local updateSubPanelTitle = muc.createFont(
            updateSubPanel,
            nil,
            nil,
            nil,
            { "TOPLEFT", "TOPLEFT", 16, -10 },
            "更新日志",
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

            local lefttext = muc.createFont(
                rowFrame,
                nil,
                nil,
                "GameFontHighlight",
                { "LEFT", SliderBackground, "LEFT", 5, -1 },
                name,
                { mf.ARHei, 18, "OUTLINE" }
            )
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
