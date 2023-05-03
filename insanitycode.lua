
-- // Macro Code- Rest of source is below
if Visual.Macro.Enabled == true and Visual.Macro.Keybind ~= nil then
    local Player = game:GetService("Players").LocalPlayer
    local Mouse = Player:GetMouse()
    local Settings = Settings

    local Enabled = Visual.Macro.Enabled
    local MacroKey = Visual.Macro.Keybind
    local Delay = "0.1"

    Mouse.KeyDown:Connect(function(Key)
        if Key == MacroKey then
            Enabled = not Enabled
            if Enabled then
                repeat
                    game:GetService("RunService").Heartbeat:Wait()
                    game:GetService("VirtualInputManager"):SendMouseWheelEvent(Delay, Delay, true, game)
                    game:GetService("RunService").Heartbeat:Wait()
                    game:GetService("VirtualInputManager"):SendMouseWheelEvent(Delay, Delay, false, game)
                    game:GetService("RunService").Heartbeat:Wait()
                until not Enabled
            end
        end
    end)
end



-- // If You See This Means That You Got This Or It Got Leaked. Look I Do Not Care About You Skidding Of It But If Your Just Gonna try To Make The Exact Same Replica Imma Beat Yo Mamma. AnyWays Gl 

-- // Checks If Obfuscated Else Makes Luraph Macro Useless Function
if not LPH_OBFUSCATED then
    LPH_JIT_MAX = function(...)
        return (...)
    end
    LPH_NO_VIRTUALIZE = function(...)
        return (...)
    end
end

