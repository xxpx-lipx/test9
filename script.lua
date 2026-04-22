local players, run, ts, uis = game:GetService("Players"), game:GetService("RunService"), game:GetService("TweenService"), game:GetService("UserInputService")
local lp, lit, cam = workspace.CurrentCamera and players.LocalPlayer, game:GetService("Lighting"), workspace.CurrentCamera
local c3, v2, ud, ud2 = Color3.fromRGB, Vector2.new, UDim.new, UDim2.new
local f_g, f_gb, s_y = Enum.Font.Gotham, Enum.Font.GothamBold, Enum.AutomaticSize.Y
local tESP = false

local Config = { Toggles = {}, Positions = {} }
local HttpService = game:GetService("HttpService")

local function saveConfig()
    pcall(function()
        writefile("PXHUB_Config.json", HttpService:JSONEncode(Config))
    end)
end

local function loadConfig()
    pcall(function()
        if isfile("PXHUB_Config.json") then
            local raw = HttpService:JSONDecode(readfile("PXHUB_Config.json"))
            if raw.Toggles then Config.Toggles = raw.Toggles end
            if raw.Positions then Config.Positions = raw.Positions end
        end
    end)
end

loadConfig()

local function getPos(name, def)
    local p = Config.Positions[name]
    if p then return ud2(p[1], p[2], p[3], p[4]) else return def end
end

local gui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
gui.Name, gui.ResetOnSpawn, gui.IgnoreGuiInset = "PxHUB_V1_9_Ultimate_Delta", false, true

local function mk(cls, prnt, props)
    local i = Instance.new(cls, prnt)
    for k, v in pairs(props) do i[k] = v end
    return i
end

local btn = mk("TextButton", gui, {Size = ud2(0,75,0,25), Position = getPos("Btn", ud2(0,20,.15,0)), BackgroundTransparency = 1, Text = "Px", TextColor3 = c3(255,255,255), TextScaled = true, Font = f_gb, ZIndex = 10})
local bg = mk("Frame", btn, {Size = ud2(1,0,1,0), BackgroundColor3 = c3(20,80,60), BorderSizePixel = 0, ZIndex = 9})
mk("UIGradient", bg, {Color = ColorSequence.new(c3(54,152,118), c3(93,219,133)), Rotation = 45})
local strk = mk("UIStroke", bg, {Thickness = 2, Color = c3(255,255,255), ApplyStrokeMode = "Border"})
local sG = mk("UIGradient", strk, {Color = ColorSequence.new(c3(54,152,118), c3(113,255,158))})
run.RenderStepped:Connect(function(dt) sG.Rotation = (sG.Rotation + 120 * dt) % 360 end)
mk("UICorner", bg, {CornerRadius = ud(1,0)});
mk("UICorner", btn, {CornerRadius = ud(1,0)})

local menu = mk("Frame", gui, {Size = ud2(0,300,0,350), AnchorPoint = v2(.5,.5), Position = getPos("Menu", ud2(.5,0,.5,0)), BackgroundTransparency = .2, BackgroundColor3 = c3(15,40,25), Visible = false, BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 5})
mk("UICorner", menu, {CornerRadius = ud(0,12)})
local mS = mk("UIStroke", menu, {Thickness = 2, ApplyStrokeMode = "Border", Color = c3(255,255,255)})
local mainGrad = mk("UIGradient", mS, {Color = ColorSequence.new(c3(54,152,118), c3(113,255,158))})
run.RenderStepped:Connect(function(dt) mainGrad.Rotation = (mainGrad.Rotation + 120 * dt) % 360 end)

mk("TextLabel", menu, {Size = ud2(1,-20,0,30), Position = ud2(0,10,0,5), BackgroundTransparency = 1, Text = "PXHUB V1.9", TextColor3 = c3(255,255,255), Font = f_gb, TextSize = 20, TextScaled = false, TextXAlignment = "Left", ZIndex = 6})
local tC = mk("Frame", menu, {Size = ud2(1,-20,0,25), Position = ud2(0,10,0,35), BackgroundTransparency = 1, ZIndex = 6})
mk("UIListLayout", tC, {FillDirection = "Horizontal", Padding = ud(0,5), HorizontalAlignment = "Center"})
local scr = mk("ScrollingFrame", menu, {Size = ud2(1,-20,1,-75), Position = ud2(0,10,0,65), AutomaticCanvasSize = s_y, CanvasSize = ud2(0,0,0,0), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2, ZIndex = 6})

local pgs, tbs = {}, {}
local function cP(n)
    local p = mk("Frame", scr, {Name = n, Size = ud2(1,0,1,0), BackgroundTransparency = 1, Visible = false})
    mk("UIListLayout", p, {Padding = ud(0,5), SortOrder = "LayoutOrder", HorizontalAlignment = "Center"});
    pgs[n] = p; return p
end
local mP, vP, pP, uP = cP("Main"), cP("Visual"), cP("Player"), cP("Utlis");
mP.Visible = true

local function uTV(sN)
    for n, b in pairs(tbs) do
        b.BackgroundColor3 = (n==sN and c3(54,152,118) or c3(30,60,45));
        b.BackgroundTransparency = (n==sN and 0 or .5) 
    end
end

local function cT(n)
    local t = mk("TextButton", tC, {Size = ud2(.23,0,1,0), BackgroundColor3 = c3(30,60,45), BackgroundTransparency = .5, Text = n, TextColor3 = c3(255,255,255), Font = f_gb, TextSize = 13, ZIndex = 7})
    mk("UICorner", t, {CornerRadius = ud(0,4)});
    tbs[n] = t
    t.MouseButton1Click:Connect(function() for pN, pF in pairs(pgs) do pF.Visible = (pN==n) end uTV(n) end)
end
for _, v in {"Main","Visual","Player","Utlis"} do cT(v) end uTV("Main")

local function addT(pg, txt, cb, ord, keyHint)
    local c = mk("Frame", pg, {Size = ud2(1,-10,0,35), BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = ord or 0, ZIndex = 7})
    local title = mk("TextLabel", c, {Size = ud2(.7,0,1,0), BackgroundTransparency = 1, Text = "  "..txt, TextColor3 = c3(255,255,255), Font = f_gb, TextSize = 15, TextXAlignment = "Left", ZIndex = 8})
    if keyHint then
        mk("TextLabel", title, {Size = ud2(0,20,1,0), Position = ud2(0, title.TextBounds.X + 15, 0, 0), BackgroundTransparency = 1, Text = "("..keyHint..")", TextColor3 = c3(180,180,180), Font = f_gb, TextSize = 15, TextXAlignment = "Left", ZIndex = 8})
    end
    local b = mk("TextButton", c, {Size = ud2(0,45,0,22), Position = ud2(1,-50,0,6), BackgroundColor3 = c3(40,40,40), BackgroundTransparency = .3, Text = "", ZIndex = 8})
    mk("UICorner", b, {CornerRadius = ud(1,0)})
    local ck = mk("Frame", b, {Size = ud2(0,18,0,18), Position = ud2(0,2,0,2), BackgroundColor3 = c3(200,200,200), ZIndex = 9})
    mk("UICorner", ck, {CornerRadius = ud(1,0)})
    
    local on = false
    if Config.Toggles[txt] ~= nil then on = Config.Toggles[txt] end
    
    local function update(isInit)
        ts:Create(ck, TweenInfo.new(.2), {Position = on and ud2(1,-20,0,2) or ud2(0,2,0,2), BackgroundColor3 = on and c3(113,255,158) or c3(200,200,200)}):Play()
        ts:Create(b, TweenInfo.new(.2), {BackgroundColor3 = on and c3(30,100,60) or c3(40,40,40)}):Play()
        cb(on)
        if not isInit then
            Config.Toggles[txt] = on
            saveConfig()
        end
    end
    
    b.MouseButton1Click:Connect(function() on = not on update(false) end)
    if on then task.spawn(function() update(true) end) end
    
    return {c = c, set = function(v) on = v update(false) end, get = function() return on end}
end

local function toggle()
    local v = not menu.Visible
    if v then menu.Size, menu.BackgroundTransparency, menu.Visible = ud2(0,280,0,330), 1, true end
    local t = ts:Create(menu, TweenInfo.new(v and .2 or .15), {Size = v and ud2(0,300,0,350) or ud2(0,280,0,330), BackgroundTransparency = v and .2 or 1})
    t:Play() if not v then t.Completed:Wait() menu.Visible = false end
end

local function drag(o, id)
    local d, dS, sP, mv, iT = false, nil, nil, false, {Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch}
    o.InputBegan:Connect(function(i) 
        if table.find(iT, i.UserInputType) then 
            d, mv, dS, sP = true, false, i.Position, o.Position
            if id == "Btn" then ts:Create(o, TweenInfo.new(0.1), {Size = ud2(0,70,0,22)}):Play() end
        end 
    end)
    o.InputChanged:Connect(function(i) if d and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local dl = i.Position - dS;
        if dl.Magnitude > 7 then mv = true end
        local np = ud2(sP.X.Scale, sP.X.Offset + dl.X, sP.Y.Scale, sP.Y.Offset + dl.Y)
        o.Position = np
        Config.Positions[id] = {np.X.Scale, np.X.Offset, np.Y.Scale, np.Y.Offset}
    end end)
    uis.InputEnded:Connect(function(i) if table.find(iT, i.UserInputType) and d then 
        d = false 
        if id == "Btn" then ts:Create(o, TweenInfo.new(0.1), {Size = ud2(0,75,0,25)}):Play() end
        if id == "Btn" and not mv then toggle() end
        saveConfig()
    end end)
end
drag(btn, "Btn");
drag(menu, "Menu")

mk("TextLabel", mP, {Size = ud2(1,0,0,30), BackgroundTransparency = 1, Text = "  Devour", TextColor3 = c3(255,255,255), Font = f_gb, TextSize = 13, TextXAlignment = "Left", LayoutOrder = 1, ZIndex = 8})

local devourEnabled = false
local stealDevourEnabled = false
local cloneDevourEnabled = false
local cloneDevourTriggered = false
local devourSetter = nil

local function CleanAcc(char)
    for _, v in pairs(char:GetChildren()) do
        if v:IsA("Accessory") then v:Destroy() end
    end
end

local function MonitorPlayer(p)
    p.CharacterAdded:Connect(function(char)
        char:WaitForChild("Humanoid")
        CleanAcc(char)
        char.ChildAdded:Connect(function(child)
            if child:IsA("Accessory") then task.defer(function() child:Destroy() end) end
        end)
    end)
    if p.Character then CleanAcc(p.Character) end
end

for _, p in pairs(players:GetPlayers()) do MonitorPlayer(p) end
players.PlayerAdded:Connect(MonitorPlayer)

task.spawn(function()
    while true do
        task.wait(0.05)
        if (devourEnabled or cloneDevourTriggered) and lp.Character then
            local h = lp.Character:FindFirstChildOfClass("Humanoid")
            local b = lp.Backpack:FindFirstChild("Bat") or lp.Character:FindFirstChild("Bat")
            if b and h then
                h:EquipTool(b)
                task.wait(0.05)
                h:UnequipTools()
            end
        end
    end
end)

local function checkCloneTool(tool)
    if tool:IsA("Tool") and tool.Name:lower():find("clone") then
        tool.Activated:Connect(function()
            if cloneDevourEnabled then
                task.spawn(function()
                    task.wait(1)
                    if cloneDevourEnabled then
                        cloneDevourTriggered = true
                    end
                end)
            end
        end)
    end
end

local function hookPlayerTools()
    local function monitorContainer(container)
        for _, item in pairs(container:GetChildren()) do
            checkCloneTool(item)
        end
        container.ChildAdded:Connect(checkCloneTool)
    end

    if lp.Character then monitorContainer(lp.Character) end
    if lp:FindFirstChild("Backpack") then monitorContainer(lp.Backpack) end

    lp.CharacterAdded:Connect(function(char)
        monitorContainer(char)
        local bp = lp:WaitForChild("Backpack", 5)
        if bp then monitorContainer(bp) end
    end)
end
hookPlayerTools()

local devG = nil

local function cDEVOUR()
    if devG then return end
    local g = mk("ScreenGui", lp:WaitForChild("PlayerGui"), {Name = "Px_Devour_UI", IgnoreGuiInset = true, ResetOnSpawn = false})
    devG = g
    local f = mk("Frame", g, {BackgroundColor3 = c3(15,40,25), BackgroundTransparency = 0.2, Size = ud2(0,230,0,175), Position = getPos("Devour", ud2(1,-250,0.5,-20)), BorderSizePixel = 0, ClipsDescendants = true})
    mk("UICorner", f, {CornerRadius = ud(0,12)})
    local mS = mk("UIStroke", f, {Thickness = 2, Color = c3(255,255,255), ApplyStrokeMode = "Border"})
    local mG = mk("UIGradient", mS, {Color = ColorSequence.new(c3(54,152,118), c3(113,255,158))})
    run.RenderStepped:Connect(function(dt) if mG.Parent then mG.Rotation = (mG.Rotation + 120 * dt) % 360 end end)

    local tb = mk("Frame", f, {Size = ud2(1,0,0,40), BackgroundColor3 = c3(20,80,60), BorderSizePixel = 0})
    mk("UIGradient", tb, {Color = mG.Color, Rotation = 45})
    mk("UICorner", tb, {CornerRadius = ud(0,12)})
    mk("TextLabel", tb, {Size = ud2(1,-40,1,0), Position = ud2(0,12,0,0), BackgroundTransparency = 1, Text = "Px Devour", TextColor3 = c3(255,255,255), Font = f_gb, TextSize = 13, TextXAlignment = "Left"})
    local tB = mk("TextButton", tb, {Size = ud2(0,24,0,24), Position = ud2(1,-32,0,8), Text = "－", BackgroundColor3 = c3(30,60,45), TextColor3 = c3(255,255,255), Font = f_gb, TextSize = 13})
    mk("UICorner", tB, {CornerRadius = ud(0,6)})

    local iF = mk("Frame", f, {Position = ud2(0,0,0,40), Size = ud2(1,0,1,-40), BackgroundTransparency = 1})

    local function cTg(name, yPos)
        local container = mk("Frame", iF, {Size = ud2(1,0,0,40), Position = ud2(0,0,0,yPos), BackgroundTransparency = 1})
        local lab = mk("TextLabel", container, {Size = ud2(0,130,1,0), Position = ud2(0,15,0,0), BackgroundTransparency = 1, Text = name, TextColor3 = c3(255,255,255), Font = f_gb, TextSize = 15, TextXAlignment = "Left"})
        
        if name == "Devour" then mk("TextLabel", lab, {Size = ud2(0,20,1,0), Position = ud2(0, lab.TextBounds.X + 5, 0, 0), BackgroundTransparency = 1, Text = "(G)", TextColor3 = c3(180,180,180), Font = f_gb, TextSize = 15, TextXAlignment = "Left"}) end
        
        local s = mk("TextButton", container, {Size = ud2(0,45,0,22), Position = ud2(1,-60,0.5,-11), BackgroundColor3 = c3(40,40,40), BackgroundTransparency = 0.3, Text = ""})
        mk("UICorner", s, {CornerRadius = ud(1,0)})
        local k = mk("Frame", s, {Size = ud2(0,18,0,18), Position = ud2(0,2,0.5,-9), BackgroundColor3 = c3(200,200,200)})
        mk("UICorner", k, {CornerRadius = ud(1,0)})

        local st = false
        if Config.Toggles["Devour_"..name] ~= nil then st = Config.Toggles["Devour_"..name] end

        local function upd(isInit)
            if name == "Devour" then 
                devourEnabled = st
            elseif name == "Steal Devour" then
                stealDevourEnabled = st
            elseif name == "Clone Devour" then
                cloneDevourEnabled = st
                if not st then cloneDevourTriggered = false end
            end

            ts:Create(k, TweenInfo.new(.2), {Position = st and ud2(1,-20,.5,-9) or ud2(0,2,.5,-9), BackgroundColor3 = st and c3(113,255,158) or c3(200,200,200)}):Play()
            ts:Create(s, TweenInfo.new(.2), {BackgroundColor3 = st and c3(30,100,60) or c3(40,40,40)}):Play()
            if not isInit then Config.Toggles["Devour_"..name] = st saveConfig() end
        end

        s.MouseButton1Click:Connect(function() st = not st upd(false) end)
        if st then task.spawn(function() upd(true) end) end
        
        if name == "Devour" then devourSetter = {set = function(v) st = v upd(false) end, get = function() return st end} end
    end

    cTg("Steal Devour", 5)
    cTg("Clone Devour", 45)
    cTg("Devour", 85)

    local op = true
    tB.MouseButton1Click:Connect(function() op = not op tB.Text = op and "－" or "＋" ts:Create(f, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = op and ud2(0,230,0,175) or ud2(0,230,0,40)}):Play() iF.Visible = op end)
    local dr, ds, sp;
    f.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dr, ds, sp = true, i.Position, f.Position end end)
    uis.InputChanged:Connect(function(i) if dr and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local dl = i.Position - ds local np = ud2(sp.X.Scale, sp.X.Offset+dl.X, sp.Y.Scale, sp.Y.Offset+dl.Y) f.Position = np Config.Positions["Devour"] = {np.X.Scale, np.X.Offset, np.Y.Scale, np.Y.Offset} end end)
    uis.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dr = false saveConfig() end end)
end

