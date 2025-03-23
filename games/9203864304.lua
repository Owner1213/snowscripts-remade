local loadstring = function(...)
	local res, err = loadstring(...)
	if err and vape then
		vape:CreateNotification('Vape', 'Failed to load : '..err, 30, 'alert')
	end
	return res
end
local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end
local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/Owner1213/snowscripts-remade/'..readfile('newvape/profiles/commit.txt')..'/'..select(1, path:gsub('newvape/', '')), true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		if path:find('.lua') then
			res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'..res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end
local function notif(...) 
    vape:CreateNotification(...)
end
local run = function(func)
	func()
end
local queue_on_teleport = queue_on_teleport or function() end
local cloneref = cloneref or function(obj)
	return obj
end

local playersService = cloneref(game:GetService('Players'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local runService = cloneref(game:GetService('RunService'))
local inputService = cloneref(game:GetService('UserInputService'))
local tweenService = cloneref(game:GetService('TweenService'))
local lightingService = cloneref(game:GetService('Lighting'))
local marketplaceService = cloneref(game:GetService('MarketplaceService'))
local teleportService = cloneref(game:GetService('TeleportService'))
local httpService = cloneref(game:GetService('HttpService'))
local guiService = cloneref(game:GetService('GuiService'))
local groupService = cloneref(game:GetService('GroupService'))
local textChatService = cloneref(game:GetService('TextChatService'))
local contextService = cloneref(game:GetService('ContextActionService'))
local coreGui = cloneref(game:GetService('CoreGui'))

local isnetworkowner = identifyexecutor and table.find({'AWP', 'Nihon'}, ({identifyexecutor()})[1]) and isnetworkowner or function()
	return true
end
local gameCamera = workspace.CurrentCamera or workspace:FindFirstChildWhichIsA('Camera')
local lplr = playersService.LocalPlayer
local assetfunction = getcustomasset

local vape = shared.vape
local tween = vape.Libraries.tween
local targetinfo = vape.Libraries.targetinfo
local getfontsize = vape.Libraries.getfontsize
local getcustomasset = vape.Libraries.getcustomasset
local sessioninfo = vape.Libraries.sessioninfo

sessioninfo:AddItem("Roommate's rent amount", 0, function(val) return workspace.Roommate.Head.Amt.Value end, true)
sessioninfo:AddItem("Can Raise", "no", function(val) return workspace.Roommate.Head.CanRaise.Value end, true)
run(function() 
    local autoclick

    autoclick = vape.Categories.Utility:CreateModule({
        Name = "AutoFloppaClick",
        Function = function(callback)
            if callback then 
                repeat
                    fireclickdetector(workspace.Floppa:FindFirstChildWhichIsA("ClickDetector"))
                    runService.Heartbeat:Wait()
                until not autoclick.Enabled
            end
        end
    })
end)

run(function()
    local autocollectmoney
    local sound
    local connection

    local function OnDescendantAdded(i)
        if i.Name == "Money" or i.Name == "MoneyBag" then
            i.Transparency = 1
            local character = lplr.Character or lplr.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            
            if not humanoidRootPart then
                notif("Vape", "HumanoidRootPart not found!", 3, "warning")
                return
            end

            i.CanCollide = false
            i.CFrame = humanoidRootPart.CFrame
        elseif sound.Enabled and i.Name == "DollaDollaBills" then
            task.wait()
            i:Stop()
            i:Destroy()
        end
    end

    autocollectmoney = vape.Categories.Utility:CreateModule({
        Name = "AutoCollectMoney",
        Function = function(callback)
            if callback then 
                for _, obj in ipairs(workspace:GetDescendants()) do
                    OnDescendantAdded(obj)
                end
                
                connection = workspace.DescendantAdded:Connect(OnDescendantAdded)
            else
                if connection then
                    connection:Disconnect()
                end
            end
        end
    })

    sound = autocollectmoney:CreateToggle({
        Name = "No Sound",
        Function = function(val) end,
        Default = true,
        Tooltip = "removes the annoying sound"
    })
end)
