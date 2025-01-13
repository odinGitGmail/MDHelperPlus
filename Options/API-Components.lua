local addonName,mdhelper = ...
local mcore = mdhelper.Core
local mspells = mdhelper.Spells
local muc = mdhelper.UI.components
local mucf = mdhelper.UI.components.Func
local muf = mdhelper.UI.Func



----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------



-- 创建水平滑动条
function muc.createHorizontalSliderBar(sliderBarName, basicUI, width, height,mdhPotin, soliderHandler)
	-- 创建一个滑动条
	local slider = CreateFrame("Slider", sliderBarName, basicUI, "OptionsSliderTemplate")
	slider:SetSize(width, height)  -- 设置滑动条的宽度和高度
	slider:SetPoint(mdhPotin.point, basicUI, mdhPotin.relativePoint, mdhPotin.offx, mdhPotin.offy) -- 将文本框置于屏幕中央
	slider:SetMinMaxValues(0, 100)  -- 设置滑动条的最小值和最大值
	slider:SetValue(50)  -- 设置滑动条的初始值
	slider:SetValueStep(1)  -- 设置滑动条的步进值
	slider:SetOrientation("HORIZONTAL")  -- 水平滑动条 HORIZONTAL

	-- 设置滑动条值的显示
	slider.Value = slider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	slider.Value:SetPoint("TOP", slider, "BOTTOM", 0, -2)  -- 值显示在滑动条的下方
	slider.Value:SetText(slider:GetValue())  -- 初始化值显示

	-- 当滑动条的值发生变化时更新显示
	slider:SetScript("OnValueChanged", function(self, value)
		soliderHandler(self, value)
	end)
    -- 创建菜单框架
    return slider
end

-- 创建垂直滑动条
function muc.createVerticalSliderBar(sliderBarName, basicUI, width, height,mdhPotin, soliderHandler)
	-- 创建滑动条的滑块
	local slider = CreateFrame("Slider", sliderBarName, basicUI)
	slider:SetSize(width, height)
	slider:SetPoint(mdhPotin.point, basicUI, mdhPotin.relativePoint, mdhPotin.offx, mdhPotin.offy) -- 将文本框置于屏幕中央
	slider:SetMinMaxValues(0, 100)  -- 设置滑动条的最小值和最大值
	slider:SetValue(50)  -- 设置滑动条的初始值
	slider:SetValueStep(1)  -- 设置滑动条的步进值
	slider:SetOrientation("VERTICAL")  -- 水平滑动条 HORIZONTAL

	-- 设置滑动条值的显示
	slider.Value = slider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	slider.Value:SetPoint("TOP", slider, "BOTTOM", 0, -2)  -- 值显示在滑动条的下方
	slider.Value:SetText(slider:GetValue())  -- 初始化值显示

	-- 当滑动条值变化时，打印出当前的值
	slider:SetScript("OnValueChanged", function(self, value)
		soliderHandler(self, value)
	end)

    -- 创建菜单框架
    return slider
end

-- 创建进度条
-- function muc.createProgressBar(progressBarName, basicUI, width, height, mdhPotin, minValue,maxValue,mdhTextPotin, defaultSetting, defaultTxt)
-- 	local progressBar = CreateFrame("StatusBar", progressBarName, basicUI) -- 创建进度条
-- 	local timerText = progressBar:CreateFontString(nil, "OVERLAY", "GameFontNormal") -- 创建文本显示
-- 	progressBar:SetSize(width, height) -- 设置进度条大小
--     progressBar:SetPoint(mdhPotin.point, basicUI, mdhPotin.relativePoint, mdhPotin.offx, mdhPotin.offy)-- 将文本框置于屏幕中央
--     progressBar:SetMinMaxValues(minValue, maxValue) -- 设置进度条的最小值和最大值
--     progressBar:SetValue(0) -- 初始化进度条为 0
--     progressBar:SetStatusBarTexture("Interface\\Addons\\AddUI\\UI\\Textures\\colorbar.tga") -- 设置进度条样式


--       -- 创建背景纹理
--     local bgTexture = progressBar:CreateTexture(nil, "BACKGROUND")
--     bgTexture:SetAllPoints(progressBar) -- 背景填满进度条
--     bgTexture:SetColorTexture(0.1, 0.1, 0.1, 0.7) -- 设置背景色为深灰色，透明度 0.7