LPH_JIT_MAX(function()
-- // Variables (Too Lazy To Make It To One Local)
local Visual = getgenv().Visual
local OldSilentAimPart = Visual.Silent.Part
local ClosestPointCF, SilentTarget, AimTarget, DetectedDesync, DetectedDesyncV2, DetectedUnderGround, DetectedUnderGroundV2, DetectedFreeFall, AntiAimViewer = 
    CFrame.new(), 
    nil, 
    nil, 
    false, 
    false, 
    false, 
    false, 
    false, 
    true
local Script = {Functions = {}, Friends = {}, Drawing = {}, EspPlayers = {}}

local Players, Client, Mouse, RS, Camera, GuiS, Uis, Ran =
    game:GetService("Players"),
    game:GetService("Players").LocalPlayer,
    game:GetService("Players").LocalPlayer:GetMouse(),
    game:GetService("RunService"),
    game:GetService("Workspace").CurrentCamera,
    game:GetService("GuiService"),
    game:GetService("UserInputService"),
    math.random

-- // Drawing For AimAssist And SilentAim
Script.Drawing.SilentCircle = Drawing.new("Circle")
Script.Drawing.SilentCircle.Color = Color3.new(1,1,1)
Script.Drawing.SilentCircle.Thickness = 1

Script.Drawing.AimAssistCircle = Drawing.new("Circle")
Script.Drawing.AimAssistCircle.Color = Color3.new(1,1,1)
Script.Drawing.AimAssistCircle.Thickness = 1

-- // Chat Check
Client.Chatted:Connect(function(Msg)
    if Msg == Visual.Commands.CrashMode then
        while true do end
    end
    local Splitted = string.split(Msg, " ")
    if Splitted[1] and Splitted[2] and Visual.Commands.Enabled then
        if Splitted[1] == Visual.Commands.Silent_Prediction then
            Visual.Silent.PredictionVelocity = Splitted[2]
        elseif Splitted[1] == Visual.Commands.Silent_Fov_Size then
            Visual.SilentFov.Radius = Splitted[2]
        elseif Splitted[1] == Visual.Commands.Silent_Fov_Show then
            if Splitted[2] == "true" then
                Visual.SilentFov.Visible = true
            else
                Visual.SilentFov.Visible = false
            end
        elseif Splitted[1] == Visual.Commands.Silent_Enabled then
            if Splitted[2] == "true" then
                Visual.Silent.Enabled = true
            else
                Visual.Silent.Enabled = false 
            end
        elseif Splitted[1] == Visual.Commands.Silent_HitChance then
            Visual.Silent.HitChance = Splitted[2]
        elseif Splitted[1] == Visual.Commands.AimAssist_Prediction then
            Visual.AimAssist.PredictionVelocity = Splitted[2]
        elseif Splitted[1] == Visual.Commands.AimAssist_Fov_Size then
            Visual.AimAssistFov.Radius = Splitted[2]
        elseif Splitted[1] == Visual.Commands.AimAssist_Fov_Show then
            if Splitted[2] == "true" then
                Visual.AimAssistFov.Visible = true
            else
                Visual.AimAssistFov.Visible = false
            end
        elseif Splitted[1] == Visual.Commands.AimAssist_Enabled then
            if Splitted[2] == "true" then
                Visual.AimAssist.Enabled = true
            else
                Visual.AimAssist.Enabled = false
            end
        elseif Splitted[1] == Visual.Commands.AimAssist_SmoothX then
            Visual.AimAssist.Smoothness_X = Splitted[2]
        elseif Splitted[1] == Visual.Commands.AimAssist_SmoothY then
            Visual.AimAssist.Smoothness_Y = Splitted[2]
        elseif Splitted[1] == Visual.Commands.AimAssist_Shake then
            Visual.AimAssist.ShakeValue = Splitted[2]
        end
    end
end)

-- // KeyDown Check
Mouse.KeyDown:Connect(function(Key)
    local Keybind = Visual.AimAssist.Key:lower()
    if Key == Keybind then
        if Visual.AimAssist.Enabled then
            IsTargetting = not IsTargetting
            if IsTargetting then
                Script.Functions.GetClosestPlayer2()
            else
                if AimTarget ~= nil then
                    AimTarget = nil
                    IsTargetting = false
                end
            end
        end
    end
    local Keybind2 = Visual.Silent.Keybind:lower()
    if Key == Keybind2 and Visual.Silent.UseKeybind then
        Visual.Silent.Enabled = not Visual.Silent.Enabled
        if Visual.Both.SendNotification then
            game.StarterGui:SetCore("SendNotification",{
                Title = "Insanity",
                Text = "Silent Aim: " .. tostring(Visual.Silent.Enabled),
                Icon = "rbxassetid://12225612888",
                Duration = 1
            })
        end
    end
    local Keybind3 = Visual.Both.UnderGroundKey:lower()
    if Key == Keybind3 and Visual.Both.UseUnderGroundKeybind then
        Visual.Both.DetectUnderGround = not Visual.Both.DetectUnderGround
        if Visual.Both.SendNotification then
            game.StarterGui:SetCore("SendNotification",{
                Title = "Insanity",
                Text = "UnderGround Resolver: " .. tostring(Visual.Both.DetectUnderGround),
                Icon = "rbxassetid://12225612888",
                Duration = 1
            })
        end
    end
    local Keybind4 = Visual.Both.DetectDesyncKey:lower()
    if Key == Keybind4 and Visual.Both.UsDetectDesyncKeybind then
        Visual.Both.DetectDesync = not Visual.Both.DetectDesync
        if Visual.Both.SendNotification then
            game.StarterGui:SetCore("SendNotification",{
                Title = "Insanity",
                Text = "Desync Resolver: " .. tostring(Visual.Both.DetectDesync),
                Icon = "rbxassetid://12225612888",
                Duration = 1
            })
        end
    end
    local Keybind5 = Visual.Both.LayKeybind:lower()
    if Key == Keybind5 and Visual.Both.UseLay then
        local Args = {
            [1] = "AnimationPack",
            [2] = "Lay"
        }
        game:GetService("ReplicatedStorage"):FindFirstChild("MainEvent"):FireServer(unpack(Args))
    end
    local Keybind6 = Visual.Esp.EspKey:lower()
    if Key == Keybind6 and Visual.Esp.UseEspKeybind then
		if Visual.Esp.HoldMode then
			Visual.Esp.Enabled = true
		else
			Visual.Esp.Enabled = not Visual.Esp.Enabled
		end
    end
end)

-- // KeyUp Check
Mouse.KeyUp:Connect(function(Key)
    local Keybind = Visual.Esp.EspKey:lower()
    if Key == Keybind and Visual.Esp.UseEspKeybind and Visual.Esp.HoldMode then
		Visual.Esp.Enabled = false
    end
    local Keybind2 = Visual.AimAssist.Key:lower()
    if Key == Keybind2 and Visual.AimAssist.Enabled and Visual.AimAssist.HoldMode then
        IsTargetting = false
		AimTarget = nil
    end
end)

-- // Disabled If AntiAimViewer Is On
if Visual.Silent.AntiAimViewer then
    AntiAimViewer = false
else
    AntiAimViewer = true
end

-- // Blocks Mouse Triggering
game:GetService("ContextActionService"):BindActionAtPriority(
    "LeftMouseBlock",
    function()
        if AntiAimViewer == false and Visual.Silent.AntiAimViewer and Client.Character and Client.Character:FindFirstChildWhichIsA("Tool") then
            return Enum.ContextActionResult.Sink
        else
            return Enum.ContextActionResult.Pass
        end
    end,
    true,
    Enum.ContextActionPriority.Low.Value,
    Enum.UserInputType.MouseButton1
)

-- // Delaying The Mouse Trigger
Uis.InputBegan:connect(function(input)
    if input.UserInputType == Enum.UserInputType[Visual.Silent.TriggerBotKey] and Visual.Silent.UseTriggerBotKeybind then
        Visual.Silent.TriggerBot = true
    end
    if input.UserInputType == Enum.UserInputType.MouseButton1 and Visual.Silent.AntiAimViewer and Client.Character and Client.Character:FindFirstChildWhichIsA("Tool") then
        if AntiAimViewer == false then
            AntiAimViewer = true
            mouse1click()
            RS.RenderStepped:Wait()
            RS.RenderStepped:Wait()
            mouse1press()
            RS.RenderStepped:Wait()
            RS.RenderStepped:Wait()
            AntiAimViewer = false
        end
    end
end)

-- // Helps With Automatics
Uis.InputEnded:connect(function(input)
    if input.UserInputType == Enum.UserInputType[Visual.Silent.TriggerBotKey] and Visual.Silent.UseTriggerBotKeybind then
        Visual.Silent.TriggerBot = true
    end
    if input.UserInputType == Enum.UserInputType.MouseButton1 and Visual.Silent.AntiAimViewer and Client.Character and Client.Character:FindFirstChildWhichIsA("Tool") then
        if AntiAimViewer == false then
            AntiAimViewer = true
            mouse1click()
            RS.RenderStepped:Wait()
            RS.RenderStepped:Wait()
            mouse1click()
            RS.RenderStepped:Wait()
            RS.RenderStepped:Wait()
            AntiAimViewer = true
        end
    end
end)

-- // Checks If The Player Is Alive
Script.Functions.Alive = LPH_NO_VIRTUALIZE(function(Plr)
    if Plr and Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart") ~= nil and Plr.Character:FindFirstChild("Humanoid") ~= nil and Plr.Character:FindFirstChild("Head") ~= nil then
        return true
    end
    return false
end)

-- // Checks If Player Is On Your Screen
Script.Functions.OnScreen = LPH_NO_VIRTUALIZE(function(Object)
    local _, screen = Camera:WorldToScreenPoint(Object.Position)
    return screen
end)

-- // Gets Magnitude From Part Position And Mouse
Script.Functions.GetMagnitudeFromMouse = LPH_NO_VIRTUALIZE(function(Part)
    local PartPos, OnScreen = Camera:WorldToScreenPoint(Part.Position)
    if OnScreen then
        local Magnitude = (Vector2.new(PartPos.X, PartPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
        return Magnitude
    end
    return math.huge
end)

-- // Makes Random Number With Vector3 
Script.Functions.RandomVec = LPH_NO_VIRTUALIZE(function(Number, Multi)
    return (Vector3.new(Ran(-Number, Number), Ran(-Number, Number), Ran(-Number, Number)) * Multi or 1)
end)

-- // Checks If The Player Is Behind A Wall Or Something Else
Script.Functions.RayCastCheck = LPH_NO_VIRTUALIZE(function(Part, PartDescendant)
    local Character = Client.Character or Client.CharacterAdded.Wait(Client.CharacterAdded)
    local Origin = Camera.CFrame.Position

    local RayCastParams = RaycastParams.new()
    RayCastParams.FilterType = Enum.RaycastFilterType.Blacklist
    RayCastParams.FilterDescendantsInstances = {Character, Camera}

    local Result = Workspace.Raycast(Workspace, Origin, Part.Position - Origin, RayCastParams)
    
    if (Result) then
        local PartHit = Result.Instance
        local Visible = (not PartHit or Instance.new("Part").IsDescendantOf(PartHit, PartDescendant))
        
        return Visible
    end
    return false
end)

-- // Gets The Part From An Object
Script.Functions.GetParts = LPH_NO_VIRTUALIZE(function(Object)
    if string.find(Object.Name, "Gun") then
        return
    end
    if table.find({"Part", "MeshPart", "BasePart"}, Object.ClassName) then
        return true
    end
end)

-- // Random Number To Compare
Script.Functions.CalculateChance = LPH_NO_VIRTUALIZE(function(Percentage)
    Percentage = math.floor(Percentage)
    local chance = math.floor(Random.new().NextNumber(Random.new(), 0, 1) * 100) / 100

    return chance < Percentage / 100
end)

-- // Check If Crew Folder Is A Thing
Script.Functions.FindCrew = LPH_NO_VIRTUALIZE(function(Player)
	if Player:FindFirstChild("DataFolder") and Player.DataFolder:FindFirstChild("Information") and Player.DataFolder.Information:FindFirstChild("Crew") and Client:FindFirstChild("DataFolder") and Client.DataFolder:FindFirstChild("Information") and Client.DataFolder.Information:FindFirstChild("Crew") then
        if Client.DataFolder.Information:FindFirstChild("Crew").Value ~= nil and Player.DataFolder.Information:FindFirstChild("Crew").Value ~= nil and Player.DataFolder.Information:FindFirstChild("Crew").Value ~= "" and Client.DataFolder.Information:FindFirstChild("Crew").Value ~= "" then 
			return true
		end
	end
	return false
end)

-- // Splits The Gun Name And Splits []
Script.Functions.GetGunName = LPH_NO_VIRTUALIZE(function(Name)
    local split = string.split(string.split(Name, "[")[2], "]")[1]
    return split
end)

-- // Gets Current Gun
Script.Functions.GetCurrentWeaponName = LPH_NO_VIRTUALIZE(function()
    if Client.Character and Client.Character:FindFirstChildWhichIsA("Tool") then
       local Tool =  Client.Character:FindFirstChildWhichIsA("Tool")
       if string.find(Tool.Name, "%[") and string.find(Tool.Name, "%]") and not string.find(Tool.Name, "Wallet") and not string.find(Tool.Name, "Phone") then
          return Script.Functions.GetGunName(Tool.Name)
       end
    end
    return nil
end)
-- // Headless Horseman Script


-- // Macro Official Code
-- at the top dumbass

-- // Drawing Function With Property Attached
Script.Functions.NewDrawing = LPH_NO_VIRTUALIZE(function(Type, Properties)
    local NewDrawing = Drawing.new(Type)

    for i,v in next, Properties or {} do
        NewDrawing[i] = v
    end
    return NewDrawing
end)

-- // Draws For The New Players Joining For Esp
Script.Functions.NewPlayer = LPH_NO_VIRTUALIZE(function(Player)
    Script.EspPlayers[Player] = {
        Name = Script.Functions.NewDrawing("Text", {Color = Color3.fromRGB(255,2550, 255), Outline = true, Visible = false, Center = true, Size = 13, Font = 0}),
        BoxOutline = Script.Functions.NewDrawing("Square", {Color = Color3.fromRGB(0, 0, 0), Thickness = 3, Visible = false}),
        Box = Script.Functions.NewDrawing("Square", {Color = Color3.fromRGB(255, 255, 255), Thickness = 1, Visible = false}),
        HealthBarOutline = Script.Functions.NewDrawing("Line", {Color = Color3.fromRGB(0, 0, 0), Thickness = 3, Visible = false}),
        HealthBar = Script.Functions.NewDrawing("Line", {Color = Color3.fromRGB(0, 255, 0), Thickness = 1, Visible = false}),
        HealthText = Script.Functions.NewDrawing("Text", {Color = Color3.fromRGB(0, 255, 0), Outline = true, Visible = false, Center = true, Size = 13, Font = 0}),
        Distance = Script.Functions.NewDrawing("Text", {Color = Color3.fromRGB(255, 255, 255), Outline = true, Visible = false, Center = true, Size = 13, Font = 0})
    }
end)

-- // Gets The Closest Part From Cursor
Script.Functions.GetClosestBodyPart = LPH_NO_VIRTUALIZE(function(Char)
    local Distance = math.huge
    local ClosestPart = nil
    local Filterd = {}

    if not (Char and Char:IsA("Model")) then
        return ClosestPart
    end

    local Parts = Char:GetChildren()
    for _, v in pairs(Parts) do
        if Script.Functions.GetParts(v) and Script.Functions.OnScreen(v) then
            table.insert(Filterd, v)
            for _, Part in pairs(Filterd) do                
                local Magnitude = Script.Functions.GetMagnitudeFromMouse(Part)
                if Magnitude < Distance then
                    ClosestPart = Part
                    Distance = Magnitude
                end
            end
        end
    end
    return ClosestPart
end)

-- // Gets The Closest Point From Cursor
Script.Functions.GetClosestPointOfPart = LPH_NO_VIRTUALIZE(function(Part)
    local NearestPosition = nil
    if Part ~= nil then
        local Hit, Half = Mouse.Hit.Position, Part.Size * 0.5
        local Transform = Part.CFrame:PointToObjectSpace(Mouse.Hit.Position)
        NearestPosition = Part.CFrame * Vector3.new(math.clamp(Transform.X, -Half.X, Half.X),math.clamp(Transform.Y, -Half.Y, Half.Y),math.clamp(Transform.Z, -Half.Z, Half.Z))
    end
    return NearestPosition
end)

-- // Gets The Closest Player For Cursor (Silent Aim)
Script.Functions.GetClosestPlayer = LPH_NO_VIRTUALIZE(function()
    local Target = nil
    local Closest = math.huge
    local HitChance = Script.Functions.CalculateChance(Visual.Silent.HitChance)

    if not HitChance then
        return nil
    end
    for _, v in pairs(Players:GetPlayers()) do
        if v.Character and v ~= Client and v.Character:FindFirstChild("HumanoidRootPart") then
            if not Script.Functions.OnScreen(v.Character.HumanoidRootPart) then 
                continue 
            end
            if Visual.Silent.WallCheck and not Script.Functions.RayCastCheck(v.Character.HumanoidRootPart, v.Character) then 
                continue 
            end
            if Visual.Silent.CheckIf_KO and v.Character:FindFirstChild("BodyEffects") then
                local KoCheck = v.Character.BodyEffects:FindFirstChild("K.O").Value
                local Grabbed = v.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
                if KoCheck or Grabbed then
                    continue
                end
            end
            if Visual.Silent.CheckIf_TargetDeath and v.Character:FindFirstChild("Humanoid") then
                if v.Character.Humanoid.health < 4 then
                    continue
                end
            end
            if Visual.Both.VisibleCheck and v.Character:FindFirstChild("Head") then
                if v.Character.Head.Transparency > 0.5 then
                    continue
                end
            end
            if Visual.Both.CrewCheck and Script.Functions.FindCrew(v) and v.DataFolder.Information:FindFirstChild("Crew").Value == Client.DataFolder.Information:FindFirstChild("Crew").Value then
                continue
            end
            if Visual.Both.TeamCheck then
                if v.Team ~= Client.Team then
                    continue
                end
            end
            if Visual.Both.FriendCheck then
                if not table.find(Script.Friends, v.UserId) then
                    continue
                end
            end
            local Distance = Script.Functions.GetMagnitudeFromMouse(v.Character.HumanoidRootPart)

            if (Distance < Closest and Script.Drawing.SilentCircle.Radius + 10 > Distance) then
                Closest = Distance
                Target = v
            end
        end
    end

    SilentTarget = Target
end)

-- // Gets Closest Player From Mouse (AimAssist)
Script.Functions.GetClosestPlayer2 = LPH_NO_VIRTUALIZE(function()
    local Target = nil
    local Distance = nil
    local Closest = math.huge
    
    for _, v in pairs(Players:GetPlayers()) do
        if v.Character and v ~= Client and v.Character:FindFirstChild("HumanoidRootPart") then
            if not Script.Functions.OnScreen(v.Character.HumanoidRootPart) then 
                continue 
            end
            if Visual.AimAssist.WallCheck and not Script.Functions.RayCastCheck(v.Character.HumanoidRootPart, v.Character) then 
                continue 
            end
            local Distance = Script.Functions.GetMagnitudeFromMouse(v.Character.HumanoidRootPart)

            if Distance < Closest then
                if (Visual.AimAssist.UseCircleRadius and Script.Drawing.AimAssistCircle.Radius + 10 < Distance) then continue end
                Closest = Distance
                Target = v
            end
        end
    end

    if Script.Functions.Alive(Target) then
		if Visual.Both.VisibleCheck then
			if Target.Character.Head.Transparency > 0.5 then
				return nil
			end
		end
		if Visual.Both.CrewCheck and Script.Functions.FindCrew(Target) and Target.DataFolder.Information:FindFirstChild("Crew").Value == Client.DataFolder.Information:FindFirstChild("Crew").Value then
			return nil
		end
	end
    if Visual.Both.TeamCheck and Target then
        if Target.Team == Client.Team then
            return nil
        end
    end
    if Visual.Both.FriendCheck then
        if table.find(Script.Friends, Target.UserId) then
            return nil
        end
    end
    
    AimTarget = Target
end)

-- // Server Side Mouse Position Changer
local OldIndex = nil 
OldIndex = hookmetamethod(game, "__index", LPH_NO_VIRTUALIZE(function(self, Index)
    if not checkcaller() and Mouse and self == Mouse and Index == "Hit" and Visual.Silent.Enabled and AntiAimViewer then
        if Script.Functions.Alive(SilentTarget) and Players[tostring(SilentTarget)].Character:FindFirstChild(Visual.Silent.Part) then
            local EndPoint = nil
            local TargetCF = nil
            local TargetVel = Players[tostring(SilentTarget)].Character.HumanoidRootPart.Velocity
            local TargetMov = Players[tostring(SilentTarget)].Character.Humanoid.MoveDirection

            if Visual.Silent.ClosestPoint then
                TargetCF = ClosestPointCF
            else
                TargetCF = Players[tostring(SilentTarget)].Character[Visual.Silent.Part].CFrame
            end

            if Visual.Both.DetectDesync then
                local Magnitude = TargetVel.magnitude
                local Magnitude2 = TargetMov.magnitude
                if Magnitude > Visual.Both.DesyncDetection then
                    DetectedDesync = true
                elseif Magnitude < 1 and Magnitude2 > 0.01 then
                    DetectedDesync = true
                elseif Magnitude > 5 and Magnitude2 < 0.01 then
                    DetectedDesync = true
                else
                    DetectedDesync = false
                end
            else
                DetectedDesync = false
            end
            if Visual.Silent.AntiGroundShots then
                if TargetVel.Y < Visual.Silent.WhenAntiGroundActivate then
                    DetectedFreeFall = true
                else
                    DetectedFreeFall = false
                end
            end
            if Visual.Both.DetectUnderGround then 
                if TargetVel.Y < Visual.Both.UnderGroundDetection then            
                    DetectedUnderGround = true
                else
                    DetectedUnderGround = false
                end
            else
                DetectedUnderGround = false
            end
            
            if TargetCF ~= nil then
                if DetectedDesync then
                    local MoveDirection = TargetMov * 16
                    EndPoint = TargetCF + (MoveDirection * Visual.Silent.PredictionVelocity)
                elseif DetectedUnderGround then
                    EndPoint = TargetCF + (Vector3.new(TargetVel.X, 0, TargetVel.Z) * Visual.Silent.PredictionVelocity)
                elseif DetectedFreeFall then
                    EndPoint = TargetCF + (Vector3.new(TargetVel.X, (TargetVel.Y * Visual.Silent.AntiGroundValue), TargetVel.Z) * Visual.Silent.PredictionVelocity)
                elseif Visual.Silent.PredictMovement then
                    EndPoint = TargetCF + (Vector3.new(TargetVel.X, (TargetVel.Y * 0.5), TargetVel.Z) * Visual.Silent.PredictionVelocity)
                else
                    EndPoint = TargetCF
                end
                if Visual.Silent.Humanize then
                    local HumanizeValue = Visual.Silent.HumanizeValue 
                    EndPoint = (EndPoint + Script.Functions.RandomVec(HumanizeValue, 0.01))
                end
            end

            if EndPoint ~= nil then
                return (Index == "Hit" and EndPoint)
            end
        end
    end
    return OldIndex(self, Index)
end))

-- // Silent Aim Misc
Script.Functions.SilentMisc = LPH_NO_VIRTUALIZE(function()
    if Visual.Silent.Enabled and Script.Functions.Alive(SilentTarget) then
        if Visual.Silent.UseAirPart then
            if SilentTarget.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                   Visual.Silent.Part = Visual.Silent.AirPart
            else
                Visual.Silent.Part = OldSilentAimPart
            end
        end
        if Visual.Silent.TriggerBot then
			mouse1click()
		end
    end
     if Visual.Silent.AutoPrediction then
        local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
        if ping < 10 then
            Visual.Silent.PredictionVelocity = 0.07
        elseif ping < 20 then
            Visual.Silent.PredictionVelocity = 0.155
        elseif ping < 30 then
            Visual.Silent.PredictionVelocity = 0.132
        elseif ping < 40 then
            Visual.Silent.PredictionVelocity = 0.136
        elseif ping < 50 then
            Visual.Silent.PredictionVelocity = 0.130
        elseif ping < 60 then
            Visual.Silent.PredictionVelocity = 0.136
        elseif ping < 70 then
            Visual.Silent.PredictionVelocity = 0.138
        elseif ping < 80 then
            Visual.Silent.PredictionVelocity = 0.138
        elseif ping < 90 then
            Visual.Silent.PredictionVelocity = 0.146
        elseif ping < 100 then
            Visual.Silent.PredictionVelocity = 0.14322
        elseif ping < 110 then
            Visual.Silent.PredictionVelocity = 0.146
        elseif ping < 120 then
            Visual.Silent.PredictionVelocity = 0.149
        elseif ping < 130 then
            Visual.Silent.PredictionVelocity = 0.151
        elseif ping < 140 then
            Visual.Silent.PredictionVelocity = 0.1223333
        elseif ping < 150 then
            Visual.Silent.PredictionVelocity = 0.15
        elseif ping < 160 then
            Visual.Silent.PredictionVelocity = 0.16
        elseif ping < 170 then
            Visual.Silent.PredictionVelocity = 0.1923111
        elseif ping < 180 then
            Visual.Silent.PredictionVelocity = 0.19284
        elseif ping > 180 then
            Visual.Silent.PredictionVelocity = 0.166547
        end
    end
end)

-- // The AimAssist Mouse Dragging/Check Functions
Script.Functions.MouseChanger = LPH_NO_VIRTUALIZE(function()
    if Visual.AimAssist.Enabled and Script.Functions.Alive(AimTarget) and Players[tostring(AimTarget)].Character:FindFirstChild(Visual.AimAssist.Part) and Script.Functions.OnScreen(Players[tostring(AimTarget)].Character[Visual.AimAssist.Part]) then
        local EndPosition = nil
        local TargetPos = Players[tostring(AimTarget)].Character[Visual.AimAssist.Part].Position
        local TargetVel = Players[tostring(AimTarget)].Character[Visual.AimAssist.Part].Velocity
        local TargetMov = Players[tostring(AimTarget)].Character.Humanoid.MoveDirection

        if Visual.Both.DetectDesync then
            local Magnitude = TargetVel.magnitude
            local Magnitude2 = TargetMov.magnitude
            if Magnitude > Visual.Both.DesyncDetection then
                DetectedDesyncV2 = true
            elseif Magnitude < 1 and Magnitude2 > 0.01 then
                DetectedDesyncV2 = true
            elseif Magnitude > 5 and Magnitude2 < 0.01 then
                DetectedDesyncV2 = true
            else
                DetectedDesyncV2 = false
            end
        else
            DetectedDesyncV2 = false
        end
        if Visual.Both.DetectUnderGround then 
            if TargetVel.Y < Visual.Both.UnderGroundDetection then            
                DetectedUnderGroundV2 = true
            else
                DetectedUnderGroundV2 = false
            end
        else
            DetectedUnderGroundV2 = false
        end

        if Script.Functions.Alive(Client) then
            if Visual.AimAssist.DisableLocalDeath then
                if Client.Character.Humanoid.health < 4 then
                    AimTarget = nil
                    IsTargetting = false
                    return
                end
            end
            if Visual.AimAssist.DisableOutSideCircle then
                local Magnitude = Script.Functions.GetMagnitudeFromMouse(AimTarget.Character.HumanoidRootPart)
                if Script.Drawing.AimAssistCircle.Radius < Magnitude then
                    AimTarget = nil
                    IsTargetting = false
                    return
                end
            end
        end

        if Visual.AimAssist.DisableOn_KO and AimTarget.Character:FindFirstChild("BodyEffects") then 
            local KoCheck = AimTarget.Character.BodyEffects:FindFirstChild("K.O").Value
            local Grabbed = AimTarget.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
            if KoCheck or Grabbed then
                AimTarget = nil
                IsTargetting = false
                return
            end
        end
        if Visual.AimAssist.DisableTargetDeath then
            if AimTarget.Character.Humanoid.health < 4 then
                AimTarget = nil
                IsTargetting = false
                return
            end
        end

        if DetectedDesyncV2 and Visual.AimAssist.PredictMovement then
            local MoveDirection = TargetMov * 16
            EndPosition = Camera:WorldToScreenPoint(TargetPos + (MoveDirection * Visual.AimAssist.PredictionVelocity))
        elseif DetectedUnderGroundV2 and Visual.AimAssist.PredictMovement then
            EndPosition = Camera:WorldToScreenPoint(TargetPos + (Vector3.new(TargetVel.X, 0, TargetVel.Z) * Visual.AimAssist.PredictionVelocity))
        elseif Visual.AimAssist.PredictMovement then
            if Visual.AimAssist.UseShake and Script.Functions.Alive(Client) then
                local Shake = Visual.AimAssist.ShakeValue / 100
                local Mag = math.ceil((TargetPos - Client.Character.HumanoidRootPart.Position).Magnitude)
                EndPosition = Camera:WorldToScreenPoint(TargetPos + (TargetVel * Visual.AimAssist.PredictionVelocity) + Script.Functions.RandomVec(Mag * Shake, 0.1))
            else
                EndPosition = Camera:WorldToScreenPoint(TargetPos + (TargetVel * Visual.AimAssist.PredictionVelocity))
            end
        else
            if Visual.AimAssist.UseShake and Script.Functions.Alive(Client) then
                local Shake = Visual.AimAssist.ShakeValue / 100
                local Mag = math.ceil((TargetPos - Client.Character.HumanoidRootPart.Position).Magnitude)
                EndPosition = Camera:WorldToScreenPoint(TargetPos + Script.Functions.RandomVec(Mag * Shake, 0.1))
            else
                EndPosition = Camera:WorldToScreenPoint(TargetPos)
            end
        end

        if EndPosition ~= nil then
            local InCrementX = (EndPosition.X - Mouse.X) * Visual.AimAssist.Smoothness_X
            local InCrementY = (EndPosition.Y - Mouse.Y) * Visual.AimAssist.Smoothness_Y
            mousemoverel(InCrementX, InCrementY)
        end
    end
end)

--// Update Size/Position Of Circle
Script.Functions.UpdateFOV = LPH_NO_VIRTUALIZE(function()
    if (not Script.Drawing.SilentCircle and not Script.Drawing.AimAssistCircle) then
        return Script.Drawing.SilentCircle and Script.Drawing.AimAssistCircle
    end
    
    Script.Drawing.AimAssistCircle.Visible = Visual.AimAssistFov.Visible
    Script.Drawing.AimAssistCircle.Filled = Visual.AimAssistFov.Filled
    Script.Drawing.AimAssistCircle.Color = Visual.AimAssistFov.Color
    Script.Drawing.AimAssistCircle.Transparency = Visual.AimAssistFov.Transparency
    Script.Drawing.AimAssistCircle.Position = Vector2.new(Mouse.X, Mouse.Y + GuiS:GetGuiInset().Y)
	Script.Drawing.AimAssistCircle.Radius = Visual.AimAssistFov.Radius * 3
    
    Script.Drawing.SilentCircle.Visible = Visual.SilentFov.Visible
    Script.Drawing.SilentCircle.Color = Visual.SilentFov.Color
    Script.Drawing.SilentCircle.Filled = Visual.SilentFov.Filled
    Script.Drawing.SilentCircle.Transparency = Visual.SilentFov.Transparency
    Script.Drawing.SilentCircle.Position = Vector2.new(Mouse.X, Mouse.Y + GuiS:GetGuiInset().Y)
	Script.Drawing.SilentCircle.Radius = Visual.SilentFov.Radius * 3
	
    if Visual.RangeFov.Enabled or Visual.GunFov.Enabled then
		local CurrentGun = Script.Functions.GetCurrentWeaponName()
		if Visual.GunFov.Enabled then
			local WeaponSettings = Visual.GunFov[CurrentGun]
			if WeaponSettings ~= nil then
				Visual.SilentFov.Radius = WeaponSettings.Fov
			end
		end
		if Visual.RangeFov.Enabled then
			local WeaponSettingsV2 = Visual.RangeFov[CurrentGun]
			if WeaponSettingsV2 ~= nil then
				if Script.Functions.Alive(SilentTarget) and Script.Functions.Alive(Client) then
                    local Magnitude = (SilentTarget.Character.HumanoidRootPart.Position - Client.Character.HumanoidRootPart.Position).Magnitude
					if Magnitude < Visual.RangeFov.Close_Activation then
						Visual.SilentFov.Radius = WeaponSettingsV2.Close
					elseif Magnitude < Visual.RangeFov.Medium_Activation then
						Visual.SilentFov.Radius = WeaponSettingsV2.Med
					elseif Magnitude < Visual.RangeFov.Far_Activation then
						Visual.SilentFov.Radius = WeaponSettingsV2.Far
					end
				end
			end
		end
	end
end)

-- // Updates Esp Posistions
Script.Functions.UpdateEsp = LPH_NO_VIRTUALIZE(function()
    for i,v in pairs(Script.EspPlayers) do
        if Visual.Esp.Enabled and i ~= Client and i.Character and i.Character:FindFirstChild("Humanoid") and i.Character:FindFirstChild("HumanoidRootPart") and i.Character:FindFirstChild("Head") then
            local Hum = i.Character.Humanoid
            local Hrp = i.Character.HumanoidRootPart
            
            local Vector, OnScreen = Camera:WorldToViewportPoint(i.Character.HumanoidRootPart.Position)
            local Size = (Camera:WorldToViewportPoint(Hrp.Position - Vector3.new(0, 3, 0)).Y - Camera:WorldToViewportPoint(Hrp.Position + Vector3.new(0, 2.6, 0)).Y) / 2
            local BoxSize = Vector2.new(math.floor(Size * 1.5), math.floor(Size * 1.9))
            local BoxPos = Vector2.new(math.floor(Vector.X - Size * 1.5 / 2), math.floor(Vector.Y - Size * 1.6 / 2))
            local BottomOffset = BoxSize.Y + BoxPos.Y + 1

            if OnScreen then
                if Visual.Esp.Name.Enabled then
                    v.Name.Position = Vector2.new(BoxSize.X / 2 + BoxPos.X, BoxPos.Y - 16)
                    v.Name.Outline = Visual.Esp.Name.OutLine
                    v.Name.Text = tostring(i)
                    v.Name.Color = Visual.Esp.Name.Color
                    v.Name.OutlineColor = Color3.fromRGB(0, 0, 0)
                    v.Name.Font = 0
                    v.Name.Size = 16

                    v.Name.Visible = true
                else
                    v.Name.Visible = false
                end
                if Visual.Esp.Distance.Enabled and Client.Character and Client.Character:FindFirstChild("HumanoidRootPart") then
                    v.Distance.Position = Vector2.new(BoxSize.X / 2 + BoxPos.X, BottomOffset)
                    v.Distance.Outline = Visual.Esp.Distance.OutLine
                    v.Distance.Text = "[" .. math.floor((Hrp.Position - Client.Character.HumanoidRootPart.Position).Magnitude) .. "m]"
                    v.Distance.Color = Visual.Esp.Distance.Color
                    v.Distance.OutlineColor = Color3.fromRGB(0, 0, 0)
                    BottomOffset = BottomOffset + 15

                    v.Distance.Font = 0
                    v.Distance.Size = 16

                    v.Distance.Visible = true
                else
                    v.Distance.Visible = false
                end
                if Visual.Esp.Box.Enabled then
                    v.BoxOutline.Size = BoxSize
                    v.BoxOutline.Position = BoxPos
                    v.BoxOutline.Visible = Visual.Esp.Box.OutLine
                    v.BoxOutline.Color = Color3.fromRGB(0, 0, 0)
    
                    v.Box.Size = BoxSize
                    v.Box.Position = BoxPos
                    v.Box.Color = Visual.Esp.Box.Color
                    v.Box.Visible = true
                else
                    v.BoxOutline.Visible = false
                    v.Box.Visible = false
                end
                if Visual.Esp.HealthBar.Enabled then
                    v.HealthBar.From = Vector2.new((BoxPos.X - 5), BoxPos.Y + BoxSize.Y)
                    v.HealthBar.To = Vector2.new(v.HealthBar.From.X, v.HealthBar.From.Y - (Hum.Health / Hum.MaxHealth) * BoxSize.Y)
                    v.HealthBar.Color = Visual.Esp.HealthBar.Color
                    v.HealthBar.Visible = true

                    v.HealthBarOutline.From = Vector2.new(v.HealthBar.From.X, BoxPos.Y + BoxSize.Y + 1)
                    v.HealthBarOutline.To = Vector2.new(v.HealthBar.From.X, (v.HealthBar.From.Y - 1 * BoxSize.Y) -1)
                    v.HealthBarOutline.Color = Color3.fromRGB(0, 0, 0)
                    v.HealthBarOutline.Visible = Visual.Esp.HealthBar.OutLine
                else
                    v.HealthBarOutline.Visible = false
                    v.healthBar.Visible = false
                end
                if Visual.Esp.HealthText.Enabled then
                    v.HealthText.Text = tostring(math.floor((Hum.Health / Hum.MaxHealth) * 100 + 0.5))
                    v.HealthText.Position = Vector2.new((BoxPos.X - 20), (BoxPos.Y + BoxSize.Y - 1 * BoxSize.Y) -1)
                    v.HealthText.Color = Visual.Esp.HealthText.Color
                    v.HealthText.OutlineColor = Color3.fromRGB(0, 0, 0)
                    v.HealthText.Outline = Visual.Esp.HealthText.OutLine

                    v.HealthText.Font = 0
                    v.HealthText.Size = 16

                    v.HealthText.Visible = true
                else
                    v.HealthText.Visible = false
                end
            else
                v.Name.Visible = false
                v.BoxOutline.Visible = false
                v.Box.Visible = false
                v.HealthBarOutline.Visible = false
                v.HealthBar.Visible = false
                v.HealthText.Visible = false
                v.Distance.Visible = false
            end
        else
            v.Name.Visible = false
            v.BoxOutline.Visible = false
            v.Box.Visible = false
            v.HealthBarOutline.Visible = false
            v.HealthBar.Visible = false
            v.HealthText.Visible = false
            v.Distance.Visible = false
        end
    end
end)

-- // Client Fps (EXECUTES PER FRAME)
RS.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
    Script.Functions.GetClosestPlayer()
    Script.Functions.SilentMisc()
    Script.Functions.MouseChanger()
end))

-- // Server Tick (EXECUTES PER TICK)
RS.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
    Script.Functions.UpdateEsp()
    Script.Functions.UpdateFOV()
    if Visual.Silent.Enabled and Visual.Silent.ClosestPoint and Script.Functions.Alive(SilentTarget) and Players[tostring(SilentTarget)].Character:FindFirstChild(Visual.Silent.Part) then
        local ClosestPoint = Script.Functions.GetClosestPointOfPart(Players[tostring(SilentTarget)].Character[Visual.Silent.Part])
        ClosestPointCF = CFrame.new(ClosestPoint.X, ClosestPoint.Y, ClosestPoint.Z)
    end
    if Visual.AimAssist.Enabled and Script.Functions.Alive(AimTarget) and Visual.Silent.ClosestPart and Script.Functions.Alive(SilentTarget) then
        local currentpart = tostring(Script.Functions.GetClosestBodyPart(AimTarget.Character))
        if Visual.AimAssist.ClosestPart then
			Visual.AimAssist.Part = currentpart
		end
        if Visual.Silent.ClosestPart then
            Visual.Silent.Part = currentpart
            OldSilentAimPart = Visual.Silent.Part
        end
        return
    end
    if Visual.AimAssist.Enabled and Visual.AimAssist.ClosestPart and Script.Functions.Alive(AimTarget) then
        Visual.AimAssist.Part = tostring(Script.Functions.GetClosestBodyPart(AimTarget.Character))
    end
    if Visual.Silent.Enabled and Visual.Silent.ClosestPart and Script.Functions.Alive(SilentTarget) then
        Visual.Silent.Part = tostring(Script.Functions.GetClosestBodyPart(SilentTarget.Character))
        OldSilentAimPart = Visual.Silent.Part
    end
end))

