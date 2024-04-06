function setup()
	-- FONT_load("AlexBrush", "asset://AlexBrush-Regular-OTF.otf")
	FONT_load("AlexBrush", "asset://JetBrainsMono-Medium.ttf")

	count = 0
	pLabel = UI_Label(
		nil,               -- <parent pointer>,
		7001,              -- <order>,
		110, 70,           -- <x>, <y>,
		0xFF, 0x000000,    -- <alpha>, <rgb>,
		"",                -- "<font name>",
		20,                -- <font size>,
		"Click Count: " .. count -- "<text string>"
	)

	local x = 100
	local y = 100

	local tblAREA = {
		x = 0,
		y = 0,
		width = 166,
		height = 55
	}

	pSimpleItem = UI_DragIcon(nil,
		7000,
		x, y,
		tblAREA,
		"asset://btn_confirm.png.imag",
		"asset://btn_confirm.png.imag",
		10,
		0.0,
		30, 70,
		"onClick"
	)

	bFlag = true
	pBtnLabel = UI_Label(
		pSimpleItem, -- <parent pointer>,
		7001,     -- <order>,
		20, 15,   -- <x>, <y>,
		0xFF, 0x000000, -- <alpha>, <rgb>,
		"",       -- "<font name>",
		20,       -- <font size>,
		"Danger Click" -- "<text string>"
	)
end

function execute(deltaT)
end

function leave()
end

function onClick(x, y)
	count = count + 1
	local tip = '';
	if count > 10 then
		clear();
		return
	elseif count > 7 then
		tip = tip .. " very danger"
	elseif count > 3 then
		tip = tip .. " danger"
	end
	prop = TASK_getProperty(pLabel)
	prop.text = "Click Count: " .. count .. tip
	TASK_setProperty(pLabel, prop)
end

function clear()
	prop = TASK_getProperty(pLabel)
	prop.visible = false
	TASK_setProperty(pLabel, prop)


	prop = TASK_getProperty(pSimpleItem)
	prop.color = 0xFF00FF
	TASK_setProperty(pSimpleItem, prop)
end
