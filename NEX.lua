-- [[ TOOLALL MM2 - NEX HUB: BLUE HUD + HARD-LOCK BEHIND & AUTO SHOOT 40 COINS + SHIFT LOCK AIM ]]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

-- KHAI BÁO BIẾN GỐC
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local CurrentTween = nil
_G.IsAutoFarming = false
_G.AntiFling = false
_G.AutoFarmPro = false 
_G.AntiAFK = false 
_G.UseESP = false
_G.UseMurd = false
_G.UseAura = false
_G.UseLoot = false
_G.UseFly = false
_G.AutoShootMurd = false 
local HasJumped = false 

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

-- TITLE BAR
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -40, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "NEX HUB ⚡ BLUE HUD"
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

local FarmTab = CreateTab("FARM")
local CombatTab = CreateTab("COMBAT")
local VisualsTab = CreateTab("VISUAL")
local MiscTab = CreateTab("MISC")

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
        
        if (var == "IsAutoFarming" or var == "AutoFarmPro") and not _G[var] then
            if CurrentTween then CurrentTween:Cancel() end
            HasJumped = false
        end

        if var == "UseFly" and _G.UseFly then
            loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fly-V3-55253"))()
        end
    end)
end

AddToggle(FarmTab, "Auto Farm PRO (Siêu Cấp)", "AutoFarmPro")
AddToggle(FarmTab, "Auto Farm (Né SN 10 Stu)", "IsAutoFarming")
AddToggle(FarmTab, "Chống Treo Máy (Anti-AFK)", "AntiAFK")
AddToggle(FarmTab, "Kích Hoạt Bay (Fly)", "UseFly")

AddToggle(CombatTab, "Auto Bắn Sát Nhân", "AutoShootMurd")
AddToggle(CombatTab, "Chain Kill (Dịch Chuyển)", "UseMurd")
AddToggle(CombatTab, "Kill Aura (Tầm Xa 400)", "UseAura")
AddToggle(CombatTab, "Nhặt Súng Từ Xa", "UseLoot")

AddToggle(VisualsTab, "ESP Soi Vai Trò", "UseESP")
AddToggle(MiscTab, "Chống Fling (Anti-Fling)", "AntiFling")

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
    while task.wait() do 
        local glow = math.sin(tick() * 3) * 0.5 + 0.5
        local dynamicBlue = Color3.fromRGB(0, math.floor(100 + 70 * glow), 255)
        MainStroke.Color = dynamicBlue
        MiniStroke.Color = dynamicBlue 
    end
end)

-- =========================================================================
-- SYSTEM LOOPS (ĐÃ THÊM LOGIC TỰ BẮN KHI ĐỦ 40 XU VÀ GHIM TÂM NGẮM SHIFT LOCK)
-- =========================================================================

game.Players.LocalPlayer.CharacterAdded:Connect(function()
    HasJumped = false; task.wait(2)
    if _G.AutoFarmPro or _G.IsAutoFarming then if CurrentTween then CurrentTween:Cancel() end end
end)

