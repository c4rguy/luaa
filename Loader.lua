local ReplicatedStorage = game:GetService('ReplicatedStorage')
local VirtualInputManager = game:GetService('VirtualInputManager')
local UserInputService = game:GetService('UserInputService')
local RunService = game:GetService('RunService')
local Workspace = game:GetService('Workspace')
local Players = game:GetService('Players')

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild('HumanoidRootPart')
local Humanoid = Character.Humanoid

local Target

local originalSpreadValues = {}
local originalRecoilValues = {}
local originalFirerateValues = {}
local originalADSValues = {}

-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local FrameCounter, FrameTimer, FPS, StartTime = 0, 0, 60, tick()

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = "Operation Siege | Pure",
    LoadingTitle = "Operation:Siege",
    LoadingSubtitle = "by Pure",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "Pure",
        FileName = "Operation_Siege_Config"
    },
    Discord = {
        Enabled = true,
        Invite = "https://discord.gg/6VGgAXDFEp",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "Untitled",
        Subtitle = "Key System",
        Note = "No method of obtaining the key is provided",
        FileName = "Key",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"Hello"}
    }
})

-- Create Tabs
local CombatTab = Window:CreateTab("Combat", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local MiscTab = Window:CreateTab("Miscellaneous", 4483362458)

-- Variables for toggles and sliders
local Toggles = {}
local Sliders = {}

-- Combat Section - Silent Aim
local SilentAimSection = CombatTab:CreateSection("Silent Aim")

Toggles.Silent = CombatTab:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Flag = "Silent",
    Callback = function(Value)
        -- Silent aim logic handled in main loop
    end,
})

Toggles.MagicBullet = CombatTab:CreateToggle({
    Name = "Magic Bullet",
    CurrentValue = false,
    Flag = "MagicBullet",
    Callback = function(Value)
        -- Magic bullet logic
    end,
})

Toggles.ShowFOV = CombatTab:CreateToggle({
    Name = "Show FOV Circle",
    CurrentValue = false,
    Flag = "ShowFOV",
    Callback = function(Value)
        -- FOV circle logic handled in main loop
    end,
})

Sliders.HitChance = CombatTab:CreateSlider({
    Name = "Hit Chance",
    Range = {1, 100},
    Increment = 1,
    Suffix = "%",
    CurrentValue = 100,
    Flag = "HitChance",
    Callback = function(Value)
        -- Hit chance logic
    end,
})

Sliders.FOVSize = CombatTab:CreateSlider({
    Name = "FOV Size",
    Range = {1, 1000},
    Increment = 1,
    Suffix = "",
    CurrentValue = 100,
    Flag = "FOVSize",
    Callback = function(Value)
        -- FOV size logic handled in main loop
    end,
})

local TargetDropdown = CombatTab:CreateDropdown({
    Name = "Target Part",
    Options = {"Head", "HumanoidRootPart"},
    CurrentOption = {"Head"},
    MultipleOptions = false,
    Flag = "TargetPart",
    Callback = function(Option)
        -- Target part selection
    end,
})

-- Combat Section - Gun Mods
local GunModsSection = CombatTab:CreateSection("Gun Mods")

Toggles.NoRecoil = CombatTab:CreateToggle({
    Name = "No Recoil",
    CurrentValue = false,
    Flag = "NoRecoil",
    Callback = function(Value)
        if Value then
            for _, obj in ipairs(getgc(true)) do
                if typeof(obj) == "table" then
                    for key, value in pairs(obj) do
                        if typeof(key) == "string" and key:lower():find("recoil") and typeof(value) == "number" then
                            originalRecoilValues[obj] = originalRecoilValues[obj] or {}
                            if originalRecoilValues[obj][key] == nil then
                                originalRecoilValues[obj][key] = value
                            end
                            obj[key] = 0.000001
                        end
                    end
                end
            end
        else
            for obj, keys in pairs(originalRecoilValues) do
                if typeof(obj) == "table" then
                    for key, originalValue in pairs(keys) do
                        obj[key] = originalValue
                    end
                end
            end
            originalRecoilValues = {}
        end
    end,
})

