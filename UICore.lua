local addonName,mdhelper = ...
local mcore = mdhelper.Core
local mspells = mdhelper.Spells
local muc = mdhelper.UI.components
local mucf = mdhelper.UI.components.Func
local muf = mdhelper.UI.Func



local interruptProgressbar, timerText
-- 创建一个事件框架
local eventFrame = CreateFrame("Frame")
-- 注册 PLAYER_LOGIN 事件
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        -- 玩家成功登录时触发的代码
        print(UnitName("player") .. " 登录游戏！")

        -- 你可以在这里执行其他初始化操作
        -- 例如加载设置、初始化变量等

        -- 创建主框架
        local MDHelperFrame = CreateFrame("Frame", "MDHelperFrame", UIParent, "BackdropTemplate")
        MDHelperFrame:SetSize(400, 300) -- 设置宽度和高度
        MDHelperFrame:SetPoint("CENTER") -- 设置位置居中
        MDHelperFrame:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
            edgeSize = 16,
        })
        MDHelperFrame:SetBackdropColor(0, 0, 0, 1) -- 设置背景颜色
        MDHelperFrame:EnableMouse(true) -- 允许鼠标交互


        MDHelperFrame:Hide()

        -- 注册到插件选项界面
        local category = Settings.RegisterCanvasLayoutCategory(MDHelperFrame,"大秘境助手")
        Settings.RegisterAddOnCategory(category)

        -- 注册斜杠命令
        SLASH_MDHELPER1 = "/mdh"
        SlashCmdList["MDHELPER"] = function()
            Settings.OpenToCategory(category:GetID())
        end

        -- 标题
        local MDHelperTitle = muc.createFont(16, -10 , MDHelperFrame, "TOPLEFT", MDHelperFrame, "TOPLEFT", "大秘境助手", 30)
        -- 子标题
        local MDHelperSubTitle = muc.createFont(0, 0 , MDHelperFrame, "BOTTOMLEFT", MDHelperTitle, "BOTTOMRIGHT", "大秘境增强功能", 15)
        -- 功能描述
        local MDHelperDescription = muc.createFont(16, -50 , MDHelperFrame, "TOPLEFT", MDHelperFrame, "TOPLEFT", "此界面只是一些功能的开关,大部分功能改动后需要重载界面", 15)
        -- 重载按钮
        local reloadBtn = muc.createButton(
            "reloadBtn",
            "重载", 
            MDHelperFrame, 
            70,
            30,
            muf.createMdhPotin(muf.Potin.TOPLEFT,muf.RelativePoint.TOPLEFT,450,-40),
            function(btnSelf)
                ReloadUI()
            end)


        -- 职业选择label
        local unitCareerlbl = muc.createFont(20, -90 , MDHelperFrame, "TOPLEFT", MDHelperFrame, "TOPLEFT", "当前职业", 15)
        local _, class = UnitClass("player")
        local ucc = muf.unitCareerColor(mdhelper.Career[string.lower(class)],"player")
        local unitCareer = muc.createFont(90, -90 , MDHelperFrame, "TOPLEFT", MDHelperFrame, "TOPLEFT", ucc, 15)

        -- 打断法师ID label
        local interruptSpellIDlbl = muc.createFont(180, -90 , MDHelperFrame, "TOPLEFT", MDHelperFrame, "TOPLEFT", "打断法术ID", 15)

        -- 打断法师ID选择
        local interruptSpellIDTxtBox = muc.createTextBox("interruptSpellIDTxtBox", MDHelperFrame,  120, 45 , "TOPLEFT", 270, -75, mdhelperDB["playerInfo"]["interruptSpellID"])

        -- 重载按钮
        local saveInterruptSpellIDBtn = muc.createButton(
            "saveInterruptSpellIDBtn",
            "确定",
            MDHelperFrame,
            70,
            30,
            muf.createMdhPotin(muf.Potin.TOPLEFT,muf.RelativePoint.TOPLEFT,400,-80),
            function(btnSelf)
                local ssid = interruptSpellIDTxtBox:GetText()
                mdhelperDB["playerInfo"]["interruptSpellID"] = ssid
            end)

        -- 大秘境功能
        local mdhItemlbl = muc.createFont(20, -120 , MDHelperFrame, "TOPLEFT", MDHelperFrame, "TOPLEFT", "大秘境功能:", 15)

        -- 开启打断提醒
        local useInterrupt = muc.createCheckbox(
            "chk_Interrupt",
            MDHelperFrame,
            1,
            "打断提醒",
            "打断提醒进度条",
            mdhelperDB.mdhUser.interrupt,
            function(chkBox)
                mdhelperDB.mdhUser.interrupt = chkBox:GetChecked()
            end
            )

        -- 减伤提醒
        local useAvoidance = muc.createCheckbox(
            "chk_Avoidance",
            MDHelperFrame,
            2,
            "减伤提醒",
            "被怪点名减伤提醒",
            mdhelperDB.mdhUser.avoidance,
            function(chkBox)
                mdhelperDB.mdhUser.avoidance = chkBox:GetChecked()
            end
            )

        -- 打断提醒子面板
        local interruptSubPanel = CreateFrame("Frame", "interruptSubPanel", UIParent)
        interruptSubPanel.name = "interruptSubPanel"

        -- 添加标题
        local interruptSubTitle = interruptSubPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        interruptSubTitle:SetPoint("TOPLEFT", 0, -16)
        interruptSubTitle:SetText("打断提醒")

        -- 注册子面板
        local category2 = Settings.RegisterCanvasLayoutSubcategory(category, interruptSubPanel, "打断提醒")
        Settings.RegisterAddOnCategory(category2)

        -- 打断提醒进度条
        local interruptProgressbar, timerText,iconFrams = muc.createProgressBar(
            "interruptProgressBar",
            UIParent,
            mdhelperDB.mdhUser.interruptProgressBar.width,
            mdhelperDB.mdhUser.interruptProgressBar.height,
            muf.createMdhPotin(
                mdhelperDB.mdhUser.interruptProgressBar.point,
                mdhelperDB.mdhUser.interruptProgressBar.relativePoint,
                mdhelperDB.mdhUser.interruptProgressBar.offx,
                mdhelperDB.mdhUser.interruptProgressBar.offy),
            0,
            100,
            {drag = mdhelperDB.mdhUser.interruptProgressBar.drag, show = mdhelperDB.mdhUser.interruptProgressBar.show},
            {
                { point=muf.Potin.LEFT,relativePoint=muf.RelativePoint.LEFT,offx=mdhelperDB.mdhUser.interruptProgressBar.height+10,offy=0,text="" },
                { point=muf.Potin.RIGHT,relativePoint=muf.RelativePoint.RIGHT,offx=-10,offy=0,text="" },
            },
            {
                { 
                    point=muf.Potin.LEFT,
                    relativePoint=muf.RelativePoint.LEFT,
                    offx=0,
                    offy=0,
                    width=mdhelperDB.mdhUser.interruptProgressBar.height,
                    height=mdhelperDB.mdhUser.interruptProgressBar.height,
                }
            }
        )
        muc.interruptProgressbar = interruptProgressbar
        muc.interruptProgressbarTimerTexts = timerText
        muc.interruptProgressbarIconFrams = iconFrams


        -- 显示锚点按钮
        local interruptProgressbarBtnTxt = ""
        if(mdhelperDB.mdhUser.interruptProgressBar.show) then
            interruptProgressbarBtnTxt = "隐藏锚点"
        else
            interruptProgressbarBtnTxt = "显示锚点"
        end
        -- 显示锚点/隐藏锚点 按钮
        local interruptProgressbarBtn = muc.createButton(
            "interruptProgressbarBtn",
            interruptProgressbarBtnTxt,
            interruptSubPanel,
            70,
            30,
            muf.createMdhPotin(muf.Potin.TOPLEFT,muf.RelativePoint.TOPLEFT,0,-40),
            function(btnSelf)
                -- 显示状态去反并控制进度条显示和隐藏
                mdhelperDB.mdhUser.interruptProgressBar.show = not mdhelperDB.mdhUser.interruptProgressBar.show
                mdhelperDB.mdhUser.interruptProgressBar.drag = mdhelperDB.mdhUser.interruptProgressBar.show
                if mdhelperDB.mdhUser.interruptProgressBar.show then
                    interruptProgressbar:Show()
                    btnSelf:SetText("隐藏锚点")
                else
                    interruptProgressbar:Hide()
                    btnSelf:SetText("显示锚点")
                end

                -- 调整打断进度条是否可以被拖拽
                interruptProgressbar:SetMovable(mdhelperDB.mdhUser.interruptProgressBar.drag)
                interruptProgressbar:EnableMouse(mdhelperDB.mdhUser.interruptProgressBar.drag)

                -- RaidNotice_AddMessage(RaidWarningFrame, "你被点名了！注意躲避！", ChatTypeInfo["RAID_WARNING"])
                -- SendChatMessage("BOSS技能即将释放，请注意！", "PARTY")
                -- 测试代码 判断打断法术是否存在 如果存在 判断是否冷却
                -- if mdhelperDB.playerInfo.interruptSpellID~="" then
                --     print(mdhelperDB.playerInfo.interruptSpellID)
                --     local isReady, currentCharges, maxCharges, remainingTime = mdhelper.GetSpellStatus(mdhelperDB.playerInfo.interruptSpellID)
                --     if isReady then
                --         print("法术可用，当前充能: " .. currentCharges .. "/" .. maxCharges)
                --     else
                --         print("法术冷却中，剩余时间: " .. remainingTime .. " 秒")
                --     end
                -- end

                -- 测试代码  判断 buff 335151 是否存在
                -- local buffs = mspells.GetAllHarmFulBuffs("player")
                -- local isExists = mcore.containsElement(buffs,335151)
                -- print("buff 335151 is exists", isExists)
            end)

        -- 进度条设置宽 文本
        local interruptProgressbarWidthlbl = muc.createFont(80, -50 , interruptSubPanel, "TOPLEFT", interruptSubPanel, "TOPLEFT", "进度条宽:", 15)

        -- 进度条设置宽 滑动条
        local interruptProgressbarWidthSilderBar = muc.createHorizontalSliderBar(
            "interruptProgressbarWidthSilderBar",
            interruptSubPanel,
            180, 20,
            muf.createMdhPotin(muf.Potin.TOPLEFT,muf.RelativePoint.TOPLEFT,160,-45),
            function(self, value)
                local bs = math.floor(value)
                if mdhelperDB.mdhUser.interruptProgressBar.width<300 then
                    mdhelperDB.mdhUser.interruptProgressBar.width=300
                end
                if mdhelperDB.mdhUser.interruptProgressBar.width> 400 then
                    mdhelperDB.mdhUser.interruptProgressBar.width = 400
                end
                -- self.Value:SetText(bs.."  -  "..mdhelperDB.mdhUser.interruptProgressBar.width)
                self.Value:SetText(bs)
                mdhelperDB.mdhUser.interruptProgressBar.width = mdhelperDB.mdhUser.interruptProgressBar.width + (bs);
                interruptProgressbar:SetWidth(mdhelperDB.mdhUser.interruptProgressBar.width)
            end)

        -- 进度条设置高 文本
        local interruptProgressbarHeightlbl = muc.createFont(360, -50 , interruptSubPanel, "TOPLEFT", interruptSubPanel, "TOPLEFT", "进度条高:", 15)

        -- 进度条设置高 滑动条
        local interruptProgressbarHeightSilderBar = muc.createHorizontalSliderBar(
            "interruptProgressbarHeightSilderBar",
            interruptSubPanel,
            180, 20,
            muf.createMdhPotin(muf.Potin.TOPLEFT,muf.RelativePoint.TOPLEFT,440,-45),
            function(self, value)
                local bs = math.floor(value)
                if mdhelperDB.mdhUser.interruptProgressBar.height<40 then
                    mdhelperDB.mdhUser.interruptProgressBar.height=40
                end
                if mdhelperDB.mdhUser.interruptProgressBar.height> 60 then
                    mdhelperDB.mdhUser.interruptProgressBar.height = 60
                end
                -- self.Value:SetText(bs.."  -  "..mdhelperDB.mdhUser.interruptProgressBar.height)
                self.Value:SetText(bs)
                mdhelperDB.mdhUser.interruptProgressBar.height = mdhelperDB.mdhUser.interruptProgressBar.height + (20*bs/100)-10;
                interruptProgressbar:SetHeight(mdhelperDB.mdhUser.interruptProgressBar.height)
                if #iconFrams>0 and iconFrams[1]~=nil then
                    iconFrams[1]:SetWidth(mdhelperDB.mdhUser.interruptProgressBar.height)
                    iconFrams[1]:SetHeight(mdhelperDB.mdhUser.interruptProgressBar.height)
                end

                if #timerText>0 and timerText[1]~=nil then
                    if timerText[1]~=nil then
                        local point, relativeTo, relativePoint, _, offsetY = timerText[1]:GetPoint()
                        timerText[1]:ClearAllPoints()
                        timerText[1]:SetPoint(
                            point,
                            relativeTo,
                            relativePoint,
                            mdhelperDB.mdhUser.interruptProgressBar.height+10,
                            offsetY)
                    end
                end
            end)



        -- 更新日志面板
        local updateSubPanel = CreateFrame("Frame", "updateSubPanel", UIParent)
        updateSubPanel.name = "updateSubPanel"

        -- 注册子面板
        local category3 = Settings.RegisterCanvasLayoutSubcategory(category, updateSubPanel, "更新日志")
        Settings.RegisterAddOnCategory(category3)

        -- 标题
        local updateSubPanelTitle = muc.createFont(16, -10 , updateSubPanel, "TOPLEFT", updateSubPanel, "TOPLEFT", "更新日志", 30)

        local OpenUpDate = CreateFrame("Button", "OpenUpDate", updateSubPanel, "UIPanelButtonTemplate")
        OpenUpDate:SetText("返回设置")
        OpenUpDate:SetWidth(120)
        OpenUpDate:SetHeight(22)
        OpenUpDate:SetPoint("TOPRIGHT", -5, -5)
        OpenUpDate:SetScript("OnClick", function()
            Settings.OpenToCategory(category:GetID())
        end)

        --滚动框架
        local updatescroll = CreateFrame("ScrollFrame", nil, updateSubPanel, "UIPanelScrollFrameTemplate")
        updatescroll:SetPoint("TOPLEFT", updateSubPanel, "TOPLEFT", 0, -40)
        updatescroll:SetPoint("BOTTOMRIGHT", updateSubPanel, "BOTTOMRIGHT", -20, 0)
        --滚动内容
        local ConFrame = CreateFrame("Frame", nil, updatescroll)
        ConFrame:SetSize(670,480)
        updatescroll:SetScrollChild(ConFrame)
        mdhelper.updateY = 0	--设置起始位置

        local Yoffset = -10
        local textcolor = {0.8, 0.8, 0.8, 0.9}
        local function AddUpdate(name)
            local rowFrame = CreateFrame("Frame", nil, ConFrame)

            rowFrame:SetPoint("TOPLEFT", 10, Yoffset)
            rowFrame:SetSize(630, 26)
            local SliderBackground = rowFrame:CreateTexture(nil, "BACKGROUND")
            SliderBackground:SetTexture(130937)
            SliderBackground:SetPoint("TOPLEFT",rowFrame,"TOPLEFT",0,0)
            SliderBackground:SetColorTexture(0.5, 0.5, 0.5, 0.1) -- 设置背景颜色为黑色，透明度为0.5
            SliderBackground:SetScript("OnEnter", function(self)
                self:SetColorTexture(0.5, 0.5, 0.5, .3)
            end)
            SliderBackground:SetScript("OnLeave", function(self)
                self:SetColorTexture(0.5, 0.5, 0.5, 0.1)
            end)

            local lefttext = rowFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
            lefttext:SetPoint("LEFT", SliderBackground, "LEFT", 5, -1)
            lefttext:SetText(name)
            lefttext:SetFont("fonts\\ARHei.ttf", 18, "OUTLINE")
            lefttext:SetJustifyH("LEFT") 
            lefttext:SetWordWrap(true)--换行
            lefttext:SetWidth(623)
            lefttext:SetSpacing(6)--间距
            lefttext:SetTextColor(unpack(textcolor))--颜色
            SliderBackground:SetSize(630,lefttext:GetHeight()+15)--背景颜色根据字体框架高度设置

            Yoffset = Yoffset - 25 - lefttext:GetHeight()--后面的位置

            textcolor = {0.6, 0.6, .6, 0.6}
            mdhelper.updateY = mdhelper.updateY + 1
        end

        -- 收集更新表格
        local keys = {}
        for k in pairs(mdhelper.update) do
            table.insert(keys, k)
        end

        -- 对表格进行排序
        table.sort(keys, function(a, b) return a > b end)

        -- 根据排序后的表格创建文本
        for _, k in ipairs(keys) do
            AddUpdate("|cff00FFFF"..k.." : |r"..mdhelper.update[k])
        end
    end
end)