local devFrame = mk("Frame", mP, {Size = ud2(1,-10,0,37), BackgroundTransparency = 1, LayoutOrder = 2, ZIndex = 7})
mk("UICorner", devFrame, {CornerRadius = ud(0, 8)})
local devStrk = mk("UIStroke", devFrame, {Thickness = 2, ApplyStrokeMode = "Border", Color = c3(255, 255, 255)})
local devGrad = mk("UIGradient", devStrk, {Color = ColorSequence.new(c3(255, 255, 255), c3(113, 255, 158))})
run.RenderStepped:Connect(function(dt) if devGrad.Parent then devGrad.Rotation = (devGrad.Rotation + 120 * dt) % 360 end end)
mk("UIListLayout", devFrame, {Padding = ud(0, 2), HorizontalAlignment = "Center", SortOrder = "LayoutOrder"})

addT(devFrame, "Devour Panel", function(on) if on then cDEVOUR() else if devG then devG:Destroy() devG = nil devourSetter = nil end end end, 1)

mk("TextLabel", mP, {Size = ud2(1,0,0,30), BackgroundTransparency = 1, Text = "  Instant Steal", TextColor3 = c3(255,255,255), Font = f_gb, TextSize = 13, TextXAlignment = "Left", LayoutOrder = 3, ZIndex = 8})

local instG = nil

local function cINST()
    if instG then return end
    
    local function doDesync()
        local fflags = { S2PhysicsSenderRate = 15000, AngularVelociryLimit = 360, StreamJobNOUVolumeCap = 10000000000, GameNetDontSendRedundantDeltaPositionMillionth = 1, TimestepArbiterOmegaThou = 1073741823, MaxMissedWorldStepsRemembered = -10000000000, GameNetPVHeaderRotationalVelocityZeroCutoffExponent = -50000, PhysicsSenderMaxBandwidthBps = 20000, LargeReplicatorSerializeWrite4 = true, MaxAcceptableUpdateDelay = 1, ServerMaxBandwith = 52, InterpolationFrameRotVelocityThresholdMillionth = 5, GameNetDontSendRedundantNumTimes = 1, StreamJobNOUVolumeLengthCap = 10000000000, CheckPVLinearVelocityIntegrateVsDeltaPositionThresholdPercent = 1, TimestepArbiterHumanoidTurningVelThreshold = 1, MaxTimestepMultiplierAcceleration = 10000000000, SimOwnedNOUCountThresholdMillionth = 10000000000, SimExplicitlyCappedTimestepMultiplier = 10000000000, TimestepArbiterVelocityCriteriaThresholdTwoDt = 10000000000, CheckPVCachedVelThresholdPercent = 10, ReplicationFocusNouExtentsSizeCutoffForPauseStuds = 10000000000, InterpolationFramePositionThresholdMillionth = 5, DebugSendDistInSteps = -10000000000, LargeReplicatorEnabled9 = true, CheckPVDifferencesForInterpolationMinRotVelThresholdRadsPerSecHundredth = 1, LargeReplicatorWrite5 = true, NextGenReplicatorEnabledWrite4 = true, MaxTimestepMultiplierContstraint = 10000000000, MaxTimestepMultiplierBuoyancy = 10000000000, MaxDataPacketPerSend = 10000000000, LargeReplicatorRead5 = true, CheckPVDifferencesForInterpolationMinVelThresholdStudsPerSecHundredth = 1, TimestepArbiterHumanoidLinearVelThreshold = 1, WorldStepMax = 30, InterpolationFrameVelocityThresholdMillionth = 5, LargeReplicatorSerializeRead3 = true, GameNetPVHeaderLinearVelocityZeroCutoffExponent = -5000, CheckPVCachedRotVelThresholdPercent = 10 }
        local function respawn(plr)
            local char = plr.Character;
            if not char then return end
            local hum = char:FindFirstChildWhichIsA('Humanoid')
            if hum then hum:ChangeState(Enum.HumanoidStateType.Dead) end
            char:ClearAllChildren()
            local newChar = Instance.new('Model', workspace)
            plr.Character = newChar;
            task.wait()
            plr.Character = char;
            newChar:Destroy()
        end
        for name, value in pairs(fflags) do pcall(function() setfflag(tostring(name), tostring(value)) end) end
        respawn(lp)
    end
    
    doDesync()

    local TPdelay, stealing, UsePotion, AutoAP = 0.2, false, false, false
    local LEFT_WAYPOINTS = {Vector3.new(-352.4, -6, 114.8), Vector3.new(-353.4, -6, 7.2), Vector3.new(-334.6, -4.79, 21)}
    local RIGHT_WAYPOINTS = {Vector3.new(-353.4, -6, 7.2), Vector3.new(-352.4, -6, 114.8), Vector3.new(-334.6, -4.79, 101.1)}
    local LEFT_SEMI_POS, RIGHT_SEMI_POS = Vector3.new(-353.2, -6.5, 40), Vector3.new(-353.2, -6.5, 80)
    local promptInfo, ProgressBarFill = {}, nil

    local function getChar() return lp.Character or lp.CharacterAdded:Wait() end
    local function getHrp() return getChar():WaitForChild("HumanoidRootPart") end
    local function equipTool(n)
        local t = lp.Backpack:FindFirstChild(n) or getChar():FindFirstChild(n)
        if t then getChar():FindFirstChildOfClass("Humanoid"):EquipTool(t) return t end
    end
    local function fastTP(pos) local h = getHrp() if h then h.CFrame = CFrame.new(pos) h.AssemblyLinearVelocity, h.AssemblyAngularVelocity = Vector3.new(), Vector3.new() end end
  
    local function carpetTP(way)
        local char = getChar()
        equipTool("Carpet")
        local path = (way == "LEFT") and LEFT_WAYPOINTS or RIGHT_WAYPOINTS
        local semi = (way == "LEFT") and LEFT_SEMI_POS or RIGHT_SEMI_POS
        for i=1, #path do if getChar() ~= char then break end fastTP(path[i]) task.wait(TPdelay) end
        task.wait(0.2) fastTP(semi)
    end

    local function buildCallbacks(p)
        if promptInfo[p] then return end
        local data = {hold = {}, trigger = {}, ready = true}
        local ok1, c1 = pcall(getconnections, p.PromptButtonHoldBegan)
        if ok1 then for _,c in ipairs(c1) do table.insert(data.hold, c.Function) end end
        local ok2, c2 = pcall(getconnections, p.Triggered)
        if ok2 then for _,c in ipairs(c2) do table.insert(data.trigger, c.Function) end end
        promptInfo[p] = data
    end

    local function execSteal(p, way)
        local data = promptInfo[p]
        if not data or not data.ready or stealing then return end
        data.ready, stealing = false, true
        task.spawn(function()
            for _,f in ipairs(data.hold) do task.spawn(f) end
            local start = tick()
            while tick() - start < 0.3 do
                if ProgressBarFill then ProgressBarFill.Size = ud2(math.clamp((tick()-start)/0.3, 0, 1), 0, 1, 0) end
                task.wait()
            end
            if ProgressBarFill then ProgressBarFill.Size = ud2(1,0,1,0) end
            carpetTP(way)
            for _,f in ipairs(data.trigger) do task.spawn(f) end
            
            if stealDevourEnabled then
                if devourSetter then
                    devourSetter.set(true)
                end
            end

            if UsePotion then
                task.spawn(function() local g = equipTool("Giant") if g then g:Activate() g.Parent = lp.Backpack end end)
                equipTool("Carpet")
            end
            if AutoAP then
                task.spawn(function()
                    local target = nil
                    for _,o in pairs(players:GetPlayers()) do if o ~= lp and o.Character and o.Character:FindFirstChild("HumanoidRootPart") then
                        if not target or (getHrp().Position - o.Character.HumanoidRootPart.Position).Magnitude < (getHrp().Position - target.HumanoidRootPart.Position).Magnitude then target = o.Character end
                    end end
                    if target and game:GetService("TextChatService").ChatVersion == Enum.ChatVersion.TextChatService then
                        local ch = game:GetService("TextChatService").TextChannels:WaitForChild("RBXGeneral")
                        for _,cmd in {";jumpscare ", ";morph ", "tiny ", ";inverse ", ";nightvision ", ";rocket ", ";balloon ", ";ragdoll ", ";jail "} do pcall(function() ch:SendAsync(cmd..target.Name) end) task.wait(0.1) end
                    end
                end)
            end
            task.wait(0.2) if ProgressBarFill then ProgressBarFill.Size = ud2(0,0,1,0) end
            data.ready, stealing = true, false
        end)
    end

    local g = mk("ScreenGui", lp:WaitForChild("PlayerGui"), {Name="Px_InstantSteal_V1_2", IgnoreGuiInset=true, ResetOnSpawn=false});
    instG = g
    local f = mk("Frame", g, {Size=ud2(0,200,0,215), Position=getPos("InstSteal", ud2(1, -210, 0.5, -240)), BackgroundColor3=c3(15,40,25), BackgroundTransparency=0.2, ClipsDescendants=true})
    mk("UICorner", f, {CornerRadius=ud(0,12)})
    local s = mk("UIStroke", f, {Thickness=2, Color=c3(255,255,255), ApplyStrokeMode="Border"})
    local gr = mk("UIGradient", s, {Color = ColorSequence.new(c3(54,152,118), c3(113,255,158))})
    run.RenderStepped:Connect(function(dt) if gr.Parent then gr.Rotation = (gr.Rotation+120*dt)%360 end end)
    
    local tb = mk("Frame", f, {Size=ud2(1,0,0,40), BackgroundColor3=c3(20,80,60)})
    mk("UIGradient", tb, {Color=gr.Color, Rotation=45});
    mk("UICorner", tb, {CornerRadius=ud(0,12)})
    mk("TextLabel", tb, {Size=ud2(1,-40,1,0), Position=ud2(0,12,0,0), Text="Instant Steal V1.2", TextColor3=c3(255,255,255), Font=f_gb, TextSize=13, BackgroundTransparency=1, TextXAlignment="Left"})
    local cls = mk("TextButton", tb, {Size=ud2(0,24,0,24), Position=ud2(1,-32,0,8), Text="－", BackgroundColor3=c3(30,60,45), TextColor3=c3(255,255,255), Font=f_gb, TextSize = 13})
    mk("UICorner", cls, {CornerRadius = ud(0,6)})
    
    local inf = mk("Frame", f, {Position=ud2(0,0,0,40), Size=ud2(1,0,1,-40), BackgroundTransparency=1})
    local function addTg(n, y, cb)
        local c = mk("Frame", inf, {Size=ud2(1,0,0,35), Position=ud2(0,0,0,y), BackgroundTransparency=1})
        mk("TextLabel", c, {Size=ud2(0,110,1,0), Position=ud2(0,15,0,0), Text=n, TextColor3=c3(255,255,255), Font=f_gb, TextSize=15, BackgroundTransparency=1, TextXAlignment="Left"})
        local b = mk("TextButton", c, {Size=ud2(0,40,0,20), Position=ud2(1,-55,0.5,-10), BackgroundColor3=c3(40,40,40), BackgroundTransparency=0.3, Text=""})
        mk("UICorner", b, {CornerRadius=ud(1,0)})
        local k = mk("Frame", b, {Size=ud2(0,16,0,16), Position=ud2(0,2,0.5,-8), BackgroundColor3=c3(200,200,200)})
        mk("UICorner", k, {CornerRadius=ud(1,0)})
        
        local st = false
        if Config.Toggles["InstSteal_"..n] ~= nil then st = Config.Toggles["InstSteal_"..n] end
        local function upd(isInit)
            ts:Create(k, TweenInfo.new(0.2), {Position=st and ud2(1,-18,0.5,-8) or ud2(0,2,0.5,-8), BackgroundColor3=st and c3(113,255,158) or c3(200,200,200)}):Play()
            ts:Create(b, TweenInfo.new(0.2), {BackgroundColor3=st and c3(30,100,60) or c3(40,40,40)}):Play()
            cb(st)
            if not isInit then Config.Toggles["InstSteal_"..n] = st saveConfig() end
        end
        b.MouseButton1Click:Connect(function() st = not st upd(false) end)
        if st then task.spawn(function() upd(true) end) end
    end
    addTg("Giant Potion", 5, function(s) UsePotion = s end)
    addTg("Auto AP", 40, function(s) AutoAP = s end)

    local function addBtn(t, y, way)
        local b = mk("TextButton", inf, {Position=ud2(0.1,0,0,y), Size=ud2(0.8,0,0,32), BackgroundColor3=c3(30,80,50), Text=t, TextColor3=c3(255,255,255), Font=f_gb, TextSize = 13})
        mk("UICorner", b, {CornerRadius=ud(0,8)});
        mk("UIStroke", b, {Thickness=2, Color=c3(113, 255, 158), ApplyStrokeMode="Border"})
        b.MouseButton1Click:Connect(function()
            local found, dist = nil, math.huge
            local targetPos = (way == "LEFT") and LEFT_SEMI_POS or RIGHT_SEMI_POS
            for _,d in pairs(workspace.Plots:GetDescendants()) do
                if d:IsA("ProximityPrompt") and d.Enabled and d.ActionText == "Steal" then
                    local pDist = (d.Parent.Parent.Position - targetPos).Magnitude
                    if pDist < dist then found, dist = d, pDist end
                end
            end
            if found then buildCallbacks(found) execSteal(found, way) end
        end)
    end
    addBtn("TP Left", 80, "LEFT");
    addBtn("TP Right", 118, "RIGHT")

    local pBg = mk("Frame", inf, {Position=ud2(0.1,0,0,160), Size=ud2(0.8,0,0,6), BackgroundColor3=c3(40,40,40), BorderSizePixel=0})
    mk("UICorner", pBg, {CornerRadius=ud(1,0)})
    ProgressBarFill = mk("Frame", pBg, {Size=ud2(0,0,1,0), BackgroundColor3=c3(113,255,158), BorderSizePixel=0})
    mk("UICorner", ProgressBarFill, {CornerRadius=ud(1,0)})

    local op = true
    cls.MouseButton1Click:Connect(function() op = not op cls.Text = op and "－" or "＋" ts:Create(f, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = op and ud2(0,200,0,215) or ud2(0,200,0,40)}):Play() inf.Visible = op end)
    
    local dr, ds, sp;
    f.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dr, ds, sp = true, i.Position, f.Position end end)
    uis.InputChanged:Connect(function(i) if dr and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local dl = i.Position - ds local np = ud2(sp.X.Scale, sp.X.Offset+dl.X, sp.Y.Scale, sp.Y.Offset+dl.Y) f.Position = np Config.Positions["InstSteal"] = {np.X.Scale, np.X.Offset, np.Y.Scale, np.Y.Offset} end end)
    uis.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dr = false saveConfig() end end)
end

local instFrame = mk("Frame", mP, {Size = ud2(1,-10,0,37), BackgroundTransparency = 1, LayoutOrder = 4, ZIndex = 7})
mk("UICorner", instFrame, {CornerRadius = ud(0, 8)})
local instStrk = mk("UIStroke", instFrame, {Thickness = 2, ApplyStrokeMode = "Border", Color = c3(255, 255, 255)})
local instGrad = mk("UIGradient", instStrk, {Color = ColorSequence.new(c3(255, 255, 255), c3(113, 255, 158))})
run.RenderStepped:Connect(function(dt) if instGrad.Parent then instGrad.Rotation = (instGrad.Rotation + 120 * dt) % 360 end end)
mk("UIListLayout", instFrame, {Padding = ud(0, 2), HorizontalAlignment = "Center", SortOrder = "LayoutOrder"})

addT(instFrame, "Instant Steal Panel V1.2", function(on) if on then cINST() else if instG then instG:Destroy() instG = nil end end end, 1)

mk("TextLabel", mP, {Size = ud2(1,0,0,30), BackgroundTransparency = 1, Text = "  Desync", TextColor3 = c3(255,255,255), Font = f_gb, TextSize = 13, TextXAlignment = "Left", LayoutOrder = 5, ZIndex = 8})
local desyncFrame = mk("Frame", mP, {Size = ud2(1,-10,0,74), BackgroundTransparency = 1, LayoutOrder = 6, ZIndex = 7})
mk("UICorner", desyncFrame, {CornerRadius = ud(0, 8)})
local desyncStrk = mk("UIStroke", desyncFrame, {Thickness = 2, ApplyStrokeMode = "Border", Color = c3(255, 255, 255)})
local desyncGrad = mk("UIGradient", desyncStrk, {Color = ColorSequence.new(c3(255, 255, 255), c3(113, 255, 158))})
run.RenderStepped:Connect(function(dt) if desyncGrad.Parent then desyncGrad.Rotation = (desyncGrad.Rotation + 120 * dt) % 360 end end)
mk("UIListLayout", desyncFrame, {Padding = ud(0, 2), HorizontalAlignment = "Center", SortOrder = "LayoutOrder"})

addT(desyncFrame, "Mobile Desync", function(on) end, 1)
addT(desyncFrame, "PC Desync", function(on) end, 2)

-- ════════════════════════════════════════════════════════════
-- AUTO STEAL SYSTEM (Core Module)
-- ════════════════════════════════════════════════════════════
local autoStealCoreEnabled = false
local allAnimals     = {}
local plotChannels   = {}
local lastHash       = {}
local PromptCache    = {}
local StealCache     = {}

local autoMode       = true
local selIdx         = 1
local rotIdx         = 1
local rainbowClock   = 0