-- // Checks Everyone In The Server And Puts It In A Table
for _, Player in ipairs(Players:GetPlayers()) do
    if (Player ~= Client and Client:IsFriendsWith(Player.UserId)) then
        table.insert(Script.Friends, Player)
    end
    Script.Functions.NewPlayer(Player)
end

-- // Checks When Players Joins And Adds Them To A Table
Players.PlayerAdded:Connect(function(Player)
    if (Client:IsFriendsWith(Player.UserId)) then
        table.insert(Script.Friends, Player)
    end
    Script.Functions.NewPlayer(Player)
end)

-- // Checks If A Player Left And Removes Them From The Table
Players.PlayerRemoving:Connect(function(Player)
    local i = table.find(Script.Friends, Player)
    if (i) then
        table.remove(Script.Friends, i)
    end
    for i,v in pairs(Script.EspPlayers[Player]) do
        v:Remove()
    end
    Script.EspPlayers[Player] = nil
end)

end)()

-- // Key System
local keys = {
  "z2w!6e1r#8t@4y7u",
  "i9k@0l#7o6p!5m3n",
  "h5j!4k#3l6@1q9e2",
  "y8u!2i#1o7p@5r4t",
  "d2f!3g#5h@7j8k1l",
  "v6b!1n#9m8c7x4z",
  "p7o!9i#8u7y6t5r",
  "n1m!8k#7j6h5g4f",
  "s2a!1d#3f4g5h6j",
  "l8k!2j#4h@7g6f",
  "q7w!3e#6r@5t4y",
  "x5c!4v#3b2n1m",
  "f4u!2i#5o7p6y8t",
  "g5h!6j#7k9l1o2i",
  "a9s!2d#4f6g8h1j",
  "r1t!3y#5u7i9o2p",
  "b8v!3n#6m7c4x1z",
  "o1i!2u#3y4t5r6e",
  "c4x!2z#6b7n8m9v",
  "e1q!3w#4e6r7t8y",
  "k9o!4i#7p6u5y8t",
  "m3n!6j#9k1l2o7i",
  "t7g!4h#5f8d2s1a",
  "w2s!6d#8f7g9h1j",
  "z1x!2c#3v5b6n7m",
  "u3y!4t#5r7e2q1w",
  "h8j!7k#5l3o2i1u",
  "f1g!3h#5j7k9l1o",
  "v2b!5n#7m6c4x1z",
  "x1z!2c#3v5b6n7m",
  "n6m!7c#9x8z4b1v",
  "p4o!5i#6u7y8t1r",
  "j2k!4l#6o8i9u7y",
  "d3f!4g#6h8j9k1l",
  "q9w!3e#5r6t7y8u",
  "r2t!4y#6u7i8o9p",
  "b6v!7n#8m1c2x3z",
  "s8a!9d#1f2g3h4j",
  "l6k!7j#8h1u2i3o",
  "o2i!4u#6y7t8r9e",
  "c3x!4v#6b8n9m1z",
  "Z8h#k9d!p7l2m0n",
  "X6g#f5s!d4a1b9c",
  "C7j#k6f!h2g0e5d",
"V3n#m4b!l2k1j8i",
"B1u#n9c!f8d6s4a",
"T5f#g3d!h2j1k8l",
"E1h#d5f!j9l6k8j",
"O4j#p7l!m1n0b5v",
"I2k#f4g!h9j6l8o",
"P1l#k2j!h3g4f5",
"S5d#f7h!j1k2l9",
"R3s#g1f!d7h8j6",
"M8n#b3v!m7k2j1",
"Y2f#r5h!d1s6j8",
"U8g#i5k!h7j6f1",
"A9f#k1j!l7h3g6",
"H7j#k3l!h2g5f1",
"F9h#g2f!d3s6j8",
"J2k#f8h!d5j7l9",
"D3f#h7g!j6k1l8",
"K1j#h4g!d2f5l7",
"L6k#j7h!f4g5d1",
"G5h#f1d!j8k6l4",
"Q4f#h5j!g2k6l9",
"W9k#d5f!j1h7l8",
"Z5s#d7h!j8k1l6",
"C6f#d9g!h2j7l8",
"V2g#j4h!d6f8l1",
"B3f#h7k!j8l5g4",
"T6d#f4h!j8k1l7",
"E7h#d1f!j9k8l2",
"O2j#l4h!k7j1f8",
"I4k#g3f!d1h6l8",
"P3l#k5j!h7g1f6",
"S6f#d9g!h2j7l8",
"R1h#f2d!j6k7l8",
"M2j#g7f!d5h9l1",
"Y5h#f1d!j8k6l4",
"U2k#h7f!d5j6l9",
"A8f#k1h!d5j7l9",
"H3j#l6k!h2g5f1",
"F5h#d1f!j8k6l4",
"J8k#g1f!d7h6l3",
"D1f#h4g!j7k6l8",
"K7j#f8h!d1s6l9",
"L9k#j6h!f2g4d5",
"G4h#f1d!j7k6l8",
"Q7f#h2j!g4k6l9",
"V8f#h5g!j2k1l9"
"B5h#j6f!d8s1l7"
"T1h#g5f!j9k8l3"
"E3f#h7g!j6k2l8"
"O6k#j7h!d1f4l9"
"I9j#g4f!d1h6l8"
"P5k#j3h!f4g6d8"
"S9f#h6j!d1k2l8"
"R8k#g6f!d7h2l4"
"M5h#f9d!j1k6l8"
"Y7f#h1g!j2k6l8"
"U4k#h2j!f5d7l1"
"A3f#h8g!j4k7l6"
"H6j#k8h!f3g5d7"
"F2k#g8f!d5h6l1"
"J1f#h5j!g2k6l9"
"D2j#h8k!f5g6l1"
"K5h#f9d!j1k6l8"
"L3f#h5g!j2k6l8"
"G7j#k1h!f2d5l9"
"Q2f#h5j!g8k6l1"
"W5k#j6h!f8g4d1"
"Z6f#h1g!j8k2l5"
"C2h#f6g!j9k8l4"
"V4f#h6j!d8k1l7"
"B6h#j4f!d9g2l5"
"T2j#g4f!h1k8l9"
"E6f#h2j!g8k5l1"
"O1h#f7g!j6k8l5"
"I3k#j7h!f8g1d6"
"P6f#h5g!j2k8l1"
"S1j#g6f!h7k8l9"
"R2h#f5d!j7k6l8"
"M3j#k4h!f7g5d8"
"Y4f#h6g!j2k1l8"
"U7j#k6h!f4d5l9"
"A4h#j5f!d2g6l1"
"H5k#g7f!j1h6l8"
"F8f#h2j!g6k5l1"
"J6h#f7g!j2k5l8"
"D9k#j1h!f2g6l5"
"K2f#h8g!j4k6l1"
"L1j#k5h!f8g6d7"
"G6f#h8j!d7k1l9"
"Q3k#g5f!h1j6l8"
"W1h#f8g!j2k6l9"
"Z2j#h8k!f7g1l6"
"C5h#j6f!d8g2l4"
"V6j#g4f!h2k8l9"
}


