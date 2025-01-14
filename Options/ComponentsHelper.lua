local addonName, mdhelper = ...
local muc = mdhelper.UI.components

----------------------------------------------------------------------------------------------------------------------
---注册category到addonCategory
----------------------------------------------------------------------------------------------------------------------
function muc.registerCanvasLayoutCategory(mainCategory)
	-- 注册到插件选项界面
	local registerCategory = Settings.RegisterCanvasLayoutCategory(
		mainCategory.frame, mainCategory.text)
	Settings.RegisterAddOnCategory(registerCategory)
	return registerCategory
end

----------------------------------------------------------------------------------------------------------------------
---注册subcategory到 mainCategory
----------------------------------------------------------------------------------------------------------------------
function muc.registerSubCanvasLayoutCategory(mainCategory, subCategorys)
	local registerSubCategorys = {}
	if subCategorys ~= nil and #subCategorys > 0 then
		for i, v in ipairs(subCategorys) do
			local subCategory = v
			local registerSubCategory =
				Settings.RegisterCanvasLayoutSubcategory(mainCategory,
					subCategory.frame,
					subCategory.text)
			Settings.RegisterAddOnCategory(registerSubCategory)
			table.insert(registerSubCategorys, registerSubCategory)
		end
	end

	return registerSubCategorys
end

----------------------------------------------------------------------------------------------------------------------
---创建水平滑动条
----------------------------------------------------------------------------------------------------------------------
function muc.createHorizontalSliderBar(sliderBarName, parentUI, width, height,
									   mdhPotin, soliderHandler)
	-- 创建一个滑动条
	local slider = CreateFrame("Slider", sliderBarName, parentUI,
		"OptionsSliderTemplate")
	slider:SetSize(width, height)    -- 设置滑动条的宽度和高度
	slider:SetPoint(mdhPotin.point, parentUI, mdhPotin.relativePoint,
		mdhPotin.offx, mdhPotin.offy) -- 将文本框置于屏幕中央
	slider:SetMinMaxValues(0, 100)   -- 设置滑动条的最小值和最大值
	slider:SetValue(50)              -- 设置滑动条的初始值
	slider:SetValueStep(1)           -- 设置滑动条的步进值
	slider:SetOrientation("HORIZONTAL") -- 水平滑动条 HORIZONTAL

	-- 设置滑动条值的显示
	slider.Value = slider:CreateFontString(nil, "ARTWORK",
		"GameFontHighlightSmall")
	slider.Value:SetPoint("TOP", slider, "BOTTOM", 0, -2) -- 值显示在滑动条的下方
	slider.Value:SetText(slider:GetValue())            -- 初始化值显示

	-- 当滑动条的值发生变化时更新显示
	slider:SetScript("OnValueChanged",
		function(self, value) soliderHandler(self, value) end)
	-- 创建菜单框架
	return slider
end

----------------------------------------------------------------------------------------------------------------------
---创建垂直滑动条
----------------------------------------------------------------------------------------------------------------------
function muc.createVerticalSliderBar(sliderBarName, parentUI, width, height,
									 mdhPotin, soliderHandler)
	-- 创建滑动条的滑块
	local slider = CreateFrame("Slider", sliderBarName, parentUI)
	slider:SetSize(width, height)
	slider:SetPoint(mdhPotin.point, parentUI, mdhPotin.relativePoint,
		mdhPotin.offx, mdhPotin.offy) -- 将文本框置于屏幕中央
	slider:SetMinMaxValues(0, 100) -- 设置滑动条的最小值和最大值
	slider:SetValue(50)            -- 设置滑动条的初始值
	slider:SetValueStep(1)         -- 设置滑动条的步进值
	slider:SetOrientation("VERTICAL") -- 水平滑动条 HORIZONTAL

	-- 设置滑动条值的显示
	slider.Value = slider:CreateFontString(nil, "ARTWORK",
		"GameFontHighlightSmall")
	slider.Value:SetPoint("TOP", slider, "BOTTOM", 0, -2) -- 值显示在滑动条的下方
	slider.Value:SetText(slider:GetValue())            -- 初始化值显示

	-- 当滑动条值变化时，打印出当前的值
	slider:SetScript("OnValueChanged",
		function(self, value) soliderHandler(self, value) end)

	-- 创建菜单框架
	return slider
end