Toggles.NoSpread = CombatTab:CreateToggle({
    Name = "No Spread",
    CurrentValue = false,
    Flag = "NoSpread",
    Callback = function(Value)
        if Value then
            for _, obj in ipairs(getgc(true)) do
                if typeof(obj) == "table" then
                    for key, value in pairs(obj) do
                        if typeof(key) == "string" and key:lower():find("spread") and typeof(value) == "number" then
                            originalSpreadValues[obj] = originalSpreadValues[obj] or {}
                            if originalSpreadValues[obj][key] == nil then
                                originalSpreadValues[obj][key] = value
                            end
                            obj[key] = 0.000001
                        end
                    end
                end
            end
        else
            for obj, keys in pairs(originalSpreadValues) do
                if typeof(obj) == "table" then
                    for key, originalValue in pairs(keys) do
                        obj[key] = originalValue
                    end
                end
            end
            originalSpreadValues = {}
        end
    end,
})

Toggles.FastFirerate = CombatTab:CreateToggle({
    Name = "Fast Firerate",
    CurrentValue = false,
    Flag = "FastFirerate",
    Callback = function(Value)
        if Value then
            for _, obj in ipairs(getgc(true)) do
                if typeof(obj) == "table" then
                    for key, value in pairs(obj) do
                        if typeof(key) == "string" and key:lower():find("ShootRate") and typeof(value) == "number" then
                            originalFirerateValues[obj] = originalFirerateValues[obj] or {}
                            if originalFirerateValues[obj][key] == nil then
                                originalFirerateValues[obj][key] = value
                            end
                            obj[key] = 10
                        end
                    end
                end
            end
        else
            for obj, keys in pairs(originalFirerateValues) do
                if typeof(obj) == "table" then
                    for key, originalValue in pairs(keys) do
                        obj[key] = originalValue
                    end
                end
            end
            originalFirerateValues = {}
        end
    end,
})

-- Visuals Section - Player ESP
local PlayerESPSection = VisualsTab:CreateSection("Player ESP")

Toggles.ESP = VisualsTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = false,
    Flag = "ESP",
    Callback = function(Value)
        -- ESP logic handled in ESP function
    end,
})

Toggles.Boxes = VisualsTab:CreateToggle({
    Name = "Boxes",
    CurrentValue = false,
    Flag = "Boxes",
    Callback = function(Value)
        -- Box ESP logic
    end,
})

Toggles.Names = VisualsTab:CreateToggle({
    Name = "Names",
    CurrentValue = false,
    Flag = "Names",
    Callback = function(Value)
        -- Name ESP logic
    end,
})

Toggles.HealthBar = VisualsTab:CreateToggle({
    Name = "Health Bar",
    CurrentValue = false,
    Flag = "HealthBar",
    Callback = function(Value)
        -- Health bar logic
    end,
})

Toggles.Weapon = VisualsTab:CreateToggle({
    Name = "Weapon",
    CurrentValue = false,
    Flag = "Weapon",
    Callback = function(Value)
        -- Weapon ESP logic
    end,
})

Toggles.Distance = VisualsTab:CreateToggle({
    Name = "Distance",
    CurrentValue = false,
    Flag = "Distance",
    Callback = function(Value)
        -- Distance ESP logic
    end,
})

Toggles.Skeleton = VisualsTab:CreateToggle({
    Name = "Skeleton",
    CurrentValue = false,
    Flag = "Skeleton",
    Callback = function(Value)
        -- Skeleton ESP logic
    end,
})

Toggles.HeadCircle = VisualsTab:CreateToggle({
    Name = "Head Circle",
    CurrentValue = false,
    Flag = "HeadCircle",
    Callback = function(Value)
        -- Head circle logic
    end,
})