local TRIGGER_DIST   = 10
local CHARGE_SPEED   = 70
local DIP_AMOUNT     = 8
local DIP_SPEED      = 100
local RUSH_SPEED     = 420
local STEAL_COOLDOWN = 0.4

local stealPct       = 0
local stealTarget    = nil
local stealPhase     = "charging"
local dipTarget      = 0
local lastStealTime  = 0
local stealFiring    = false

local function getInternalTable()
    local Packages = game:GetService("ReplicatedStorage"):FindFirstChild("Packages"); if not Packages then return nil end
    local SynMod   = Packages:FindFirstChild("Synchronizer");      if not SynMod   then return nil end
    local ok, syn  = pcall(require, SynMod);                       if not ok or not syn then return nil end
    local Get      = syn.Get;                                       if type(Get)~="function" then return nil end
    for i=1,5 do
        local s,u=pcall(getupvalue,Get,i)
        if s and type(u)=="table" then
            if u.___private or u.___channels or u.___data then return u end
            for k,v in pairs(u) do
                if type(k)=="string" and k:match("^Plot_") or type(v)=="table" then return u end
            end
        end
    end
    local s,e=pcall(getfenv,Get); if s and e and e.self then return e.self end
    return nil
end

local SyncInt={_cache={},_data=nil}
task.spawn(function()
    for i=1,10 do SyncInt._data=getInternalTable(); if SyncInt._data then break end; task.wait(1) end
end)

local function stealthGet(n)
    if not n or type(n)~="string" then return nil end
    if SyncInt._cache[n]==false then return nil end
    if SyncInt._data then
        for _,k in ipairs({n,"Plot_"..n,"Plot"..n,n.."_Channel","Channel_"..n}) do
            if SyncInt._data[k] then SyncInt._cache[n]=SyncInt._data[k]; return SyncInt._data[k] end
        end
        for k,v in pairs(SyncInt._data) do
            if type(k)=="string" and (k==n or k:find(n,1,true)) and type(v)=="table" then
                SyncInt._cache[n]=v; return v
            end
        end
    end
    SyncInt._cache[n]=false; return nil
end

local function sProp(ch,p)
    if not ch or type(ch)~="table" then return nil end
    if ch[p] then return ch[p] end
    if type(ch.Get)=="function" then local ok,r=pcall(ch.Get,ch,p); if ok then return r end end
    local alts={Owner={"owner","Owner","plotOwner","PlotOwner"},AnimalList={"animalList","AnimalList","animals","Animals","pets"}}
    if alts[p] then for _,a in ipairs(alts[p]) do if ch[a] then return ch[a] end end end
    return nil
end

local Datas=game:GetService("ReplicatedStorage"):WaitForChild("Datas")
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local Utils=game:GetService("ReplicatedStorage"):WaitForChild("Utils")

local AnimalsData,AnimalsShared,NumberUtils
task.spawn(function()
    for i=1,10 do
        local s1,d=pcall(require,Datas:WaitForChild("Animals"))
        local s2,sh=pcall(require,Shared:WaitForChild("Animals"))
        local s3,nu=pcall(require,Utils:WaitForChild("NumberUtils"))
        if s1 and d  then AnimalsData=d   end
        if s2 and sh then AnimalsShared=sh end
        if s3 and nu then NumberUtils=nu  end
        if AnimalsData and AnimalsShared and NumberUtils then break end
        task.wait(0.5)
    end
end)

local function isMyBase(ad)
    if not ad or not ad.plot then return false end
    local plots=workspace:FindFirstChild("Plots"); if not plots then return false end
    local plot=plots:FindFirstChild(ad.plot);      if not plot  then return false end
    local ch=stealthGet(plot.Name)
    if ch then
        local o=sProp(ch,"Owner")
        if o then
            if typeof(o)=="Instance" and o:IsA("Player") then return o.UserId==lp.UserId end
            if type(o)=="table" and o.UserId             then return o.UserId==lp.UserId end
            if typeof(o)=="Instance"                     then return o==lp              end
        end
    end
    local sign=plot:FindFirstChild("PlotSign")
    if sign then local yb=sign:FindFirstChild("YourBase"); if yb and yb:IsA("BillboardGui") then return yb.Enabled end end
    return false
end

local function findPetModel(ad)
    if not ad then return nil end
    local plots=workspace:FindFirstChild("Plots"); if not plots then return nil end
    local plot=plots:FindFirstChild(ad.plot);      if not plot  then return nil end
    local pods=plot:FindFirstChild("AnimalPodiums");if not pods then return nil end
    local pod=pods:FindFirstChild(ad.slot);        if not pod   then return nil end
    local base=pod:FindFirstChild("Base")
    if base then
        local spwn=base:FindFirstChild("Spawn")
        if spwn then
            for _,c in ipairs(spwn:GetChildren()) do
                if c:IsA("Model") or c:IsA("BasePart") then return c end
            end
        end
    end
    local function deepFind(parent)
        for _,c in ipairs(parent:GetChildren()) do
            if c:IsA("Model") or (c:IsA("BasePart") and c.Name~="Base") then return c end
            local r=deepFind(c); if r then return r end
        end
        return nil
    end
    return deepFind(pod)
end

local function getPetPosition(ad)
    local model=findPetModel(ad); if not model then return nil end
    if model:IsA("Model") then
        if model.PrimaryPart then return model.PrimaryPart.Position end
        local ok,cf=pcall(function() return model:GetBoundingBox() end)
        if ok and cf then return cf.Position end
        local part=model:FindFirstChildWhichIsA("BasePart")
        if part then return part.Position end
    elseif model:IsA("BasePart") then
        return model.Position
    end
    return nil
end

local function getPlayerPos()
    local char=lp.Character; if not char then return nil end
    local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return nil end
    return hrp.Position
end

local function distToTarget(ad)
    local petPos=getPetPosition(ad); if not petPos then return math.huge end
    local plrPos=getPlayerPos();     if not plrPos then return math.huge end
    return (petPos-plrPos).Magnitude
end

local function findPrompt(ad)
    if not ad then return nil end
    local c=PromptCache[ad.uid]; if c and c.Parent then return c end
    local plots=workspace:FindFirstChild("Plots"); if not plots then return nil end
    local plot=plots:FindFirstChild(ad.plot);      if not plot  then return nil end
    local pods=plot:FindFirstChild("AnimalPodiums");if not pods then return nil end
    local pod=pods:FindFirstChild(ad.slot);        if not pod   then return nil end
    local base=pod:FindFirstChild("Base");          if not base  then return nil end
    local spwn=base:FindFirstChild("Spawn");        if not spwn  then return nil end
    local att=spwn:FindFirstChild("PromptAttachment");if not att then return nil end
    for _,p in ipairs(att:GetChildren()) do
        if p:IsA("ProximityPrompt") then PromptCache[ad.uid]=p; return p end
    end
    return nil
end

local function buildCallbacks(prompt)
    if StealCache[prompt] then return end
    local data={hold={},trig={},ready=true}
    local ok1,c1=pcall(getconnections,prompt.PromptButtonHoldBegan)
    if ok1 and type(c1)=="table" then
        for _,c in ipairs(c1) do if type(c.Function)=="function" then table.insert(data.hold,c.Function) end end
    end
    local ok2,c2=pcall(getconnections,prompt.Triggered)
    if ok2 and type(c2)=="table" then
        for _,c in ipairs(c2) do if type(c.Function)=="function" then table.insert(data.trig,c.Function) end end
    end
    if #data.hold>0 or #data.trig>0 then StealCache[prompt]=data end
end

local function runList(list) for _,fn in ipairs(list) do task.spawn(fn) end end

local function fireSteal(prompt)
    local data=StealCache[prompt]; if not data then return end
    if #data.hold>0 then runList(data.hold) end
    task.wait(0.05)
    if #data.trig>0 then runList(data.trig) end
end

local function getHash(al)
    if not al then return "" end
    local h=""
    for s,d in pairs(al) do if type(d)=="table" then h=h..tostring(s)..tostring(d.Index)..tostring(d.Mutation) end end
    return h
end

local function scanPlot(plot)
    pcall(function()
        local uid=plot.Name
        local ch=stealthGet(uid); if not ch then return end
        local al=sProp(ch,"AnimalList")
        local hash=getHash(al)
        if lastHash[uid]==hash then return end
        lastHash[uid]=hash
        for i=#allAnimals,1,-1 do if allAnimals[i].plot==uid then table.remove(allAnimals,i) end end
        local owner=sProp(ch,"Owner")
        if not owner or not players:FindFirstChild(owner.Name) then return end
        if owner.UserId == lp.UserId then return end
        if not al then return end
        for slot,ad in pairs(al) do
            if type(ad)=="table" then
                local nm=ad.Index
                local info=AnimalsData and AnimalsData[nm]; if not info then continue end
                local gen=AnimalsShared and AnimalsShared:GetGeneration(nm,ad.Mutation,ad.Traits,nil) or 0
                local genT="$"..(NumberUtils and NumberUtils:ToString(gen) or tostring(gen)).."/s"
                table.insert(allAnimals,{
                    name=info.DisplayName or nm,genText=genT,genValue=gen,
                    mutation=ad.Mutation or "None",
                    owner=owner.Name or "?",
                    plot=uid,slot=tostring(slot),uid=uid.."_"..tostring(slot),
                })
            end
        end
        table.sort(allAnimals,function(a,b) return a.genValue>b.genValue end)
    end)
end

local function setupPlot(plot)
    if plotChannels[plot.Name] then return end
    local ch; for i=1,3 do ch=stealthGet(plot.Name); if ch then break end; task.wait(0.3) end
    if not ch then return end
    plotChannels[plot.Name]=true; scanPlot(plot)
    plot.DescendantAdded:Connect(function() task.wait(0.05); scanPlot(plot) end)
    plot.DescendantRemoving:Connect(function() task.wait(0.05); scanPlot(plot) end)
    task.spawn(function() while plot.Parent and plotChannels[plot.Name] do task.wait(1); scanPlot(plot) end end)
end

local function initScanner()
    local plots=workspace:FindFirstChild("Plots")
    if not plots then
        for i=1,120 do plots=workspace:FindFirstChild("Plots"); if plots then break end; task.wait(1) end
        if not plots then return end
    end
    for _,p in ipairs(plots:GetChildren()) do task.spawn(setupPlot,p) end
    plots.ChildAdded:Connect(function(p) task.wait(0.2); task.spawn(setupPlot,p) end)
    plots.ChildRemoved:Connect(function(p)
        plotChannels[p.Name]=nil; lastHash[p.Name]=nil
        for i=#allAnimals,1,-1 do if allAnimals[i].plot==p.Name then table.remove(allAnimals,i) end end
    end)
end

local function getTargetAnimal()
    if not autoStealCoreEnabled then return nil end
    if autoMode then
        if #allAnimals==0 then return nil end
        local best,bestDist=nil,math.huge
        for _,pet in ipairs(allAnimals) do if not isMyBase(pet) then local d=distToTarget(pet); if d<bestDist then bestDist=d; best=pet end end end
        return best
    else
        local pet=allAnimals[selIdx]; if pet and not isMyBase(pet) then return pet end; return nil
    end
end

run.Heartbeat:Connect(function(dt)
    if not autoStealCoreEnabled then if stealPhase~="idle" then stealPct=0; stealTarget=nil; stealPhase="idle"; dipTarget=0; stealFiring=false end; return end
    if stealFiring then return end
    local target=getTargetAnimal()
    if target~=stealTarget then
        stealTarget=target
        if not target then if stealPhase=="dipping" or stealPhase=="rushing" then stealPct=90; stealPhase="holding" elseif stealPhase=="idle" then stealPhase="charging" end
        else if stealPhase=="idle" then stealPhase="charging" elseif stealPhase=="holding" or stealPhase=="dipping" or stealPhase=="rushing" then stealPct=90; stealPhase="holding"; dipTarget=0 end end
    end
    if not stealTarget then return end
    local dist=distToTarget(stealTarget)
    if stealPhase=="charging" then
        stealPct=stealPct+CHARGE_SPEED*dt; if stealPct>=95 then stealPct=95; stealPhase="holding" end
    elseif stealPhase=="holding" then
        stealPct=95; if dist<=TRIGGER_DIST then dipTarget=95-DIP_AMOUNT-math.random(0,3); stealPhase="dipping" end
    elseif stealPhase=="dipping" then
        stealPct=stealPct+DIP_SPEED*dt; if stealPct<=dipTarget then stealPct=dipTarget; stealPhase="rushing" end
    elseif stealPhase=="rushing" then
        stealPct=stealPct+RUSH_SPEED*dt
        if stealPct>=100 then
            stealPct=100; local now=tick()
            if now-lastStealTime>=STEAL_COOLDOWN then
                lastStealTime=now; stealFiring=true; task.spawn(function()
                    local prompt=PromptCache[stealTarget and stealTarget.uid or ""] or findPrompt(stealTarget)
                    if prompt then buildCallbacks(prompt); if StealCache[prompt] and StealCache[prompt].ready then fireSteal(prompt) end end
                    task.wait(0.25); stealPct=95; stealPhase="holding"; dipTarget=0; stealFiring=false;
                end)
            else stealPct=95; stealPhase="holding"; dipTarget=0 end
            return
        end
    end
end)

task.spawn(function()
    while not AnimalsData or not AnimalsShared or not NumberUtils do task.wait(0.5) end
    task.wait(1.5)
    initScanner()
    task.wait(1)
end)
-- ════════════════════════════════════════════════════════════


mk("TextLabel", mP, {Size = ud2(1,0,0,30), BackgroundTransparency = 1, Text = "  Stealing", TextColor3 = c3(255,255,255), Font = f_gb, TextSize = 13, TextXAlignment = "Left", LayoutOrder = 7, ZIndex = 8})
local sFrame = mk("Frame", mP, {Size = ud2(1,-10,0,259), BackgroundTransparency = 1, LayoutOrder = 8, ZIndex = 7})
mk("UICorner", sFrame, {CornerRadius = ud(0, 8)})
local sStrk = mk("UIStroke", sFrame, {Thickness = 2, ApplyStrokeMode = "Border", Color = c3(255, 255, 255)})
local sGrad = mk("UIGradient", sStrk, {Color = ColorSequence.new(c3(255, 255, 255), c3(113, 255, 158))})
run.RenderStepped:Connect(function(dt) if sGrad.Parent then sGrad.Rotation = (sGrad.Rotation + 120 * dt) % 360 end end)
mk("UIListLayout", sFrame, {Padding = ud(0, 2), HorizontalAlignment = "Center", SortOrder = "LayoutOrder"})