----------------------------------------------------------------------------------------------------------------------
---创建进度条
----------------------------------------------------------------------------------------------------------------------
-- comment
---@param progressBarName any	进度条Name
---@param parentUI any	进度条基于的父级框架
---@param width any
---@param height any
---@param mdhPotin any
---@param minValue any
---@param maxValue any
---@param defaultSetting any {drag=true|false,show=true|false}
---@param progressTexts any { { point=mdhTextPotin.point,relativePoint=mdhTextPotin.relativePoint,offx=mdhTextPotin.offx,offy=mdhTextPotin.offy,text="" } }
---@param progressIcons any { { point=mdhTextPotin.point,relativePoint=mdhTextPotin.relativePoint,offx=mdhTextPotin.offx,offy=mdhTextPotin.offy,width=0,height=0,iconID = -1 } }
---@return table|StatusBar
---@return FontString
function muc.createProgressBar(progressBarName, parentUI, width, height,
							   barTexture, mdhPotin, minValue, maxValue,
							   defaultSetting, progressTexts, progressIcons)
	local progressBar = CreateFrame("StatusBar", progressBarName, parentUI) -- 创建进度条

	progressBar:SetSize(width, height)                                   -- 设置进度条大小
	progressBar:SetPoint(mdhPotin.point, parentUI, mdhPotin.relativePoint,
		mdhPotin.offx, mdhPotin.offy)                                    -- 将文本框置于屏幕中央
	progressBar:SetMinMaxValues(minValue, maxValue)                      -- 设置进度条的最小值和最大值
	progressBar:SetValue(0)                                              -- 初始化进度条为 0
	progressBar:SetStatusBarTexture(barTexture)                          -- 设置进度条样式

	-- 启用拖拽功能
	progressBar:SetMovable(defaultSetting.drag or false)
	progressBar:EnableMouse(defaultSetting.drag or false)
	progressBar:SetClampedToScreen(true) -- 防止框架被拖出屏幕

	if not defaultSetting.show or defaultSetting.show == false then
		progressBar:Hide()
	else
		progressBar:Show()
	end

	-- 创建背景纹理
	local bgTexture = progressBar:CreateTexture(nil, "BACKGROUND")
	bgTexture:SetAllPoints(progressBar)        -- 背景填满进度条
	bgTexture:SetColorTexture(0.1, 0.1, 0.1, 0.7) -- 设置背景色为深灰色，透明度 0.7

	local pTexts = {}
	if #progressTexts > 0 then
		for index = 1, #progressTexts do
			local pTextPotin = progressTexts[index].point
			local pTextRelativePotin = progressTexts[index].relativePoint
			local pTextOffx = progressTexts[index].offx
			local pTextOffy = progressTexts[index].offy
			local pTextText = progressTexts[index].text
			local timerText = progressBar:CreateFontString(nil, "OVERLAY",
				"GameFontNormal") -- 创建文本显示
			timerText:SetPoint(pTextPotin, progressBar, pTextRelativePotin,
				pTextOffx, pTextOffy) -- 将文本框置于屏幕中央
			timerText:SetText(pTextText) -- 初始化文本内容
			table.insert(pTexts, timerText)
		end
	end

	local pIconFrams = {}
	if #progressIcons > 0 then
		for index = 1, #progressIcons do
			local pIconPotin = progressIcons[index].point
			local pIconRelativePotin = progressIcons[index].relativePoint
			local pIconOffx = progressIcons[index].offx
			local pIconOffy = progressIcons[index].offy
			local pIconWidth = progressIcons[index].width or width
			local pIconHeight = progressIcons[index].height or height
			local pIcon = progressIcons[index].iconID
			local iconFrame = CreateFrame("Frame", nil, progressBar)
			iconFrame:SetSize(pIconWidth, pIconHeight) -- 设置图标大小
			iconFrame:SetPoint(pIconPotin, progressBar, pIconRelativePotin,
				pIconOffx, pIconOffy)         -- 设置图标位置

			-- 创建纹理
			iconFrame.iconTexture = iconFrame:CreateTexture(nil, "ARTWORK")
			iconFrame.iconTexture:SetAllPoints(iconFrame) -- 填满框架
			if pIcon ~= nil then
				iconFrame.iconTexture:SetTexture(pIcon) -- 设置法术图标纹理
			end

			table.insert(pIconFrams, iconFrame)
		end
	end

	-- 鼠标按下时开始拖拽
	progressBar:SetScript("OnMouseDown", function(self, button)
		if button == "LeftButton" and
			mdhelperDB.mdhUser.interruptProgressBar.drag then
			self:StartMoving() -- 开始拖拽
		end
	end)

	-- 鼠标松开时停止拖拽
	progressBar:SetScript("OnMouseUp", function(self)
		self:StopMovingOrSizing() -- 停止拖拽
		local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint()
		mdhelperDB.mdhUser.interruptProgressBar.point = point;
		mdhelperDB.mdhUser.interruptProgressBar.relativePoint = relativePoint;
		mdhelperDB.mdhUser.interruptProgressBar.offx = xOfs;
		mdhelperDB.mdhUser.interruptProgressBar.offy = yOfs;
	end)

	if mdhelperDB.mdhUser.interruptProgressBar.show then
		progressBar:Show()
	else
		progressBar:Hide()
	end

	-- 创建菜单框架
	return progressBar, pTexts, pIconFrams
