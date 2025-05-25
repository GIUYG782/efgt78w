local localPlayer = game:GetService("Players").LocalPlayer
local uis = game:GetService("UserInputService")
local isRunning = false 
local multiplier = 1000
task.spawn(function()
    local hint = Instance.new("Hint", workspace)
    hint.Text = "Script Made By Proofex And MARTIN (KIDS)"
    task.wait(2)
    hint:Destroy()
end)
 
 
uis.InputBegan:Connect(function(i, gp)
    if gp then return end 
    if i.KeyCode == Enum.KeyCode.Q then 
        isRunning = true 
        while isRunning do 
            task.wait()
            localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame + localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame.lookVector * multiplier
        end
    end
end)
uis.InputEnded:Connect(function(i, gp)
    if gp then return end 
    if i.KeyCode == Enum.KeyCode.Q then 
        isRunning = false
    end
