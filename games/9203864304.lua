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
    local collectmethod
    local connection

    local function OnDescendantAdded(i)
        print("New descendant added:", i.Name)

        if i.Name == "Money" or i.Name == "MoneyBag" then
            local character = lplr.Character or lplr.CharacterAdded:Wait()
            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
            
            if not humanoidRootPart then
                print("HumanoidRootPart not found!")
                return
            end

            print("Attempting to simulate touch on:", i.Name)

            if i:IsA("Model") then
                i = i.PrimaryPart or i:FindFirstChildWhichIsA("BasePart")
                if not i then
                    print("No valid BasePart found in Model:", i.Name)
                    return
                end
            elseif not i:IsA("BasePart") then
                print("Invalid part:", i.Name)
                return
            end

            -- Simulate the touch
            print("Simulating touch on:", i.Name)
            firetouchinterest(humanoidRootPart, i, 0)
            task.wait(0.1)
            firetouchinterest(humanoidRootPart, i, 1)

        elseif i.Name == 'DollaDollaBills' then
            print("Destroying DollaDollaBills")
            task.wait()
            i:Stop()
            i:Destroy()
        end
    end

    autocollectmoney = vape.Categories.Utility:CreateModule({
        Name = "AutoCollectMoney",
        Function = function(callback)
            if callback then 
                print("AutoCollectMoney enabled")
                
                -- Check existing money
                for _, obj in ipairs(workspace:GetDescendants()) do
                    OnDescendantAdded(obj)
                end
                
                connection = workspace.DescendantAdded:Connect(OnDescendantAdded)
            else
                print("AutoCollectMoney disabled")
                if connection then
                    connection:Disconnect()
                end
            end
        end
    })
end)