local function GetMurd()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Character and (p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")) then return p end
    end
    return nil
end

local function getTargetCoin()
    local coins = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if (v.Name == "CoinVisual" or v.Name == "GoldCoin" or v:FindFirstChild("CoinVisual")) and v:IsA("BasePart") then
            if v:FindFirstChild("TouchInterest") or v.Parent:FindFirstChild("TouchInterest") then table.insert(coins, v) end
        end
    end
    if #coins > 0 then
        table.sort(coins, function(a, b) return (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - a.Position).Magnitude < (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - b.Position).Magnitude end)
        return coins[1]
    end
    return nil
end

-- AUTO FARM LOOP & LOGIC 40 XU
task.spawn(function()
    while true do
        task.wait(0.1)
        if _G.AutoFarmPro or _G.IsAutoFarming then
            pcall(function()
                local lp = game.Players.LocalPlayer
                local char = lp.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local hrp = char.HumanoidRootPart
                
                -- LOGIC TỰ ĐỘNG BẬT BẮN KHI ĐỦ 40 XU
                local coins = 0
                pcall(function() coins = lp.leaderstats.Coins.Value end)
                local hasGun = lp.Backpack:FindFirstChild("Gun") or char:FindFirstChild("Gun")
                
                if _G.AutoFarmPro and coins >= 40 and hasGun then
                    _G.AutoShootMurd = true -- Tự động kích hoạt bắn
                end

                local knife = lp.Backpack:FindFirstChild("Knife") or char:FindFirstChild("Knife")
                if knife and _G.AutoFarmPro then
                    _G.UseAura = true; _G.UseMurd = true; HasJumped = false; return
                end

                local murd = GetMurd()
                local safeDist = _G.AutoFarmPro and 20 or 10 
                
                if murd and murd.Character and murd.Character:FindFirstChild("HumanoidRootPart") and (hrp.Position - murd.Character.HumanoidRootPart.Position).Magnitude < safeDist then
                    if CurrentTween then CurrentTween:Cancel() end
                    local direction = (hrp.Position - murd.Character.HumanoidRootPart.Position).Unit
                    hrp.CFrame = CFrame.new(hrp.Position + (direction * 15), hrp.Position + direction * 20)
                    HasJumped = false; task.wait(0.1)
                else
                    local target = getTargetCoin()
                    if target then
                        local dist = (hrp.Position - target.Position).Magnitude
                        if _G.AutoFarmPro and dist > 400 then 
                            if not HasJumped then hrp.CFrame = hrp.CFrame * CFrame.new(0, 70, 0); HasJumped = true end
                            return 
                        end
                        CurrentTween = TweenService:Create(hrp, TweenInfo.new(dist / 25, Enum.EasingStyle.Linear), {CFrame = target.CFrame})
                        CurrentTween:Play(); CurrentTween.Completed:Wait(); HasJumped = false 
                    else
                        if not HasJumped then if CurrentTween then CurrentTween:Cancel() end; hrp.CFrame = hrp.CFrame * CFrame.new(0, 70, 0); HasJumped = true end
                    end
                end
            end)
        end
    end
end)

-- COMBAT & ESP & LOOT
local function IsAdmin(player)
    if player:GetRankInGroup(2913303) >= 100 or player.UserId == 16122546 or player.UserId == 27268945 then return true end
    return false
end

local lastShotTime = 0
spawn(function()
    while task.wait(0.01) do
        pcall(function()
            local lp = game.Players.LocalPlayer
            local char = lp.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end

            if _G.AutoShootMurd then
                local gun = char:FindFirstChild("Gun") or lp.Backpack:FindFirstChild("Gun")
                if gun then
                    local murd = GetMurd()
                    if murd and murd.Character and murd.Character:FindFirstChild("HumanoidRootPart") and murd.Character.Humanoid.Health > 0 then
                        if gun.Parent == lp.Backpack then char.Humanoid:EquipTool(gun) end
                        
                        -- [FIX]: ÉP TOOL VÀO TRẠNG THÁI ACTIVE ĐỂ KHÔNG BỊ CHẶN BẮN
                        gun:Activate() 
                        
                        local shootEvent = gun:FindFirstChild("Shoot")
                        if shootEvent then
                            local murdHrp = murd.Character.HumanoidRootPart
                            char.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                            char.HumanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
                            char.HumanoidRootPart.CFrame = murdHrp.CFrame * CFrame.new(0, 0, 2.2)
                            
                            -- XOAY CAMERA ĐỂ KHỚP TÂM
                            local cam = workspace.CurrentCamera
                            local camPos = cam.CFrame.Position
                            cam.CFrame = CFrame.new(camPos, murdHrp.Position)

                            if tick() - lastShotTime >= 0.18 then
                                lastShotTime = tick()
                                local origin = char.HumanoidRootPart.Position
                                local target = murdHrp.Position
                                local gunArgs = {CFrame.new(origin, target), CFrame.new(target)}
                                shootEvent:FireServer(unpack(gunArgs))
                            end
                        end
                    end
                end
            end

            if _G.UseAura then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    for _, p in pairs(game.Players:GetPlayers()) do
                        if p ~= lp and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                            local dist = (char.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                            if dist < 400 then
                                if tool.Name:lower():find("knife") or tool:FindFirstChild("Handle") then
                                    firetouchinterest(p.Character.HumanoidRootPart, tool.Handle, 0)
                                    firetouchinterest(p.Character.HumanoidRootPart, tool.Handle, 1)
                                end
                                if tool.Name:lower():find("gun") or tool.Name:lower():find("revolver") then
                                    local r = tool:FindFirstChild("Shoot") or tool:FindFirstChild("Activate") or tool:FindFirstChildOfClass("RemoteEvent")
                                    if r then r:FireServer(p.Character.Head.Position) end
                                end
                            end
                        end
                    end
                end
            end

            if _G.UseMurd then
                local knife = lp.Backpack:FindFirstChild("Knife") or char:FindFirstChild("Knife")
                if knife then
                    char.Humanoid:EquipTool(knife)
                    for _, p in pairs(game.Players:GetPlayers()) do
                        if p ~= lp and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                            char.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1)
                            knife:Activate()
                            local s = knife:FindFirstChild("Stab") or knife:FindFirstChild("Slash")
                            if s then s:FireServer() end
                            task.wait(0.12)
                        end
                    end
                end
            end

            if _G.UseESP then
                for _, p in pairs(game.Players:GetPlayers()) do
                    if p ~= lp and p.Character then
                        local h = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
                        local isM = p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")
                        local isS = p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun")
                        if IsAdmin(p) then h.FillColor = Color3.fromRGB(255, 255, 0)
                        elseif isM then h.FillColor = Color3.fromRGB(255, 0, 0)
                        elseif isS then h.FillColor = Color3.fromRGB(0, 0, 255)
                        else h.FillColor = Color3.fromRGB(0, 255, 0) end
                        h.Enabled = true
                    else
                        if p.Character and p.Character:FindFirstChild("Highlight") then p.Character.Highlight.Enabled = false end
                    end
                end
            else
                for _, p in pairs(game.Players:GetPlayers()) do
                    if p.Character and p.Character:FindFirstChild("Highlight") then p.Character.Highlight.Enabled = false end
                end
            end

            if _G.UseLoot then
                for _, v in pairs(game.Workspace:GetDescendants()) do
                    if v.Name == "GunDrop" or v.Name == "GunHandle" then
                        firetouchinterest(char.HumanoidRootPart, v:IsA("BasePart") and v or v.Parent, 0)
                        firetouchinterest(char.HumanoidRootPart, v:IsA("BasePart") and v or v.Parent, 1)
                    end
                end
            end
        end)
    end
end)

spawn(function()
    while task.wait() do
        if _G.AntiFling then
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    for _, v in pairs(char:GetChildren()) do
                        if v:IsA("BasePart") then v.Velocity = Vector3.new(0,0,0); v.RotVelocity = Vector3.new(0,0,0) end
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(30) do
        if _G.AntiAFK then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
                if not _G.IsAutoFarming and not _G.AutoFarmPro then
                    local lp = game.Players.LocalPlayer
                    if lp.Character and lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid.Jump = true end
                end
            end)
        end
    end
end)

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    if _G.AntiAFK then
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)
end)