-- Miscellaneous Section - Player Mods
local PlayerModsSection = MiscTab:CreateSection("Player Mods")

Toggles.Walkspeed = MiscTab:CreateToggle({
    Name = "Walkspeed",
    CurrentValue = false,
    Flag = "Walkspeed",
    Callback = function(Value)
        if Value then
            Humanoid.WalkSpeed = Sliders.Speed.CurrentValue or 11
        else
            Humanoid.WalkSpeed = 11
        end
    end,
})

Sliders.Speed = MiscTab:CreateSlider({
    Name = "Speed",
    Range = {1, 100},
    Increment = 1,
    Suffix = "",
    CurrentValue = 11,
    Flag = "Speed",
    Callback = function(Value)
        if Toggles.Walkspeed.CurrentValue then
            Humanoid.WalkSpeed = Value
        end
    end,
})

Toggles.NoClip = MiscTab:CreateToggle({
    Name = "No-Clip",
    CurrentValue = false,
    Flag = "NoClip",
    Callback = function(Value)
        -- NoClip logic handled in main loop
    end,
})

local velocity = Instance.new("BodyVelocity")
velocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
velocity.P = 1e4
velocity.Name = "FlyVelocity"

local Flymovement = {
    forward = 0,
    right = 0,
    up = 0
}

Toggles.Fly = MiscTab:CreateToggle({
    Name = "Flight",
    CurrentValue = false,
    Flag = "Fly",
    Callback = function(Value)
        if Value then
            velocity.Parent = HumanoidRootPart
        else
            velocity.Parent = nil
            HumanoidRootPart.Velocity = Vector3.zero
        end
    end,
})

Sliders.FlySpeed = MiscTab:CreateSlider({
    Name = "Fly Speed",
    Range = {1, 100},
    Increment = 1,
    Suffix = "",
    CurrentValue = 11,
    Flag = "FlySpeed",
    Callback = function(Value)
        -- Fly speed logic handled in main loop
    end,
})