addT(sFrame, "Clone TP GUI", function(on)
    if on then
        local old = lp.PlayerGui:FindFirstChild("Clone_TP_UI") or game:GetService("CoreGui"):FindFirstChild("Clone_TP_UI")
        if old then old:Destroy() end

        local Players = game:GetService("Players")
        local TweenService = game:GetService("TweenService")
        local RunService = game:GetService("RunService")
        local player = lp

        local function equipTool(toolName)
            local char = player.Character or player.CharacterAdded:Wait()
            local hum = char:WaitForChild("Humanoid")
            local t = player.Backpack:FindFirstChild(toolName)
            if t then hum:EquipTool(t) return t
            else
                for _, v in pairs(player.Backpack:GetChildren()) do
                    if v:IsA("Tool") and v.Name:lower():find(toolName:lower()) then hum:EquipTool(v) return v end
                end
            end
        end
        local function unequipTools()
            local char = player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum:UnequipTools() end
        end
        local function fastTeleport(position)
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(position)
                hrp.AssemblyLinearVelocity, hrp.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
            end
        end

        local function startSequence(jumpPos, finalPos, jumpType)
            task.spawn(function()
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local ui = player.PlayerGui:FindFirstChild("Clone_TP_UI") or game:GetService("CoreGui"):FindFirstChild("Clone_TP_UI")
                local fill = ui and ui:FindFirstChild("ProgressBarFill", true)
                if not hrp then return end
                if fill then fill.Size = UDim2.new(1, 0, 1, 0) end
                equipTool("Carpet")
                task.wait(0.12)
                fastTeleport(Vector3.new(-352.07, -6.74, 5.94))
                task.wait(0.08)
                fastTeleport(Vector3.new(-353.31, -6.80, 113.32))
                task.wait(0.2)
                if jumpType == "small" then
                    hrp.CFrame = CFrame.new(jumpPos)
                    unequipTools(); hrp.AssemblyLinearVelocity = Vector3.new(0, 45, 0); task.wait(0.18); equipTool("Carpet")
                elseif jumpType == "normal" then
                    hrp.CFrame = CFrame.new(jumpPos)
                    unequipTools(); hrp.AssemblyLinearVelocity = Vector3.new(0, 85, 0); task.wait(0.55); equipTool("Carpet")
                end
                task.wait(0.05); fastTeleport(finalPos); task.wait(0.1); unequipTools()
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(-75), 0); task.wait(0.05)
                local cl = equipTool("Clone")
                if cl then task.wait(0.15); cl:Activate() end
                
                if fill then TweenService:Create(fill, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 1, 0)}):Play() end
            end)
        end

        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "Clone_TP_UI"
        pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
        if not ScreenGui.Parent then ScreenGui.Parent = player:WaitForChild("PlayerGui") end
        ScreenGui.ResetOnSpawn = false
        ScreenGui.IgnoreGuiInset = true

        local Frame = Instance.new("Frame", ScreenGui)
        Frame.BackgroundColor3 = Color3.fromRGB(15, 40, 25)
        Frame.BackgroundTransparency = 0.2
        Frame.Size = UDim2.new(0, 200, 0, 185)
        Frame.Position = getPos("CloneTP", UDim2.new(0.4, 0, 0.3, 0))
        Frame.BorderSizePixel = 0
        Frame.ClipsDescendants = true
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

        local mStroke = Instance.new("UIStroke", Frame)
        mStroke.Thickness, mStroke.Color, mStroke.ApplyStrokeMode = 2, Color3.fromRGB(255, 255, 255), Enum.ApplyStrokeMode.Border
        local mGrad = Instance.new("UIGradient", mStroke)
        mGrad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(54, 152, 118)), ColorSequenceKeypoint.new(1, Color3.fromRGB(113, 255, 158))}
        RunService.RenderStepped:Connect(function(dt) if mGrad.Parent then mGrad.Rotation = (mGrad.Rotation + 120 * dt) % 360 end end)

        local TopBar = Instance.new("Frame", Frame)
        TopBar.Size, TopBar.BackgroundColor3, TopBar.BorderSizePixel = UDim2.new(1, 0, 0, 40), Color3.fromRGB(20, 80, 60), 0
        local TopBarGrad = Instance.new("UIGradient", TopBar)
        TopBarGrad.Color, TopBarGrad.Rotation = mGrad.Color, 45
        Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

        local Title = Instance.new("TextLabel", TopBar)
        Title.Size, Title.Position, Title.BackgroundTransparency = UDim2.new(1, -40, 1, 0), UDim2.new(0, 12, 0, 0), 1
        Title.Text, Title.TextColor3, Title.Font, Title.TextSize, Title.TextXAlignment = "Clone TP", Color3.new(1,1,1), Enum.Font.GothamBold, 13, 0

        local ToggleBtn = Instance.new("TextButton", TopBar)
        ToggleBtn.Size, ToggleBtn.Position, ToggleBtn.Text = UDim2.new(0, 24, 0, 24), UDim2.new(1, -32, 0, 8), "－"
        ToggleBtn.BackgroundColor3, ToggleBtn.TextColor3 = Color3.fromRGB(30, 60, 45), Color3.new(1,1,1)
        ToggleBtn.Font, ToggleBtn.TextSize = Enum.Font.GothamBold, 13
        Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 6)

        local Inner = Instance.new("Frame", Frame)
        Inner.Position, Inner.Size, Inner.BackgroundTransparency = UDim2.new(0, 0, 0, 40), UDim2.new(1, 0, 1, -40), 1

        local ProgressBarBg = Instance.new("Frame", Inner)
        ProgressBarBg.Position, ProgressBarBg.Size, ProgressBarBg.BackgroundColor3 = UDim2.new(0.1, 0, 0, 138), UDim2.new(0.8, 0, 0, 4), Color3.fromRGB(30, 30, 30)
        Instance.new("UICorner", ProgressBarBg)
        local ProgressBarFill = Instance.new("Frame", ProgressBarBg)
        ProgressBarFill.Name = "ProgressBarFill"
        ProgressBarFill.Size, ProgressBarFill.BackgroundColor3 = UDim2.new(0, 0, 1, 0), Color3.fromRGB(113, 255, 158)
        Instance.new("UICorner", ProgressBarFill)

        local function createBtn(text, yPos, callback)
            local btn = Instance.new("TextButton", Inner)
            btn.Position, btn.Size, btn.BackgroundColor3 = UDim2.new(0.1, 0, 0, yPos), UDim2.new(0.8, 0, 0, 35), Color3.fromRGB(30, 80, 50)
            btn.Text, btn.TextColor3, btn.Font, btn.TextSize = text, Color3.new(1,1,1), Enum.Font.GothamBold, 13
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
            local strk = Instance.new("UIStroke", btn)
            strk.Thickness, strk.Color, strk.ApplyStrokeMode = 2, Color3.fromRGB(113, 255, 158), Enum.ApplyStrokeMode.Border
            btn.MouseButton1Click:Connect(callback)
        end

        createBtn("1", 10, function() startSequence(Vector3.new(-354.25, -6.35, 113.58), Vector3.new(-340.71, -4.75, 113.27), "small") end)
        createBtn("2", 55, function() startSequence(Vector3.new(-353.31, 11.42, 113.32), Vector3.new(-340.29, 13.50, 113.82), "normal") end)
        createBtn("3", 100, function() startSequence(Vector3.new(-353.31, 11.42, 113.32), Vector3.new(-339.51, 30.24, 112.93), "normal") end)

        local isOpened = true
        ToggleBtn.MouseButton1Click:Connect(function()
            isOpened = not isOpened
            ToggleBtn.Text = isOpened and "－" or "＋"
            TweenService:Create(Frame, TweenInfo.new(0.3), {Size = isOpened and UDim2.new(0, 200, 0, 185) or UDim2.new(0, 200, 0, 40)}):Play()
            Inner.Visible = isOpened
        end)

        local drag, dStart, sPos
        Frame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag, dStart, sPos = true, i.Position, Frame.Position end end)
        Frame.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - dStart
            local np = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y)
            Frame.Position = np
            Config.Positions["CloneTP"] = {np.X.Scale, np.X.Offset, np.Y.Scale, np.Y.Offset}
        end end)
        Frame.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false saveConfig() end end)

    else
        local target = lp.PlayerGui:FindFirstChild("Clone_TP_UI") or game:GetService("CoreGui"):FindFirstChild("Clone_TP_UI")
        if target then target:Destroy() end
    end
end, 1)

addT(sFrame, "Auto Steal GUI", function(on) end, 2)
addT(sFrame, "Auto Steal", function(on) autoStealCoreEnabled = on end, 3)

local invisStealOn = false
addT(sFrame, "Invis Steal", function(on)
    invisStealOn = on
    if on then
        turnOnInvis()
    else
        turnOffInvis()
    end
end, 4)

addT(sFrame, "Unlock Base", function(on) end, 5)

local autoGiantOn = false
local giantConns = {}
addT(sFrame, "Auto Giant Potion", function(on)
    autoGiantOn = on
    if on then
        task.spawn(function()
            local function eT(n)
                local c = lp.Character or lp.CharacterAdded:Wait()
                local h = c:FindFirstChildOfClass("Humanoid")
                local t = lp.Backpack:FindFirstChild(n) or c:FindFirstChild(n)
                if t then h:EquipTool(t) return t end
                for _,v in pairs(lp.Backpack:GetChildren()) do
                    if v:IsA("Tool") and v.Name:lower():find(n:lower()) then h:EquipTool(v) return v end
                end
            end
            local function doGiant()
                task.spawn(function()
                    local g = eT("Giant")
                    if g then g:Activate() task.wait(0.1) g.Parent = lp.Backpack end
                    eT("Carpet")
                end)
            end
            local function monitor(p)
                if p:IsA("ProximityPrompt") and p.ActionText == "Steal" then
                    table.insert(giantConns, p.Triggered:Connect(doGiant))
                end
            end
            local pl = workspace:FindFirstChild("Plots")
            if not pl then
                for i=1, 20 do pl = workspace:FindFirstChild("Plots"); if pl then break end; task.wait(0.5) end
            end
            if pl and autoGiantOn then
                for _, d in pairs(pl:GetDescendants()) do monitor(d) end
                table.insert(giantConns, pl.DescendantAdded:Connect(monitor))
            end
        end)
    else
        for _, c in ipairs(giantConns) do c:Disconnect() end
        giantConns = {}
    end
end, 6)

local autoKickSelfEnabled = false
addT(sFrame, "Auto Kick Self", function(on)
    autoKickSelfEnabled = on
end, 7)

local TARGET_TEXT = "You stole"
local function fastCheck(obj)
    if typeof(obj.Text) == "string" and string.find(obj.Text, TARGET_TEXT, 1, true) then
        if autoKickSelfEnabled then
            lp:Kick("https://discord.gg/xxpx")
        end
        if stealDevourEnabled then
            if devourSetter then
                devourSetter.set(true)
            end
        end
    end
end

local function monitorText(obj)
    if obj:IsA("TextLabel") or obj:IsA("TextButton") then
        pcall(fastCheck, obj)
        obj:GetPropertyChangedSignal("Text"):Connect(function()
            pcall(fastCheck, obj)
        end)
    end
end

lp.PlayerGui.DescendantAdded:Connect(monitorText)
for _, v in ipairs(lp.PlayerGui:GetDescendants()) do
    task.spawn(monitorText, v)
end

mk("TextLabel", pP, {Size = ud2(1,0,0,30), BackgroundTransparency = 1, Text = "  Movement", TextColor3 = c3(255,255,255), Font = f_gb, TextSize = 13, TextXAlignment = "Left", LayoutOrder = 0, ZIndex = 8})
local mvtFrame = mk("Frame", pP, {Size = ud2(1,-10,0,148), BackgroundTransparency = 1, LayoutOrder = 1, ZIndex = 7})
mk("UICorner", mvtFrame, {CornerRadius = ud(0, 8)})
local mvtStrk = mk("UIStroke", mvtFrame, {Thickness = 2, ApplyStrokeMode = "Border", Color = c3(255, 255, 255)})
local mvtGrad = mk("UIGradient", mvtStrk, {Color = ColorSequence.new(c3(255, 255, 255), c3(113, 255, 158))})
run.RenderStepped:Connect(function(dt) if mvtGrad.Parent then mvtGrad.Rotation = (mvtGrad.Rotation + 120 * dt) % 360 end end)
mk("UIListLayout", mvtFrame, {Padding = ud(0, 2), HorizontalAlignment = "Center", SortOrder = "LayoutOrder"})

local antiRagdollMode = "off"
local ragdollConnections = {}
local cachedCharData = {}

local function cacheCharacterData()
    local char = lp.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return false end
    cachedCharData = {
        character = char,
        humanoid = hum,
        root = root,
        originalWalkSpeed = hum.WalkSpeed,
        originalJumpPower = hum.JumpPower,
        isFrozen = false
    }
    return true
end

local function isRagdolled()
    if not cachedCharData.humanoid then return false end
    local hum = cachedCharData.humanoid
    local state = hum:GetState()
    local ragdollStates = {
        [Enum.HumanoidStateType.Physics] = true,
        [Enum.HumanoidStateType.Ragdoll] = true,
        [Enum.HumanoidStateType.FallingDown] = true
    }
    if ragdollStates[state] then
        return true
    end
    local endTime = lp:GetAttribute("RagdollEndTime")
    if endTime then
        local now = workspace:GetServerTimeNow()
        if (endTime - now) > 0 then
            return true
        end
    end
    return false
end

local function removeRagdollConstraints()
    if not cachedCharData.character then return false end
    for _, descendant in ipairs(cachedCharData.character:GetDescendants()) do
        if descendant:IsA("BallSocketConstraint") or 
           (descendant:IsA("Attachment") and descendant.Name:find("RagdollAttachment")) then
            pcall(function()
                descendant:Destroy()
            end)
        end
    end
end

local function forceExitRagdoll()
    if not cachedCharData.humanoid or not cachedCharData.root then return end
    local hum = cachedCharData.humanoid
    local root = cachedCharData.root
    pcall(function()
        lp:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
    end)
    if hum.Health > 0 then
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end
    root.Anchored = false
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
end

local antiRagdollCamConn = nil
local function setupCameraBinding()
    if antiRagdollCamConn then antiRagdollCamConn:Disconnect() antiRagdollCamConn = nil end
    if not cachedCharData.humanoid then return end
    antiRagdollCamConn = run.RenderStepped:Connect(function()
        if antiRagdollMode ~= "v1" then return end
        local cam = workspace.CurrentCamera
        if cam and cachedCharData.humanoid and cachedCharData.humanoid.Health > 0 and cam.CameraSubject ~= cachedCharData.humanoid then
            cam.CameraSubject = cachedCharData.humanoid
        end
    end)
end

local v1LoopRunning = false
local function v1HeartbeatLoop()
    if v1LoopRunning then return end
    v1LoopRunning = true
    while antiRagdollMode == "v1" do
        task.wait()
        if cachedCharData.humanoid and isRagdolled() then
            removeRagdollConstraints()
            forceExitRagdoll()
        end
    end
    v1LoopRunning = false
end

local function onCharacterAddedRagdoll(char)
    task.wait(0.5) 
    if cacheCharacterData() then
        setupCameraBinding()
        task.spawn(v1HeartbeatLoop)
    end
end

addT(mvtFrame, "Anti Ragdoll", function(on)
    if on then
        antiRagdollMode = "v1"
        for _, conn in ipairs(ragdollConnections) do
            pcall(function() conn:Disconnect() end)
        end
        ragdollConnections = {}
        table.insert(ragdollConnections, lp.CharacterAdded:Connect(onCharacterAddedRagdoll))
        if cacheCharacterData() then
            setupCameraBinding()
            task.spawn(v1HeartbeatLoop)
        end
    else
        antiRagdollMode = "off"
        for _, conn in ipairs(ragdollConnections) do
            pcall(function() conn:Disconnect() end)
        end
        ragdollConnections = {}
        if antiRagdollCamConn then antiRagdollCamConn:Disconnect() antiRagdollCamConn = nil end
    end
end, 1)

local FOV_MANAGER = {
    activeCount = 0,
    conn = nil,
    forcedFOV = 70,
}
function FOV_MANAGER:Start()
    if self.conn then return end
    self.conn = run.RenderStepped:Connect(function()
        local cam = workspace.CurrentCamera
        if cam and cam.FieldOfView ~= self.forcedFOV then
            cam.FieldOfView = self.forcedFOV
        end
    end)
end
function FOV_MANAGER:Stop()
    if self.conn then
        self.conn:Disconnect()
        self.conn = nil
    end
end
function FOV_MANAGER:Push()
    self.activeCount = self.activeCount + 1
    self:Start()
end

local ANTI_BEE_DISCO = {}
local antiBeeDiscoRunning = false
local antiBeeDiscoConnections = {}
local originalMoveFunction = nil
local controlsProtected = false
local BAD_LIGHTING_NAMES = {
    Blue = true,
    DiscoEffect = true,
    BeeBlur = true,
    ColorCorrection = true,
}

local function antiBeeDiscoNuke(obj)
    if not obj or not obj.Parent then return end
    if BAD_LIGHTING_NAMES[obj.Name] then
        pcall(function()
            obj:Destroy()
        end)
    end
end

local function protectControls()
    if controlsProtected then return end
    pcall(function()
        local PlayerScripts = lp.PlayerScripts
        local PlayerModule = PlayerScripts:FindFirstChild("PlayerModule")
        if not PlayerModule then return end
        local Controls = require(PlayerModule):GetControls()
        if not Controls then return end
        if not originalMoveFunction then
            originalMoveFunction = Controls.moveFunction
        end
        local function protectedMoveFunction(self, moveVector, relativeToCamera)
            if originalMoveFunction then
                originalMoveFunction(self, moveVector, relativeToCamera)
            end
        end
        local controlCheckConn = run.Heartbeat:Connect(function()
            if not antiBeeDiscoRunning then return end
            if Controls.moveFunction ~= protectedMoveFunction then
                Controls.moveFunction = protectedMoveFunction
            end
        end)
        table.insert(antiBeeDiscoConnections, controlCheckConn)
        Controls.moveFunction = protectedMoveFunction
        controlsProtected = true
    end)
end

local function blockBuzzingSound()
    pcall(function()
        local PlayerScripts = lp.PlayerScripts
        local beeScript = PlayerScripts:FindFirstChild("Bee", true)
        if beeScript then
            local buzzing = beeScript:FindFirstChild("Buzzing")
            if buzzing and buzzing:IsA("Sound") then
                buzzing:Stop()
                buzzing.Volume = 0
            end
        end
    end)
end

addT(mvtFrame, "Anti Bee", function(on)
    if on then
        if antiBeeDiscoRunning then return end
        antiBeeDiscoRunning = true
        for _, inst in ipairs(game:GetService("Lighting"):GetDescendants()) do
            antiBeeDiscoNuke(inst)
        end
        table.insert(antiBeeDiscoConnections, game:GetService("Lighting").DescendantAdded:Connect(function(obj)
            if not antiBeeDiscoRunning then return end
            antiBeeDiscoNuke(obj)
        end))
        protectControls()
        table.insert(antiBeeDiscoConnections, run.Heartbeat:Connect(function()
            if not antiBeeDiscoRunning then return end
            blockBuzzingSound()
        end))
        FOV_MANAGER:Push()
    else
        antiBeeDiscoRunning = false
        FOV_MANAGER:Stop()
        for _, conn in ipairs(antiBeeDiscoConnections) do
            pcall(function() conn:Disconnect() end)
        end
        antiBeeDiscoConnections = {}
        controlsProtected = false
        pcall(function()
            local PlayerModule = lp.PlayerScripts:FindFirstChild("PlayerModule")
            if PlayerModule and originalMoveFunction then
                local Controls = require(PlayerModule):GetControls()
                if Controls then Controls.moveFunction = originalMoveFunction end
            end
        end)
    end
end, 2)

local infJumpConn
addT(mvtFrame, "Infinity Jump", function(on)
    if on then
        infJumpConn = uis.JumpRequest:Connect(function()
            local character = lp.Character
            if character then
                local hrp = character:FindFirstChild("HumanoidRootPart")
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if hrp and humanoid then
                    local jumpVelocity = 50
                    hrp.Velocity = Vector3.new(hrp.Velocity.X, jumpVelocity, hrp.Velocity.Z)
                end
            end
        end)
    else
        if infJumpConn then infJumpConn:Disconnect() infJumpConn = nil end
    end
end, 3)

