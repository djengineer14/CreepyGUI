-- Creepy GUI LocalScript

local Players     = game:GetService("Players")
local player      = Players.LocalPlayer

-- Utility: find any Motor6D whose name contains the given substring
local function findMotor6D(character, substring)
    for _, m6d in pairs(character:GetDescendants()) do
        if m6d:IsA("Motor6D") and m6d.Name:lower():find(substring) then
            return m6d
        end
    end
    return nil
end

-- Glow effect: attach a red Highlight to the whole character
local function addHighlight(character)
    if character:FindFirstChild("CreepyGlow") then
        return
    end
    local hl = Instance.new("Highlight")
    hl.Name           = "CreepyGlow"
    hl.FillColor      = Color3.new(1, 0, 0)
    hl.OutlineColor   = Color3.new(1, 0, 0)
    hl.DepthMode      = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee        = character
    hl.Parent         = workspace
end

-- Set up glow on every existing player, and hook future players
for _, plr in ipairs(Players:GetPlayers()) do
    if plr.Character then
        addHighlight(plr.Character)
    end
    plr.CharacterAdded:Connect(addHighlight)
end
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(addHighlight)
end)

-- Creepy twitch + T-pose effect on your character
local function setupCreepy(character)
    local neck           = findMotor6D(character, "neck")
    local rShoulder      = findMotor6D(character, "rightshoulder")
    local lShoulder      = findMotor6D(character, "leftshoulder")
    if not neck or not rShoulder or not lShoulder then
        return
    end

    local origNeck   = neck.C0
    local origRS     = rShoulder.C0
    local origLS     = lShoulder.C0

    local function twitchHead()
        neck.C0 = origNeck * CFrame.Angles(
            math.rad(math.random(-15, 15)),
            math.rad(math.random(-15, 15)),
            math.rad(math.random(-15, 15))
        )
        wait(0.1)
        neck.C0 = origNeck
    end

    local function twitchTPose()
        rShoulder.C0 = origRS * CFrame.Angles(0, math.rad(90), 0)
        lShoulder.C0 = origLS * CFrame.Angles(0, math.rad(-90), 0)
        wait(0.2)
        rShoulder.C0 = origRS
        lShoulder.C0 = origLS
    end

    spawn(function()
        while character.Parent do
            wait(2)
            twitchHead()
            if math.random() < 0.3 then
                twitchTPose()
            end
        end
    end)
end

-- Initialize on your current character and any respawns
if player.Character then
    setupCreepy(player.Character)
end
player.CharacterAdded:Connect(setupCreepy)
