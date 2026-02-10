-- [[ NEX HUB - BLOX FRUITS: V10 MODERN GUI & ULTRA SNIPER ]]
if not game:IsLoaded() then game.Loaded:Wait() end
repeat task.wait() until game.Players.LocalPlayer and game.Players.LocalPlayer.Character

-- 1. HỆ THỐNG LƯU TRẠNG THÁI
local folder, file = "NEX_HUB_DATA", "SniperV10_Config.json"
if not isfolder(folder) then makefolder(folder) end
local function Save(d) writefile(folder.."/"..file, game:GetService("HttpService"):JSONEncode(d)) end
local function Load()
    if isfile(folder.."/"..file) then
        local s, r = pcall(function() return game:GetService("HttpService"):JSONDecode(readfile(folder.."/"..file)) end)
        if s then return r end
    end
    return {Enabled = true}
end
local Config = Load()

-- 2. GIAO DIỆN HIỆN ĐẠI (MODERN UI)
local SG = Instance.new("ScreenGui", game.CoreGui)
local MF = Instance.new("Frame", SG)
local Btn = Instance.new("TextButton", MF)
local Lbl = Instance.new("TextLabel", MF)

-- GUI Chính
MF.Size, MF.Position = UDim2.new(0, 260, 0, 150), UDim2.new(0.5, -130, 0.4, 0)
MF.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MF.BorderSizePixel = 0
MF.Active, MF.Draggable = true, true
Instance.new("UICorner", MF).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", MF)
MainStroke.Thickness, MainStroke.Color = 2, Color3.fromRGB(120, 50, 255)

-- Nút Bật/Tắt
Btn.Size, Btn.Position = UDim2.new(0, 220, 0, 50), UDim2.new(0, 20, 0, 30)
Btn.Text = Config.Enabled and "SNIPER: ON" or "SNIPER: OFF"
Btn.BackgroundColor3 = Config.Enabled and Color3.fromRGB(40, 180, 100) or Color3.fromRGB(60, 60, 70)
Btn.Font, Btn.TextSize, Btn.TextColor3 = Enum.Font.GothamBold, 18, Color3.new(1,1,1)
Instance.new("UICorner", Btn)

-- Trạng thái
Lbl.Size, Lbl.Position = UDim2.new(0, 210, 0, 30), UDim2.new(0, 25, 0, 95)
Lbl.Text = "System: Ready"
Lbl.TextColor3, Lbl.BackgroundTransparency, Lbl.Font = Color3.fromRGB(200, 200, 200), 1, Enum.Font.GothamMedium

-- 3. BIỂU TƯỢNG NEX HIỆN ĐẠI (MINI BUTTON)
local Mini = Instance.new("TextButton", SG)
local MiniCorner = Instance.new("UICorner", Mini)
local MiniStroke = Instance.new("UIStroke", Mini)
local MiniGradient = Instance.new("UIGradient", Mini)

Mini.Name = "NEX_Mini"
Mini.Size = UDim2.new(0, 60, 0, 60)
Mini.Position = UDim2.new(0, 15, 0.5, -30)
Mini.BackgroundColor3 = Color3.new(1, 1, 1)
Mini.Text = "NEX"
Mini.Font = Enum.Font.LuckiestGuy
Mini.TextSize = 20
Mini.TextColor3 = Color3.new(1, 1, 1)

MiniCorner.CornerRadius = UDim.new(1, 0) -- Hình tròn hiện đại
MiniStroke.Thickness, MiniStroke.Color = 3, Color3.new(1, 1, 1)
MiniGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 50, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 200, 255))
}

-- Hiệu ứng nhấp nháy viền nhẹ cho nút NEX
task.spawn(function()
    while task.wait(0.1) do
        MiniStroke.Color = Color3.fromHSV(tick() % 5 / 5, 0.8, 1)
    end
end)

Mini.MouseButton1Click:Connect(function() 
    MF.Visible = not MF.Visible 
end)

-- 4. LOGIC SERVER HOP CỰC MẠNH
local function Hop()
    Lbl.Text = "Status: Hopping..."
    local Http = game:GetService("HttpService")
    pcall(function()
        local Servers = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
        for _, v in pairs(Servers.data) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, v.id)
                task.wait(3)
            end
        end
    end)
    task.wait(2)
    game:GetService("TeleportService"):Teleport(game.PlaceId)
end

-- 5. LOGIC SNIPER & STORE
local function Main()
    if not Config.Enabled then return end
    task.wait(2)
    
    local fruit = nil
    for _, v in pairs(game.Workspace:GetChildren()) do
        if v:IsA("Tool") and (v.Name:find("Fruit") or v.Name:find("Trái")) then
            fruit = v; break
        end
    end

    if fruit then
        Lbl.Text = "Found: " .. fruit.Name
        local lp = game.Players.LocalPlayer
        local root = lp.Character.HumanoidRootPart
        
        -- Nhặt
        local t = tick()
        repeat
            root.CFrame = fruit.Handle.CFrame
            firetouchinterest(root, fruit.Handle, 0); firetouchinterest(root, fruit.Handle, 1)
            task.wait(0.1)
        until fruit.Parent ~= game.Workspace or tick() - t > 5
        
        -- Cất kho
        task.wait(1)
        local st = tick()
        repeat
            local tool = lp.Backpack:FindFirstChild(fruit.Name) or lp.Character:FindFirstChild(fruit.Name)
            if tool then
                lp.Character.Humanoid:EquipTool(tool)
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", tool:GetAttribute("FruitName") or tool.Name, tool)
            end
            task.wait(0.5)
        until (not lp.Backpack:FindFirstChild(fruit.Name) and not lp.Character:FindFirstChild(fruit.Name)) or tick() - st > 8
        
        Hop()
    else
        for i = 3, 1, -1 do
            Lbl.Text = "No Fruit. Hopping in: "..i.."s"
            task.wait(1)
        end
        Hop()
    end
end

-- 6. ĐIỀU KHIỂN
Btn.MouseButton1Click:Connect(function()
    Config.Enabled = not Config.Enabled
    Save(Config)
    Btn.Text = Config.Enabled and "SNIPER: ON" or "SNIPER: OFF"
    Btn.BackgroundColor3 = Config.Enabled and Color3.fromRGB(40, 180, 100) or Color3.fromRGB(60, 60, 70)
    if Config.Enabled then task.spawn(Main) end
end)

if Config.Enabled then task.spawn(Main) end

-- Anti-Stuck (30s)
task.spawn(function()
    while task.wait(30) do if Config.Enabled then Hop() end end
end)