local autoDestroySentryConn
addT(mvtFrame, "Auto Destroy Turret", function(on)
    if on then
        autoDestroySentryConn = run.Heartbeat:Connect(function()
            for _, v in pairs(workspace:GetChildren()) do
                if v.Name:find("Sentry_") then
                    pcall(function() v:Destroy() end)
                end
            end
        end)
    else
        if autoDestroySentryConn then autoDestroySentryConn:Disconnect() autoDestroySentryConn = nil end
    end
end, 4)

-- Optimizer Container
mk("TextLabel", vP, {Size = ud2(1,0,0,30), BackgroundTransparency = 1, Text = "  Optimizer", TextColor3 = c3(255,255,255), Font = f_gb, TextSize = 13, TextXAlignment = "Left", LayoutOrder = 1, ZIndex = 8})
local optFrame = mk("Frame", vP, {Size = ud2(1,-10,0,74), BackgroundTransparency = 1, LayoutOrder = 2, ZIndex = 7})
mk("UICorner", optFrame, {CornerRadius = ud(0, 8)})
local optStrk = mk("UIStroke", optFrame, {Thickness = 2, ApplyStrokeMode = "Border", Color = c3(255, 255, 255)})
local optGrad = mk("UIGradient", optStrk, {Color = ColorSequence.new(c3(255, 255, 255), c3(113, 255, 158))})
run.RenderStepped:Connect(function(dt) if optGrad.Parent then optGrad.Rotation = (optGrad.Rotation + 120 * dt) % 360 end end)
mk("UIListLayout", optFrame, {Padding = ud(0, 2), HorizontalAlignment = "Center", SortOrder = "LayoutOrder"})

local function removeMeshes(obj)
    for _, descendant in pairs(obj:GetDescendants()) do
        if descendant:IsA("MeshPart") or descendant:IsA("SpecialMesh") or descendant:IsA("CharacterMesh") or descendant:IsA("FileMesh") then
            descendant:Destroy()
        end
    end
end

local function onCharacterAddedFPS(character)
    character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            removeMeshes(child)
        end
    end)
    for _, item in pairs(character:GetChildren()) do
        if item:IsA("Tool") then
            removeMeshes(item)
        end
    end
end

local function isPlayerCharacter(model)
    return players:GetPlayerFromCharacter(model) ~= nil
end

local function handleAnimator(animator)
    local model = animator:FindFirstAncestorOfClass("Model")
    if model and isPlayerCharacter(model) then return end
    for _, track in pairs(animator:GetPlayingAnimationTracks()) do track:Stop(0) end
    animator.AnimationPlayed:Connect(function(track) track:Stop(0) end)
end

local function stripVisuals(obj)
    local model = obj:FindFirstAncestorOfClass("Model")
    local isPlayer = model and isPlayerCharacter(model)

    if obj:IsA("Animator") then handleAnimator(obj) end

    if obj:IsA("Accessory") or obj:IsA("Clothing") then
        if obj:FindFirstAncestorOfClass("Model") then
            pcall(function() obj:Destroy() end)
        end
    end

    if not isPlayer then
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or 
           obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") or 
           obj:IsA("Highlight") then
            obj.Enabled = false
        end
        if obj:IsA("Explosion") then
            pcall(function() obj:Destroy() end)
        end
        if obj:IsA("MeshPart") then
            obj.TextureID = ""
        end
    end

    if obj:IsA("BasePart") then
        obj.Material = Enum.Material.Plastic
        obj.Reflectance = 0
        obj.CastShadow = false
    end

    if obj:IsA("SurfaceAppearance") or obj:IsA("Texture") or obj:IsA("Decal") then
        pcall(function() obj:Destroy() end)
    end
end

local fpsBoostEnabled = false
local fpsBoostConn = nil
local fpsBoostCharConn = nil

addT(optFrame, "FPS Boost", function(on)
    if on then
        if fpsBoostEnabled then return end
        fpsBoostEnabled = true
        
        local Lighting = game:GetService("Lighting")
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1000000
        Lighting.FogStart = 0
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        Lighting.Brightness = 2
        Lighting.ClockTime = 12

        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or 
               v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("Atmosphere") then
                pcall(function() v:Destroy() end)
            end
        end

        for _, obj in pairs(workspace:GetDescendants()) do
            stripVisuals(obj)
        end

        fpsBoostConn = workspace.DescendantAdded:Connect(stripVisuals)

        for _, player in pairs(players:GetPlayers()) do
            player.CharacterAdded:Connect(onCharacterAddedFPS)
            if player.Character then onCharacterAddedFPS(player.Character) end
        end
        fpsBoostCharConn = players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(onCharacterAddedFPS)
        end)
    else
        fpsBoostEnabled = false
        if fpsBoostConn then fpsBoostConn:Disconnect() fpsBoostConn = nil end
        if fpsBoostCharConn then fpsBoostCharConn:Disconnect() fpsBoostCharConn = nil end
    end
end, 1)

addT(optFrame, "Game Stretcher", function(on)
    if on then
        local lg = lp.PlayerGui:FindFirstChild("LoadingScreen") or lp.PlayerGui:FindFirstChild("LoadingGui")
        if lg then lg.Enabled = false end
    end
end, 2)

-- Visual Container
mk("TextLabel", vP, {Size = ud2(1,0,0,30), BackgroundTransparency = 1, Text = "  Visual", TextColor3 = c3(255,255,255), Font = f_gb, TextSize = 13, TextXAlignment = "Left", LayoutOrder = 4, ZIndex = 8})
local visuFrame = mk("Frame", vP, {Size = ud2(1,-10,0,148), BackgroundTransparency = 1, LayoutOrder = 5, ZIndex = 7})
mk("UICorner", visuFrame, {CornerRadius = ud(0, 8)})
local visuStrk = mk("UIStroke", visuFrame, {Thickness = 2, ApplyStrokeMode = "Border", Color = c3(255, 255, 255)})
local visuGrad = mk("UIGradient", visuStrk, {Color = ColorSequence.new(c3(255, 255, 255), c3(113, 255, 158))})
run.RenderStepped:Connect(function(dt) if visuGrad.Parent then visuGrad.Rotation = (visuGrad.Rotation + 120 * dt) % 360 end end)
mk("UIListLayout", visuFrame, {Padding = ud(0, 2), HorizontalAlignment = "Center", SortOrder = "LayoutOrder"})

local xrayConnection
addT(visuFrame, "X-Ray", function(on)
    if on then
        if xrayConnection then
            xrayConnection:Disconnect()
            xrayConnection = nil
        end
        xrayConnection = run.Heartbeat:Connect(function()
            local Plots = workspace:FindFirstChild("Plots")
            if Plots then
                for _, Plot in ipairs(Plots:GetChildren()) do
                    if Plot:IsA("Model") and Plot:FindFirstChild("Decorations") then
                        for _, Part in ipairs(Plot.Decorations:GetDescendants()) do
                            if Part:IsA("BasePart") then
                                Part.Transparency = 0.8
                            end
                        end
                    end
                end
            end
        end)
        print("X-Ray: ON (Auto-started)")
    else
        if xrayConnection then
            xrayConnection:Disconnect()
            xrayConnection = nil
        end
    end
end, 1)

local origLighting = {}
addT(visuFrame, "Lighting Pov", function(on)
    local Lighting = game:GetService("Lighting")
    if on then
        origLighting.GlobalShadows = Lighting.GlobalShadows
        origLighting.Brightness = Lighting.Brightness
        origLighting.ExposureCompensation = Lighting.ExposureCompensation
        origLighting.FogEnd = Lighting.FogEnd
        
        Lighting.GlobalShadows = false
        Lighting.Brightness = 1
        Lighting.ExposureCompensation = -0.2
        Lighting.FogEnd = 9e9
        
        for _, v in pairs(Lighting:GetDescendants()) do
            if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") then
                v.Enabled = false
            end
        end
        for _, v in pairs(Lighting:GetDescendants()) do
            if v:IsA("ColorCorrectionEffect") then
                v:Destroy()
            end
        end
    else
        if origLighting.GlobalShadows ~= nil then
            Lighting.GlobalShadows = origLighting.GlobalShadows
            Lighting.Brightness = origLighting.Brightness
            Lighting.ExposureCompensation = origLighting.ExposureCompensation
            Lighting.FogEnd = origLighting.FogEnd
        end
    end
end, 2)

local widoPovConn
addT(visuFrame, "Wido Pov", function(on)
    if on then
        local Camera = workspace.CurrentCamera
        if widoPovConn then widoPovConn:Disconnect() end
        widoPovConn = game:GetService("RunService").RenderStepped:Connect(function()
            if Camera then
                Camera.CFrame = Camera.CFrame * CFrame.new(
                    0, 0, 0,
                    1, 0, 0,
                    0, 0.84, 0,
                    0, 0, 1
                )
            end
        end)
    else
        if widoPovConn then
            widoPovConn:Disconnect()
            widoPovConn = nil
        end
    end
end, 3)

addT(visuFrame, "No Animataions", function(on)
    if on and lp.Character then
        local animate = lp.Character:FindFirstChild("Animate")
        if animate then animate.Disabled = true end
        local humanoid = lp.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local animator = humanoid:FindFirstChildOfClass("Animator")
            if animator then animator:Destroy() end
            local tracks = humanoid:GetPlayingAnimationTracks()
            for _, track in pairs(tracks) do track:Stop() end
        end
    end
end, 4)

-- ESP Container
mk("TextLabel", vP, {Size = ud2(1,0,0,30), BackgroundTransparency = 1, Text = "  ESP", TextColor3 = c3(255,255,255), Font = f_gb, TextSize = 13, TextXAlignment = "Left", LayoutOrder = 7, ZIndex = 8})
local espFrame = mk("Frame", vP, {Size = ud2(1,-10,0,222), BackgroundTransparency = 1, LayoutOrder = 8, ZIndex = 7})
mk("UICorner", espFrame, {CornerRadius = ud(0, 8)})
local espStrk = mk("UIStroke", espFrame, {Thickness = 2, ApplyStrokeMode = "Border", Color = c3(255, 255, 255)})
local espGrad = mk("UIGradient", espStrk, {Color = ColorSequence.new(c3(255, 255, 255), c3(113, 255, 158))})
run.RenderStepped:Connect(function(dt) if espGrad.Parent then espGrad.Rotation = (espGrad.Rotation + 120 * dt) % 360 end end)
mk("UIListLayout", espFrame, {Padding = ud(0, 2), HorizontalAlignment = "Center", SortOrder = "LayoutOrder"})

local espO = false
local function cET(p)
    if not p.Character or p.Character:FindFirstChild("XXPX_Tag") then return end
    local h = p.Character:WaitForChild("Head", 5) if not h then return end
    local b = mk("BillboardGui", p.Character, {Name = "XXPX_Tag", Adornee = h, Size = ud2(0,150,0,30), StudsOffset = Vector3.new(0,3,0), AlwaysOnTop = true})
    local l = mk("TextLabel", b, {Size = ud2(1,0,1,0), BackgroundTransparency = 1, TextColor3 = c3(0,255,0), Font = f_gb, TextSize = 13, Text = p.Name})
    mk("UIStroke", l, {Thickness = 1.5})
end
local function cEB(hrp)
    if hrp:FindFirstChild("PxBox_Final") then return end
    mk("BoxHandleAdornment", hrp, {Name = "PxBox_Final", AlwaysOnTop = true, ZIndex = 10, Adornee = hrp, Size = Vector3.new(4,5.5,4), Transparency = .7, Color3 = c3(0,255,0)})
end
run.Heartbeat:Connect(function()
    for _, p in pairs(players:GetPlayers()) do
        local c = p.Character
        if p ~= lp and espO and c and c:FindFirstChild("HumanoidRootPart") then
            local h = c:FindFirstChild("XXPX_Highlight") or mk("Highlight", c, {Name = "XXPX_Highlight", FillColor = c3(0,255,0), OutlineColor = c3(255,255,255), DepthMode = "AlwaysOnTop"})
            cEB(c.HumanoidRootPart) cET(p)
        elseif c then
            local h, t, b = c:FindFirstChild("XXPX_Highlight"), c:FindFirstChild("XXPX_Tag"), c:FindFirstChild("HumanoidRootPart") and c.HumanoidRootPart:FindFirstChild("PxBox_Final")
            if h then h:Destroy() end if t then t:Destroy() end if b then b:Destroy() end
        end
    end
end)

local function TESP(plt)
    local p = plt:FindFirstChild("Purchases") if not p then return end
    local lb, mY = nil, math.huge
    for _, c in pairs(p:GetChildren()) do if c.Name == "PlotBlock" and c:FindFirstChild("Main") and c.Main.Position.Y < mY then mY, lb = c.Main.Position.Y, c end end
    if not lb or lb.Main:FindFirstChild("TimerEsp") then return end
    local ig = lb.Main:FindFirstChild("BillboardGui")
    local b = mk("BillboardGui", lb.Main, {Name = "TimerEsp", Size = ud2(0,100,0,25), AlwaysOnTop = true, MaxDistance = 10000, StudsOffset = Vector3.new(0,5,0)})
    local l = mk("TextLabel", b, {Size = ud2(1,0,1,0), BackgroundTransparency = 1, TextSize = 13, Font = f_gb, TextStrokeTransparency = 0})
    task.spawn(function()
        while lb and lb.Parent do
            task.wait(0.1)
            b.Enabled = tESP
            if not tESP then continue end
            local rt = ig and ig:FindFirstChild("RemainingTime")
            if rt and rt.Visible and rt.Text ~= "" then l.Text, l.TextColor3 = rt.Text, c3(255,255,255)
            else l.Text, l.TextColor3 = "OPEN", c3(0,255,0) end
        end
    end)
end
task.spawn(function() while true do task.wait(2) if workspace:FindFirstChild("Plots") then for _, p in pairs(workspace.Plots:GetChildren()) do TESP(p) end end end end)

addT(espFrame, "Player ESP", function(v) espO = v end, 1)
addT(espFrame, "Timer ESP", function(v) tESP = v end, 2)

local baseEspConn
addT(espFrame, "Base ESP", function(on)
    if on then
        baseEspConn = run.Heartbeat:Connect(function()
            for _, plot in pairs(workspace.Plots:GetChildren()) do
                local main = plot:FindFirstChild("MainRoot") or plot:FindFirstChild("Main")
                if main and not main:FindFirstChild("BaseBeam") then
                    local bb = Instance.new("BillboardGui", main)
                    bb.Name = "BaseBeam"
                    bb.Size = ud2(0, 100, 0, 25)
                    bb.AlwaysOnTop = true
                    local txt = Instance.new("TextLabel", bb)
                    txt.Size = ud2(1, 0, 1, 0)
                    txt.BackgroundTransparency = 1
                    txt.Text = "Base"
                    txt.TextColor3 = c3(255, 255, 0)
                    txt.TextSize = 13
                    txt.Font = f_gb
                end
            end
        end)
    else
        if baseEspConn then baseEspConn:Disconnect() baseEspConn = nil end
        for _, plot in pairs(workspace.Plots:GetChildren()) do
            local main = plot:FindFirstChild("MainRoot") or plot:FindFirstChild("Main")
            if main and main:FindFirstChild("BaseBeam") then main.BaseBeam:Destroy() end
        end
    end
end, 3)

local bestBaseEspConn
addT(espFrame, "Best Base ESP", function(on)
    if on then
        bestBaseEspConn = run.Heartbeat:Connect(function()
            for _, plot in pairs(workspace.Plots:GetChildren()) do
                local main = plot:FindFirstChild("MainRoot") or plot:FindFirstChild("Main")
                if main and not main:FindFirstChild("BestBaseBeam") then
                    local bb = Instance.new("BillboardGui", main)
                    bb.Name = "BestBaseBeam"
                    bb.Size = ud2(0, 100, 0, 25)
                    bb.AlwaysOnTop = true
                    local txt = Instance.new("TextLabel", bb)
                    txt.Size = ud2(1, 0, 1, 0)
                    txt.BackgroundTransparency = 1
                    txt.Text = "Best Base"
                    txt.TextColor3 = c3(0, 255, 255)
                    txt.TextSize = 13
                    txt.Font = f_gb
                end
            end
        end)
    else
        if bestBaseEspConn then bestBaseEspConn:Disconnect() bestBaseEspConn = nil end
        for _, plot in pairs(workspace.Plots:GetChildren()) do
            local main = plot:FindFirstChild("MainRoot") or plot:FindFirstChild("Main")
            if main and main:FindFirstChild("BestBaseBeam") then main.BestBaseBeam:Destroy() end
        end
    end
end, 4)

local bestBroConn
addT(espFrame, "Best Brainrot ESP", function(on)
    if on then
        bestBroConn = run.Heartbeat:Connect(function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") and v.Name:find("Brainrot") and not v:FindFirstChild("BBEsp") then
                    local bb = Instance.new("BillboardGui", v)
                    bb.Name = "BBEsp"
                    bb.Size = ud2(0, 100, 0, 25)
                    bb.AlwaysOnTop = true
                    local txt = Instance.new("TextLabel", bb)
                    txt.Size = ud2(1, 0, 1, 0)
                    txt.BackgroundTransparency = 1
                    txt.Text = "Best Brainrot"
                    txt.TextColor3 = c3(255, 0, 255)
                    txt.TextSize = 13
                    txt.Font = f_gb
                end
            end
        end)
    else
        if bestBroConn then bestBroConn:Disconnect() bestBroConn = nil end
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v.Name:find("Brainrot") and v:FindFirstChild("BBEsp") then
                v.BBEsp:Destroy()
            end
        end
    end
end, 5)

