-- [[ TOOLALL MM2 - NÚT NEX RGB - FONT CHỮ ĐẸP ]]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
local MiniButton = Instance.new("TextButton", ScreenGui) -- Đổi lại thành nút chữ
local UIStroke = Instance.new("UIStroke", MainFrame)
local MiniStroke = Instance.new("UIStroke", MiniButton)

-- 1. GIAO DIỆN CHÍNH
MainFrame.Name = "MM2_NEX_Gui"
MainFrame.Size = UDim2.new(0, 300, 0, 280)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Visible = false -- Ẩn menu chính lúc đầu
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

UIStroke.Thickness = 2
spawn(function()
    while task.wait() do 
        local color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
        UIStroke.Color = color
        MiniStroke.Color = color -- Hiệu ứng RGB cho cả nút NEX
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
    end)
end

CreateToggle("ESP Soi Vai Trò", UDim2.new(0, 20, 0, 50), "UseESP")
CreateToggle("Auto Kill (Sheriff First)", UDim2.new(0, 20, 0, 110), "UseMurd")
CreateToggle("Nhặt Súng Từ Xa", UDim2.new(0, 20, 0, 170), "UseLoot")

-- 2. CÀI ĐẶT NÚT THU NHỎ "NEX" (FONT ĐẸP)
MiniButton.Name = "NEX_Button"
MiniButton.Size = UDim2.new(0, 60, 0, 40) -- Hình chữ nhật nhỏ gọn
MiniButton.Position = UDim2.new(0, 20, 0.2, 0)
MiniButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MiniButton.Text = "NEX"
MiniButton.TextColor3 = Color3.new(1, 1, 1)
MiniButton.Font = Enum.Font.LuckiestGuy -- Font chữ nghệ thuật dày và đẹp
MiniButton.TextSize = 20
MiniButton.Visible = true
MiniButton.Draggable = true
Instance.new("UICorner", MiniButton).CornerRadius = UDim.new(0, 8)

MiniStroke.Thickness = 2
MiniStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MiniButton.Parent = ScreenGui

-- 3. LOGIC ĐÓNG/MỞ
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.Text = "_"
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold

CloseBtn.MouseButton1Click:Connect(function() 
    MainFrame.Visible = false 
    MiniButton.Visible = true 
end)

MiniButton.MouseButton1Click:Connect(function() 
    MainFrame.Visible = true 
    MiniButton.Visible = false 
end)

-- 4. VÒNG LẶP AUTO (GIỮ NGUYÊN TỐC ĐỘ CHÉM NHANH)
spawn(function()
    while task.wait(0.01) do
        pcall(function()
            local lp = game.Players.LocalPlayer
            local char = lp.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end

            if _G.UseLoot then
                for _, v in pairs(game.Workspace:GetDescendants()) do
                    if v.Name == "GunDrop" or v.Name == "GunHandle" then
                        firetouchinterest(char.HumanoidRootPart, v:IsA("BasePart") and v or v.Parent, 0)
                        firetouchinterest(char.HumanoidRootPart, v:IsA("BasePart") and v or v.Parent, 1)
                    end
                end
            end

            if _G.UseMurd then
                local knife = lp.Backpack:FindFirstChild("Knife") or char:FindFirstChild("Knife")
                if knife then
                    char.Humanoid:EquipTool(knife)
                    local targets = game.Players:GetPlayers()
                    table.sort(targets, function(a, b)
                        local hasGun = (a.Backpack:FindFirstChild("Gun") or (a.Character and a.Character:FindFirstChild("Gun")))
                        return hasGun
                    end)
                    for _, p in pairs(targets) do
                        if p ~= lp and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                            char.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1)
                            knife:Activate()
                            local s = knife:FindFirstChild("Stab") or knife:FindFirstChild("Slash")
                            if s then s:FireServer() end
                            break 
                        end
                    end
                end
            end
            
            if _G.UseESP then
                for _, p in pairs(game.Players:GetPlayers()) do
                    if p ~= lp and p.Character then
                        local h = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
                        local m = p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")
                        local s = p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun")
                        h.FillColor = m and Color3.new(1,0,0) or (s and Color3.new(1,1,0) or Color3.new(0,1,0))
                        h.Enabled = true
                    end
                end
            end
        end)
    end
end)