-- ESP Function (same as original)
-- Fixed ESP Function
local function ESP(player)
    local Connection;
    local Drawings = {
        box = Drawing.new("Square"),
        boxOutline = Drawing.new("Square"),
        name = Drawing.new("Text"),
        health = Drawing.new("Line"),
        healthOutline = Drawing.new("Line"),
        weapon = Drawing.new("Text"),
        distance = Drawing.new("Text"),
        head = Drawing.new("Circle"),
        headOutline = Drawing.new("Circle"),
        skeleton = {},
        skeletonOutline = {}
    }

    -- Fix for solid boxes - make them outlined
    Drawings.box.Filled = false
    Drawings.boxOutline.Filled = false

    for i = 1, 15 do
        local line = Drawing.new("Line")
        line.Color = Color3.fromRGB(255, 255, 255)
        line.Thickness = 1
        line.Visible = false
        line.ZIndex = 2
        table.insert(Drawings.skeleton, line)

        local lineOutline = Drawing.new("Line")
        lineOutline.Color = Color3.fromRGB(0, 0, 0)
        lineOutline.Thickness = 1.5
        lineOutline.Visible = false
        table.insert(Drawings.skeletonOutline, lineOutline)
    end

    local function Remove()
        if Connection then 
            Connection:Disconnect() 
            Connection = nil
        end
        
        for key, drawing in pairs(Drawings) do
            if typeof(drawing) == "table" then
                for _, v in ipairs(drawing) do
                    if v and v.Remove then
                        v:Remove()
                    end
                end
            else
                if drawing and drawing.Remove then
                    drawing:Remove()
                end
            end
        end
        
        -- Clear the drawings table
        for key in pairs(Drawings) do
            Drawings[key] = nil
        end
    end

    -- Enhanced cleanup system
    local function setupCleanup()
        if player then
            -- When player leaves the game
            player.AncestryChanged:Connect(function()
                if not player.Parent then
                    Remove()
                end
            end)
            
            -- When player character is removed/dies
            player.CharacterRemoving:Connect(function()
                Remove()
            end)
            
            -- Backup cleanup when player object is destroyed
            if player.Destroying then
                player.Destroying:Connect(Remove)
            end
        end
    end
    
    setupCleanup()

    local bones = {
        {"Head", "UpperTorso"},
        {"UpperTorso", "LowerTorso"},
        {"LowerTorso", "LeftUpperLeg"},
        {"LowerTorso", "RightUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"},
        {"RightUpperLeg", "RightLowerLeg"},
        {"LeftLowerLeg", "LeftFoot"},
        {"RightLowerLeg", "RightFoot"},
        {"UpperTorso", "LeftUpperArm"},
        {"UpperTorso", "RightUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"},
        {"RightUpperArm", "RightLowerArm"},
        {"LeftLowerArm", "LeftHand"},
        {"RightLowerArm", "RightHand"},
    }

    -- Function to hide all drawings
    local function hideAllDrawings()
        for key, drawing in pairs(Drawings) do
            if typeof(drawing) == "table" then
                for _, line in ipairs(drawing) do 
                    if line then line.Visible = false end
                end
            else
                if drawing then drawing.Visible = false end
            end
        end
    end

    local update = function()
        Connection = RunService.Heartbeat:Connect(function()
            -- Check if player still exists in game
            if not player or not player.Parent or not Players:FindFirstChild(player.Name) then
                Remove()
                return
            end
            
            local Character = player.Character
            -- Check if character exists and is alive
            if not Character or not Character.Parent then
                hideAllDrawings()
                return
            end

            local RootPart = Character:FindFirstChild("HumanoidRootPart")
            local Humanoid = Character:FindFirstChild("Humanoid")
            local Head = Character:FindFirstChild("Head")

            -- Check if essential parts exist and player is alive
            if not RootPart or not Humanoid or not Head or Humanoid.Health <= 0 then
                hideAllDrawings()
                return
            end
            
            -- Check if same team (hide ESP for teammates)
            if player.Team == LocalPlayer.Team then
                hideAllDrawings()
                return
            end

            -- Check if ESP is enabled
            if not Toggles.ESP.CurrentValue then
                hideAllDrawings()
                return
            end

            local Position, Visible = Camera:WorldToViewportPoint(RootPart.Position)
            local hPosition, hVisible = Camera:WorldToViewportPoint(Head.Position)
            local weapon = Character:FindFirstChildWhichIsA("Tool") or { Name = "none" }

            -- FIXED: Only show ESP when actually visible on screen
            if Visible and Position.Z > 0 then
                local scale = 1 / (Position.Z * math.tan(math.rad(Camera.FieldOfView * 0.5)) * 2) * 1000
                local width, height = math.floor(4.5 * scale), math.floor(6 * scale)
                local x, y = math.floor(Position.X), math.floor(Position.Y)
                local xPosition, yPosition = math.floor(x - width * 0.5), math.floor((y - height * 0.5) + (0.5 * scale))

                local hx, hy = math.floor(hPosition.X), math.floor(hPosition.Y)
                local distance = (HumanoidRootPart.Position - RootPart.Position).Magnitude

                -- Head Circle
                if Drawings.head and Drawings.headOutline then
                    Drawings.head.Color = Color3.fromRGB(255, 255, 255)
                    Drawings.head.Radius = scale - 1
                    Drawings.head.ZIndex = 2
                    Drawings.head.Thickness = 1
                    Drawings.head.Position = Vector2.new(hx, hy)
                    Drawings.head.Visible = Toggles.HeadCircle.CurrentValue
                    Drawings.head.Filled = false

                    Drawings.headOutline.Color = Color3.fromRGB(0, 0, 0)
                    Drawings.headOutline.Radius = scale - 1
                    Drawings.headOutline.ZIndex = 1
                    Drawings.headOutline.Thickness = 1.5
                    Drawings.headOutline.Position = Vector2.new(hx, hy)
                    Drawings.headOutline.Visible = Toggles.HeadCircle.CurrentValue
                    Drawings.headOutline.Filled = false
                end

                -- Box
                if Drawings.box and Drawings.boxOutline then
                    Drawings.box.Size = Vector2.new(width, height)
                    Drawings.box.Position = Vector2.new(xPosition, yPosition)
                    Drawings.box.Color = Color3.fromRGB(255, 255, 255)
                    Drawings.box.Thickness = 1
                    Drawings.box.Visible = Toggles.Boxes.CurrentValue
                    Drawings.box.ZIndex = 2
                    Drawings.box.Filled = false

                    Drawings.boxOutline.Size = Vector2.new(width, height)
                    Drawings.boxOutline.Position = Vector2.new(xPosition, yPosition)
                    Drawings.boxOutline.Color = Color3.fromRGB(0, 0, 0)
                    Drawings.boxOutline.Thickness = 3
                    Drawings.boxOutline.Visible = Toggles.Boxes.CurrentValue
                    Drawings.boxOutline.ZIndex = 1
                    Drawings.boxOutline.Filled = false
                end

                -- Name
                if Drawings.name then
                    Drawings.name.Text = player.Name
                    Drawings.name.Size = math.clamp(math.abs(12.5 * scale), 10, 12.5)
                    Drawings.name.Position = Vector2.new(x, (yPosition - Drawings.name.TextBounds.Y) - 2)
                    Drawings.name.Color = Color3.fromRGB(255, 255, 255)
                    Drawings.name.Outline = true
                    Drawings.name.OutlineColor = Color3.fromRGB(0, 0, 0)
                    Drawings.name.Visible = Toggles.Names.CurrentValue
                    Drawings.name.Center = true
                end

                -- Health
                local healthPercent = math.clamp((Humanoid.Health / Humanoid.MaxHealth) * 100, 0, 100)

                if Drawings.healthOutline then
                    Drawings.healthOutline.From = Vector2.new(xPosition - 8, yPosition)
                    Drawings.healthOutline.To = Vector2.new(xPosition - 8, yPosition + height)
                    Drawings.healthOutline.Color = Color3.fromRGB(0, 0, 0)
                    Drawings.healthOutline.Thickness = 3
                    Drawings.healthOutline.Visible = Toggles.HealthBar.CurrentValue
                end

                if Drawings.health then
                    Drawings.health.From = Vector2.new(xPosition - 8, (yPosition + height) - 1)
                    Drawings.health.To = Vector2.new(xPosition - 8, ((Drawings.health.From.Y - ((height / 100) * healthPercent))) + 2)
                    Drawings.health.Color = Color3.fromRGB(255, 0, 0):Lerp(Color3.fromRGB(0, 255, 0), healthPercent * 0.01)
                    Drawings.health.Visible = Toggles.HealthBar.CurrentValue
                    Drawings.health.ZIndex = 2
                end

                -- Weapon
                if Drawings.weapon then
                    Drawings.weapon.Text = weapon.Name
                    Drawings.weapon.Size = math.clamp(math.abs(11 * scale), 10, 11)
                    Drawings.weapon.Position = Vector2.new(x, (yPosition + height) + (Drawings.weapon.TextBounds.Y * 0.25))
                    Drawings.weapon.Color = Color3.fromRGB(255, 255, 255)
                    Drawings.weapon.Outline = true
                    Drawings.weapon.OutlineColor = Color3.fromRGB(0, 0, 0)
                    Drawings.weapon.Center = true
                    Drawings.weapon.Visible = Toggles.Weapon.CurrentValue
                end

                -- Distance
                if Drawings.distance then
                    Drawings.distance.Text = math.floor(distance) .. "(s)"
                    Drawings.distance.Size = math.clamp(math.abs(11 * scale), 10, 11)
                    Drawings.distance.Position = Vector2.new(x, (yPosition + height + 10) + (Drawings.distance.TextBounds.Y * 0.25))
                    Drawings.distance.Color = Color3.fromRGB(255, 255, 255)
                    Drawings.distance.Outline = true
                    Drawings.distance.OutlineColor = Color3.fromRGB(0, 0, 0)
                    Drawings.distance.Center = true
                    Drawings.distance.Visible = Toggles.Distance.CurrentValue
                end

                -- Skeleton
                if Toggles.Skeleton and Toggles.Skeleton.CurrentValue then
                    local index = 1
                    for _, bonePair in ipairs(bones) do
                        if index <= #Drawings.skeleton then
                            local part0 = Character:FindFirstChild(bonePair[1])
                            local part1 = Character:FindFirstChild(bonePair[2])
                            local line = Drawings.skeleton[index]
                            local line2 = Drawings.skeletonOutline[index]

                            if part0 and part1 and line and line2 then
                                local p0, visible0 = Camera:WorldToViewportPoint(part0.Position)
                                local p1, visible1 = Camera:WorldToViewportPoint(part1.Position)

                                if visible0 and visible1 and p0.Z > 0 and p1.Z > 0 then
                                    line.From = Vector2.new(p0.X, p0.Y)
                                    line.To = Vector2.new(p1.X, p1.Y)
                                    line.Visible = true

                                    line2.From = Vector2.new(p0.X, p0.Y)
                                    line2.To = Vector2.new(p1.X, p1.Y)
                                    line2.Visible = true
                                else
                                    line.Visible = false
                                    line2.Visible = false
                                end
                            else
                                if line then line.Visible = false end
                                if line2 then line2.Visible = false end
                            end

                            index += 1
                        end
                    end
                else
                    for _, line in ipairs(Drawings.skeleton) do
                        if line then line.Visible = false end
                    end

                    for _, line in ipairs(Drawings.skeletonOutline) do
                        if line then line.Visible = false end
                    end
                end
            else
                -- FIXED: Hide all drawings when not visible or behind camera
                hideAllDrawings()
            end
        end)
    end

    coroutine.wrap(update)()