local topBroConn
addT(espFrame, "Top 5 Brainrot ESP", function(on)
    if on then
        topBroConn = run.Heartbeat:Connect(function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") and v.Name:find("Brainrot") and not v:FindFirstChild("TopEsp") then
                    local bb = Instance.new("BillboardGui", v)
                    bb.Name = "TopEsp"
                    bb.Size = ud2(0, 100, 0, 25)
                    bb.AlwaysOnTop = true
                    local txt = Instance.new("TextLabel", bb)
                    txt.Size = ud2(1, 0, 1, 0)
                    txt.BackgroundTransparency = 1
                    txt.Text = "Top 5 Brainrot"
                    txt.TextColor3 = c3(255, 165, 0)
                    txt.TextSize = 13
                    txt.Font = f_gb
                end
            end
        end)
    else
        if topBroConn then topBroConn:Disconnect() topBroConn = nil end
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v.Name:find("Brainrot") and v:FindFirstChild("TopEsp") then
                v.TopEsp:Destroy()
            end
        end
    end
end, 6)


-- Admin Panel Container
mk("TextLabel", uP, {Size = ud2(1,0,0,30), BackgroundTransparency = 1, Text = "  Admin Panel", TextColor3 = c3(255,255,255), Font = f_gb, TextSize = 13, TextXAlignment = "Left", LayoutOrder = 1, ZIndex = 8})
local admFrame = mk("Frame", uP, {Size = ud2(1,-10,0,37), BackgroundTransparency = 1, LayoutOrder = 2, ZIndex = 7})
mk("UICorner", admFrame, {CornerRadius = ud(0, 8)})
local admStrk = mk("UIStroke", admFrame, {Thickness = 2, ApplyStrokeMode = "Border", Color = c3(255, 255, 255)})
local admGrad = mk("UIGradient", admStrk, {Color = ColorSequence.new(c3(255, 255, 255), c3(113, 255, 158))})
run.RenderStepped:Connect(function(dt) if admGrad.Parent then admGrad.Rotation = (admGrad.Rotation + 120 * dt) % 360 end end)
mk("UIListLayout", admFrame, {Padding = ud(0, 2), HorizontalAlignment = "Center", SortOrder = "LayoutOrder"})

local adminSpamGui = nil
addT(admFrame, "Admin Spammer", function(on)
    if on then
        if adminSpamGui then return end
        local TS = game:GetService("TweenService")
        local RS = game:GetService("RunService")
        local UserInputService = game:GetService("UserInputService")
        local TextChatService = game:GetService("TextChatService")
        local info = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        local COMMANDS = {";rocket ", ";tiny ", ";ragdoll ", ";balloon ", ";jumpscare ", ";morph ", ";inverse ", ";blind "}
        local WAIT_TIME = 0.15

        local function getHRP(player)
            local char = player.Character
            return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso"))
        end

        local function getNearestPlayer()
            local nearest = nil
            local lastDist = math.huge
            local myHRP = getHRP(lp)
            if not myHRP then return nil end
            for _, player in pairs(players:GetPlayers()) do
                if player ~= lp then
                    local targetHRP = getHRP(player)
                    if targetHRP then
                        local dist = (myHRP.Position - targetHRP.Position).Magnitude
                        if dist < lastDist then
                            lastDist = dist
                            nearest = player
                        end
                    end
                end
            end
            return nearest
        end

        local function sendCommand(msg)
            local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
            if channel then
                channel:SendAsync(msg)
            else
                local events = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
                if events and events:FindFirstChild("SayMessageRequest") then
                    events.SayMessageRequest:FireServer(msg, "All")
                end
            end
        end

        local ScreenGui = mk("ScreenGui", lp:WaitForChild("PlayerGui"), {Name = "Px_Admin_Spammer_V2", ResetOnSpawn = false, IgnoreGuiInset = true})
        adminSpamGui = ScreenGui

        local Frame = mk("Frame", ScreenGui, {BackgroundColor3 = c3(15, 40, 25), BackgroundTransparency = 0.2, Size = ud2(0, 300, 0, 320), Position = getPos("AdminSpam", ud2(0, 20, 1, -420)), BorderSizePixel = 0, ClipsDescendants = true})
        mk("UICorner", Frame, {CornerRadius = ud(0, 12)})

        local mStroke = mk("UIStroke", Frame, {Thickness = 2, Color = c3(255, 255, 255), ApplyStrokeMode = "Border"})
        local mGrad = mk("UIGradient", mStroke, {Color = ColorSequence.new(c3(54,152,118), c3(113, 255, 158))})
        local spamRot = RS.RenderStepped:Connect(function(dt) mGrad.Rotation = (mGrad.Rotation + 120 * dt) % 360 end)

        local TopBar = mk("Frame", Frame, {Size = ud2(1, 0, 0, 40), BackgroundColor3 = c3(20, 80, 60), BorderSizePixel = 0})
        local TGrad = mk("UIGradient", TopBar, {Color = mGrad.Color, Rotation = 45})
        mk("UICorner", TopBar, {CornerRadius = ud(0, 12)})

        mk("TextLabel", TopBar, {Size = ud2(1, -40, 1, 0), Position = ud2(0, 12, 0, 0), BackgroundTransparency = 1, Text = "Px Admin Spammer", TextColor3 = c3(255, 255, 255), Font = f_gb, TextSize = 13, TextXAlignment = "Left"})
        local ToggleGuiButton = mk("TextButton", TopBar, {Size = ud2(0, 24, 0, 24), Position = ud2(1, -32, 0, 8), BackgroundColor3 = c3(30, 60, 45), Text = "－", TextColor3 = c3(255, 255, 255), Font = f_gb, TextSize = 13})
        mk("UICorner", ToggleGuiButton, {CornerRadius = ud(0, 6)})

        local InnerFrame = mk("Frame", Frame, {Position = ud2(0, 0, 0, 40), Size = ud2(1, 0, 1, -40), BackgroundTransparency = 1})
        local ScrollingFrame = mk("ScrollingFrame", InnerFrame, {Size = ud2(1, 0, 1, -100), Position = ud2(0, 0, 0, 10), BackgroundTransparency = 1, ScrollBarThickness = 2, ScrollBarImageColor3 = c3(113, 255, 158), CanvasSize = ud2(0, 0, 0, 0), BorderSizePixel = 0})
        local UIList = mk("UIListLayout", ScrollingFrame, {Padding = ud(0, 6), SortOrder = "LayoutOrder", HorizontalAlignment = "Center"})

        local function updatePlayerList()
            for _, child in pairs(ScrollingFrame:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
            for _, p in pairs(players:GetPlayers()) do
                if p == lp then continue end
                local PlayerCard = mk("Frame", ScrollingFrame, {Size = ud2(0, 270, 0, 50), BackgroundColor3 = c3(25, 25, 25), BackgroundTransparency = 0.4})
                mk("UICorner", PlayerCard, {CornerRadius = ud(0, 8)})
                mk("ImageLabel", PlayerCard, {Size = ud2(0, 40, 0, 40), Position = ud2(0, 5, 0.5, -20), BackgroundTransparency = 1, Image = players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)})
                mk("TextLabel", PlayerCard, {Size = ud2(1, -55, 0, 25), Position = ud2(0, 50, 0, 5), BackgroundTransparency = 1, Text = p.DisplayName, TextColor3 = c3(255,255,255), Font = f_gb, TextSize = 13, TextXAlignment = 0})
                mk("TextLabel", PlayerCard, {Size = ud2(1, -55, 0, 15), Position = ud2(0, 50, 0, 25), BackgroundTransparency = 1, Text = "ID: "..p.UserId, TextColor3 = c3(160, 160, 160), Font = f_gb, TextSize = 15, TextXAlignment = 0})
                local SelectBtn = mk("TextButton", PlayerCard, {Size = ud2(1, 0, 1, 0), BackgroundTransparency = 1, Text = ""})
                SelectBtn.MouseButton1Click:Connect(function()
                    task.spawn(function() for _, cmd in ipairs(COMMANDS) do sendCommand(cmd .. p.Name) task.wait(WAIT_TIME) end end)
                end)
            end
            ScrollingFrame.CanvasSize = ud2(0, 0, 0, UIList.AbsoluteContentSize.Y)
        end
        players.PlayerAdded:Connect(updatePlayerList); players.PlayerRemoving:Connect(updatePlayerList)
        updatePlayerList()

        local ExecuteBtn = mk("TextButton", Frame, {Position = ud2(0.1, 0, 1, -50), Size = ud2(0.8, 0, 0, 40), BackgroundColor3 = c3(30, 80, 50), Text = "Spam Closest (V)", TextColor3 = c3(255,255,255), Font = f_gb, TextSize = 13, ZIndex = 5})
        mk("UICorner", ExecuteBtn, {CornerRadius = ud(0, 8)})
        mk("UIStroke", ExecuteBtn, {Thickness = 2, Color = c3(113, 255, 158), ApplyStrokeMode = "Border"})

        local isSpamming = false
        local function runSpam()
            if isSpamming then return end
            local target = getNearestPlayer()
            if target and target ~= lp then
                isSpamming = true
                ts:Create(ExecuteBtn, info, {BackgroundColor3 = c3(100, 30, 30)}):Play()
                task.spawn(function()
                    for _, cmd in ipairs(COMMANDS) do sendCommand(cmd .. target.Name) task.wait(WAIT_TIME) end
                    ts:Create(ExecuteBtn, info, {BackgroundColor3 = c3(30, 80, 50)}):Play()
                    isSpamming = false
                end)
            end
        end
        ExecuteBtn.MouseButton1Click:Connect(runSpam)
        local inputCon = uis.InputBegan:Connect(function(input, gpe) if not gpe and input.KeyCode == Enum.KeyCode.V then runSpam() end end)

        local isOpened = true
        ToggleGuiButton.MouseButton1Click:Connect(function()
            isOpened = not isOpened
            ToggleGuiButton.Text = isOpened and "－" or "＋"
            ts:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = isOpened and ud2(0, 300, 0, 320) or ud2(0, 300, 0, 95)}):Play()
            ts:Create(ExecuteBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Position = isOpened and ud2(0.1, 0, 1, -50) or ud2(0.1, 0, 0, 48)}):Play()
            InnerFrame.Visible = isOpened
        end)

        local dragging, dS, sP; 
        Frame.InputBegan:Connect(function(i) 
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
                dragging, dS, sP = true, i.Position, Frame.Position 
            end 
        end)
        uis.InputChanged:Connect(function(i) 
            if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                local dl = i.Position - dS
                local np = ud2(sP.X.Scale, sP.X.Offset + dl.X, sP.Y.Scale, sP.Y.Offset + dl.Y)
                Frame.Position = np
                Config.Positions["AdminSpam"] = {np.X.Scale, np.X.Offset, np.Y.Scale, np.Y.Offset}
            end 
        end)
        uis.InputEnded:Connect(function(i) 
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
                dragging = false 
                saveConfig()
            end 
        end)
        
        ScreenGui.Destroying:Connect(function() spamRot:Disconnect() inputCon:Disconnect() end)
    else
        if adminSpamGui then adminSpamGui:Destroy() adminSpamGui = nil end
    end
end, 1)

-- Defense Panel Container
mk("TextLabel", uP, {Size = ud2(1,0,0,30), BackgroundTransparency = 1, Text = "  Defense Panel", TextColor3 = c3(255,255,255), Font = f_gb, TextSize = 13, TextXAlignment = "Left", LayoutOrder = 3, ZIndex = 8})
local defFrame = mk("Frame", uP, {Size = ud2(1,-10,0,111), BackgroundTransparency = 1, LayoutOrder = 4, ZIndex = 7})
mk("UICorner", defFrame, {CornerRadius = ud(0, 8)})
local defStrk = mk("UIStroke", defFrame, {Thickness = 2, ApplyStrokeMode = "Border", Color = c3(255, 255, 255)})
local defGrad = mk("UIGradient", defStrk, {Color = ColorSequence.new(c3(255, 255, 255), c3(113, 255, 158))})
run.RenderStepped:Connect(function(dt) if defGrad.Parent then defGrad.Rotation = (defGrad.Rotation + 120 * dt) % 360 end end)
mk("UIListLayout", defFrame, {Padding = ud(0, 2), HorizontalAlignment = "Center", SortOrder = "LayoutOrder"})

local DefConfig = {
    StealDefenseEnabled = false,
    SuperDefenderEnabled = false,
    AdminID = "f888ee6e-c86d-46e1-93d7-0639d6635d42",
    BodyHitboxSize = Vector3.new(30, 30, 30),
    MyPlot = nil,
    StealHitbox = nil,
    LastPos = {},
    LastExecuted = {},
    EntryTime = {}, 
    HasWarned = {},
    Cooldown = { balloon = 30.5, ragdoll = 0.5, jumpscare = 60.5, rocket = 120.5 }
}

local mainAutoDefToggle, mainAutoFlashToggle
local guiAutoDefToggle, guiAutoFlashToggle
local defenseObj = nil
local defenseConns = {}
local defenseLogicInitialized = false

