-- [[ NEX FULL-FARM V22: BLUE HUD COMPACT (GIAO DIỆN MM2) ]]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local TweenService = game:GetService("TweenService")
local lp = game.Players.LocalPlayer

-- ⚙️ KHAI BÁO BIẾN GỐC & STATE
local StopTalentThreshold = 40 
local LegendaryList = {"Legendary", "Mythic", "Huyền Thoại", "Uchiha", "Senju"} 
_G.states = {Herb = false, Iron = false, Gold = false, RollFam = false, RollTalent = false}
local ToggleButtons = {} -- Lưu các nút để auto tắt khi Roll ra đồ ngon

-- TÌM REMOTE EVENTS
local remoteHerb = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("CollectHerb")
local remoteOre = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("MineOre")
local remoteUnblock = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Skills"):WaitForChild("Main"):WaitForChild("Unblock")
local remoteRollFam = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("RollFamily")
local remoteRollTalent = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("RollTalent")

-- 🎨 CẤU HÌNH THEME (BLUE HUD COMPACT)
local BG_COLOR = Color3.fromRGB(15, 15, 18)
local ACCENT_COLOR = Color3.fromRGB(0, 170, 255) 
local TAB_OFF = Color3.fromRGB(25, 25, 30)
local BTN_OFF = Color3.fromRGB(30, 30, 35)
local TEXT_COLOR = Color3.fromRGB(230, 230, 230)

-- TẠO NÚT THU NHỎ TRƯỚC
local MiniButton = Instance.new("TextButton", ScreenGui) 
local MiniStroke = Instance.new("UIStroke", MiniButton)

-- 1. KHUNG CHÍNH CHỮ NHẬT NẰM NGANG
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

-- TITLE BAR (Thanh Tiêu Đề)
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -40, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "NEX FULL-FARM V22 ⚡ BLUE HUD"
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

-- 2. THANH CHÍP CHỨC NĂNG (TOP TABS)
local TabContainer = Instance.new("Frame", MainFrame)
TabContainer.Size = UDim2.new(1, -20, 0, 32)
TabContainer.Position = UDim2.new(0, 10, 0, 35)
TabContainer.BackgroundTransparency = 1

local TabList = Instance.new("UIListLayout", TabContainer)
TabList.FillDirection = Enum.FillDirection.Horizontal
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabList.Padding = UDim.new(0, 8)

-- 3. KHUNG CHỨA NỘI DUNG CÁC TAB
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
    page.CanvasSize = UDim2.new(0, 0, 0, 150)
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = ACCENT_COLOR
    
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 6)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    local tabBtn = Instance.new("TextButton", TabContainer)
    tabBtn.Size = UDim2.new(0, 120, 1, 0) 
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

-- TẠO CÁC CHÍP CHỨC NĂNG
local FarmTab = CreateTab("FARMING")
local RollTab = CreateTab("ROLLING")

-- Mặc định mở Tab Farm
tabs[1].Visible = true
tabButtons[1].BackgroundColor3 = ACCENT_COLOR
tabButtons[1].TextColor3 = Color3.fromRGB(0, 0, 0)

-- HÀM TẠO NÚT TOGGLE (GIAO DIỆN MM2)
local function AddToggle(parentTab, name, key)
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

    ToggleButtons[key] = btn -- Lưu nút để tương tác ở ngoài vòng lặp

    btn.MouseButton1Click:Connect(function()
        _G.states[key] = not _G.states[key]
        
        if _G.states[key] then
            btn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
            stroke.Color = ACCENT_COLOR
            btn.Text = "  " .. name .. " [ ĐANG CHẠY ]"
        else
            btn.BackgroundColor3 = BTN_OFF
            stroke.Color = Color3.fromRGB(50, 50, 60)
            btn.Text = "  " .. name .. " [ TẮT ]"
            -- Dừng nhân vật nếu tắt farm khoáng
            if (key == "Iron" or key == "Gold") and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                lp.Character.HumanoidRootPart.Anchored = false
            end
        end
    end)
end

-- 📌 PHÂN BỔ CHỨC NĂNG VÀO TỪNG CHÍP
AddToggle(FarmTab, "Hái Thảo Dược (Herbs)", "Herb")
AddToggle(FarmTab, "Camp Sắt (Iron Ore)", "Iron")
AddToggle(FarmTab, "Camp Vàng (Gold Ore)", "Gold")

AddToggle(RollTab, "Roll Family (Legendary)", "RollFam")
AddToggle(RollTab, "Roll Talent (> 40)", "RollTalent")

-- 4. CẤU HÌNH NÚT MINI NEX
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