local ScrollFrame = Instance.new("ScrollingFrame", MainFrame)
ScrollFrame.Size = UDim2.new(1, -10, 1, -50)
ScrollFrame.Position = UDim2.new(0, 5, 0, 40)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 530)
ScrollFrame.ScrollBarThickness = 2
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)

local UIListLayout = Instance.new("UIListLayout", ScrollFrame)
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function CreateToggle(name, var)
    local btn = Instance.new("TextButton", ScrollFrame)
    btn.Size = UDim2.new(0, 260, 0, 45)
    btn.Font = Enum.Font.GothamBold
    btn.Text = name .. ": TẮT"
    btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    btn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    btn.MouseButton1Click:Connect(function()
        _G[var] = not _G[var]
        btn.BackgroundColor3 = _G[var] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
        btn.Text = name .. (_G[var] and ": BẬT" or ": TẮT")
        
        if (var == "IsAutoFarming" or var == "AutoFarmPro") and not _G[var] then
            if CurrentTween then CurrentTween:Cancel() end
            HasJumped = false
        end

        if var == "UseFly" and _G.UseFly then
            loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fly-V3-55253"))()
        end
    end)
end

-- DANH SÁCH NÚT
CreateToggle("Chống Treo Máy (Anti-AFK)", "AntiAFK")
CreateToggle("Auto Farm PRO (Siêu Cấp)", "AutoFarmPro")
CreateToggle("ESP Soi Vai Trò", "UseESP")
CreateToggle("Chain Kill (Dịch Chuyển)", "UseMurd")
CreateToggle("Kill Aura (Tầm Xa 400)", "UseAura")
CreateToggle("Nhặt Súng Từ Xa", "UseLoot")
CreateToggle("Kích Hoạt Bay (Fly)", "UseFly")
CreateToggle("Auto Farm (Né SN 10 Stu)", "IsAutoFarming")
CreateToggle("Chống Fling (Anti-Fling)", "AntiFling")