local function initDefenseLogic()
    if defenseLogicInitialized then return end
    defenseLogicInitialized = true

    local plrs = game:GetService("Players")
    local repsto = game:GetService("ReplicatedStorage")
    local ws = game:GetService("Workspace")

    local function findMyPlot()
        local plots = ws:FindFirstChild("Plots")
        if not plots then
            for i=1, 20 do plots = ws:FindFirstChild("Plots"); if plots then break end; task.wait(0.5) end
        end
        if plots then
            for _, p in ipairs(plots:GetChildren()) do
                local sign = p:FindFirstChild("PlotSign")
                if sign then
                    local lbl = sign:FindFirstChild("TextLabel", true)
                    if lbl and (lbl.Text:find(lp.Name) or lbl.Text:find(lp.DisplayName)) then
                        DefConfig.MyPlot = p
                        DefConfig.StealHitbox = p:FindFirstChild("StealHitbox", true)
                        break
                    end
                end
            end
        end
    end

    local function getAdminRemote()
        local success, net = pcall(function() return repsto:WaitForChild("Packages"):WaitForChild("Net") end)
        if success and net then
            local children = net:GetChildren()
            for i, v in ipairs(children) do
                if v.Name:find("a0e78691") then return children[i+1] end
            end
        end
        return nil
    end

    local function fire(target, command)
        local remote = getAdminRemote()
        if remote and target and target ~= lp then
            local uid = target.UserId
            if not DefConfig.LastExecuted[uid] then DefConfig.LastExecuted[uid] = {} end
            local now = tick()
            if (now - (DefConfig.LastExecuted[uid][command] or 0)) >= (DefConfig.Cooldown[command] or 1) then
                DefConfig.LastExecuted[uid][command] = now
                task.spawn(function() pcall(function() remote:InvokeServer(DefConfig.AdminID, target, command) end) end)
                return true
            end
        end
        return false
    end

    local function handleStealSequence(target)
        local uid = target.UserId
        local now = tick()
        if not DefConfig.EntryTime[uid] then DefConfig.EntryTime[uid] = now end
        local elapsed = now - DefConfig.EntryTime[uid]
        fire(target, "balloon")
        if elapsed >= 10 and not DefConfig.HasWarned[uid] then
            DefConfig.HasWarned[uid] = true
            fire(target, "jumpscare")
        end
        if elapsed >= 15 then
            local lastB = (DefConfig.LastExecuted[uid] and DefConfig.LastExecuted[uid]["balloon"]) or 0
            if (now - lastB) < DefConfig.Cooldown.balloon then fire(target, "ragdoll") end
        end
    end

    local function scanRemotes(parent)
        for _, obj in ipairs(parent:GetChildren()) do
            if obj:IsA("RemoteEvent") then
                obj.OnClientEvent:Connect(function(...)
                    if not DefConfig.StealDefenseEnabled then return end
                    for _, msg in ipairs({...}) do
                        if type(msg) == "string" and msg:lower():find("stealing") then
                            for _, p in ipairs(plrs:GetPlayers()) do
                                if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.HumanoidRootPart.Size == DefConfig.BodyHitboxSize then
                                    handleStealSequence(p)
                                end
                            end
                        end
                    end
                end)
            end
            if #obj:GetChildren() > 0 then
                scanRemotes(obj)
            end
        end
        task.wait()
    end

    task.spawn(function()
        findMyPlot()
        scanRemotes(repsto)
    end)

    run.Heartbeat:Connect(function()
        if not DefConfig.StealDefenseEnabled or not DefConfig.StealHitbox then return end
        local cf, size = DefConfig.StealHitbox.CFrame, DefConfig.StealHitbox.Size
        local hx, hz = size.X * 0.5, size.Z * 0.5
        for _, p in ipairs(plrs:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                local rel = cf:PointToObjectSpace(hrp.Position)
                if math.abs(rel.X) <= hx and math.abs(rel.Z) <= hz then
                    hrp.Size = DefConfig.BodyHitboxSize
                    hrp.Transparency = 0.7
                    hrp.BrickColor = BrickColor.new("Cyan")
                    hrp.CanCollide = false
                else
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                end
            end
        end
    end)

    run.Heartbeat:Connect(function()
        if not DefConfig.SuperDefenderEnabled then return end
        for _, p in ipairs(plrs:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local pos = p.Character.HumanoidRootPart.Position
                local last = DefConfig.LastPos[p.UserId]
                if last and (pos - last).Magnitude > 35 then
                    local myPos = (lp.Character and lp.Character.PrimaryPart) and lp.Character.PrimaryPart.Position or Vector3.new()
                    if (pos - myPos).Magnitude < 80 then
                        fire(p, "balloon"); fire(p, "rocket"); fire(p, "jumpscare")
                    end
                end
                DefConfig.LastPos[p.UserId] = pos
            end
        end
    end)
end
initDefenseLogic()

local function startDefenseGUI()
    if defenseObj then return end
    local info = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

    local ScreenGui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
    ScreenGui.Name = "Px_Defense_Lite"
    ScreenGui.ResetOnSpawn, ScreenGui.IgnoreGuiInset = false, true
    defenseObj = ScreenGui

    local Frame = Instance.new("Frame", ScreenGui)
    Frame.BackgroundColor3, Frame.BackgroundTransparency = Color3.fromRGB(15, 40, 25), 0.2
    Frame.Size, Frame.Position, Frame.BorderSizePixel, Frame.ClipsDescendants = UDim2.new(0, 300, 0, 130), getPos("Defense", UDim2.new(0.4, 0, 0.4, 0)), 0, true
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

    local mStroke = Instance.new("UIStroke", Frame)
    mStroke.Thickness, mStroke.Color, mStroke.ApplyStrokeMode = 2, Color3.fromRGB(255, 255, 255), Enum.ApplyStrokeMode.Border
    local mGrad = Instance.new("UIGradient", mStroke)
    mGrad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(54, 152, 118)), ColorSequenceKeypoint.new(1, Color3.fromRGB(113, 255, 158))}
    table.insert(defenseConns, run.RenderStepped:Connect(function(dt) mGrad.Rotation = (mGrad.Rotation + 120 * dt) % 360 end))

    local TopBar = Instance.new("Frame", Frame)
    TopBar.Size, TopBar.BackgroundColor3, TopBar.BorderSizePixel = UDim2.new(1, 0, 0, 40), Color3.fromRGB(20, 80, 60), 0
    local TGrad = Instance.new("UIGradient", TopBar)
    TGrad.Color, TGrad.Rotation = mGrad.Color, 45
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

    local Title = Instance.new("TextLabel", TopBar)
    Title.Size, Title.Position, Title.BackgroundTransparency = UDim2.new(1, -40, 1, 0), UDim2.new(0, 12, 0, 0), 1
    Title.Text, Title.TextColor3, Title.Font, Title.TextSize, Title.TextXAlignment = "Px Defense", Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 13, Enum.TextXAlignment.Left

    local ToggleBtn = Instance.new("TextButton", TopBar)
    ToggleBtn.Size, ToggleBtn.Position, ToggleBtn.BackgroundColor3 = UDim2.new(0, 24, 0, 24), UDim2.new(1, -32, 0, 8), Color3.fromRGB(30, 60, 45)
    ToggleBtn.Text, ToggleBtn.TextColor3, ToggleBtn.Font, ToggleBtn.TextSize = "－", Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 13
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 6)

    local Inner = Instance.new("Frame", Frame)
    Inner.Position, Inner.Size, Inner.BackgroundTransparency = UDim2.new(0, 0, 0, 40), UDim2.new(1, 0, 0, 90), 1

    local function createSwitch(label, yPos, cfgKey, callback)
        local lbl = Instance.new("TextLabel", Inner)
        lbl.Size, lbl.Position, lbl.BackgroundTransparency = UDim2.new(0, 150, 0, 40), UDim2.new(0, 15, 0, yPos), 1
        lbl.Text, lbl.TextColor3, lbl.Font, lbl.TextSize, lbl.TextXAlignment = label, Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 15, Enum.TextXAlignment.Left

        local sw = Instance.new("TextButton", Inner)
        sw.Size, sw.Position, sw.BackgroundColor3, sw.BackgroundTransparency, sw.Text = UDim2.new(0, 45, 0, 22), UDim2.new(1, -60, 0, yPos + 9), Color3.fromRGB(40, 40, 40), 0.3, ""
        Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)

        local knob = Instance.new("Frame", sw)
        knob.Size, knob.Position, knob.BackgroundColor3 = UDim2.new(0, 18, 0, 18), UDim2.new(0, 2, 0.5, -9), Color3.fromRGB(200, 200, 200)
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

        local active = false
        if cfgKey == "Defense_Auto" and mainAutoDefToggle then active = mainAutoDefToggle.get()
        elseif cfgKey == "Defense_Flash" and mainAutoFlashToggle then active = mainAutoFlashToggle.get()
        elseif Config.Toggles[cfgKey] ~= nil then active = Config.Toggles[cfgKey] end
        
        local function updateState(isInit)
            ts:Create(knob, info, {Position = active and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9), BackgroundColor3 = active and Color3.fromRGB(113, 255, 158) or Color3.fromRGB(200, 200, 200)}):Play()
            ts:Create(sw, info, {BackgroundColor3 = active and Color3.fromRGB(30, 100, 60) or Color3.fromRGB(40, 40, 40)}):Play()
            callback(active)
            if not isInit then Config.Toggles[cfgKey] = active saveConfig() end
        end

        sw.MouseButton1Click:Connect(function()
            active = not active
            updateState(false)
        end)
        if active then task.spawn(function() updateState(true) end) end

        return {
            set = function(v)
                active = v
                ts:Create(knob, info, {Position = active and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9), BackgroundColor3 = active and Color3.fromRGB(113, 255, 158) or Color3.fromRGB(200, 200, 200)}):Play()
                ts:Create(sw, info, {BackgroundColor3 = active and Color3.fromRGB(30, 100, 60) or Color3.fromRGB(40, 40, 40)}):Play()
            end,
            get = function() return active end
        }
    end

    guiAutoDefToggle = createSwitch("Auto Defense", 5, "Defense_Auto", function(v) 
        DefConfig.StealDefenseEnabled = v 
        if mainAutoDefToggle and mainAutoDefToggle.get() ~= v then mainAutoDefToggle.set(v) end
    end)
    
    guiAutoFlashToggle = createSwitch("Auto Flash Defense", 45, "Defense_Flash", function(v) 
        DefConfig.SuperDefenderEnabled = v 
        if mainAutoFlashToggle and mainAutoFlashToggle.get() ~= v then mainAutoFlashToggle.set(v) end
    end)

    local opened = true
    ToggleBtn.MouseButton1Click:Connect(function()
        opened = not opened
        ToggleBtn.Text = opened and "－" or "＋"
        ts:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = opened and UDim2.new(0, 300, 0, 130) or UDim2.new(0, 300, 0, 40)}):Play()
        Inner.Visible = opened
    end)

    local dragging, dragStart, startPos
    table.insert(defenseConns, Frame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging, dragStart, startPos = true, i.Position, Frame.Position end end))
    table.insert(defenseConns, uis.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - dragStart
        local np = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        Frame.Position = np
        Config.Positions["Defense"] = {np.X.Scale, np.X.Offset, np.Y.Scale, np.Y.Offset}
    end end))
    table.insert(defenseConns, uis.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false saveConfig() end end))
end

local function stopDefenseGUI()
    if defenseObj then defenseObj:Destroy() defenseObj = nil end
    for _, conn in ipairs(defenseConns) do
        if conn.Disconnect then conn:Disconnect() end
    end
    defenseConns = {}
end

addT(defFrame, "Auto Defense GUI", function(on)
    if on then
        startDefenseGUI()
    else
        stopDefenseGUI()
    end
end, 1)

mainAutoDefToggle = addT(defFrame, "Auto Defense", function(on)
    DefConfig.StealDefenseEnabled = on
    if guiAutoDefToggle and guiAutoDefToggle.get() ~= on then guiAutoDefToggle.set(on) end
    if not on then
        for _, p in ipairs(players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                p.Character.HumanoidRootPart.Transparency = 1
            end
        end
    end
end, 2)

mainAutoFlashToggle = addT(defFrame, "Auto Flash Defense", function(on)
    DefConfig.SuperDefenderEnabled = on
    if guiAutoFlashToggle and guiAutoFlashToggle.get() ~= on then guiAutoFlashToggle.set(on) end
end, 3)

-- Booster Panel Container
mk("TextLabel", uP, {Size = ud2(1,0,0,30), BackgroundTransparency = 1, Text = "  Booster Panel", TextColor3 = c3(255,255,255), Font = f_gb, TextSize = 13, TextXAlignment = "Left", LayoutOrder = 7, ZIndex = 8})
local bstFrame = mk("Frame", uP, {Size = ud2(1,-10,0,74), BackgroundTransparency = 1, LayoutOrder = 8, ZIndex = 7})
mk("UICorner", bstFrame, {CornerRadius = ud(0, 8)})
local bstStrk = mk("UIStroke", bstFrame, {Thickness = 2, ApplyStrokeMode = "Border", Color = c3(255, 255, 255)})
local bstGrad = mk("UIGradient", bstStrk, {Color = ColorSequence.new(c3(255, 255, 255), c3(113, 255, 158))})
run.RenderStepped:Connect(function(dt) if bstGrad.Parent then bstGrad.Rotation = (bstGrad.Rotation + 120 * dt) % 360 end end)
mk("UIListLayout", bstFrame, {Padding = ud(0, 2), HorizontalAlignment = "Center", SortOrder = "LayoutOrder"})

local bstG = nil
local bstS = 27.5
local spC = nil
local globalBoosterOn = false

local function applyBoosterState(on)
    globalBoosterOn = on
    if globalBoosterOn then 
        if not spC then 
            spC = run.RenderStepped:Connect(function() 
                if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and lp.Character:FindFirstChildOfClass("Humanoid") and lp.Character:FindFirstChildOfClass("Humanoid").MoveDirection.Magnitude > .05 then 
                    lp.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(lp.Character:FindFirstChildOfClass("Humanoid").MoveDirection.X * bstS, lp.Character.HumanoidRootPart.AssemblyLinearVelocity.Y, lp.Character:FindFirstChildOfClass("Humanoid").MoveDirection.Z * bstS) 
                end 
            end) 
        end 
    else 
        if spC then spC:Disconnect() spC = nil end 
    end
end

local function cBST()
    if bstG and bstG.Parent then return end
    local g = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
    g.Name = "Booster_Px_Lite"
    g.IgnoreGuiInset = true
    g.ResetOnSpawn = false
    bstG = g
    
    local f = Instance.new("Frame", g)
    f.BackgroundColor3 = Color3.fromRGB(15, 40, 25)
    f.BackgroundTransparency = 0.2
    f.Size = UDim2.new(0, 220, 0, 130)
    f.Position = getPos("Booster", UDim2.new(1, -420, 0.5, -92))
    f.BorderSizePixel = 0
    f.ClipsDescendants = true
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 12)
    
    local mS = Instance.new("UIStroke", f)
    mS.Thickness = 2
    mS.Color = Color3.fromRGB(255, 255, 255)
    mS.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local mG = Instance.new("UIGradient", mS)
    mG.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(54, 152, 118)), ColorSequenceKeypoint.new(1, Color3.fromRGB(113, 255, 158))}
    run.RenderStepped:Connect(function(dt) if mG.Parent then mG.Rotation = (mG.Rotation + 120 * dt) % 360 end end)
    
    local tb = Instance.new("Frame", f)
    tb.Size = UDim2.new(1, 0, 0, 40)
    tb.BackgroundColor3 = Color3.fromRGB(20, 80, 60)
    tb.BorderSizePixel = 0
    local tbGrad = Instance.new("UIGradient", tb)
    tbGrad.Color = mG.Color
    tbGrad.Rotation = 45
    Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 12)
    
    local title = Instance.new("TextLabel", tb)
    title.Size = UDim2.new(1, -40, 1, 0)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Booster"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    
    local cls = Instance.new("TextButton", tb)
    cls.Size = UDim2.new(0, 24, 0, 24)
    cls.Position = UDim2.new(1, -32, 0, 8)
    cls.Text = "－"
    cls.BackgroundColor3 = Color3.fromRGB(30, 60, 45)
    cls.TextColor3 = Color3.new(1, 1, 1)
    cls.Font = Enum.Font.GothamBold
    cls.TextSize = 13
    Instance.new("UICorner", cls).CornerRadius = UDim.new(0, 6)
    
    local iF = Instance.new("Frame", f)
    iF.Position = UDim2.new(0, 0, 0, 40)
    iF.Size = UDim2.new(1, 0, 0, 100)
    iF.BackgroundTransparency = 1
    
    local bstCont = Instance.new("Frame", iF)
    bstCont.Size = UDim2.new(1, -10, 0, 35)
    bstCont.Position = UDim2.new(0, 5, 0, 5)
    bstCont.BackgroundTransparency = 1
    Instance.new("UICorner", bstCont).CornerRadius = UDim.new(0, 8)
    
    local labB = Instance.new("TextLabel", bstCont)
    labB.Size = UDim2.new(0, 100, 1, 0)
    labB.Position = UDim2.new(0, 10, 0, 0)
    labB.BackgroundTransparency = 1
    labB.RichText = true
    labB.Text = "Booster <font color='#909090'>(T)</font>"
    labB.TextColor3 = Color3.new(1, 1, 1)
    labB.Font = Enum.Font.GothamBold
    labB.TextSize = 15
    labB.TextXAlignment = Enum.TextXAlignment.Left
    
    local s = Instance.new("TextButton", bstCont)
    s.Size = UDim2.new(0, 45, 0, 22)
    s.Position = UDim2.new(1, -55, 0.5, -11)
    s.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    s.BackgroundTransparency = 0.3
    s.Text = ""
    Instance.new("UICorner", s).CornerRadius = UDim.new(1, 0)
    local k = Instance.new("Frame", s)
    k.Size = UDim2.new(0, 18, 0, 18)
    k.Position = UDim2.new(0, 2, 0.5, -9)
    k.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    Instance.new("UICorner", k).CornerRadius = UDim.new(1, 0)
    
    local wsCont = Instance.new("Frame", iF)
    wsCont.Size = UDim2.new(1, -10, 0, 35)
    wsCont.Position = UDim2.new(0, 5, 0, 45)
    wsCont.BackgroundTransparency = 1
    Instance.new("UICorner", wsCont).CornerRadius = UDim.new(0, 8)
    
    local wsLabel = Instance.new("TextLabel", wsCont)
    wsLabel.Size = UDim2.new(0, 100, 1, 0)
    wsLabel.Position = UDim2.new(0, 10, 0, 0)
    wsLabel.BackgroundTransparency = 1
    wsLabel.Text = "Walk Speed"
    wsLabel.TextColor3 = Color3.new(1, 1, 1)
    wsLabel.Font = Enum.Font.GothamBold
    wsLabel.TextSize = 15
    wsLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    if Config.Toggles["BoosterVal"] ~= nil then bstS = Config.Toggles["BoosterVal"] end
    local sB = Instance.new("TextBox", wsCont)
    sB.Size = UDim2.new(0, 50, 0, 25)
    sB.Position = UDim2.new(1, -60, 0.5, -12.5)
    sB.BackgroundColor3 = Color3.fromRGB(30, 60, 45)
    sB.Text = tostring(bstS)
    sB.TextColor3 = Color3.new(1, 1, 1)
    sB.Font = Enum.Font.GothamBold
    sB.TextSize = 13
    Instance.new("UICorner", sB).CornerRadius = UDim.new(0, 6)
    sB.FocusLost:Connect(function() 
        local n = tonumber(sB.Text) 
        bstS = n and math.clamp(n, 0, 50) or bstS 
        sB.Text = tostring(bstS) 
        Config.Toggles["BoosterVal"] = bstS 
        saveConfig() 
    end)
    
    local function updB()
        ts:Create(k, TweenInfo.new(0.2), {Position = globalBoosterOn and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9), BackgroundColor3 = globalBoosterOn and Color3.fromRGB(113, 255, 158) or Color3.fromRGB(200, 200, 200)}):Play()
        ts:Create(s, TweenInfo.new(0.2), {BackgroundColor3 = globalBoosterOn and Color3.fromRGB(30, 100, 60) or Color3.fromRGB(40, 40, 40)}):Play()
        applyBoosterState(globalBoosterOn)
    end
    
    s.MouseButton1Click:Connect(function()
        globalBoosterOn = not globalBoosterOn
        updB()
    end)
    
    local tConn = uis.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode.T then
            globalBoosterOn = not globalBoosterOn
            updB()
        end
    end)
    
    local op = true
    cls.MouseButton1Click:Connect(function() 
        op = not op 
        cls.Text = op and "－" or "＋" 
        ts:Create(f, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = op and UDim2.new(0, 220, 0, 130) or UDim2.new(0, 220, 0, 40)}):Play() 
        iF.Visible = op 
    end)
    
    local dragging, dS, sP; 
    f.InputBegan:Connect(function(i) 
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
            dragging = true 
            dS, sP = i.Position, f.Position 
        end 
    end)
    uis.InputChanged:Connect(function(i) 
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then 
            local dl = i.Position - dS 
            local np = UDim2.new(sP.X.Scale, sP.X.Offset + dl.X, sP.Y.Scale, sP.Y.Offset + dl.Y) 
            f.Position = np
            Config.Positions["Booster"] = {np.X.Scale, np.X.Offset, np.Y.Scale, np.Y.Offset}
        end 
    end)
    uis.InputEnded:Connect(function(i) 
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
            dragging = false 
            saveConfig()
        end 
    end)

    g.Destroying:Connect(function()
        if tConn then tConn:Disconnect() end
    end)
    
    updB()