end

-- Initialize ESP for existing players
do
    for _, v in pairs(Players:GetPlayers()) do
        if v.Name ~= Players.LocalPlayer.Name then
            coroutine.wrap(ESP)(v)
        end      
    end
    Players.PlayerAdded:Connect(function(v)
        task.delay(1, function()
            coroutine.wrap(ESP)(v)
        end)
    end) 
end 

-- Helper Functions
local function IsPlayerValid(player)
    if player == LocalPlayer then return false end
    if not player.Character then return false end

    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end

    if player.Team == LocalPlayer.Team then
        return false
    end

    return true
end

local function GetTargetPart(character)
    local targetPart = TargetDropdown.CurrentOption[1] or "Head"
    return character:FindFirstChild(targetPart) or character:FindFirstChild("Head")
end

local function GetClosestTarget()
    local closestPart = nil
    local shortestDistance = math.huge
    local mousePos = Vector2.new(LocalPlayer:GetMouse().X, LocalPlayer:GetMouse().Y)

    for _, player in ipairs(Players:GetPlayers()) do
        if IsPlayerValid(player) then
            local part = GetTargetPart(player.Character)
            if part then
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if distance < shortestDistance and distance <= (Sliders.FOVSize.CurrentValue or 100) then
                        shortestDistance = distance
                        closestPart = part
                    end
                end
            end
        end
    end

    return closestPart
