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
    shared.vape:CreateNotification(...)
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

local oFireProximityPrompt = fireproximityprompt
fireproximityprompt = function(prompt)
    if typeof(prompt) ~= "Instance" or not prompt:IsA("ProximityPrompt") then
        error("Invalid ProximityPrompt instance")
    end

    local success, result = pcall(function()
        oFireProximityPrompt(Instance.new("ProximityPrompt"))
    end)

    if not success or result ~= nil then
        prompt:InputHoldBegin(playersService.LocalPlayer)
        task.wait(prompt.HoldDuration + 0.1)
        prompt:InputHoldEnd(playersService.LocalPlayer)
    else
        oFireProximityPrompt(prompt)
    end
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

run(function() 
    local Plant
    local dropdown

    local t = {}

    for _, v in pairs(lplr.PlayerGui:WaitForChild('Market').CropsList) do
        if v:IsA('TextButton') then 
            table.insert(t, v.Name)
        end
    end

    local PlantAll = replicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("PlantCrop"):WaitForChild("PlantAll")

    Plant = vape.Categories.Blatant:CreateModule({
        Name = 'PlantExploit',
        Function = function(callback) 
            if callback then 
                PlantAll:FireServer('Pumpkin')
                Plant:Toggle()
            end
        end,
        Tooltip = 'Plant anything you want'
    })

    dropdown = Plant:CreateDropdown({
        Name = 'Plant',
        List = t,
        Function = function(val)
            print(val, 'dropdown value changed')
        end,
        Tooltip = 'This is a test dropdown.'
    })
end)