--Fucking skids get lost


local ReplicatedStorage = game:GetService('ReplicatedStorage')
local VirtualInputManager = game:GetService('VirtualInputManager')
local UserInputService = game:GetService('UserInputService')
local RunService = game:GetService('RunService')
local Workspace = game:GetService('Workspace')
local Players = game:GetService('Players')
local Lighting = game:GetService('Lighting')

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

-- Preset System Variables
local PresetSystem = {
    CurrentPreset = "Default",
    AutoSave = true,
    AutoSaveInterval = 30, -- seconds
    LastAutoSave = tick()
}

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
local PresetTab = Window:CreateTab("Presets", 4483362458)
local CombatTab = Window:CreateTab("Combat", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local MiscTab = Window:CreateTab("Miscellaneous", 4483362458)

-- Variables for toggles and sliders
local Toggles = {}
local Sliders = {}

-- Preset System Functions
local function GetCurrentSettings()
    local settings = {
        -- Combat Settings
        Silent = Toggles.Silent and Toggles.Silent.CurrentValue or false,
        MagicBullet = Toggles.MagicBullet and Toggles.MagicBullet.CurrentValue or false,
        ShowFOV = Toggles.ShowFOV and Toggles.ShowFOV.CurrentValue or false,
        HitChance = Sliders.HitChance and Sliders.HitChance.CurrentValue or 100,
        FOVSize = Sliders.FOVSize and Sliders.FOVSize.CurrentValue or 100,
        
        -- Gun Mods
        NoRecoil = Toggles.NoRecoil and Toggles.NoRecoil.CurrentValue or false,
        NoSpread = Toggles.NoSpread and Toggles.NoSpread.CurrentValue or false,
        FastFirerate = Toggles.FastFirerate and Toggles.FastFirerate.CurrentValue or false,
        
        -- Visuals Settings
        PlayerESP = Toggles.PlayerESP and Toggles.PlayerESP.CurrentValue or false,
        DroneESP = Toggles.DroneESP and Toggles.DroneESP.CurrentValue or false,
        CameraESP = Toggles.CameraESP and Toggles.CameraESP.CurrentValue or false,
        GadgetESP = Toggles.GadgetESP and Toggles.GadgetESP.CurrentValue or false,
        PlayerTeamCheck = Toggles.PlayerTeamCheck and Toggles.PlayerTeamCheck.CurrentValue or false,
        PlayerOutline = Toggles.PlayerOutline and Toggles.PlayerOutline.CurrentValue or true,
        ESPDelay = Sliders.ESPDelay and Sliders.ESPDelay.CurrentValue or 0.5,
        PlayerESPDelay = Sliders.PlayerESPDelay and Sliders.PlayerESPDelay.CurrentValue or 0.5,
        PlayerTransparency = Sliders.PlayerTransparency and Sliders.PlayerTransparency.CurrentValue or 0.5,
        
        -- Misc Settings
        Walkspeed = Toggles.Walkspeed and Toggles.Walkspeed.CurrentValue or false,
        Speed = Sliders.Speed and Sliders.Speed.CurrentValue or 11,
        NoClip = Toggles.NoClip and Toggles.NoClip.CurrentValue or false,
        Fly = Toggles.Fly and Toggles.Fly.CurrentValue or false,
        FlySpeed = Sliders.FlySpeed and Sliders.FlySpeed.CurrentValue or 11
    }
    return settings
end

local function ApplySettings(settings)
    -- Apply Combat Settings
    if Toggles.Silent then Toggles.Silent:Set(settings.Silent or false) end
    if Toggles.MagicBullet then Toggles.MagicBullet:Set(settings.MagicBullet or false) end
    if Toggles.ShowFOV then Toggles.ShowFOV:Set(settings.ShowFOV or false) end
    if Sliders.HitChance then Sliders.HitChance:Set(settings.HitChance or 100) end
    if Sliders.FOVSize then Sliders.FOVSize:Set(settings.FOVSize or 100) end
    
    -- Apply Gun Mods
    if Toggles.NoRecoil then Toggles.NoRecoil:Set(settings.NoRecoil or false) end
    if Toggles.NoSpread then Toggles.NoSpread:Set(settings.NoSpread or false) end
    if Toggles.FastFirerate then Toggles.FastFirerate:Set(settings.FastFirerate or false) end
    
    -- Apply Visuals Settings
    if Toggles.PlayerESP then Toggles.PlayerESP:Set(settings.PlayerESP or false) end
    if Toggles.DroneESP then Toggles.DroneESP:Set(settings.DroneESP or false) end
    if Toggles.CameraESP then Toggles.CameraESP:Set(settings.CameraESP or false) end
    if Toggles.GadgetESP then Toggles.GadgetESP:Set(settings.GadgetESP or false) end
    if Toggles.PlayerTeamCheck then Toggles.PlayerTeamCheck:Set(settings.PlayerTeamCheck or false) end
    if Toggles.PlayerOutline then Toggles.PlayerOutline:Set(settings.PlayerOutline or true) end
    if Sliders.ESPDelay then Sliders.ESPDelay:Set(settings.ESPDelay or 0.5) end
    if Sliders.PlayerESPDelay then Sliders.PlayerESPDelay:Set(settings.PlayerESPDelay or 0.5) end
    if Sliders.PlayerTransparency then Sliders.PlayerTransparency:Set(settings.PlayerTransparency or 0.5) end
    
    -- Apply Misc Settings
    if Toggles.Walkspeed then Toggles.Walkspeed:Set(settings.Walkspeed or false) end
    if Sliders.Speed then Sliders.Speed:Set(settings.Speed or 11) end
    if Toggles.NoClip then Toggles.NoClip:Set(settings.NoClip or false) end
    if Toggles.Fly then Toggles.Fly:Set(settings.Fly or false) end
    if Sliders.FlySpeed then Sliders.FlySpeed:Set(settings.FlySpeed or 11) end
end

local function SavePreset(presetName)
    local settings = GetCurrentSettings()
    writefile("Pure/Presets/" .. presetName .. ".json", game:GetService("HttpService"):JSONEncode(settings))
    
    Rayfield:Notify({
        Title = "Preset Saved",
        Content = "Preset '" .. presetName .. "' has been saved successfully!",
        Duration = 3,
        Image = 4483362458
    })
end

local function LoadPreset(presetName)
    local success, result = pcall(function()
        local data = readfile("Pure/Presets/" .. presetName .. ".json")
        return game:GetService("HttpService"):JSONDecode(data)
    end)
    
    if success then
        ApplySettings(result)
        PresetSystem.CurrentPreset = presetName
        
        Rayfield:Notify({
            Title = "Preset Loaded",
            Content = "Preset '" .. presetName .. "' has been loaded successfully!",
            Duration = 3,
            Image = 4483362458
        })
    else
        Rayfield:Notify({
            Title = "Load Failed",
            Content = "Failed to load preset '" .. presetName .. "'",
            Duration = 3,
            Image = 4483362458
        })
    end
end

local function GetAvailablePresets()
    local presets = {"Default"}
    
    if isfolder("Pure/Presets") then
        for _, file in pairs(listfiles("Pure/Presets")) do
            if file:match("%.json$") then
                local presetName = file:match("([^/\\]+)%.json$")
                if presetName and presetName ~= "Default" then
                    table.insert(presets, presetName)
                end
            end
        end
    end
    
    return presets
end

local function AutoSaveCurrentPreset()
    if PresetSystem.AutoSave and PresetSystem.CurrentPreset ~= "Default" then
        SavePreset(PresetSystem.CurrentPreset)
    end
end

-- Create Preset folder if it doesn't exist
if not isfolder("Pure") then
    makefolder("Pure")
end
if not isfolder("Pure/Presets") then
    makefolder("Pure/Presets")
end

-- Preset Tab UI
local PresetSection = PresetTab:CreateSection("Preset Management")

local PresetInput = PresetTab:CreateInput({
    Name = "Preset Name",
    PlaceholderText = "Enter preset name...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        -- Input handling
    end,
})



local PresetDropdown = PresetTab:CreateDropdown({
    Name = "Load Preset",
    Options = GetAvailablePresets(),
    CurrentOption = {"Default"},
    MultipleOptions = false,
    Flag = "PresetSelection",
    Callback = function(Option)
        local presetName = Option[1]
        if presetName and presetName ~= "Default" then
            LoadPreset(presetName)
        end
    end,
})

local DeletePresetButton = PresetTab:CreateButton({
    Name = "Delete Selected Preset",
    Callback = function()
        local selectedPreset = PresetDropdown.CurrentOption[1]
        if selectedPreset and selectedPreset ~= "Default" then
            local success = pcall(function()
                delfile("Pure/Presets/" .. selectedPreset .. ".json")
            end)
            
            if success then
                PresetDropdown:Refresh(GetAvailablePresets(), true)
                PresetSystem.CurrentPreset = "Default"
                
                Rayfield:Notify({
                    Title = "Preset Deleted",
                    Content = "Preset '" .. selectedPreset .. "' has been deleted",
                    Duration = 3,
                    Image = 4483362458
                })
            else
                Rayfield:Notify({
                    Title = "Delete Failed",
                    Content = "Failed to delete preset '" .. selectedPreset .. "'",
                    Duration = 3,
                    Image = 4483362458
                })
            end
        else
            Rayfield:Notify({
                Title = "Invalid Selection",
                Content = "Cannot delete the Default preset",
                Duration = 3,
                Image = 4483362458
            })
        end
    end,
})

local ManualSaveButton = PresetTab:CreateButton({
    Name = "Save Current Preset",
    Callback = function()
        if PresetSystem.CurrentPreset ~= "Default" then
            SavePreset(PresetSystem.CurrentPreset)
        else
            Rayfield:Notify({
                Title = "No Active Preset",
                Content = "Please create or load a preset first",
                Duration = 3,
                Image = 4483362458
            })
        end
    end,
})

local function UpdateCharacterReferences()
    Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    HumanoidRootPart = Character:WaitForChild('HumanoidRootPart')
    Humanoid = Character:WaitForChild('Humanoid')
    
    -- Update the fly velocity parent if fly is currently enabled
    if Toggles.Fly and Toggles.Fly.CurrentValue then
        velocity.Parent = HumanoidRootPart
    end
    
    print("Character references updated") -- Debug message
end

-- ESP Variables and Storage
local ESP = {
    Player = false,
    PlayerDelay = 0.5,
    PlayerTeamCheck = false,
    PlayerColor = Color3.fromRGB(255,0,0),
    PlayerTransparency = 0.5,
    PlayerOutline = true,
    PlayerOutlineColor = Color3.fromRGB(255,255,255),
    PlayerOutlineTransparency = 0,
    
    Drone = false,
    DroneColor = Color3.fromRGB(255,0,0),
    DroneTransparency = 0.5,
    DroneOutline = true,
    DroneOutlineColor = Color3.fromRGB(255,255,255),
    DroneOutlineTransparency = 0,
    
    Camera = false,
    CameraColor = Color3.fromRGB(0, 0, 255),
    CameraTransparency = 0.5,
    CameraOutline = true,
    CameraOutlineColor = Color3.fromRGB(255,255,255),
    CameraOutlineTransparency = 0,
    
    Gadget = false,
    GadgetColor = Color3.fromRGB(255, 0, 0),
    GadgetTransparency = 0.5,
    GadgetOutline = false,
    GadgetOutlineColor = Color3.fromRGB(255,255,255),
    GadgetOutlineTransparency = 0,
    
    Delay = 0.5
}

-- Create ESP Storage Folders
local PlayerStorage = Instance.new("Folder")
PlayerStorage.Parent = game.Workspace
PlayerStorage.Name = "Player_ESP_Storage"

local DroneStorage = Instance.new("Folder")
DroneStorage.Parent = game.Workspace
DroneStorage.Name = "Drone_ESP_Storage"

local CameraStorage = Instance.new("Folder")
CameraStorage.Parent = game.Workspace
CameraStorage.Name = "Camera_ESP_Storage"

local GadgetStorage = Instance.new("Folder")
GadgetStorage.Parent = game.Workspace
GadgetStorage.Name = "Gadget_ESP_Storage"

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

-- Visuals Section - ESP
local ESPSection = VisualsTab:CreateSection("ESP Settings")

local ESPButton = VisualsTab:CreateButton({
    Name = "ESP Not Working? (Roblox Limit: 31 Highlights)",
    Callback = function()
        Rayfield:Notify({
            Title = "ESP Limit",
            Content = "Roblox has a set adornee limit (31 highlights max). Use fewer ESP features!",
            Duration = 5,
            Image = 4483362458
        })
    end
})

Sliders.ESPDelay = VisualsTab:CreateSlider({
    Name = "ESP Update Delay",
    Range = {0.1, 3},
    Increment = 0.1,
    Suffix = "s",
    CurrentValue = 0.5,
    Flag = "ESPDelay",
    Callback = function(Value)
        ESP.Delay = Value
    end,
})

-- Player ESP Section
local PlayerESPSection = VisualsTab:CreateSection("Player ESP")

Toggles.PlayerESP = VisualsTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Flag = "PlayerESP",
    Callback = function(Value)
        ESP.Player = Value
        if Value then
            PlayerESPLoop()
        else
            for _, v in pairs(PlayerStorage:GetChildren()) do
                v:Destroy()
            end
        end
    end,
})

