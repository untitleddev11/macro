local DevicesVM = {}

function DevicesVM:Init()
    if not game:IsLoaded() then
        game.Loaded:Wait()
    end

    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local UserInputService = game:GetService("UserInputService")
    local HttpService = game:GetService("HttpService")
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")

    local LocalPlayer = Players.LocalPlayer
    if game.CoreGui:GetAttribute("RunningDVM") then print("retard") return end --> Check if script already running for dumbasses that execute shit multiple times then complain its bugged
    game.CoreGui:SetAttribute("RunningDVM", true)

    local Functions = loadstring(game:HttpGet("https://raw.githubusercontent.com/untitleddev11/macro/refs/heads/main/dependencies/functions.lua"))()
    local Games = game:HttpGet("https://raw.githubusercontent.com/untitleddev11/macro/refs/heads/main/dependencies/games.json")
    local ImGui = loadstring(game:HttpGet('https://github.com/depthso/Roblox-ImGUI/raw/main/ImGui.lua'))()

    local Success, GamesData = pcall(function()
        return HttpService:JSONDecode(Games)
    end)

    local CurrentPlaceId = game.PlaceId
    local PlaceId = nil
    local MainEvent = nil
    local Event = nil

    coroutine.wrap(function()
        for Id, Data in pairs(GamesData) do
            if not Id or typeof(Data) ~= "table" then continue end

            if tonumber(Id) == CurrentPlaceId then
                PlaceId = Id
                MainEvent = Data.Remote and Functions:SearchRemotes(Data.Remote) or "MainEvent"
                Event = Data.Event or "UpdateMousePos"
                break
            end
        end
    end)()

    RunService.RenderStepped:Wait()

    if PlaceId == nil then
        setclipboard("https://github.com/untitleddev11/macro/blob/main/dependencies/games.json")
        LocalPlayer:Kick("This game is not supported! check our github repository to see supported games. (copied to ur clipboard)")
        return
	end

    local FOVCircle = Drawing.new("Circle")
    FOVCircle.Visible = false
    FOVCircle.Color = Color3.new(1, 1, 1)
    FOVCircle.Thickness = 1
    FOVCircle.Transparency = 1
    FOVCircle.Filled = false

    local function UpdateFOVCircle()
        FOVCircle.Radius = getgenv().CheatSettings.Preferences.MaxMouseDistance
        FOVCircle.Visible = getgenv().CheatSettings.Preferences.DrawFOV
        local MousePos = UserInputService:GetMouseLocation()
        FOVCircle.Position = Vector2.new(MousePos.X, MousePos.Y)
    end

    RunService.RenderStepped:Connect(function()
        UpdateFOVCircle()
    end)

    coroutine.wrap(function()
        local Window = ImGui:CreateWindow({
            Title = "DVM - @devllce",
            Size = UDim2.fromOffset(550, 500),
            Position = UDim2.new(0.5, 0, 0, 70),
        })

        local TabAiming = Window:CreateTab({
            Name = "Aiming",
            Visible = true 
        })

        local TabSettings = Window:CreateTab({
            Name = "Settings",
            Visible = false 
        })

        TabAiming:Separator({
            Text = "Toggles"
        })

        TabAiming:Checkbox({
            Label = "aimlock",
            Value = getgenv().CheatSettings.Aiming.AimLock,
            Callback = function(self, Value)
                getgenv().CheatSettings.Aiming.AimLock = Value
            end
        })

        TabAiming:Checkbox({
            Label = "silentaim",
            Value = getgenv().CheatSettings.Aiming.SilentAim,
            Callback = function(self, Value)
                getgenv().CheatSettings.Aiming.SilentAim = Value
            end
        })

        TabAiming:Checkbox({
            Label = "use multiple body parts [SILENT - LEGIT]",
            Value = getgenv().CheatSettings.Aiming.MultiParts,
            Callback = function(self, Value)
                getgenv().CheatSettings.Aiming.MultiParts = Value
            end
        })

        TabAiming:Checkbox({
            Label = "notify (notification when locked)",
            Value = getgenv().CheatSettings.Preferences.Notify,
            Callback = function(self, Value)
                getgenv().CheatSettings.Preferences.Notify = Value
            end
        })

        TabAiming:Separator({
            Text = "Keybinds"
        })

        TabAiming:Keybind({
            Label = "aimlock bind",
            Value = getgenv().CheatSettings.Aiming.AimLockBind,
            IgnoreGameProcessed = false,
            Callback = function(self, KeyCode)
                getgenv().CheatSettings.Aiming.AimLockBind = KeyCode
            end
        })

        TabAiming:Separator({
            Text = "Values"
        })

        TabAiming:InputText({
            Label = "aimlock smoothing",
            Value = getgenv().CheatSettings.Aiming.AimSmoothing,
            PlaceHolder = "insert here (NO NUMBER = NO CHANGE)",
            Callback = function(self, Value)
                if not tonumber(Value) then return end
                getgenv().CheatSettings.Aiming.AimSmoothing = Value
            end
        })

        TabAiming:InputText({
            Label = "aimlock prediction",
            Value = getgenv().CheatSettings.Aiming.AimPrediction,
            PlaceHolder = "insert here (NO NUMBER = NO CHANGE)",
            Callback = function(self, Value)
                if not tonumber(Value) then return end
                getgenv().CheatSettings.Aiming.AimPrediction = Value
            end
        })

        TabAiming:InputText({
            Label = "silentaim prediction",
            Value = getgenv().CheatSettings.Aiming.SilentPrediction,
            PlaceHolder = "insert here (NO NUMBER = NO CHANGE)",
            Callback = function(self, Value)
                if not tonumber(Value) then return end
                getgenv().CheatSettings.Aiming.SilentPrediction = Value
            end
        })

        TabAiming:Separator({
            Text = "Dropdowns"
        })

        TabAiming:Combo({
            Selected = getgenv().CheatSettings.Aiming.BodyPart,
            Label = "body part",
            Items = {
                "Head", "UpperTorso", "LowerTorso", "LeftUpperArm", "LeftLowerArm", "RightUpperArm", "RightLowerArm"
            },
            Callback = function(self, Value)
                getgenv().CheatSettings.Aiming.BodyPart = Value
            end
        })

        TabSettings:Separator({
            Text = "Toggles"
        })

        TabSettings:Checkbox({
            Label = "check KO",
            Value = getgenv().CheatSettings.Preferences.CheckKO,
            Callback = function(self, Value)
                getgenv().CheatSettings.Preferences.CheckKO = Value
            end
        })

        TabSettings:Checkbox({
            Label = "check player KO",
            Value = getgenv().CheatSettings.Preferences.CheckPlayerKO,
            Callback = function(self, Value)
                getgenv().CheatSettings.Preferences.CheckPlayerKO = Value
            end
        })

        TabSettings:Checkbox({
            Label = "visibility check",
            Value = getgenv().CheatSettings.Preferences.VisibilityCheck,
            Callback = function(self, Value)
                getgenv().CheatSettings.Preferences.VisibilityCheck = Value
            end
        })

        TabSettings:Checkbox({
            Label = "use silentaim fov",
            Value = getgenv().CheatSettings.Preferences.SilentAimMouseDistanceCheck,
            Callback = function(self, Value)
                getgenv().CheatSettings.Preferences.SilentAimMouseDistanceCheck = Value
            end
        })

        TabSettings:Checkbox({
            Label = "draw silentaim fov",
            Value = getgenv().CheatSettings.Preferences.DrawFOV,
            Callback = function(self, Value)
                getgenv().CheatSettings.Preferences.DrawFOV = Value
            end
        })

        TabSettings:Separator({
            Text = "Values"
        })

        TabSettings:InputText({
            Label = "silentaim fov",
            Value = getgenv().CheatSettings.Preferences.MaxMouseDistance,
            PlaceHolder = "insert here (NO NUMBER = NO CHANGE)",
            Callback = function(self, Value)
                if not tonumber(Value) then return end
                getgenv().CheatSettings.Preferences.MaxMouseDistance = Value
            end
        })

        TabSettings:Separator({
            Text = "Keybinds"
        })

        TabSettings:Keybind({
            Label = "script visible bind",
            Value = Enum.KeyCode.Equals,
            IgnoreGameProcessed = false,
            Callback = function(self, KeyCode)
                Window:SetVisible(true)
            end
        })
    end)()

    local Targeting = nil

    LocalPlayer.Character.ChildAdded:Connect(function(Child)
        if not Functions:CheckGunHold(Child) then return end

        Child.Activated:Connect(function()
            if not getgenv().CheatSettings.Aiming.SilentAim then return end

            local SilentTargeting = Functions:ReturnClosestToMouse(LocalPlayer)

            if getgenv().CheatSettings.Preferences.CheckKO and SilentTargeting and SilentTargeting.Character and SilentTargeting.Character:FindFirstChild("Humanoid") then
                local KOd = SilentTargeting.Character:FindFirstChild("BodyEffects")["K.O"].Value
                local Grabbed = SilentTargeting.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
                if SilentTargeting.Character.Humanoid.Health < 1 or KOd or Grabbed then
                    SilentTargeting = nil
                end
            end

            if getgenv().CheatSettings.Preferences.CheckPlayerKO and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character:FindFirstChild("BodyEffects") and LocalPlayer.Character.BodyEffects:FindFirstChild("K.O") then
                local KOd = LocalPlayer.Character.BodyEffects["K.O"].Value
                local Grabbed = LocalPlayer.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
                if LocalPlayer.Character.Humanoid.Health < 1 or KOd or Grabbed then
                    SilentTargeting = nil
                end
            end

            if SilentTargeting and SilentTargeting.Character then
                local ClosestPart = nil
                local ClosestDistance = math.huge

                if getgenv().CheatSettings.Aiming.MultiParts then
                    for Index, PartName in ipairs(getgenv().CheatSettings.Aiming.BodyParts) do
                        local Part = SilentTargeting.Character:FindFirstChild(PartName)
                        if not Part then return end

                        local ScreenPos = workspace.CurrentCamera:WorldToViewportPoint(Part.Position)
                        local MousePos = UserInputService:GetMouseLocation()
                        local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude

                        if Distance < ClosestDistance then
                            ClosestDistance = Distance
                            ClosestPart = Part
                        end
                    end
                else
                    ClosestPart = SilentTargeting.Character:FindFirstChild(getgenv().CheatSettings.Aiming.BodyPart)
                end

                local RootToViewportPoint, IsOnScreen = workspace.CurrentCamera:WorldToViewportPoint(SilentTargeting.Character:FindFirstChild("HumanoidRootPart").Position)
                if getgenv().CheatSettings.Preferences.VisibilityCheck and not IsOnScreen then
                    return
                end

                if getgenv().CheatSettings.Preferences.VisibilityCheck and ClosestPart and not Functions:VisibilityCheck(LocalPlayer, SilentTargeting, ClosestPart) then
                    return
                end

                if ClosestPart then
                    local ScreenPos = workspace.CurrentCamera:WorldToViewportPoint(ClosestPart.Position)
                    local MousePos = UserInputService:GetMouseLocation()
                    local MouseDistance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude

                    if not getgenv().CheatSettings.Preferences.SilentAimMouseDistanceCheck or MouseDistance <= tonumber(getgenv().CheatSettings.Preferences.MaxMouseDistance) then
                        local Position = ClosestPart.Position
                        local RandomOffset = Vector3.new(
                            math.random(-0.01, 0.01),
                            math.random(0, 0.01),
                            math.random(-0.01, 0.01)
                        )

                        
                        Position += RandomOffset
                        MainEvent:FireServer(Event, Position + ((SilentTargeting.Character.HumanoidRootPart.Velocity) * getgenv().CheatSettings.Aiming.SilentPrediction))
                    end
                end
            end
        end)
    end)

    LocalPlayer.CharacterAdded:Connect(function(RespawnCharacter)
        RespawnCharacter.ChildAdded:Connect(function(Child)
            if not Functions:CheckGunHold(Child) then return end

            Child.Activated:Connect(function()
                if not getgenv().CheatSettings.Aiming.SilentAim then return end

                local SilentTargeting = Functions:ReturnClosestToMouse(LocalPlayer)

                if getgenv().CheatSettings.Preferences.CheckKO and SilentTargeting and SilentTargeting.Character and SilentTargeting.Character:FindFirstChild("Humanoid") then
                    local KOd = SilentTargeting.Character:FindFirstChild("BodyEffects")["K.O"].Value
                    local Grabbed = SilentTargeting.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
                    if SilentTargeting.Character.Humanoid.Health < 1 or KOd or Grabbed then
                        SilentTargeting = nil
                    end
                end

                if getgenv().CheatSettings.Preferences.CheckPlayerKO and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character:FindFirstChild("BodyEffects") and LocalPlayer.Character.BodyEffects:FindFirstChild("K.O") then
                    local KOd = LocalPlayer.Character.BodyEffects["K.O"].Value
                    local Grabbed = LocalPlayer.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
                    if LocalPlayer.Character.Humanoid.Health < 1 or KOd or Grabbed then
                        SilentTargeting = nil
                    end
                end

                if SilentTargeting and SilentTargeting.Character then
                    local ClosestPart = nil
                    local ClosestDistance = math.huge

                    if getgenv().CheatSettings.Aiming.MultiParts then
                        for Index, PartName in ipairs(getgenv().CheatSettings.Aiming.BodyParts) do
                            local Part = SilentTargeting.Character:FindFirstChild(PartName)
                            if not Part then return end

                            local ScreenPos = workspace.CurrentCamera:WorldToViewportPoint(Part.Position)
                            local MousePos = UserInputService:GetMouseLocation()
                            local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude

                            if Distance < ClosestDistance then
                                ClosestDistance = Distance
                                ClosestPart = Part
                            end
                        end
                    else
                        ClosestPart = SilentTargeting.Character:FindFirstChild(getgenv().CheatSettings.Aiming.BodyPart)
                    end

                    local RootToViewportPoint, IsOnScreen = workspace.CurrentCamera:WorldToViewportPoint(SilentTargeting.Character:FindFirstChild("HumanoidRootPart").Position)
                    if getgenv().CheatSettings.Preferences.VisibilityCheck and not IsOnScreen then
                        return
                    end

                    if getgenv().CheatSettings.Preferences.VisibilityCheck and ClosestPart and not Functions:VisibilityCheck(LocalPlayer, SilentTargeting, ClosestPart) then
                        return
                    end

                    if ClosestPart then
                        local ScreenPos = workspace.CurrentCamera:WorldToViewportPoint(ClosestPart.Position)
                        local MousePos = UserInputService:GetMouseLocation()
                        local MouseDistance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude

                        if not getgenv().CheatSettings.Preferences.SilentAimMouseDistanceCheck or MouseDistance <= tonumber(getgenv().CheatSettings.Preferences.MaxMouseDistance) then
                            local Position = ClosestPart.Position
                            local RandomOffset = Vector3.new(
                                math.random(-0.01, 0.01),
                                math.random(0, 0.01),
                                math.random(-0.01, 0.01)
                            )

                            Position += RandomOffset
                            MainEvent:FireServer(Event, Position + ((SilentTargeting.Character.HumanoidRootPart.Velocity) * getgenv().CheatSettings.Aiming.SilentPrediction))
                        end
                    end
                end
            end)
        end)
    end)

    UserInputService.InputBegan:Connect(function(Input, GameProcessedEvent)
        if GameProcessedEvent then return end
    
        if Input.KeyCode == getgenv().CheatSettings.Aiming.AimLockBind then
            OnTarget = not OnTarget
    
            if OnTarget then
                Targeting = Functions:ReturnClosestToMouse(LocalPlayer)
    
                if getgenv().CheatSettings.Preferences.VisibilityCheck and Targeting and Targeting.Character and not Functions:VisibilityCheck(LocalPlayer, Targeting, Targeting.Character:FindFirstChild(getgenv().CheatSettings.Aiming.BodyPart)) then
                    Targeting = nil
                end
    
                if Targeting == nil then
                    OnTarget = false
                else
                    if getgenv().CheatSettings.Preferences.Notify then
                    game:GetService("StarterGui"):SetCore("SendNotification",{
                        Title = "AIMLOCK",
                        Text = "Locked on to: ".. Targeting.Name
                    })
                    end
                end
            else
		if getgenv().CheatSettings.Preferences.Notify then
                    game:GetService("StarterGui"):SetCore("SendNotification",{
                        Title = "AIMLOCK",
                        Text = "Unlocked from: ".. Targeting.Name
                    })
                end
                Targeting = nil
            end
        end
    end)

    RunService.Heartbeat:Connect(function()
        if Targeting ~= nil and getgenv().CheatSettings.Aiming.AimLock then
            local TargetPart = Targeting.Character[getgenv().CheatSettings.Aiming.BodyPart]
            local Position = TargetPart.Position
            local Main = CFrame.new(workspace.CurrentCamera.CFrame.Position, Position + ((Targeting.Character.HumanoidRootPart.Velocity) * getgenv().CheatSettings.Aiming.AimPrediction))
            workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(Main, getgenv().CheatSettings.Aiming.AimSmoothing, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        end

        if getgenv().CheatSettings.Preferences.CheckKO and Targeting and Targeting.Character and Targeting.Character:FindFirstChild("Humanoid") then
            local KOd = Targeting.Character:FindFirstChild("BodyEffects")["K.O"].Value
            local Grabbed = Targeting.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
            if Targeting.Character.Humanoid.Health < 1 or KOd or Grabbed then
                if OnTarget then
                    Targeting = nil
                    OnTarget = false
                end
            end
        end
    
        if getgenv().CheatSettings.Preferences.CheckPlayerKO and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character:FindFirstChild("BodyEffects") and LocalPlayer.Character.BodyEffects:FindFirstChild("K.O") then
            local KOd = LocalPlayer.Character.BodyEffects["K.O"].Value
            local Grabbed = LocalPlayer.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
            if LocalPlayer.Character.Humanoid.Health < 1 or KOd or Grabbed then
                if OnTarget then
                    Targeting = nil
                    OnTarget = false
                end
            end
        end
    end)
end

return DevicesVM
