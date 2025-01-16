local addonName, mdhelper = ...
local muc = mdhelper.UI.components
local mf = mdhelper.fonts
local mfx = mdhelper.fonts.fontXmlTemplate
--[[
mdhelper.UI.components ui界面创建框架、元素等相关方法
]] --

----------------------------------------------------------------------------------------------------------------------
---注册category到addonCategory
---@param mainCategory table 主面板 { frame=oneFrame, text = "面板中文名" }
---@return table 当前注册的面板
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
---frame
function muc.createFrame(frameType, frmaName, parentUI, xmlTemplate, uiPoint, size, backdrop, color)
	local frame = {}
	if xmlTemplate ~= nil then
		if frameType ~= nil then
			frame = CreateFrame(frameType, frmaName, parentUI, xmlTemplate)
		else
			frame = CreateFrame("Frame", frmaName, parentUI, xmlTemplate)
		end
	else
		if frameType ~= nil then
			frame = CreateFrame(frameType, frmaName, parentUI)
		else
			frame = CreateFrame("Frame", frmaName, parentUI)
		end
	end

	if uiPoint ~= nil then
		if #uiPoint == 4 then
			table.insert(uiPoint, 2, parentUI) -- 插入父框架
		end
		frame:SetPoint(unpack(uiPoint))
	end
	if size ~= nil then
		frame:SetSize(unpack(size))
	end
	if backdrop ~= nil then
		frame:SetBackdrop({
			bgFile = backdrop.bgFile, -- 背景纹理
			edgeFile = backdrop.edgeFile, -- 边框纹理
			edgeSize = backdrop.edgeSize,
			insets = { left = backdrop.insets.left, right = backdrop.insets.right, top = backdrop.insets.top, bottom = backdrop.insets.bottom },
		})
	end

	if color ~= nil then
		if color.backdropColor ~= nil then
			frame:SetBackdropColor(unpack(color.backdropColor))
		end
		if color.backdropBorderColor ~= nil then
			frame:SetBackdropBorderColor(unpack(color.backdropBorderColor))
		end
	end

	if frameType == "ScrollFrame" then
		frame.ScrollBar:Show()
	end
	return frame
end

