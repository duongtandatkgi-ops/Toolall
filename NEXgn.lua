-- [[ NEX HUB: MUSIC PLAYER V2.1 - MINIMIZE FEATURE ]]
local CoreGui = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local SoundService = game:GetService("SoundService")

-- Xóa UI cũ nếu chạy lại script
local existingGui = CoreGui:FindFirstChild("NexMusicPlayer")
if existingGui then existingGui:Destroy() end

-- Tạo bộ phát âm thanh
local MyAudio = SoundService:FindFirstChild("NexCustomAudio")
if not MyAudio then
    MyAudio = Instance.new("Sound")
    MyAudio.Name = "NexCustomAudio"
    MyAudio.Parent = SoundService
    MyAudio.Volume = 1
    MyAudio.Looped = true
end

-- Danh sách 6 ID
local songList = {
    "133758365650956",
    "99152674992699",
    "108477308631109",
    "1845922899",
    "77654003503401",
    "124384558101360"
}

-- [1. GIAO DIỆN CHÍNH]
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "NexMusicPlayer"
ScreenGui.ResetOnSpawn = false

-- Nút nổi (Nốt nhạc) để mở lại UI khi đã thu nhỏ
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0, 20, 0.4, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
OpenBtn.Text = "🎵"
OpenBtn.TextSize = 20
OpenBtn.Visible = false -- Ban đầu ẩn đi
OpenBtn.Active = true
OpenBtn.Draggable = true -- Có thể kéo thả nút nhỏ này
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0) -- Làm tròn thành hình tròn

-- Khung chính
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 210)
MainFrame.Position = UDim2.new(0.4, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

-- Tiêu đề
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(45, 30, 30)
Title.Text = "  NEX HUB | MUSIC PLAYER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 8)

-- NÚT THU NHỎ (×)
local MinimizeBtn = Instance.new("TextButton", MainFrame)
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -35, 0, 2)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Text = "×"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
MinimizeBtn.TextSize = 24
MinimizeBtn.Font = Enum.Font.SourceSansBold

-- Ô nhập ID
local IDInput = Instance.new("TextBox", MainFrame)
IDInput.Size = UDim2.new(0, 220, 0, 35)
IDInput.Position = UDim2.new(0.5, -110, 0, 50)
IDInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
IDInput.Text = ""
IDInput.PlaceholderText = "Nhập hoặc chọn ID bên cạnh..."
IDInput.TextColor3 = Color3.fromRGB(255, 255, 255)
IDInput.TextSize = 14
IDInput.Font = Enum.Font.SourceSansBold
IDInput.ClearTextOnFocus = false
Instance.new("UICorner", IDInput).CornerRadius = UDim.new(0, 6)

local PlayBtn = Instance.new("TextButton", MainFrame)
PlayBtn.Size = UDim2.new(0, 100, 0, 40)
PlayBtn.Position = UDim2.new(0, 20, 0, 100)
PlayBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
PlayBtn.Text = "PLAY"
PlayBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayBtn.TextSize = 14
PlayBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", PlayBtn).CornerRadius = UDim.new(0, 6)

local StopBtn = Instance.new("TextButton", MainFrame)
StopBtn.Size = UDim2.new(0, 100, 0, 40)
StopBtn.Position = UDim2.new(1, -120, 0, 100)
StopBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
StopBtn.Text = "STOP"
StopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StopBtn.TextSize = 14
StopBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", StopBtn).CornerRadius = UDim.new(0, 6)

-- Nút Danh Sách
local ListToggleBtn = Instance.new("TextButton", MainFrame)
ListToggleBtn.Size = UDim2.new(0, 220, 0, 35)
ListToggleBtn.Position = UDim2.new(0.5, -110, 0, 155)
ListToggleBtn.BackgroundColor3 = Color3.fromRGB(70, 60, 90)
ListToggleBtn.Text = "📜 DANH SÁCH NHẠC GỢI Ý"
ListToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ListToggleBtn.TextSize = 13
ListToggleBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", ListToggleBtn).CornerRadius = UDim.new(0, 6)

-- [2. BẢNG DANH SÁCH NHỎ (SIDE PANEL)]
local SideFrame = Instance.new("Frame", MainFrame)
SideFrame.Size = UDim2.new(0, 180, 0, 210)
SideFrame.Position = UDim2.new(1, 10, 0, 0)
SideFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SideFrame.Visible = false 
Instance.new("UICorner", SideFrame).CornerRadius = UDim.new(0, 8)

local SideTitle = Instance.new("TextLabel", SideFrame)
SideTitle.Size = UDim2.new(1, 0, 0, 30)
SideTitle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SideTitle.Text = " CHỌN ID NHANH"
SideTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
SideTitle.TextSize = 12
SideTitle.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", SideTitle).CornerRadius = UDim.new(0, 8)

local ScrollList = Instance.new("ScrollingFrame", SideFrame)
ScrollList.Size = UDim2.new(1, -10, 1, -40)
ScrollList.Position = UDim2.new(0, 5, 0, 35)
ScrollList.BackgroundTransparency = 1
ScrollList.CanvasSize = UDim2.new(0, 0, 0, #songList * 32)
ScrollList.ScrollBarThickness = 4

local UIListLayout = Instance.new("UIListLayout", ScrollList)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- [3. HÀM XỬ LÝ]
local function playAudioById(id)
    MyAudio:Stop()
    MyAudio.SoundId = "rbxassetid://" .. id
    IDInput.Text = id
    if not MyAudio.IsLoaded then MyAudio.Loaded:Wait() end
    MyAudio:Play()
end

for index, id in pairs(songList) do
    local IdBtn = Instance.new("TextButton", ScrollList)
    IdBtn.Size = UDim2.new(1, -5, 0, 26)
    IdBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    IdBtn.Text = "🎵 Bài " .. tostring(index) .. ": " .. id
    IdBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
    IdBtn.TextSize = 12
    IdBtn.Font = Enum.Font.SourceSans
    Instance.new("UICorner", IdBtn).CornerRadius = UDim.new(0, 4)
    
    IdBtn.MouseButton1Click:Connect(function() playAudioById(id) end)
end

-- [4. SỰ KIỆN NÚT BẤM]
-- Sự kiện Nút Thu Nhỏ (×)
MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true -- Hiện nút Nốt nhạc xíu xiu
end)

-- Sự kiện Mở Lại (Bấm vào nút Nốt nhạc)
OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false -- Ẩn đi khi bảng đã mở
end)

ListToggleBtn.MouseButton1Click:Connect(function() SideFrame.Visible = not SideFrame.Visible end)

PlayBtn.MouseButton1Click:Connect(function()
    local soundId = IDInput.Text:match("%d+")
    if soundId then
        playAudioById(soundId)
    else
        IDInput.Text = "Lỗi ID!"
        task.wait(1.5)
        IDInput.Text = ""
    end
end)

StopBtn.MouseButton1Click:Connect(function() MyAudio:Stop() end)

print("✅ Music Player V2.1: Đã thêm nút thu nhỏ (×)!")
