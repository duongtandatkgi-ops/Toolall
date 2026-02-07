-- [[ GEMINI V21 - ALL IMPACT (BRING PLAYERS TO TOOL) ]]
-- [[ Tác động Tool lên toàn bộ Server | Sử dụng cẩn thận ]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

_G.ImpactAll = false

-- 1. TẠO GIAO DIỆN NHANH
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Button = Instance.new("TextButton", ScreenGui)
Button.Size = UDim2.new(0, 150, 0, 50)
Button.Position = UDim2.new(0.5, -75, 0.1, 0)
Button.Text = "IMPACT ALL: OFF"
Button.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
Button.TextColor3 = Color3.new(1, 1, 1)

Button.MouseButton1Click:Connect(function()
    _G.ImpactAll = not _G.ImpactAll
    Button.Text = "IMPACT ALL: " .. (_G.ImpactAll and "ON" or "OFF")
    Button.BackgroundColor3 = _G.ImpactAll and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
end)

-- 2. LOGIC TÁC ĐỘNG (DI CHUYỂN NGƯỜI CHƠI KHÁC VÀO TẦM ĐÁNH)
spawn(function()
    while task.wait() do
        if _G.ImpactAll then
            pcall(function()
                local myChar = LocalPlayer.Character
                local tool = myChar:FindFirstChildOfClass("Tool")
                
                if tool then
                    -- Tìm tất cả người chơi trong Server
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            local enemyHRP = p.Character.HumanoidRootPart
                            
                            -- ĐƯA ĐỐI THỦ VỀ TRƯỚC MẶT BẠN (TẦM ĐÁNH CỦA TOOL)
                            -- Lưu ý: Chỉ di chuyển phía Client của bạn để tránh bị Server đá
                            enemyHRP.CFrame = myChar.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                            
                            -- GIẢ LẬP ĐÒN ĐÁNH (CLICK)
                            game:GetService("VirtualUser"):CaptureController()
                            game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                        end
                    end
                end
            end)
        end
    end
end)
