-- GunClient.lua
-- Place this LocalScript inside the Tool
-- Fully integrated with Outfit system for animation sync

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local tool = script.Parent
local config = require(tool:WaitForChild("GunConfig"))

local equipped = false
local reloading = false
local aiming = false
local fanning = false
local currentAmmo = config.MagazineSize
local reserveAmmo = config.ReserveAmmo
local fireModeIndex = 1
local fireModes = {"Semi", "Burst", "Auto"}
local lastShot = 0
local canShoot = true
local recoilValue = 0

local shotRequest = ReplicatedStorage:FindFirstChild("GunShotRequest")
if not shotRequest then
    shotRequest = Instance.new("RemoteEvent")
    shotRequest.Name = "GunShotRequest"
    shotRequest.Parent = ReplicatedStorage
end

local scopeEvent = ReplicatedStorage:FindFirstChild("GunScope")
if not scopeEvent then
    scopeEvent = Instance.new("RemoteEvent")
    scopeEvent.Name = "GunScope"
    scopeEvent.Parent = ReplicatedStorage
end

local function getMuzzle()
    local handle = tool:FindFirstChild("Handle")
    if handle then
        return handle:FindFirstChild("Muzzle") or handle:FindFirstChild("MuzzleAttachment")
    end
    return nil
end

local function playSound(name)
    local soundFolder = ReplicatedStorage:FindFirstChild(config.SoundFolder)
    if not soundFolder then return end
    local sound = soundFolder:FindFirstChild(name)
    if not sound then return end

    local clone = sound:Clone()
    clone.Parent = workspace
    clone:Play()

    task.delay(clone.TimeLength + 0.1, function()
        if clone and clone.Parent then
            clone:Destroy()
        end
    end)
end

local function createTrail(startPos, endPos, color)
    local distance = (startPos - endPos).Magnitude
    if distance <= 0 then return end

    local trail = Instance.new("Part")
    trail.Name = "BulletTrail"
    trail.Anchored = true
    trail.CanCollide = false
    trail.CanTouch = false
    trail.CanQuery = false
    trail.Material = Enum.Material.Neon
    trail.Color = color or Color3.fromRGB(255, 220, 100)
    trail.Transparency = 0.15
    trail.Size = Vector3.new(0.08, 0.08, distance)
    trail.CFrame = CFrame.new(startPos, endPos) * CFrame.new(0, 0, -trail.Size.Z / 2)
    trail.Parent = workspace

    local tween = TweenService:Create(trail, TweenInfo.new(config.BulletTrailLifetime, Enum.EasingStyle.Linear), {
        Transparency = 1
    })
    tween:Play()

    task.delay(config.BulletTrailLifetime + 0.05, function()
        if trail and trail.Parent then
            trail:Destroy()
        end
    end)
end

local function showScope()
    if not config.ScopeEnabled then return end
    local playerGui = player:WaitForChild("PlayerGui")
    local scopeFolder = ReplicatedStorage:FindFirstChild("Scope")
    if not scopeFolder then return end
    local scopeGui = scopeFolder:FindFirstChild("Scope")
    if not scopeGui then return end

    local existing = playerGui:FindFirstChild("ScopeGui")
    if existing then
        existing:Destroy()
    end

    local clone = scopeGui:Clone()
    clone.Name = "ScopeGui"
    clone.Parent = playerGui
end

local function hideScope()
    local playerGui = player:WaitForChild("PlayerGui")
    local existing = playerGui:FindFirstChild("ScopeGui")
    if existing then
        existing:Destroy()
    end
end

local function triggerAim(aimState)
    aiming = aimState
    if aiming then
        showScope()
    else
        hideScope()
    end
    scopeEvent:FireServer(aiming)
end

local function reload()
    if reloading or not equipped then return end
    if currentAmmo >= config.MagazineSize or reserveAmmo <= 0 then return end

    reloading = true

    playSound(config.ReloadOpenSound)
    task.wait(config.ReloadOpenTime)

    playSound(config.ReloadInsertSound)
    task.wait(config.ReloadInsertTime)

    local needed = config.MagazineSize - currentAmmo
    local loaded = math.min(needed, reserveAmmo)
    currentAmmo += loaded
    reserveAmmo -= loaded

    playSound(config.ReloadCloseSound)
    task.wait(config.ReloadCloseTime)

    reloading = false
end