-- 2. NÚT NEX (MINI BUTTON)
MiniButton.Name = "NEX_Modern_Toggle"
MiniButton.Size = UDim2.new(0, 60, 0, 60)
MiniButton.Position = UDim2.new(0, 20, 0.2, 0)
MiniButton.BackgroundColor3 = Color3.new(1, 1, 1)
MiniButton.Text = "NEX"
MiniButton.TextColor3 = Color3.new(1, 1, 1)
MiniButton.Font = Enum.Font.LuckiestGuy
MiniButton.TextSize = 20
MiniButton.Draggable = true
MiniCorner.CornerRadius = UDim.new(1, 0)
MiniStroke.Thickness = 3
MiniGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 50, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 200, 255))
}
MiniButton.MouseButton1Click:Connect(function() 
    MainFrame.Visible = not MainFrame.Visible
    MiniButton.Visible = not MainFrame.Visible
end)

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.Text = "_"
CloseBtn.MouseButton1Click:Connect(function() 
    MainFrame.Visible = false 
    MiniButton.Visible = true 
end)

-- LOGIC TỰ ĐỘNG BẬT LẠI KHI CHẾT
game.Players.LocalPlayer.CharacterAdded:Connect(function()
    HasJumped = false
    task.wait(2)
    if _G.AutoFarmPro or _G.IsAutoFarming then
        if CurrentTween then CurrentTween:Cancel() end
    end
end)