Sliders.PlayerESPDelay = VisualsTab:CreateSlider({
    Name = "Player ESP Delay",
    Range = {0.1, 5},
    Increment = 0.1,
    Suffix = "s",
    CurrentValue = 0.5,
    Flag = "PlayerESPDelay",
    Callback = function(Value)
        ESP.PlayerDelay = Value
    end,
})

Toggles.PlayerTeamCheck = VisualsTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = false,
    Flag = "PlayerTeamCheck",
    Callback = function(Value)
        ESP.PlayerTeamCheck = Value
    end,
})

local PlayerColorPicker = VisualsTab:CreateColorPicker({
    Name = "Player ESP Color",
    Color = Color3.fromRGB(255, 0, 0),
    Flag = "PlayerESPColor",
    Callback = function(Value)
        ESP.PlayerColor = Value
    end
})

Sliders.PlayerTransparency = VisualsTab:CreateSlider({
    Name = "Player Transparency",
    Range = {0, 0.9},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = 0.5,
    Flag = "PlayerTransparency",
    Callback = function(Value)
        ESP.PlayerTransparency = Value
    end,
})

Toggles.PlayerOutline = VisualsTab:CreateToggle({
    Name = "Player Outline",
    CurrentValue = true,
    Flag = "PlayerOutline",
    Callback = function(Value)
        ESP.PlayerOutline = Value
    end,
})

