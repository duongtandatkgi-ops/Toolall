-- [[ TOOLALL MM2 - NEX: UPDATE COLOR ESP & CHAIN KILL & FLY & AURA ]]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
local MiniButton = Instance.new("TextButton", ScreenGui) 
local UIStroke = Instance.new("UIStroke", MainFrame)
local MiniStroke = Instance.new("UIStroke", MiniButton)

-- 1. GIAO DIỆN NEX
MainFrame.Name = "NEX_Final_Color"
MainFrame.Size = UDim2.new(0, 300, 0, 390) -- Tăng một chút để đủ chỗ 5 nút
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -195)
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

local function CreateToggle(name, pos, var)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0, 260, 0, 45)
    btn.Position = pos
    btn.Font = Enum.Font.GothamBold
    btn.Text = name .. ": TẮT"
    btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    btn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    btn.MouseButton1Click:Connect(function()
        _G[var] = not _G[var]
        btn.BackgroundColor3 = _G[var] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
        btn.Text = name .. (_G[var] and ": BẬT" or ": TẮT")
        
        -- Kích hoạt Fly khi bấm nút
        if var == "UseFly" and _G.UseFly then
            loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fly-V3-55253"))()
        elseif var == "UseFly" and not _G.UseFly then
            -- Tắt Fly (tùy bản script fly hỗ trợ)
            if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
            end
        end
    end)
end

-- THÊM CÁC NÚT (Giữ đúng kiểu CreateToggle của ông)
CreateToggle("ESP Soi Vai Trò", UDim2.new(0, 20, 0, 30), "UseESP")
CreateToggle("Chain Kill (Dịch Chuyển)", UDim2.new(0, 20, 0, 90), "UseMurd")
CreateToggle("Kill Aura (Tầm Xa 400)", UDim2.new(0, 20, 0, 150), "UseAura")
CreateToggle("Nhặt Súng Từ Xa", UDim2.new(0, 20, 0, 210), "UseLoot")
CreateToggle("Kích Hoạt Bay (Fly)", UDim2.new(0, 20, 0, 270), "UseFly")

-- 2. NÚT NEX CHỮ ĐẸP
MiniButton.Name = "NEX_Toggle"
MiniButton.Size = UDim2.new(0, 60, 0, 40)
MiniButton.Position = UDim2.new(0, 20, 0.2, 0)
MiniButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MiniButton.Text = "NEX"
MiniButton.TextColor3 = Color3.new(1, 1, 1)
MiniButton.Font = Enum.Font.LuckiestGuy
MiniButton.TextSize = 20
MiniButton.Visible = true
MiniButton.Draggable = true
Instance.new("UICorner", MiniButton).CornerRadius = UDim.new(0, 8)
MiniStroke.Thickness = 2
MiniButton.Parent = ScreenGui

MiniButton.MouseButton1Click:Connect(function() MainFrame.Visible = true; MiniButton.Visible = false end)
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 25, 0, 25); CloseBtn.Position = UDim2.new(1, -30, 0, 5); CloseBtn.Text = "_"
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; MiniButton.Visible = true end)

-- 3. HÀM KIỂM TRA ADMIN
local function IsAdmin(player)
    if player:GetRankInGroup(2913303) >= 100 or player.UserId == 16122546 or player.UserId == 27268945 then
        return true
    end
    return false
end

-- 4. VÒNG LẶP XỬ LÝ CHÍNH
spawn(function()
    while task.wait(0.01) do
        pcall(function()
            local lp = game.Players.LocalPlayer
            local char = lp.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end

            -- KILL AURA 400M (Thêm vào vòng lặp của ông)
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

            -- CHAIN KILL THEO LƯỢT (Giữ nguyên)
            if _G.UseMurd then
                local knife = lp.Backpack:FindFirstChild("Knife") or char:FindFirstChild("Knife")
                if knife then
                    char.Humanoid:EquipTool(knife)
                    local players = game.Players:GetPlayers()
                    table.sort(players, function(a, b)
                        return a.Backpack:FindFirstChild("Gun") or (a.Character and a.Character:FindFirstChild("Gun"))
                    end)

                    for _, p in pairs(players) do
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

            -- ESP VỚI MÀU SẮC YÊU CẦU (Giữ nguyên)
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

            -- NHẶT SÚNG TỪ XA (Giữ nguyên)
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