end

addT(bstFrame, "Booster GUI", function(v) if v then cBST() else if bstG then bstG:Destroy() bstG = nil end end end, 1)
mainBoosterToggle = addT(bstFrame, "Booster", function(on) 
    applyBoosterState(on)
    if boosterSetter and boosterSetter.get() ~= on then boosterSetter.set(on) end
end, 2)

-- Quick Panel Container
mk("TextLabel", uP, {Size = ud2(1,0,0,30), BackgroundTransparency = 1, Text = "  Quick Panel", TextColor3 = c3(255,255,255), Font = f_gb, TextSize = 13, TextXAlignment = "Left", LayoutOrder = 10, ZIndex = 8})
local qpFrame = mk("Frame", uP, {Size = ud2(1,-10,0,37), BackgroundTransparency = 1, LayoutOrder = 11, ZIndex = 7})
mk("UICorner", qpFrame, {CornerRadius = ud(0, 8)})
local qpStrk = mk("UIStroke", qpFrame, {Thickness = 2, ApplyStrokeMode = "Border", Color = c3(255, 255, 255)})
local qpGrad = mk("UIGradient", qpStrk, {Color = ColorSequence.new(c3(255, 255, 255), c3(113, 255, 158))})
run.RenderStepped:Connect(function(dt) if qpGrad.Parent then qpGrad.Rotation = (qpGrad.Rotation + 120 * dt) % 360 end end)
mk("UIListLayout", qpFrame, {Padding = ud(0, 2), HorizontalAlignment = "Center", SortOrder = "LayoutOrder"})

local qpGuiObj = nil
local function createQuickPanelGUI()
    if qpGuiObj then return end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Px_Quick_Panel"
    ScreenGui.Parent = lp:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    qpGuiObj = ScreenGui

    local Frame = Instance.new("Frame")
    Frame.Parent = ScreenGui
    Frame.BackgroundColor3 = Color3.fromRGB(15, 40, 25)
    Frame.BackgroundTransparency = 0.2
    Frame.Size = UDim2.new(0, 220, 0, 320)
    Frame.Position = getPos("Other", UDim2.new(0.4, 0, 0.3, 0))
    Frame.BorderSizePixel = 0
    Frame.ClipsDescendants = true

    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

    local mStroke = Instance.new("UIStroke", Frame)
    mStroke.Thickness = 2
    mStroke.Color = Color3.fromRGB(255, 255, 255)
    mStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local mGrad = Instance.new("UIGradient", mStroke)
    mGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(54, 152, 118)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(113, 255, 158))
    }

    local otherRot = run.RenderStepped:Connect(function(dt)
        if mGrad.Parent then mGrad.Rotation = (mGrad.Rotation + 120 * dt) % 360 end
    end)

    local TopBar = Instance.new("Frame", Frame)
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Color3.fromRGB(20, 80, 60)
    TopBar.BorderSizePixel = 0

    local TopBarGrad = Instance.new("UIGradient", TopBar)
    TopBarGrad.Color = mGrad.Color
    TopBarGrad.Rotation = 45
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

    local Title = Instance.new("TextLabel", TopBar)
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "Quick Panel"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local ToggleGuiButton = Instance.new("TextButton", TopBar)
    ToggleGuiButton.Size = UDim2.new(0, 24, 0, 24)
    ToggleGuiButton.Position = UDim2.new(1, -32, 0, 8)
    ToggleGuiButton.Text = "－"
    ToggleGuiButton.BackgroundColor3 = Color3.fromRGB(30, 60, 45)
    ToggleGuiButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleGuiButton.Font = Enum.Font.GothamBold
    ToggleGuiButton.TextSize = 13
    Instance.new("UICorner", ToggleGuiButton).CornerRadius = UDim.new(0, 6)

    local InnerFrame = Instance.new("Frame", Frame)
    InnerFrame.Position = UDim2.new(0, 0, 0, 40)
    InnerFrame.Size = UDim2.new(1, 0, 1, -40)
    InnerFrame.BackgroundTransparency = 1
    
    local UIPad = Instance.new("UIPadding", InnerFrame)
    UIPad.PaddingTop = UDim.new(0, 10)

    local function createExecuteButton(name, yPos, parent)
        local btn = Instance.new("TextButton", parent)
        btn.Name = name .. "Btn"
        btn.Position = UDim2.new(0.1, 0, 0, yPos)
        btn.Size = UDim2.new(0.8, 0, 0, 35)
        btn.BackgroundColor3 = Color3.fromRGB(30, 80, 50)
        btn.Text = name
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 13
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

        local stroke = Instance.new("UIStroke", btn)
        stroke.Thickness = 2
        stroke.Color = Color3.fromRGB(113, 255, 158)
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        btn.MouseButton1Down:Connect(function()
            ts:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(50, 120, 80)}):Play()
        end)
        btn.MouseButton1Up:Connect(function()
            ts:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(30, 80, 50)}):Play()
        end)

        return btn
    end

    local RejoinBtn = createExecuteButton("Rejoin", 0, InnerFrame)
    local KickBtn = createExecuteButton("Kick Self", 45, InnerFrame)
    local RagdollBtn = createExecuteButton("Ragdoll Self", 90, InnerFrame)
    local ResetBtn = createExecuteButton("Reset Character", 135, InnerFrame)
    local DropCharBtn = createExecuteButton("Drop Character", 180, InnerFrame)
    
    local CarpetSpeedBtn = createExecuteButton("Carpet Speed", 225, InnerFrame)
    CarpetSpeedBtn.RichText = true
    CarpetSpeedBtn.Text = "Carpet Speed <font color='#909090'>(Q)</font>"

    DropCharBtn.MouseButton1Click:Connect(function()
        local dropEnabled = true
        local wfConns = {}

        local function startDrop()
            local colConn = run.Stepped:Connect(function()
                if not dropEnabled then return end
                for _, p in ipairs(players:GetPlayers()) do
                    if p ~= lp and p.Character then
                        for _, part in ipairs(p.Character:GetChildren()) do
                            if part:IsA("BasePart") then 
                                part.CanCollide = false 
                            end
                        end
                    end
                end
            end)
            table.insert(wfConns, colConn)

            task.spawn(function()
                while dropEnabled do
                    run.Heartbeat:Wait()
                    local c = lp.Character
                    local root = c and c:FindFirstChild("HumanoidRootPart")
                    if not root then continue end
                    local vel = root.Velocity
                    root.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
                    run.RenderStepped:Wait()
                    if root and root.Parent then root.Velocity = vel end
                    run.Stepped:Wait()
                    if root and root.Parent then 
                        root.Velocity = vel + Vector3.new(0, 0.1, 0) 
                    end
                end
            end)
            
            task.delay(0.5, function()
                dropEnabled = false
                for _, conn in ipairs(wfConns) do
                    if conn.Disconnect then conn:Disconnect() end
                end
            end)
        end

        startDrop()
    end)

    local carpetSpeedOn = false
    local carpetSpeedConn = nil
    local carpetSpeedCharConn = nil
    local STEAL_SPEED = 100 
    local TARGET_TOOL_NAME = "Flying Carpet"

    local function toggleCarpetSpeed()
        carpetSpeedOn = not carpetSpeedOn
        if carpetSpeedOn then
            CarpetSpeedBtn.Text = "Carpet Speed (ON) <font color='#909090'>(Q)</font>"
            local function applySpeedAndEquip()
                local char = lp.Character or lp.CharacterAdded:Wait()
                local hum = char:WaitForChild("Humanoid")
                local function equipCarpet()
                    local backpack = lp:FindFirstChild("Backpack")
                    if backpack then
                        local tool = backpack:FindFirstChild(TARGET_TOOL_NAME)
                        if tool then
                            hum:EquipTool(tool)
                        end
                    end
                end
                equipCarpet()
                if carpetSpeedConn then carpetSpeedConn:Disconnect() end
                carpetSpeedConn = run.Heartbeat:Connect(function()
                    local currentChar = lp.Character
                    if not currentChar then return end
                    local currentHum = currentChar:FindFirstChildOfClass("Humanoid")
                    local hrp = currentChar:FindFirstChild("HumanoidRootPart")
                    if not currentHum or not hrp then return end
                    local md = currentHum.MoveDirection
                    if md.Magnitude > 0 then
                        hrp.AssemblyLinearVelocity = Vector3.new(
                            md.X * STEAL_SPEED, 
                            hrp.AssemblyLinearVelocity.Y, 
                            md.Z * STEAL_SPEED
                        )
                    end
                end)
            end
            task.spawn(applySpeedAndEquip)
            if carpetSpeedCharConn then carpetSpeedCharConn:Disconnect() end
            carpetSpeedCharConn = lp.CharacterAdded:Connect(function(newChar)
                local newHum = newChar:WaitForChild("Humanoid")
                task.wait(0.5) 
                local backpack = lp:WaitForChild("Backpack")
                local tool = backpack:FindFirstChild(TARGET_TOOL_NAME)
                if tool then
                    newHum:EquipTool(tool)
                end
            end)
        else
            CarpetSpeedBtn.Text = "Carpet Speed <font color='#909090'>(Q)</font>"
            if carpetSpeedConn then carpetSpeedConn:Disconnect() carpetSpeedConn = nil end
            if carpetSpeedCharConn then carpetSpeedCharConn:Disconnect() carpetSpeedCharConn = nil end
        end
    end

    CarpetSpeedBtn.MouseButton1Click:Connect(toggleCarpetSpeed)
    
    local qHotKeyConn = uis.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode.Q then
            toggleCarpetSpeed()
        end
    end)

    RejoinBtn.MouseButton1Click:Connect(function()
        settings().Network.IncomingReplicationLag = -1000
        game:GetService("TeleportService"):Teleport(game.PlaceId, lp)
    end)
    
    KickBtn.MouseButton1Click:Connect(function() 
        game:Shutdown() 
    end)
    
    RagdollBtn.MouseButton1Click:Connect(function()
        local TextChatService = game:GetService("TextChatService")
        task.spawn(function() 
            if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
                if channel then channel:SendAsync(";ragdoll " .. lp.Name) end
            else
                local event = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
                if event then event.SayMessageRequest:FireServer(";ragdoll " .. lp.Name, "All") end
            end
        end)
        task.spawn(function()
            local adminRemote = game:GetService("ReplicatedStorage"):FindFirstChild("AdminRagdoll") or game:GetService("ReplicatedStorage"):FindFirstChild("RagdollEvent")
            if adminRemote and adminRemote:IsA("RemoteEvent") then adminRemote:FireServer(lp.Character) end
        end)
    end)
    
    ResetBtn.MouseButton1Click:Connect(function()
        local balloonEnabled = true
        local deathCoords = CFrame.new(1000003.56, 999999.69, 8.17)
        local lastTrigger = 0
        local COOLDOWN = 3

        local function equipCarpet()
            local char = lp.Character
            if not char then return end
            local backpack = lp:FindFirstChild("Backpack")
            if backpack then
                for _, tool in ipairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") and tool.Name:lower():find("carpet") then
                        char.Humanoid:EquipTool(tool)
                        return
                    end
                end
            end
        end

        local function tpAndDie()
            local char = lp.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChild("Humanoid")
            if not hrp or not hum then return end
            equipCarpet()
            task.wait()
            hrp.CFrame = deathCoords
            local conn
            conn = run.Heartbeat:Connect(function()
                if not char or not char.Parent then conn:Disconnect() return end
                local h = char:FindFirstChild("Humanoid")
                local r = char:FindFirstChild("HumanoidRootPart")
                if not h or not r then conn:Disconnect() return end
                if h.Health <= 0 then conn:Disconnect() return end
                r.CFrame = deathCoords
            end)
        end

        local function hasBalloon(text)
            if typeof(text) ~= "string" then return false end
            local lower = string.lower(text)
            return lower:find("balloon") ~= nil or lower:find("ballon") ~= nil
        end

        local function checkText(text)
            if not balloonEnabled then return end
            if not hasBalloon(text) then return end
            local now = tick()
            if now - lastTrigger < COOLDOWN then return end
            lastTrigger = now
            tpAndDie()
        end

        local function scanGuiObjects(parent)
            for _, obj in ipairs(parent:GetDescendants()) do
                if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                    checkText(obj.Text)
                    obj:GetPropertyChangedSignal("Text"):Connect(function()
                        checkText(obj.Text)
                    end)
                end
            end
        end

        local function setupGuiWatcher(g)
            g.DescendantAdded:Connect(function(desc)
                task.wait()
                if desc:IsA("TextLabel") or desc:IsA("TextButton") or desc:IsA("TextBox") then
                    checkText(desc.Text)
                    desc:GetPropertyChangedSignal("Text"):Connect(function()
                        checkText(desc.Text)
                    end)
                end
            end)
        end

        pcall(function()
            local coreGui = game:GetService("CoreGui")
            scanGuiObjects(coreGui)
            setupGuiWatcher(coreGui)
        end)

        for _, g in ipairs(lp:WaitForChild("PlayerGui"):GetChildren()) do
            scanGuiObjects(g)
            setupGuiWatcher(g)
        end

        lp:WaitForChild("PlayerGui").ChildAdded:Connect(function(g)
            setupGuiWatcher(g)
            scanGuiObjects(g)
        end)

        tpAndDie()
    end)

    local isOpened = true
    ToggleGuiButton.MouseButton1Click:Connect(function()
        isOpened = not isOpened
        ToggleGuiButton.Text = isOpened and "－" or "＋"
        ts:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = isOpened and UDim2.new(0, 220, 0, 320) or UDim2.new(0, 220, 0, 40)}):Play()
        InnerFrame.Visible = isOpened
    end)

    local drag, dragStart, startPos
    Frame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag, dragStart, startPos = true, i.Position, Frame.Position end end)
    uis.InputChanged:Connect(function(i) if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local delta = i.Position - dragStart
        local np = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        Frame.Position = np
        Config.Positions["Other"] = {np.X.Scale, np.X.Offset, np.Y.Scale, np.Y.Offset}
    end end)
    uis.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false saveConfig() end end)
    
    ScreenGui.Destroying:Connect(function() 
        otherRot:Disconnect() 
        if qHotKeyConn then qHotKeyConn:Disconnect() end
    end)
end

addT(qpFrame, "Quick Panel GUI", function(on)
    if on then
        createQuickPanelGUI()
    else
        if qpGuiObj then qpGuiObj:Destroy() qpGuiObj = nil end
    end
end, 1)

local players, run, ts = game:GetService("Players"), game:GetService("RunService"), game:GetService("TweenService")
local lp = players.LocalPlayer
local c3, ud, ud2 = Color3.fromRGB, UDim.new, UDim2.new
local f_gb = Enum.Font.GothamBold

local gui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
gui.Name = "PXHUB_StatusUI_Locked"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = ud2(0, 350, 0, 75)
frame.Position = ud2(0.5, -175, 0.225, -37) 
frame.BackgroundColor3 = c3(15, 40, 25)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = ud(0, 12)

local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 2
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Color = c3(255, 255, 255)

local gradStroke = Instance.new("UIGradient", stroke)
gradStroke.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, c3(54, 152, 118)),
    ColorSequenceKeypoint.new(1, c3(113, 255, 158))
})

local title = Instance.new("TextLabel", frame)
title.Size = ud2(1, 0, 0, 30)
title.Position = ud2(0, 0, 0, 4)
title.BackgroundTransparency = 1
title.Text = "PXHUB V4.0"
title.TextColor3 = c3(255, 255, 255)
title.Font = f_gb
title.TextSize = 27

local titleGrad = Instance.new("UIGradient", title)
titleGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, c3(57, 243, 57)),
    ColorSequenceKeypoint.new(1, c3(40, 114, 65))
})

local discord = Instance.new("TextLabel", frame)
discord.Size = ud2(1, 0, 0, 22)
discord.Position = ud2(0, 0, 0, 32)
discord.BackgroundTransparency = 1
discord.Text = "@xlxpxly-discord.gg/xxpx"
discord.TextColor3 = c3(200, 200, 200)
discord.Font = f_gb
discord.TextSize = 20

local gradDiscord = Instance.new("UIGradient", discord)
gradDiscord.Color = gradStroke.Color

local stats = Instance.new("TextLabel", frame)
stats.Size = ud2(1, 0, 0, 19)
stats.Position = ud2(0, 0, 0, 52)
stats.BackgroundTransparency = 1
stats.RichText = true
stats.Text = "FPS: <font transparency='0.5'>0</font> | PING: <font transparency='0.5'>0</font>"
stats.TextColor3 = c3(255, 255, 255)
stats.Font = f_gb
stats.TextSize = 19
stats.TextXAlignment = Enum.TextXAlignment.Center

local fpsCount = 0
local lastUpdate = tick()

run.RenderStepped:Connect(function(dt)
    gradStroke.Rotation = (gradStroke.Rotation + 250 * dt) % 360
    gradDiscord.Rotation = (gradDiscord.Rotation - 160 * dt) % 360
    
    fpsCount = fpsCount + 1
    local now = tick()
    if now - lastUpdate >= 1 then
        local ping = math.floor(lp:GetNetworkPing() * 1000)
        stats.Text = string.format("FPS: <font transparency='0.5'>%d</font> | PING: <font transparency='0.5'>%d</font>", fpsCount, ping)
        fpsCount = 0
        lastUpdate = now
    end
end)