local PlayerOutlineColorPicker = VisualsTab:CreateColorPicker({
    Name = "Player Outline Color",
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "PlayerOutlineColor",
    Callback = function(Value)
        ESP.PlayerOutlineColor = Value
    end
})

-- Drone ESP Section
local DroneESPSection = VisualsTab:CreateSection("Drone ESP")

Toggles.DroneESP = VisualsTab:CreateToggle({
    Name = "Drone ESP",
    CurrentValue = false,
    Flag = "DroneESP",
    Callback = function(Value)
        ESP.Drone = Value
        if Value then
            DroneESPLoop()
        else
            for _, v in pairs(DroneStorage:GetChildren()) do
                v:Destroy()
            end
        end
    end,
})

local DroneColorPicker = VisualsTab:CreateColorPicker({
    Name = "Drone ESP Color",
    Color = Color3.fromRGB(255, 0, 0),
    Flag = "DroneESPColor",
    Callback = function(Value)
        ESP.DroneColor = Value
    end
})

-- Camera ESP Section
local CameraESPSection = VisualsTab:CreateSection("Camera ESP")

Toggles.CameraESP = VisualsTab:CreateToggle({
    Name = "Camera ESP",
    CurrentValue = false,
    Flag = "CameraESP",
    Callback = function(Value)
        ESP.Camera = Value
        if Value then
            CameraESPLoop()
        else
            for _, v in pairs(CameraStorage:GetChildren()) do
                v:Destroy()
            end
        end
    end,
})