local function fire()
    if not equipped or reloading or not canShoot then return end
    if currentAmmo <= 0 then
        playSound(config.DryFireSound)
        return
    end

    local now = os.clock()
    if now - lastShot < config.FireRate then
        return
    end

    currentAmmo -= 1
    lastShot = now
    canShoot = false

    local muzzle = getMuzzle()
    if muzzle then
        local spread = (fanning and config.FanningSpread) or (aiming and config.AimingSpread) or config.BaseSpread
        local direction = (camera.CFrame.LookVector + Vector3.new(
            (math.random() - 0.5) * spread,
            (math.random() - 0.5) * spread,
            0
        )).Unit

        local bulletCount = config.BulletsPerShot or 1
        if config.MultiBulletShot then
            bulletCount = math.clamp(config.MaxBulletTrails or 1, 1, 6)
        end

        for i = 1, bulletCount do
            local muzzlePos = muzzle.WorldPosition
            local offset = Vector3.new(
                (math.random() - 0.5) * 0.2,
                (math.random() - 0.5) * 0.2,
                0
            )
            local endPos = muzzlePos + ((direction + offset * 0.1).Unit * config.MaxDistance)
            createTrail(muzzlePos, endPos, Color3.fromRGB(255, 220, 100))
        end

        shotRequest:FireServer(muzzle.WorldPosition, direction, config.Damage)
    end

    playSound(config.ShotSound)
    recoilValue = math.clamp(recoilValue + config.RecoilStrength, 0, 1)

    task.delay(0.08, function()
        canShoot = true
    end)
end

local function doBurst()
    if config.FireMode ~= "Burst" then return end
    for i = 1, config.BurstCount do
        task.delay(i * config.BurstDelay, function()
            fire()
        end)
    end
end

local function doFanning()
    if config.FanningEnabled and aiming then
        fanning = not fanning
    end
end

local function onActivated()
    if not equipped then return end
    if reloading then return end

    if fanning then
        fire()
        return
    end

    if config.FireMode == "Semi" then
        fire()
    elseif config.FireMode == "Burst" then
        doBurst()
    elseif config.FireMode == "Auto" then
        fire()
    end
end

local function handleInput(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.R then
        reload()
    elseif input.KeyCode == Enum.KeyCode.Q then
        fireModeIndex = fireModeIndex % #fireModes + 1
        config.FireMode = fireModes[fireModeIndex]
    elseif input.KeyCode == Enum.KeyCode.F then
        doFanning()
    elseif input.KeyCode == Enum.KeyCode.MouseButton2 then
        triggerAim(true)
    end
end

local function handleInputEnd(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.MouseButton2 then
        triggerAim(false)
    end
end

-- OUTFIT SYSTEM INTEGRATION
-- Hook into the replicated WalkAnim and IdleAnim attributes
-- When aiming, override animations; when not aiming, use outfit animations
local function syncOutfitAnimations()
    local character = player.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then return end

    -- Read the outfit-selected animations from player attributes
    local outfitIdleAnim = player:GetAttribute("IdleAnim")
    local outfitWalkAnim = player:GetAttribute("WalkAnim")
    local outfitIdleSpeed = player:GetAttribute("IdleAnimSpeed") or 1
    local outfitWalkSpeed = player:GetAttribute("WalkAnimSpeed") or 1

    -- When NOT aiming, use outfit idle/walk
    -- When aiming, use aim-specific idle/walk
    local targetIdleAnim = aiming and config.Animations.AimIdle or outfitIdleAnim
    local targetWalkAnim = aiming and config.Animations.AimWalk or outfitWalkAnim
    local targetIdleSpeed = aiming and 1 or outfitIdleSpeed
    local targetWalkSpeed = aiming and 1 or outfitWalkSpeed

    -- Apply to all playing tracks
    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
        if track and track.Animation then
            local animId = track.Animation.AnimationId

            -- Match idle tracks
            if targetIdleAnim and animId == targetIdleAnim then
                track.Speed = targetIdleSpeed
            end

            -- Match walk tracks
            if targetWalkAnim and animId == targetWalkAnim then
                track.Speed = targetWalkSpeed
            end
        end
    end
end

tool.Equipped:Connect(function()
    equipped = true
end)

tool.Unequipped:Connect(function()
    equipped = false
    aiming = false
    fanning = false
    hideScope()
end)

tool.Activated:Connect(onActivated)

UserInputService.InputBegan:Connect(handleInput)
UserInputService.InputEnded:Connect(handleInputEnd)

-- Listen to outfit animation attribute changes
player:GetAttributeChangedSignal("IdleAnim"):Connect(syncOutfitAnimations)
player:GetAttributeChangedSignal("WalkAnim"):Connect(syncOutfitAnimations)
player:GetAttributeChangedSignal("IdleAnimSpeed"):Connect(syncOutfitAnimations)
player:GetAttributeChangedSignal("WalkAnimSpeed"):Connect(syncOutfitAnimations)

RunService.RenderStepped:Connect(function()
    if not equipped then return end

    -- Sync outfit animations while equipped
    syncOutfitAnimations()

    -- Apply recoil
    if recoilValue > 0 then
        camera.CFrame = camera.CFrame * CFrame.Angles(-math.rad(recoilValue * 18), 0, 0)
        recoilValue = math.max(0, recoilValue - 0.02)
    end

    -- Apply aiming camera offset
    if aiming then
        local targetOffset = config.AimCameraOffset
        camera.CFrame = camera.CFrame * CFrame.new(targetOffset.X, targetOffset.Y, targetOffset.Z)
    end
end)