end

-- FOV Circle
-- Fixed FOV Circle (outlined instead of filled)
local SilentFOV = Drawing.new("Circle")
SilentFOV.Radius = 100
SilentFOV.Visible = false
SilentFOV.Thickness = 1.5
SilentFOV.ZIndex = 2
SilentFOV.Color = Color3.fromRGB(255, 255, 255)
SilentFOV.Filled = false -- This fixes the filled circle issue

local SilentFOVOutline = Drawing.new("Circle")
SilentFOVOutline.Radius = 100
SilentFOVOutline.Visible = false
SilentFOVOutline.Thickness = 2
SilentFOVOutline.ZIndex = 1
SilentFOVOutline.Color = Color3.fromRGB(0,0,0)
SilentFOVOutline.Filled = false -- This fixes the filled circle issue

-- Silent Aim Hook
local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local Args = {...}
    local Method = getnamecallmethod()

    if self == workspace and not checkcaller() then
        if Method == "Raycast" and Toggles.Silent.CurrentValue and Target then
            local Origin = Args[1]

            if Toggles.MagicBullet.CurrentValue then
                Args[1] = (Target.CFrame * CFrame.new(0, 0, 1)).p
                Origin = Args[1]
            end

            Args[2] = (Target.Position - Origin).Unit * 1024
        end
    end

    return OldNamecall(self, unpack(Args))