local counter = 1
local keyCheck
for i,v in pairs(keys) do
  if counter == #keys then
    -- not whitelisted!
    keys = ""
    game.Players.LocalPlayer:Kick("Please Type A Key.")
  else
    if v == _G.Key then
      -- Whitelisted!
      print("ImmerseAds")
      keyCheck = _G.Key
      keys = ""
      
      -- // Avatar Items
      while wait() do
        local ply = game.Players.LocalPlayer
        local chr = ply.Character

        if chr and chr:FindFirstChild("Head") and chr:FindFirstChild("Humanoid") then
          if getgenv().Visual.Avatar["Enabled"] then
            if getgenv().Visual.Avatar["KorbloxDeathspeaker"] then
              chr.RightLowerLeg.MeshId = "902942093"
              chr.RightLowerLeg.Transparency = 1
              chr.RightUpperLeg.MeshId = "http://www.roblox.com/asset/?id=902942096"
              chr.RightUpperLeg.TextureID = "http://roblox.com/asset/?id=902843398"
              chr.RightFoot.MeshId = "902942089"
              chr.RightFoot.Transparency = 1
            end

            if getgenv().Visual.Avatar["HeadlessHorseman"] then
              chr.Head.MeshId = "rbxassetid://6686307858"
            end
          end
        end
      end
      
    else
      counter = counter +1
    end
  end
end

while true do
  if _G.Key == keyCheck then
    -- Not spoofed
  else
    game.Players.LocalPlayer:Kick("Please Retry, This Key Is Incorrect Or You Are Trying To Bypass.")
  end
  wait()
end

