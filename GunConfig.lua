-- ModuleScript: ReplicatedStorage.GunConfig
-- Edit this file to customize your gun system
-- All animation IDs, sound IDs, damage values, and behavior settings are configured here

local GunConfig = {
    -- WEAPON NAME AND CORE STATS
    WeaponName = "Advanced Rifle",
    Damage = 30,
    HeadshotDamageMultiplier = 2.5,
    HeadshotEnabled = true,
    MaxDistance = 500,
    Range = 500,
    BulletCountPerShot = 1,

    -- FIRE MODE SETTINGS
    FireMode = "Auto", -- "Semi", "Burst", "Auto"
    BurstCount = 3,
    BurstDelay = 0.08,
    FireRate = 0.09,

    -- AMMO / RELOAD
    MagazineSize = 30,
    ReserveAmmo = 120,
    ReloadTime = 2.2,
    ReloadOpenTime = 0.18,
    ReloadInsertTime = 0.6,
    ReloadCloseTime = 0.3,
    CanReload = true,

    -- SPREAD
    BaseSpread = 0.04,
    AimingSpread = 0.012,
    FanningSpread = 0.08,
    ShotgunSpread = 0.18,

    -- RECOIL
    RecoilUp = 0.7,
    RecoilDown = 0.2,
    RecoilRecovery = 10,
    RecoilStrength = 1.2,

    -- AIMING / SCOPE
    AimFOV = 35,
    ScopeEnabled = true,
    ScopeGuiName = "Scope",
    ScopeFolderName = "Scope",
    AimCameraOffset = Vector3.new(0.65, 0.1, 0.0),
    AimSmoothing = 0.2,

    -- FANNING MODE
    FanningEnabled = true,
    FanFireSpreadMultiplier = 2.2,
    FanCrosshairScale = 2.0,

    -- SHOTGUN / MULTI-BULLET
    MultiBulletShot = false,
    BulletsPerShot = 1,
    MaxBulletTrails = 6,
    ShotgunCrosshairEnabled = false,
    ScopeCrosshairAssetId = "rbxassetid://0",

    -- CROSSHAIR
    DefaultCrosshairSize = 18,
    FanningCrosshairSize = 32,

    -- HIT EFFECTS & IMPACT TEXTURES
    DamageIndicatorEnabled = true,
    DamageIndicatorLifetime = 0.8,
    ImpactSmokeFolder = "BulletImpactSmokes",
    ImpactSmokeParts = {
        Dirt = "Dirt",
        Sand = "Sand",
        Normal = "Normal",
    },

    -- NPC BOUNTY
    NPCDamageBounty = 10,
    NPCKillBounty = 40,

    -- VISUAL EFFECTS
    MuzzleFlashEnabled = true,
    TracerEnabled = true,
    BulletTrailLifetime = 0.18,
    BulletTrailWidth = 0.05,
    MuzzleFlashDuration = 0.08,
    BulletWhizDistance = 16,

    -- ANIMATION SETTINGS
    RifleMode = false,
    UseWeaponIdleOverride = true,
    UseWeaponWalkOverride = true,
    SwayEnabled = true,

    -- EDIT THESE ANIMATION IDs FOR YOUR ANIMATIONS
    Animations = {
        Idle = "rbxassetid://YOUR_IDLE_ANIMATION_ID",
        Walk = "rbxassetid://YOUR_WALK_ANIMATION_ID",
        Run = "rbxassetid://YOUR_RUN_ANIMATION_ID",
        AimIdle = "rbxassetid://YOUR_AIM_IDLE_ANIMATION_ID",
        AimWalk = "rbxassetid://YOUR_AIM_WALK_ANIMATION_ID",
        Shoot = "rbxassetid://YOUR_SHOOT_ANIMATION_ID",
        Shoot2 = "rbxassetid://YOUR_SHOOT2_ANIMATION_ID",
        Shoot3 = "rbxassetid://YOUR_SHOOT3_ANIMATION_ID",
        ReloadOpen = "rbxassetid://YOUR_RELOAD_OPEN_ANIMATION_ID",
        ReloadInsert = "rbxassetid://YOUR_RELOAD_INSERT_ANIMATION_ID",
        ReloadClose = "rbxassetid://YOUR_RELOAD_CLOSE_ANIMATION_ID",
        FanningIdle = "rbxassetid://YOUR_FANNING_IDLE_ANIMATION_ID",
        FanningShoot = "rbxassetid://YOUR_FANNING_SHOOT_ANIMATION_ID",
        SprintIdle = "rbxassetid://YOUR_SPRINT_IDLE_ANIMATION_ID",
        SprintWalk = "rbxassetid://YOUR_SPRINT_WALK_ANIMATION_ID",
    },

    -- SOUND SETTINGS
    SoundFolder = "SoundPack",
    ShotSound = "Shoot",
    DryFireSound = "DryFire",
    ReloadOpenSound = "ReloadOpen",
    ReloadInsertSound = "ReloadInsert",
    ReloadCloseSound = "ReloadClose",
    BulletWhizSound = "BulletWhiz",

    Sounds = {
        Shoot = { Id = "rbxassetid://YOUR_SHOOT_SOUND_ID", Volume = 0.8, Pitch = 1.0 },
        ShootAlt1 = { Id = "rbxassetid://YOUR_SHOOT_ALT_SOUND_ID1", Volume = 0.8, Pitch = 1.0 },
        ShootAlt2 = { Id = "rbxassetid://YOUR_SHOOT_ALT_SOUND_ID2", Volume = 0.8, Pitch = 1.0 },
        ReloadOpen = { Id = "rbxassetid://YOUR_RELOAD_OPEN_SOUND_ID", Volume = 0.6, Pitch = 1.0 },
        ReloadInsert = { Id = "rbxassetid://YOUR_RELOAD_INSERT_SOUND_ID", Volume = 0.6, Pitch = 1.0 },
        ReloadClose = { Id = "rbxassetid://YOUR_RELOAD_CLOSE_SOUND_ID", Volume = 0.6, Pitch = 1.0 },
        DryFire = { Id = "rbxassetid://YOUR_DRY_FIRE_SOUND_ID", Volume = 0.4, Pitch = 1.0 },
        BulletWhiz = { Id = "rbxassetid://YOUR_BULLET_WHIZ_SOUND_ID", Volume = 0.5, Pitch = 1.0 },
        AimIn = { Id = "rbxassetid://YOUR_AIM_IN_SOUND_ID", Volume = 0.3, Pitch = 1.0 },
        AimOut = { Id = "rbxassetid://YOUR_AIM_OUT_SOUND_ID", Volume = 0.3, Pitch = 1.0 },
    },

    -- BEHAVIOR TOGGLES
    CanUseScope = true,
    CanUseFanFire = true,
    CanUseShotgunCrosshair = true,
    CanUseAutoFire = true,
    CanUseBurstFire = true,
    CanUseSemiFire = true,
    CanUseReload = true,
}

return GunConfig