end)

-- Main Loop
RunService.Heartbeat:Connect(function()
    -- Walkspeed
    if Toggles.Walkspeed.CurrentValue then
        Humanoid.WalkSpeed = Sliders.Speed.CurrentValue or 11
    end
    
    -- NoClip
    if Toggles.NoClip.CurrentValue then
        pcall(function()
            for i,v in pairs(Character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide == true then
                    v.CanCollide = false
                end
            end
        end)
    end

    -- Silent Aim Target
    Target = GetClosestTarget()
    
    -- FOV Circle
    if Toggles.Silent.CurrentValue and Toggles.ShowFOV.CurrentValue then
        SilentFOV.Visible = true
        SilentFOVOutline.Visible = true

        SilentFOV.Radius = Sliders.FOVSize.CurrentValue or 100
        SilentFOVOutline.Radius = Sliders.FOVSize.CurrentValue or 100

        SilentFOV.Position = UserInputService:GetMouseLocation()
        SilentFOVOutline.Position = UserInputService:GetMouseLocation()
    else
        SilentFOV.Visible = false
        SilentFOVOutline.Visible = false
    end

    -- Fly
    if Toggles.Fly.CurrentValue then
        local cam = workspace.CurrentCamera
        local moveDir = (cam.CFrame.LookVector * Flymovement.forward + cam.CFrame.RightVector * Flymovement.right + Vector3.yAxis * Flymovement.up).Unit
        if moveDir.Magnitude > 0 then
            velocity.Velocity = moveDir * (Sliders.FlySpeed.CurrentValue or 11)
        else
            velocity.Velocity = Vector3.zero
        end
    end
end)

-- Input Handling for Fly
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    if input.KeyCode == Enum.KeyCode.W then
        Flymovement.forward = 1
    elseif input.KeyCode == Enum.KeyCode.S then
        Flymovement.forward = -1
    elseif input.KeyCode == Enum.KeyCode.A then
        Flymovement.right = -1
    elseif input.KeyCode == Enum.KeyCode.D then
        Flymovement.right = 1
    elseif input.KeyCode == Enum.KeyCode.Space then
        Flymovement.up = 1
    elseif input.KeyCode == Enum.KeyCode.LeftShift then
        Flymovement.up = -1
    end
end)

UserInputService.InputEnded:Connect(function(input, gpe)
    if gpe then return end

    if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.S then
        Flymovement.forward = 0
    elseif input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.D then
        Flymovement.right = 0
    elseif input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.LeftShift then
        Flymovement.up = 0
    end
end)

-- Notification
local TimeToLoad = math.abs(StartTime - tick())
Rayfield:Notify({
    Title = "PureHub",
    Content = "Loaded in " .. TimeToLoad .. " seconds",
    Duration = 5,
    Image = 4483362458,
    Actions = {
        Ignore = {
            Name = "Okay!",
            Callback = function()
                print("The user tapped Okay!")
            end
        },
    },
})
