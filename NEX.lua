-- [[ TOOLALL MM2 - NEX HUB: COMPACT SCROLL EDITION ]]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
local MiniButton = Instance.new("TextButton", ScreenGui) 
local UIStroke = Instance.new("UIStroke", MainFrame)
local MiniStroke = Instance.new("UIStroke", MiniButton)
local MiniCorner = Instance.new("UICorner", MiniButton)
local MiniGradient = Instance.new("UIGradient", MiniButton)

-- KHAI BÁO BIẾN (GIỮ NGUYÊN & ĐẢM BẢO ANTI AFK HOẠT ĐỘNG)
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local CurrentTween = nil
_G.IsAutoFarming = false
_G.AntiFling = false
_G.AutoFarmPro = false 
_G.AntiAFK = false 
local HasJumped = false 

-- 1. GIAO DIỆN CHÍNH
MainFrame.Name = "NEX_Final_Color"
MainFrame.Size = UDim2.new(0, 300, 0, 350) 
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Visible = false 
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

UIStroke.Thickness = 2
spawn(function()
    while task.wait() do 
        local color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
        UIStroke.Color = color
        MiniStroke.Color = color 
    end
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
