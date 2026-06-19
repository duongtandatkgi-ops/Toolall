-- [[ NEX HUB: BLUE HUD x LEMON TYCOON (ĐÃ FIX LỖI DỊCH CHUYỂN) ]]

-- 1. HỆ THỐNG CHỐNG TRÙNG LẶP SCRIPT (Ngăn lỗi giật qua giật lại do chạy nhiều lần)
if _G.NexLemonFarm_Running then
    _G.NexLemonFarm_Running = false
    task.wait(0.2) -- Đợi vòng lặp cũ tự tắt
end
_G.NexLemonFarm_Running = true

for _, v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "NEX_LemonTycoon_GUI" then v:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "NEX_LemonTycoon_GUI"

-- 2. KHAI BÁO BIẾN GỐC & DỊCH VỤ
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

_G.AutoBuy = false
_G.AutoUpgrade = false
_G.AutoFruit = false

-- 🎨 CẤU HÌNH THEME (BLUE HUD COMPACT)
local BG_COLOR = Color3.fromRGB(15, 15, 18)
local ACCENT_COLOR = Color3.fromRGB(0, 170, 255) 
local TAB_OFF = Color3.fromRGB(25, 25, 30)
local BTN_OFF = Color3.fromRGB(30, 30, 35)
local TEXT_COLOR = Color3.fromRGB(230, 230, 230)

-- TẠO NÚT THU NHỎ TRƯỚC
local MiniButton = Instance.new("TextButton", ScreenGui) 
local MiniStroke = Instance.new("UIStroke", MiniButton)

-- 3. KHUNG CHÍNH CHỮ NHẬT NẰM NGANG
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "NEX_Blue_HUD"
MainFrame.Size = UDim2.new(0, 380, 0, 260) 
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -130)
MainFrame.BackgroundColor3 = BG_COLOR
MainFrame.Visible = false 
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 1.5
MainStroke.Color = ACCENT_COLOR

-- TITLE BAR
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -40, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "NEX HUB ⚡ LEMON TYCOON"
Title.TextColor3 = ACCENT_COLOR
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

-- NÚT THOÁT THU NHỎ ×
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.Text = "×" 
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextColor3 = Color3.fromRGB(255, 70, 70)
CloseBtn.TextSize = 20
CloseBtn.BackgroundTransparency = 1
CloseBtn.MouseButton1Click:Connect(function() 
    MainFrame.Visible = false 
    MiniButton.Visible = true 
end)

-- THANH CHÍP CHỨC NĂNG (TOP TABS)
local TabContainer = Instance.new("Frame", MainFrame)
TabContainer.Size = UDim2.new(1, -20, 0, 32)
TabContainer.Position = UDim2.new(0, 10, 0, 35)
TabContainer.BackgroundTransparency = 1

local TabList = Instance.new("UIListLayout", TabContainer)
TabList.FillDirection = Enum.FillDirection.Horizontal
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabList.Padding = UDim.new(0, 8)

-- KHUNG CHỨA NỘI DUNG CÁC TAB
local PageContainer = Instance.new("Frame", MainFrame)
PageContainer.Size = UDim2.new(1, -20, 1, -80)
PageContainer.Position = UDim2.new(0, 10, 0, 72)
PageContainer.BackgroundTransparency = 1

local tabs = {}
local tabButtons = {}

local function CreateTab(tabName)
    local page = Instance.new("ScrollingFrame", PageContainer)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 220)
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = ACCENT_COLOR
    
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 6)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    local tabBtn = Instance.new("TextButton", TabContainer)
    tabBtn.Size = UDim2.new(0, 80, 1, 0) 
    tabBtn.BackgroundColor3 = TAB_OFF
    tabBtn.Text = tabName
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextColor3 = TEXT_COLOR
    tabBtn.TextSize = 11
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(1, 0) 
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(tabs) do p.Visible = false end
        for _, b in pairs(tabButtons) do 
            b.BackgroundColor3 = TAB_OFF 
            b.TextColor3 = TEXT_COLOR
        end
        page.Visible = true
        tabBtn.BackgroundColor3 = ACCENT_COLOR
        tabBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    end)
    
    table.insert(tabs, page)
    table.insert(tabButtons, tabBtn)
    return page
end

-- TẠO CÁC TAB VÀ NÚT CHỨC NĂNG
local MainTab = CreateTab("AUTO FARM")

tabs[1].Visible = true
tabButtons[1].BackgroundColor3 = ACCENT_COLOR
tabButtons[1].TextColor3 = Color3.fromRGB(0, 0, 0)

local function AddToggle(parentTab, name, var)
    local btn = Instance.new("TextButton", parentTab)
    btn.Size = UDim2.new(1, -10, 0, 34)
    btn.Font = Enum.Font.GothamBold
    btn.Text = "  " .. name .. " [ TẮT ]"
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BackgroundColor3 = BTN_OFF
    btn.TextColor3 = TEXT_COLOR
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(50, 50, 60)
    stroke.Thickness = 1

    btn.MouseButton1Click:Connect(function()
        _G[var] = not _G[var]
        btn.BackgroundColor3 = _G[var] and Color3.fromRGB(0, 100, 200) or BTN_OFF
        stroke.Color = _G[var] and ACCENT_COLOR or Color3.fromRGB(50, 50, 60)
        btn.Text = "  " .. name .. (_G[var] and " [ BẬT ]" or " [ TẮT ]")
    end)
end

AddToggle(MainTab, "Tự Động Mua (Auto Buy)", "AutoBuy")
AddToggle(MainTab, "Tự Động Nâng Cấp (Auto Upgrade)", "AutoUpgrade")
AddToggle(MainTab, "Tự Động Nhặt Trái (Auto Fruit)", "AutoFruit")