end

----------------------------------------------------------------------------------------------------------------------
---创建文本
----------------------------------------------------------------------------------------------------------------------
function muc.createFont(createframe, mdhPotin, text, fontsize)
	local font = createframe:CreateFontString(nil, "ARTWORK",
		"GameFontNormalLarge")
	font:SetPoint(mdhPotin.point, createframe, mdhPotin.relativePoint,
		mdhPotin.offx, mdhPotin.offy)
	font:SetText(text)
	font:SetFont("fonts\\ARHei.ttf", fontsize, "OUTLINE")
	return font
end

----------------------------------------------------------------------------------------------------------------------
---创建文本框
----------------------------------------------------------------------------------------------------------------------
function muc.createTextBox(txtBoxName, parentUI, width, height, mdhPotin,
						   defaultTxt)
	-- 创建一个文本框
	local textBox = CreateFrame("EditBox", txtBoxName, parentUI,
		"InputBoxTemplate")
	textBox:SetSize(width, height) -- 设置宽度和高度
	textBox:SetPoint(mdhPotin.point, parentUI, mdhPotin.relativePoint,
		mdhPotin.offx, mdhPotin.offy)
	textBox:SetFontObject(GameFontNormal) -- 设置字体
	textBox:SetAutoFocus(false)        -- 禁止自动聚焦，避免影响其他操作
	if defaultTxt ~= nil and defaultTxt ~= "" then
		textBox:SetText(defaultTxt)    -- 设置默认文本
	end
	return textBox
end

----------------------------------------------------------------------------------------------------------------------
---创建按钮
----------------------------------------------------------------------------------------------------------------------
function muc.createButton(btnName, btnText, parentUI, btnWidth, btnHeight,
						  mdhPotin, btnClickHandler)
	local button = CreateFrame("Button", btnName, parentUI,
		"UIPanelButtonTemplate")
	button:SetText(btnText)
	button:SetWidth(btnWidth)
	button:SetHeight(btnHeight)
	button:SetPoint(mdhPotin.point, parentUI, mdhPotin.relativePoint,
		mdhPotin.offx, mdhPotin.offy) -- 将文本框置于屏幕中央
	button:SetScript("OnClick", function(self) btnClickHandler(self) end)
	return button
end

----------------------------------------------------------------------------------------------------------------------
---创建checkBox 基于 3列创建
----------------------------------------------------------------------------------------------------------------------
local clickXOffset1, clickXOffset2, clickXOffset3 = 0, 0, 0
function muc.createCheckboxBy3Column(checkBoxName, parentUI, clickX, text, tip,
									 defaultCheck, clickHandler)
	local x, y
	if clickX == 1 then
		x = 16
		y = clickXOffset1 * -30 - 150
		clickXOffset1 = clickXOffset1 + 1
	elseif clickX == 2 then
		x = 226
		y = clickXOffset2 * -30 - 150
		clickXOffset2 = clickXOffset2 + 1
	elseif clickX == 3 then
		x = 446
		y = clickXOffset3 * -30 - 150
		clickXOffset3 = clickXOffset3 + 1
	end
	if text == "" then return end
	local check = CreateFrame("CheckButton", checkBoxName, parentUI,
		"InterfaceOptionsCheckButtonTemplate")
	check:SetPoint("TOPLEFT", parentUI, "TOPLEFT", x, y)
	check:SetChecked(defaultCheck)
	check.text:SetText(text)
	check:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine("|cffFFFFFF" .. tip .. "|r")
		GameTooltip:Show()
	end)
	check:SetScript("OnLeave", function(self) GameTooltip:Hide() end)

	check:SetScript("OnClick", function(self) clickHandler(self) end)

	return check
end

----------------------------------------------------------------------------------------------------------------------
---创建checkBox
----------------------------------------------------------------------------------------------------------------------
function muc.createCheckbox(checkBoxName, parentUI, mdhPotin, text, tip,
							defaultCheck, clickHandler)
	if text == "" then return end
	local check = CreateFrame("CheckButton", checkBoxName, parentUI,
		"InterfaceOptionsCheckButtonTemplate")
	check:SetPoint(mdhPotin.point, parentUI, mdhPotin.relativePoint,
		mdhPotin.offx, mdhPotin.offy)
	check:SetChecked(defaultCheck)
	check.text:SetText(text)
	-- 鼠标移入显示 tip
	check:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine("|cffFFFFFF" .. tip .. "|r")
		GameTooltip:Show()
	end)
	-- 鼠标移除 隐藏 tip
	check:SetScript("OnLeave", function(self) GameTooltip:Hide() end)

	check:SetScript("OnClick", function(self) clickHandler(self) end)

	return check
end