--     timerText:SetPoint(mdhTextPotin.point, progressBar, mdhTextPotin.relativePoint, mdhTextPotin.offx, mdhTextPotin.offy)-- 将文本框置于屏幕中央
--     timerText:SetText(defaultTxt) -- 初始化文本内容

--     -- 启用拖拽功能
--     progressBar:SetMovable(defaultSetting.drag)
-- 	progressBar:EnableMouse(defaultSetting.drag)
-- 	progressBar:SetClampedToScreen(true)  -- 防止框架被拖出屏幕

-- 	progressBar:Hide()

-- 	-- 鼠标按下时开始拖拽
-- 	progressBar:SetScript("OnMouseDown", function(self, button)
-- 		if button == "LeftButton" and mdhelperDB.mdhUser.interruptProgressBar.drag then
-- 			self:StartMoving()  -- 开始拖拽
-- 		end
-- 	end)

-- 	-- 鼠标松开时停止拖拽
-- 	progressBar:SetScript("OnMouseUp", function(self)
-- 		self:StopMovingOrSizing()  -- 停止拖拽
-- 		local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint()
-- 		mdhelperDB.mdhUser.interruptProgressBar.point = point;
-- 		mdhelperDB.mdhUser.interruptProgressBar.relativePoint = relativePoint;
-- 		mdhelperDB.mdhUser.interruptProgressBar.offx = xOfs;
-- 		mdhelperDB.mdhUser.interruptProgressBar.offy = yOfs;
-- 	end)

-- 	if mdhelperDB.mdhUser.interruptProgressBar.show then
-- 		progressBar:Show()
-- 	else
-- 		progressBar:Hide()
-- 	end

--     -- 创建菜单框架
--     return progressBar, timerText
-- end