-- 3. HÀM TRỢ NĂNG (GIỮ NGUYÊN)
local function GetMurd()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Character and (p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")) then
            return p
        end
    end
    return nil
end

local function getTargetCoin()
    local coins = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if (v.Name == "CoinVisual" or v.Name == "GoldCoin" or v:FindFirstChild("CoinVisual")) and v:IsA("BasePart") then
            if v:FindFirstChild("TouchInterest") or v.Parent:FindFirstChild("TouchInterest") then
                table.insert(coins, v)
            end
        end
    end
    if #coins > 0 then
        table.sort(coins, function(a, b)
            return (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - a.Position).Magnitude < (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - b.Position).Magnitude
        end)
        return coins[1]
    end
    return nil
end

-- 4. VÒNG LẶP AUTO FARM
task.spawn(function()
    while true do
        task.wait(0.1)
        if _G.AutoFarmPro or _G.IsAutoFarming then
            pcall(function()
                local lp = game.Players.LocalPlayer
                local char = lp.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local hrp = char.HumanoidRootPart
                
                local knife = lp.Backpack:FindFirstChild("Knife") or char:FindFirstChild("Knife")
                if knife and _G.AutoFarmPro then
                    _G.UseAura = true
                    _G.UseMurd = true
                    HasJumped = false
                    return
                end

                local murd = GetMurd()
                local safeDist = _G.AutoFarmPro and 20 or 10 
                
                if murd and murd.Character and murd.Character:FindFirstChild("HumanoidRootPart") and (hrp.Position - murd.Character.HumanoidRootPart.Position).Magnitude < safeDist then
                    if CurrentTween then CurrentTween:Cancel() end
                    local direction = (hrp.Position - murd.Character.HumanoidRootPart.Position).Unit
                    hrp.CFrame = CFrame.new(hrp.Position + (direction * 15), hrp.Position + direction * 20)
                    HasJumped = false 
                    task.wait(0.1)
                else
                    local target = getTargetCoin()
                    if target then
                        local dist = (hrp.Position - target.Position).Magnitude
                        if _G.AutoFarmPro and dist > 400 then 
                            if not HasJumped then
                                hrp.CFrame = hrp.CFrame * CFrame.new(0, 70, 0)
                                HasJumped = true
                            end
                            return 
                        end
                        
                        local info = TweenInfo.new(dist / 25, Enum.EasingStyle.Linear)
                        CurrentTween = TweenService:Create(hrp, info, {CFrame = target.CFrame})
                        CurrentTween:Play()
                        CurrentTween.Completed:Wait()
                        HasJumped = false 
                    else
                        if not HasJumped then
                            if CurrentTween then CurrentTween:Cancel() end
                            hrp.CFrame = hrp.CFrame * CFrame.new(0, 70, 0)
                            HasJumped = true 
                        end
                    end
                end
            end)
        end
    end
end)

-- 5. LOGIC CHIẾN ĐẤU & ESP
local function IsAdmin(player)
    if player:GetRankInGroup(2913303) >= 100 or player.UserId == 16122546 or player.UserId == 27268945 then return true end
    return false
end

spawn(function()
    while task.wait(0.01) do
        pcall(function()
            local lp = game.Players.LocalPlayer
            local char = lp.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end

            if _G.UseAura then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    for _, p in pairs(game.Players:GetPlayers()) do
                        if p ~= lp and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                            local dist = (char.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                            if dist < 400 then
                                if tool.Name:lower():find("knife") or tool:FindFirstChild("Handle") then
                                    firetouchinterest(p.Character.HumanoidRootPart, tool.Handle, 0)
                                    firetouchinterest(p.Character.HumanoidRootPart, tool.Handle, 1)
                                end
                                if tool.Name:lower():find("gun") or tool.Name:lower():find("revolver") then
                                    local r = tool:FindFirstChild("Shoot") or tool:FindFirstChild("Activate") or tool:FindFirstChildOfClass("RemoteEvent")
                                    if r then r:FireServer(p.Character.Head.Position) end
                                end
                            end
                        end
                    end
                end
            end

            if _G.UseMurd then
                local knife = lp.Backpack:FindFirstChild("Knife") or char:FindFirstChild("Knife")
                if knife then
                    char.Humanoid:EquipTool(knife)
                    for _, p in pairs(game.Players:GetPlayers()) do
                        if p ~= lp and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                            char.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1)
                            knife:Activate()
                            local s = knife:FindFirstChild("Stab") or knife:FindFirstChild("Slash")
                            if s then s:FireServer() end
                            task.wait(0.12)
                        end
                    end
                end
            end

            if _G.UseESP then
                for _, p in pairs(game.Players:GetPlayers()) do
                    if p ~= lp and p.Character then
                        local h = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
                        local isM = p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")
                        local isS = p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun")
                        if IsAdmin(p) then h.FillColor = Color3.fromRGB(255, 255, 0)
                        elseif isM then h.FillColor = Color3.fromRGB(255, 0, 0)
                        elseif isS then h.FillColor = Color3.fromRGB(0, 0, 255)
                        else h.FillColor = Color3.fromRGB(0, 255, 0) end
                        h.Enabled = true
                    end
                end
            end

            if _G.UseLoot then
                for _, v in pairs(game.Workspace:GetDescendants()) do
                    if v.Name == "GunDrop" or v.Name == "GunHandle" then
                        firetouchinterest(char.HumanoidRootPart, v:IsA("BasePart") and v or v.Parent, 0)
                        firetouchinterest(char.HumanoidRootPart, v:IsA("BasePart") and v or v.Parent, 1)
                    end
                end
            end
        end)
    end
end)

-- 6. CHỐNG FLING
spawn(function()
    while task.wait() do
        if _G.AntiFling then
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    for _, v in pairs(char:GetChildren()) do
                        if v:IsA("BasePart") then
                            v.Velocity = Vector3.new(0, 0, 0)
                            v.RotVelocity = Vector3.new(0, 0, 0)
                        end
                    end
                end
            end)
        end
    end
end)

-- [[ TỐI ƯU ANTI-AFK: ĐẢM BẢO KHÔNG BỊ KICK 20 PHÚT ]]
task.spawn(function()
    while task.wait(30) do -- Cứ mỗi 30 giây kiểm tra một lần
        if _G.AntiAFK then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new()) -- Click chuột phải ảo
                -- Thêm một hành động nhảy nhẹ nếu đang không Auto Farm để server thấy có chuyển động
                if not _G.IsAutoFarming and not _G.AutoFarmPro then
                    local lp = game.Players.LocalPlayer
                    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
                        lp.Character.Humanoid.Jump = true
                    end
                end
            end)
        end
    end
end)

-- Chặn sự kiện Idled mặc định của Roblox
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    if _G.AntiAFK then
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)