-- HIỆU ỨNG GLOW NEON NHẸ NHÀNG (BLUE HUD)
spawn(function()
    while task.wait() do 
        local glow = math.sin(tick() * 3) * 0.5 + 0.5
        local dynamicBlue = Color3.fromRGB(0, math.floor(100 + 70 * glow), 255)
        MainStroke.Color = dynamicBlue
        MiniStroke.Color = dynamicBlue 
    end
end)


-- =========================================================================
-- HÀM HỖ TRỢ VÀ SYSTEM LOOPS (GIỮ NGUYÊN GỐC 100%)
-- =========================================================================

local function getStat(statName)
    if lp:FindFirstChild("leaderstats") and lp.leaderstats:FindFirstChild(statName) then return lp.leaderstats[statName].Value end
    if lp:FindFirstChild("Data") and lp.Data:FindFirstChild(statName) then return lp.Data[statName].Value end
    return nil
end

local function glideTo(targetPos)
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local tween = TweenService:Create(hrp, TweenInfo.new((hrp.Position - targetPos).Magnitude / 150, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos + Vector3.new(0, 3.2, 0))})
    tween:Play() 
    tween.Completed:Wait() 
    return true
end

-- VÒNG LẶP HÁI THẢO DƯỢC
spawn(function()
    while task.wait(0.5) do
        if _G.states.Herb then
            pcall(function()
                local folder = workspace:WaitForChild("Forest"):WaitForChild("Herbs")
                for _, node in pairs(folder:GetChildren()) do
                    if not _G.states.Herb then break end
                    local target = node:FindFirstChild("Ginseng") or node:FindFirstChild("Moonlight Flower") or node:FindFirstChild("Spirit Grass")
                    if target and glideTo(target:IsA("Model") and target:GetPivot().Position or target.Position) then
                        local hrp = lp.Character.HumanoidRootPart
                        hrp.Anchored = true
                        task.wait(1)
                        remoteHerb:FireServer(target)
                        task.wait(0.1)
                        hrp.Anchored = false
                    end
                end
            end)
        end
    end
end)

-- VÒNG LẶP ĐÀO KHOÁNG
spawn(function()
    local lockedNode = nil
    while task.wait(0.1) do 
        if _G.states.Iron or _G.states.Gold then
            pcall(function()
                local targetType = _G.states.Iron and "Iron" or "Gold"
                local folder = workspace:WaitForChild("Forest"):WaitForChild("Ore")
                if not lockedNode or not lockedNode:IsDescendantOf(workspace) then
                    for _, node in pairs(folder:GetChildren()) do
                        local t = node:FindFirstChild(targetType) or (node.Name == targetType and node)
                        if t and glideTo(t:IsA("Model") and t:GetPivot().Position or t.Position) then 
                            lp.Character.HumanoidRootPart.Anchored = true
                            lockedNode = t
                            break 
                        end
                    end
                else 
                    task.wait(0.2)
                    remoteOre:FireServer(lockedNode) 
                end
            end)
        else 
            lockedNode = nil
        end
    end
end)

-- VÒNG LẶP ROLL FAMILY
spawn(function()
    while task.wait(0.4) do
        if _G.states.RollFam then
            pcall(function()
                local cf = getStat("Family")
                if cf and table.find(LegendaryList, cf) then 
                    _G.states.RollFam = false
                    ToggleButtons["RollFam"].Text = "  ĐÃ CÓ: " .. cf
                    ToggleButtons["RollFam"].BackgroundColor3 = Color3.fromRGB(0, 150, 60) -- Màu xanh lá cây báo hiệu
                    ToggleButtons["RollFam"]:FindFirstChildOfClass("UIStroke").Color = Color3.fromRGB(0, 255, 100)
                else 
                    remoteUnblock:FireServer()
                    remoteRollFam:FireServer(lp) 
                end
            end)
        end
    end
end)

-- VÒNG LẶP ROLL TALENT
spawn(function()
    while task.wait(0.4) do
        if _G.states.RollTalent then
            pcall(function()
                local tVal = getStat("Talent")
                if tVal and tVal > StopTalentThreshold then 
                    _G.states.RollTalent = false
                    ToggleButtons["RollTalent"].Text = "  TALENT HIỆN TẠI: " .. tVal
                    ToggleButtons["RollTalent"].BackgroundColor3 = Color3.fromRGB(0, 150, 60) -- Màu xanh lá cây báo hiệu
                    ToggleButtons["RollTalent"]:FindFirstChildOfClass("UIStroke").Color = Color3.fromRGB(0, 255, 100)
                else 
                    remoteRollTalent:FireServer() 
                end
            end)
        end
    end
end)