-- comment
---@param progressBarName any
---@param basicUI any
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
function muc.createProgressBar(progressBarName, basicUI, width, height, mdhPotin, minValue,maxValue, defaultSetting, progressTexts, progressIcons)
	local progressBar = CreateFrame("StatusBar", progressBarName, basicUI) -- 创建进度条
	
	progressBar:SetSize(width, height) -- 设置进度条大小
    progressBar:SetPoint(mdhPotin.point, basicUI, mdhPotin.relativePoint, mdhPotin.offx, mdhPotin.offy)-- 将文本框置于屏幕中央
    progressBar:SetMinMaxValues(minValue, maxValue) -- 设置进度条的最小值和最大值
    progressBar:SetValue(0) -- 初始化进度条为 0
    progressBar:SetStatusBarTexture("Interface\\Addons\\AddUI\\UI\\Textures\\colorbar.tga") -- 设置进度条样式


	-- 启用拖拽功能
    progressBar:SetMovable(defaultSetting.drag or false)
	progressBar:EnableMouse(defaultSetting.drag or false)
	progressBar:SetClampedToScreen(true)  -- 防止框架被拖出屏幕

	if not defaultSetting.show or defaultSetting.show==false then 
		progressBar:Hide()
	else
		progressBar:Show()
	end


	-- 创建背景纹理
    local bgTexture = progressBar:CreateTexture(nil, "BACKGROUND")
    bgTexture:SetAllPoints(progressBar) -- 背景填满进度条
    bgTexture:SetColorTexture(0.1, 0.1, 0.1, 0.7) -- 设置背景色为深灰色，透明度 0.7

	local pTexts = {}
	if #progressTexts>0 then
		for index = 1, #progressTexts do
			local pTextPotin = progressTexts[index].point
			local pTextRelativePotin = progressTexts[index].relativePoint
			local pTextOffx = progressTexts[index].offx
			local pTextOffy = progressTexts[index].offy
			local pTextText = progressTexts[index].text
			local timerText = progressBar:CreateFontString(nil, "OVERLAY", "GameFontNormal") -- 创建文本显示
			timerText:SetPoint(pTextPotin, progressBar, pTextRelativePotin, pTextOffx, pTextOffy)-- 将文本框置于屏幕中央
			timerText:SetText(pTextText) -- 初始化文本内容
			table.insert(pTexts,timerText)
		end
	end


	local pIconFrams = {}
	if #progressIcons>0 then
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
			iconFrame:SetPoint(pIconPotin, progressBar, pIconRelativePotin, pIconOffx, pIconOffy) -- 设置图标位置

			-- 创建纹理
			iconFrame.iconTexture = iconFrame:CreateTexture(nil, "ARTWORK")
			iconFrame.iconTexture:SetAllPoints(iconFrame) -- 填满框架
			if pIcon~=nil then
				iconFrame.iconTexture:SetTexture(pIcon) -- 设置法术图标纹理
			end

			table.insert(pIconFrams,iconFrame)
		end
	end



	-- 鼠标按下时开始拖拽
	progressBar:SetScript("OnMouseDown", function(self, button)
		if button == "LeftButton" and mdhelperDB.mdhUser.interruptProgressBar.drag then
			self:StartMoving()  -- 开始拖拽
		end
	end)

	-- 鼠标松开时停止拖拽
	progressBar:SetScript("OnMouseUp", function(self)
		self:StopMovingOrSizing()  -- 停止拖拽
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



-- 创建文本
function muc.createFont(offx, offy, createframe, anchora, anchroframe, anchorb, text, fontsize)
	local font = createframe:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	font:SetPoint(anchora, anchroframe, anchorb, offx, offy)
	font:SetText(text)
	font:SetFont("fonts\\ARHei.ttf", fontsize, "OUTLINE")
	return font
end

-- 创建文本框
function muc.createTextBox(txtBoxName, basicUI, width, height,point, offx, offy, defaultTxt)
    -- 创建一个文本框
    local textBox = CreateFrame("EditBox", txtBoxName, basicUI, "InputBoxTemplate")
    textBox:SetSize(width, height) -- 设置宽度和高度
    textBox:SetPoint(point, basicUI, point, offx, offy) -- 将文本框置于屏幕中央
    textBox:SetFontObject(GameFontNormal) -- 设置字体
    textBox:SetAutoFocus(false) -- 禁止自动聚焦，避免影响其他操作
    if defaultTxt~=nil and defaultTxt~="" then
        textBox:SetText(defaultTxt) -- 设置默认文本
    end
    return textBox
end

-- 创建按钮
function muc.createButton(btnName, btnText, basicUI, btnWidth, btnHeight, mdhPotin,  btnClickHandler)
    local button = CreateFrame("Button", btnName, basicUI, "UIPanelButtonTemplate")
    button:SetText(btnText)
	button:SetWidth(btnWidth)
	button:SetHeight(btnHeight)
	button:SetPoint(mdhPotin.point, basicUI, mdhPotin.relativePoint, mdhPotin.offx, mdhPotin.offy)-- 将文本框置于屏幕中央
	button:SetScript("OnClick", function(self)
		btnClickHandler(self)
	end)
    return button
end

-- 创建checkBox
local clickXOffset1,clickXOffset2,clickXOffset3 = 0,0,0
function muc.createCheckbox(checkBoxName, basicUI, clickX, text, tip, defaultCheck, clickHandler)
	local x,y
	if clickX == 1 then
		x = 16
		y = clickXOffset1*-30-150
		clickXOffset1 = clickXOffset1 + 1
	elseif clickX == 2 then
		x = 226
		y = clickXOffset2*-30-150
		clickXOffset2 = clickXOffset2 + 1
	elseif clickX == 3 then
		x = 446
		y = clickXOffset3*-30-150
		clickXOffset3 = clickXOffset3 + 1
	end
	if text == "" then return end
	local check = CreateFrame("CheckButton", checkBoxName, basicUI, "InterfaceOptionsCheckButtonTemplate")
	check:SetPoint("TOPLEFT", basicUI, "TOPLEFT", x, y)
	check:SetChecked(defaultCheck)
	check.text:SetText(text)
	check:SetScript("OnEnter",function(self) 
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine("|cffFFFFFF"..tip.."|r")
		GameTooltip:Show() 
	end)
	check:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)

	check:SetScript("OnClick", function ( self )
		clickHandler(self)
	end)

	return check
end