----------------------------------------------------------------------------------------------------------------------
---水平滑动条
----------------------------------------------------------------------------------------------------------------------
function muc.createHorizontalSliderBar(sliderBarName, parentUI, xmlTemplate, size,
									   uiPoint, soliderHandler)
	-- 创建一个滑动条
	local slider = CreateFrame("Slider", sliderBarName, parentUI, xmlTemplate or "OptionsSliderTemplate")
	slider:SetSize(unpack(size))
	if uiPoint ~= nil then
		if #uiPoint == 4 then
			table.insert(uiPoint, 2, parentUI) -- 插入父框架
		end
		slider:SetPoint(unpack(uiPoint))
	end                              -- 设置滑动条的宽度和高度
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
---垂直滑动条
function muc.createVerticalSliderBar(sliderBarName, parentUI, xmlTemplate, size,
									 uiPoint, soliderHandler)
	-- 创建滑动条的滑块
	local slider = CreateFrame("Slider", sliderBarName, parentUI, xmlTemplate or "OptionsSliderTemplate")
	slider:SetSize(unpack(size))
	if uiPoint ~= nil then
		if #uiPoint == 4 then
			table.insert(uiPoint, 2, parentUI) -- 插入父框架
		end
		slider:SetPoint(unpack(uiPoint))
	end
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
---创进度条
----------------------------------------------------------------------------------------------------------------------
-- comment
---@param progressBarName string	
---进度条Name
---@param parentUI any	
---进度条基于的父级框架
---@param xmlTemplate string
---@param size any
---{width=100,height=20}
---@param barTexture string
---@param uiPoint any
---{ point="TOP",relativePoint="TOP",offx=0,offy=0 }
---@param minValue number
---@param maxValue number
---@param defaultSetting any
---{drag=true|false,show=true|false}
---@param progressTexts any
---{
---		{
---			uiPoint = { point="TOP",relativePoint="TOP",offx=0,offy=0 },
---			text=""
---		}
---}
---@param progressIcons any
---{
--- 	{
--- 		uiPoint = { point="TOP", relativePoint="TOP", offx=0, offy=0 },
--- 		size = { width=0,height=0 }
--- 		iconID = -1
--- 	}
--- }
---@return table|StatusBar
---@return FontString
function muc.createProgressBar(progressBarName, parentUI, xmlTemplate, size,
							   barTexture, uiPoint, minValue, maxValue,
							   defaultSetting, progressTexts, progressIcons)
	local progressBar = {}
	-- 创建进度条
	if xmlTemplate ~= nil then
		progressBar = CreateFrame("StatusBar", progressBarName, parentUI, xmlTemplate)
	else
		progressBar = CreateFrame("StatusBar", progressBarName, parentUI)
	end

	progressBar:SetSize(unpack(size))
	if uiPoint ~= nil then
		if #uiPoint == 4 then
			table.insert(uiPoint, 2, parentUI) -- 插入父框架
		end
		progressBar:SetPoint(unpack(uiPoint))
	end
	progressBar:SetMinMaxValues(minValue, maxValue) -- 设置进度条的最小值和最大值
	progressBar:SetValue(0)                      -- 初始化进度条为 0
	progressBar:SetStatusBarTexture(barTexture)  -- 设置进度条样式

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
			local pTextText = progressTexts[index].text
			local timerText = progressBar:CreateFontString(nil, "OVERLAY", "GameFontNormal") -- 创建文本显示
			if progressTexts[index].uiPoint ~= nil then
				local pupt = progressTexts[index].uiPoint
				if #pupt == 4 then
					table.insert(pupt, 2, progressBar) -- 插入父框架
				end
				timerText:SetPoint(unpack(pupt))
			end
			timerText:SetText(pTextText) -- 初始化文本内容
			table.insert(pTexts, timerText)
		end
	end

	local pIconFrams = {}
	if #progressIcons > 0 then
		for index = 1, #progressIcons do
			local pIcon = progressIcons[index].iconID or nil
			local iconFrame = CreateFrame("Frame", nil, progressBar)
			iconFrame:SetSize(unpack(progressIcons[index].size)) -- 设置图标大小
			if progressIcons[index].uiPoint ~= nil then
				local pup = progressIcons[index].uiPoint
				if #pup == 4 then
					table.insert(pup, 2, progressBar) -- 插入父框架
				end
				iconFrame:SetPoint(unpack(pup))
			end


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
---文本
----------------------------------------------------------------------------------------------------------------------
function muc.createFont(createframe, stringName, layer, xmlTemplate, uiPoint, text, fontSetting)
	-- 创建 FontString
	local font = createframe:CreateFontString(
		stringName,
		layer or "ARTWORK",
		xmlTemplate or mfx.GameFontNormal)

	-- 设置锚点
	if uiPoint then
		if #uiPoint == 4 then
			table.insert(uiPoint, 2, createframe) -- 插入父框架
		end
		font:SetPoint(unpack(uiPoint))
	end

	-- 设置文本内容
	if text then
		font:SetText(text)
	end

	-- 设置字体
	if fontSetting then
		if type(fontSetting) == "table" then
			font:SetFont(unpack(fontSetting))
		elseif type(fontSetting) == "number" then
			font:SetFont(mf.ARHei, fontSetting, "OUTLINE")
		else
			font:SetFont(mf.ARHei, 15, "OUTLINE") -- 默认字体大小
		end
	else
		font:SetFont(mf.ARHei, 15, "OUTLINE") -- 默认字体大小
	end

	return font
end

----------------------------------------------------------------------------------------------------------------------
---文本框
function muc.createTextBox(txtBoxName, parentUI, xmlTemplate, size, uiPoint, defaultTxt)
	-- 创建一个文本框
	local textBox = CreateFrame("EditBox", txtBoxName, parentUI, xmlTemplate or "InputBoxTemplate")

	textBox:SetSize(unpack(size)) -- 设置宽度和高度
	if uiPoint ~= nil then
		if #uiPoint == 4 then
			table.insert(uiPoint, 2, parentUI) -- 插入父框架
		end
		textBox:SetPoint(unpack(uiPoint))
	end

	textBox:SetAutoFocus(false) -- 禁止自动聚焦，避免影响其他操作
	if defaultTxt ~= nil and defaultTxt ~= "" then
		textBox:SetText(defaultTxt) -- 设置默认文本
	end
	return textBox
end

----------------------------------------------------------------------------------------------------------------------
---按钮
function muc.createButton(btnName, btnText, parentUI, xmlTemplate, size,
						  uiPoint, btnClickHandler)
	local button = {}
	if xmlTemplate ~= nil then
		button = CreateFrame("Button", btnName or nil, parentUI, xmlTemplate)
	else
		button = CreateFrame("Button", btnName or nil, parentUI)
	end

	button:SetText(btnText)
	if size ~= nil then
		button:SetSize(unpack(size))
	end
	if uiPoint ~= nil then
		if #uiPoint == 4 then
			table.insert(uiPoint, 2, parentUI) -- 插入父框架
		end
		button:SetPoint(unpack(uiPoint))
	end
	if btnClickHandler ~= nil then
		button:SetScript("OnClick", function(self) btnClickHandler(self) end)
	end
	return button