local CameraColorPicker = VisualsTab:CreateColorPicker({
    Name = "Camera ESP Color",
    Color = Color3.fromRGB(0, 0, 255),
    Flag = "CameraESPColor",
    Callback = function(Value)
        ESP.CameraColor = Value
    end
})

-- Gadget ESP Section
local GadgetESPSection = VisualsTab:CreateSection("Gadget ESP")

Toggles.GadgetESP = VisualsTab:CreateToggle({
    Name = "Gadget ESP",
    CurrentValue = false,
    Flag = "GadgetESP",
    Callback = function(Value)
        ESP.Gadget = Value
        if Value then
            GadgetESPLoop()
        else
            for _, v in pairs(GadgetStorage:GetChildren()) do
                v:Destroy()
            end
        end
    end,
})

local GadgetColorPicker = VisualsTab:CreateColorPicker({
    Name = "Gadget ESP Color",
    Color = Color3.fromRGB(255, 0, 0),
    Flag = "GadgetESPColor",
    Callback = function(Value)
        ESP.GadgetColor = Value
    end
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

-- ESP Functions
function PlayerESPLoop()
    spawn(function()
        while ESP.Player do
            wait(ESP.PlayerDelay)
            -- Clear existing highlights
            for _, v in pairs(PlayerStorage:GetChildren()) do
                v:Destroy()
            end
            
            -- Create new highlights
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                    if player.Character.Humanoid.Health > 0 then
                        local shouldHighlight = true
                        
                        if ESP.PlayerTeamCheck and player.Team == LocalPlayer.Team then
                            shouldHighlight = false
                        end
                        
                        if shouldHighlight then
                            local highlight = Instance.new("Highlight")
                            highlight.FillColor = ESP.PlayerColor
                            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            highlight.FillTransparency = ESP.PlayerTransparency
                            highlight.OutlineColor = ESP.PlayerOutlineColor
                            
                            if ESP.PlayerOutline then
                                highlight.OutlineTransparency = ESP.PlayerOutlineTransparency
                            else
                                highlight.OutlineTransparency = 1
                            end
                            
                            highlight.Parent = PlayerStorage
                            highlight.Adornee = player.Character
                        end
                    end
                end
            end
        end
        
        -- Clean up when disabled
        for _, v in pairs(PlayerStorage:GetChildren()) do
            v:Destroy()
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    UpdateCharacterReferences()
end)

function DroneESPLoop()
    spawn(function()
        while ESP.Drone do
            wait(ESP.Delay)
            -- Clear existing highlights
            for _, v in pairs(DroneStorage:GetChildren()) do
                v:Destroy()
            end
            
            -- Create new highlights for drones
            if game.Workspace:FindFirstChild("SE_Workspace") and game.Workspace.SE_Workspace:FindFirstChild("Drones") then
                for _, drone in pairs(game.Workspace.SE_Workspace.Drones:GetChildren()) do
                    if drone:FindFirstChild("Humanoid") and drone.Humanoid.Health > 0 then
                        local highlight = Instance.new("Highlight")
                        highlight.FillColor = ESP.DroneColor
                        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        highlight.FillTransparency = ESP.DroneTransparency
                        highlight.OutlineColor = ESP.DroneOutlineColor
                        
                        if ESP.DroneOutline then
                            highlight.OutlineTransparency = ESP.DroneOutlineTransparency
                        else
                            highlight.OutlineTransparency = 1
                        end
                        
                        highlight.Parent = DroneStorage
                        highlight.Adornee = drone
                    end
                end
            end
        end
        
        -- Clean up when disabled
        for _, v in pairs(DroneStorage:GetChildren()) do
            v:Destroy()
        end
    end)
end

function CameraESPLoop()
    spawn(function()
        while ESP.Camera do
            wait(ESP.Delay)
            -- Clear existing highlights
            for _, v in pairs(CameraStorage:GetChildren()) do
                v:Destroy()
            end
            
            -- Create new highlights for cameras
            if game.Workspace:FindFirstChild("SE_Workspace") and game.Workspace.SE_Workspace:FindFirstChild("Cameras") then
                for _, camera in pairs(game.Workspace.SE_Workspace.Cameras:GetChildren()) do
                    if camera:FindFirstChild("Humanoid") and camera.Humanoid.Health > 0 then
                        local highlight = Instance.new("Highlight")
                        highlight.FillColor = ESP.CameraColor
                        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        highlight.FillTransparency = ESP.CameraTransparency
                        highlight.OutlineColor = ESP.CameraOutlineColor
                        
                        if ESP.CameraOutline then
                            highlight.OutlineTransparency = ESP.CameraOutlineTransparency
                        else
                            highlight.OutlineTransparency = 1
                        end
                        
                        highlight.Parent = CameraStorage
                        highlight.Adornee = camera
                    end
                end
            end
        end
        
        -- Clean up when disabled
        for _, v in pairs(CameraStorage:GetChildren()) do
            v:Destroy()
        end
    end)
end

function GadgetESPLoop()
    spawn(function()
        while ESP.Gadget do
            wait(ESP.Delay)
            -- Clear existing highlights
            for _, v in pairs(GadgetStorage:GetChildren()) do
                v:Destroy()
            end
            
            -- Create new highlights for gadgets
            if game.Workspace:FindFirstChild("Gadgets") then
                for _, gadget in pairs(game.Workspace.Gadgets:GetChildren()) do
                    local highlight = Instance.new("Highlight")
                    highlight.FillColor = ESP.GadgetColor
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.FillTransparency = ESP.GadgetTransparency
                    highlight.OutlineColor = ESP.GadgetOutlineColor
                    
                    if ESP.GadgetOutline then
                        highlight.OutlineTransparency = ESP.GadgetOutlineTransparency
                    else
                        highlight.OutlineTransparency = 1
                    end
                    
                    highlight.Parent = GadgetStorage
                    highlight.Adornee = gadget
                end
            end
        end
        
        -- Clean up when disabled
        for _, v in pairs(GadgetStorage:GetChildren()) do
            v:Destroy()
        end
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
local SilentFOV = Drawing.new("Circle")
SilentFOV.Radius = 100
SilentFOV.Visible = false
SilentFOV.Thickness = 1.5
SilentFOV.ZIndex = 2
SilentFOV.Color = Color3.fromRGB(255, 255, 255)
SilentFOV.Filled = false

local SilentFOVOutline = Drawing.new("Circle")
SilentFOVOutline.Radius = 100
SilentFOVOutline.Visible = false
SilentFOVOutline.Thickness = 2
SilentFOVOutline.ZIndex = 1
SilentFOVOutline.Color = Color3.fromRGB(0,0,0)
SilentFOVOutline.Filled = false

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
    -- Check if character still exists, if not update references
    if not Character or not Character.Parent then
        if LocalPlayer.Character then
            UpdateCharacterReferences()
        else
            return -- Skip this frame if no character
        end
    end
    
    -- Walkspeed
    if Toggles.Walkspeed.CurrentValue and Humanoid then
        Humanoid.WalkSpeed = Sliders.Speed.CurrentValue or 11
    end
    
    -- NoClip
    if Toggles.NoClip.CurrentValue and Character then
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
    if Toggles.Fly.CurrentValue and HumanoidRootPart then
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