----------------------------------------------------------------------------------------------------------------------
---创建滚动面板
----------------------------------------------------------------------------------------------------------------------

---comment
---@param tabButtonsFramePoint any { point=mdhTextPotin.TOP,relativePoint=mdhTextPotin.TOP,offx=0,offy=-10 }
---@param tabButtonsFrameSize any	{width=380,height=40}
---@param tabContentFramePoint any { point=mdhTextPotin.TOP,relativePoint=mdhTextPotin.TOP,offx=0,offy=-30 }
---@param tabContentFrameSize any {width=380,height=200}
---@param parentUI any	parentUI
---@param tabButtons any { { width=90,height=30,text="",point="LEFT",relativePoint="LEFT",interval=10,offy=0,clickHanderl=nil } }
function muc.createTabPanls(tabButtonsFramePoint, tabButtonsFrameSize,
							tabContentFramePoint, tabContentFrameSize, parentUI,
							tabButtons)
	-- 创建 Tab 按钮容器
	local tabButtonsFrame = CreateFrame("Frame", nil, parentUI)
	tabButtonsFrame:SetSize(tabButtonsFrameSize.width,
		tabButtonsFrameSize.height)
	tabButtonsFrame:SetPoint(tabButtonsFramePoint.point, parentUI,
		tabButtonsFramePoint.relativePoint,
		tabButtonsFramePoint.offx,
		tabButtonsFramePoint.offy)

	-- 创建标签页内容容器
	local tabContentFrame = CreateFrame("Frame", nil, parentUI)
	tabContentFrame:SetSize(tabContentFrameSize.width,
		tabContentFrameSize.height)
	tabContentFrame:SetPoint(tabContentFramePoint.point, parentUI,
		tabContentFramePoint.relativePoint,
		tabContentFramePoint.offx,
		tabContentFramePoint.offy)

	-- 创建 Tab 按钮
	local tabs = {}
	local tabContents = {}
	-- 创建 Tab 按钮和内容
	local function CreateTab(index, tabButton)
		-- Tab 按钮 local
		local currentTabButton = CreateFrame("Button", nil, tabButtonsFrame,
			"UIPanelButtonTemplate")
		currentTabButton:SetSize(tabButton.width, tabButton.height)
		if not tabButton.text or #tabButton.text == 0 then
			currentTabButton:SetText("Tab" .. index)
		else
			currentTabButton:SetText(tabButton.text)
		end
		currentTabButton:SetPoint(
			tabButton.point,
			tabButtonsFrame,
			tabButton.relativePoint,
			(index - 1) * tabButton.width + tabButton.interval,
			tabButton.offy)
		-- 设置按钮背景为透明
		currentTabButton:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
			edgeSize = 16,
			insets = { left = 4, right = 4, top = 4, bottom = 4 },
		})
		currentTabButton:SetBackdropColor(0, 0, 0, 0.5)
		currentTabButton:SetBackdropBorderColor(0.7, 0.7, 0.7)
		currentTabButton.index = index
		table.insert(tabs, currentTabButton)

		-- 内容 Frame
		local content = CreateFrame("Frame", nil, tabContentFrame)
		content:SetAllPoints(tabContentFrame)
		content:Hide()
		tabContents[index] = content
		-- Tab 按钮点击切换内容
		currentTabButton:SetScript("OnClick", function(btn, ...)
			for i, tab in ipairs(tabs) do
				if i == tabButton.index then
					tabContents[i]:Show()
				else
					tabContents[i]:Hide()
				end
			end
			if tabButton.clickHandler then
				tabButton.clickHandler(btn)
			end
		end)
		-- 默认显示第一个 Tab 的内容
		if index == 1 then content:Show() end
	end

	if #tabButtons > 0 then
		for i, v in pairs(tabButtons) do
			local tabButton = tabButtons[i]
			CreateTab(i, tabButton)
		end
		return tabs, tabContents
	else
		return nil
	end
end

----------------------------------------------------------------------------------------------------------------------
---创建滚动面板
----------------------------------------------------------------------------------------------------------------------

function muc.createScroll(scrollName, parentUI, scrollFrameSize)
	-- 创建内容框架
	local scrollFrame = CreateFrame("Frame", scrollName, parentUI)
	scrollFrame:SetSize(scrollFrameSize.width, scrollFrameSize.height) -- 高度大于滚动框架，激活滚动功能
	parentUI:SetScrollChild(scrollFrame)
	-- 绑定鼠标滚轮事件，增加用户体验
	scrollFrame:EnableMouseWheel(true)
	scrollFrame:SetScript("OnMouseWheel", function(self, delta)
		local currentScroll = self:GetVerticalScroll()
		local maxScroll = self:GetVerticalScrollRange()
		self:SetVerticalScroll(math.max(0, math.min(maxScroll,
			currentScroll - delta * 20)))
	end)
	return scrollFrame
end