end

----------------------------------------------------------------------------------------------------------------------
---checkBox 基于 3列创建
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
---checkBox
----------------------------------------------------------------------------------------------------------------------
function muc.createCheckbox(checkBoxName, parentUI, xmlTemplate, uiPoint, text, tip,
							defaultCheck, clickHandler)
	if text == "" then return end
	local check = {}
	if xmlTemplate ~= nil then
		check = CreateFrame("CheckButton", checkBoxName, parentUI,
			xmlTemplate)
	else
		check = CreateFrame("CheckButton", checkBoxName, parentUI)
	end
	if uiPoint ~= nil then
		if #uiPoint == 4 then
			table.insert(uiPoint, 2, parentUI) -- 插入父框架
		end
		check:SetPoint(unpack(uiPoint))
	end
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
---ScrollFrame SetScrollChild and ScrollFrameScrollBar init scroll
function muc.scrollFrameSetScrollChildAndScrollFrameScrollBarInitScroll(
	scrollFrame,
	scrollChildContentFrame,
	scrollSetting,
	scrollFrameOnSizeChangedHandler)
	scrollFrame:SetScrollChild(scrollChildContentFrame) -- 设定滚动框架的滚动子Frame
	-- 初始化滚动条
	local scrollFrameScrollbar = scrollFrame.ScrollBar
	scrollFrameScrollbar:SetMinMaxValues(
		scrollSetting.minValue,
		scrollChildContentFrame:GetHeight() - scrollFrame:GetHeight())
	scrollFrameScrollbar:SetValueStep(scrollSetting.step)
	scrollFrameScrollbar:SetValue(scrollSetting.defaultValue)
	scrollFrame:SetScript("OnSizeChanged", function()
		if scrollFrameOnSizeChangedHandler ~= nill then
			scrollFrameOnSizeChangedHandler()
		else
			scrollFrameScrollbar:SetMinMaxValues(
				0,
				math.max(0, scrollChildContentFrame:GetHeight() - scrollFrame:GetHeight()))
		end
	end)
end

----------------------------------------------------------------------------------------------------------------------
---createTableRow
function muc.createTableRow(rowParentUI,
							rowData,
							rowHeight,
							rowBackDropColor,
							cellSize,
							cellWidth,
							cellTextPoint,
							deleteBtn,
							rowIndex,
							cellCount)
	local row = muc.createFrame(nil, nil, rowParentUI, nil, nil, { rowParentUI:GetWidth() - 20, rowHeight })
	-- 行背景
	local rowBg = row:CreateTexture(nil, "BACKGROUND")
	rowBg:SetAllPoints()
	if rowBackDropColor ~= nil and rowBackDropColor.defaultColor ~= nil then
		rowBg:SetColorTexture(unpack(rowBackDropColor.defaultColor)) -- 默认透明背景
	end

	if rowBackDropColor ~= nil and rowBackDropColor.defaultColor ~= nil and rowBackDropColor.enterColor ~= nil then
		row:SetScript("OnEnter", function()
			rowBg:SetColorTexture(unpack(rowBackDropColor.enterColor)) -- 鼠标移入背景色
		end)
		row:SetScript("OnLeave", function()
			rowBg:SetColorTexture(unpack(rowBackDropColor.defaultColor)) -- 鼠标移出恢复透明
		end)
	end

	-- 创建列
	for index, value in pairs(rowData) do
		local cell = muc.createFrame(nil, nil, row, nil, { "LEFT", "LEFT", (index - 1) * cellWidth, 0 }, cellSize) -- point default "LEFT", row, "LEFT", (j - 1) * cellWidth, 0
		local cellText = muc.createFont(
			cell,
			nil,
			nil,
			nil,
			cellTextPoint,
			value,
			15)
	end
	if rowIndex ~= 1 then
		if deleteBtn ~= nil then
			-- 删除按钮
			local deleteButton = muc.createButton(
				nil,
				deleteBtn.btnText,
				row,
				deleteBtn.xmlTemplate,
				deleteBtn.size,
				{ "LEFT", row, "LEFT", (cellCount - 1) * cellWidth + 20, 0 },
				function(self)
					deleteBtn.btnClickHandler(self)
				end
			)
			deleteButton.Tip = rowIndex
		end
	end
	row.rowIndex = rowIndex
	return row
end