-- LOGIC GIAO DIỆN THU NHỎ
MiniButton.Name = "NEX_Mini_Toggle"
MiniButton.Size = UDim2.new(0, 45, 0, 45)
MiniButton.Position = UDim2.new(0, 20, 0.2, 0)
MiniButton.BackgroundColor3 = BG_COLOR
MiniButton.Text = "N"
MiniButton.TextColor3 = ACCENT_COLOR
MiniButton.Font = Enum.Font.GothamBold
MiniButton.TextSize = 22
MiniButton.Draggable = true
MiniButton.Visible = true 
Instance.new("UICorner", MiniButton).CornerRadius = UDim.new(1, 0)
MiniStroke.Thickness = 2
MiniStroke.Color = ACCENT_COLOR

MiniButton.MouseButton1Click:Connect(function() 
    MainFrame.Visible = true 
    MiniButton.Visible = false 
end)

spawn(function()
    while _G.NexLemonFarm_Running do 
        task.wait()
        local glow = math.sin(tick() * 3) * 0.5 + 0.5
        local dynamicBlue = Color3.fromRGB(0, math.floor(100 + 70 * glow), 255)
        MainStroke.Color = dynamicBlue
        MiniStroke.Color = dynamicBlue 
    end
end)

-- =========================================================================
-- LOGIC TÍNH NĂNG LEMON TYCOON
-- =========================================================================

local userTycoon = (function()
	for _, v in pairs(workspace:GetChildren()) do
		if v:IsA("Folder") and v.Name:match("Tycoon%d") then
			if v:FindFirstChild("Owner") and v.Owner.Value == LocalPlayer then
				return v
			end
		end
	end
end)()

if not userTycoon then
    print("[NEX HUB] Không tìm thấy Tycoon!")
end

local Buying = false

local function getButtons()
	local Buttons = {}
	if not userTycoon then return Buttons end
	for _, obj in ipairs(userTycoon.Purchases:GetDescendants()) do
		if obj:IsA("Model") then
			local shown = obj:GetAttribute("Shown")
			local purchased = obj:GetAttribute("Purchased")
			if shown == true and purchased ~= true then
				local buttonPart = obj:FindFirstChild("Button")
				if buttonPart and buttonPart:IsA("BasePart") then
					table.insert(Buttons, { Name = obj.Name, Button = buttonPart })
				end
			end
		end
	end
	return Buttons
end

local function buyButton(buttonData)
	if Buying then return end
	Buying = true
	local character = LocalPlayer.Character
	if not character then Buying = false return end
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then Buying = false return end
	local buttonPart = buttonData.Button
	pcall(function()
		firetouchinterest(hrp, buttonPart, 0)
		firetouchinterest(hrp, buttonPart, 1)
	end)
	Buying = false
end

local function upgradeMachines()
	if not userTycoon then return end
	for _, obj in ipairs(userTycoon:GetDescendants()) do
		if obj:IsA("RemoteFunction") and obj.Name == "Upgrade" then
			pcall(function()
				for level = 1, 5 do obj:InvokeServer(level) end
			end)
		end
	end
end

task.spawn(function()
	while _G.NexLemonFarm_Running do
		task.wait(0.5) 
		if _G.AutoBuy and userTycoon then
			local Buttons = getButtons()
			for _, button in ipairs(Buttons) do
				pcall(function() buyButton(button) end)
			end
		end
		if _G.AutoUpgrade and userTycoon then
			pcall(function() upgradeMachines() end)
		end
	end
end)

-- LOGIC AUTO FRUIT
local Trees = {}
local function addTree(obj)
	if obj:IsA("Model") and obj.Name == "LemonTree" then
		if not table.find(Trees, obj) then table.insert(Trees, obj) end
	end
end
local function removeTree(obj)
	local index = table.find(Trees, obj)
	if index then table.remove(Trees, index) end
end
for _, v in ipairs(workspace:GetDescendants()) do addTree(v) end
workspace.DescendantAdded:Connect(addTree)
workspace.DescendantRemoving:Connect(removeTree)

local function collectFruit(tree)
	local character = LocalPlayer.Character
	if not character then return end
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

    -- BƯỚC 1: KIỂM TRA XEM CÂY CÓ TRÁI ĐỂ HÁI KHÔNG (Ngăn lỗi nhảy lung tung)
    local fruitsToClick = {}
	for _, obj in ipairs(tree:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Name == "Fruit" then
			local clickPart = obj:FindFirstChild("ClickPart")
			if clickPart then
				local detector = clickPart:FindFirstChildOfClass("ClickDetector")
				if detector then
					table.insert(fruitsToClick, detector)
				end
			end
		end
	end

    -- BƯỚC 2: CHỈ DỊCH CHUYỂN NẾU CÓ TRÁI
    if #fruitsToClick > 0 then
        hrp.CFrame = tree:GetPivot() + Vector3.new(0, 5, 0)
        
        for _, detector in ipairs(fruitsToClick) do
            if not _G.AutoFruit or not _G.NexLemonFarm_Running then break end
            task.wait(0.01) 
            pcall(function() fireclickdetector(detector) end)
        end
        task.wait(0.05) -- Nghỉ nhẹ 1 chút trước khi qua cây tiếp theo
    end
end

-- VÒNG LẶP AUTO FRUIT
task.spawn(function()
	while _G.NexLemonFarm_Running do
		task.wait(0.05) 
		if _G.AutoFruit then
			for _, tree in ipairs(Trees) do
				if not _G.AutoFruit or not _G.NexLemonFarm_Running then break end
				if tree and tree.Parent then
					pcall(function() collectFruit(tree) end)
				end
			end
		end
	end
end)
