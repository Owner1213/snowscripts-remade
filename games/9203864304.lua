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
local purchase = game:GetService("ReplicatedStorage"):WaitForChild("Purchase")

local vape = shared.vape
local tween = vape.Libraries.tween
local targetinfo = vape.Libraries.targetinfo
local getfontsize = vape.Libraries.getfontsize
local getcustomasset = vape.Libraries.getcustomasset
local sessioninfo = vape.Libraries.sessioninfo

purchase:FireServer("Roommate")

task.spawn(function()
    repeat task.wait() until workspace:FindFirstChild("Roommate")

    sessioninfo:AddItem("Roommate's rent amount", 0, function(val) return workspace.Roommate.Head.Amt.Value end, true)
    sessioninfo:AddItem("Can raise", "no", function(val) return workspace.Roommate.Head.CanRaise.Value and "yes" or "no" end, true)
end)

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
        if i.Name == "Money" then
            if i.Transparency then i.Transparency = 1 end
            local character = lplr.Character or lplr.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            
            if not humanoidRootPart then
                notif("AutoCollectMoney", "HumanoidRootPart not found!", 3, "warning")
                autocollectmoney:Toggle()
                task.wait(1)
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
        Tooltip = "removes the cash pickup sound"
    })
end)

run(function() 
    local houselights

    houselights = vape.Categories.World:CreateModule({
        Name = "Houselights",
        Function = function(callback)
            if callback then 
                repeat
                    workspace.Light:FindFirstChildWhichIsA("PointLight").Brightness = 0.4
                    task.wait()
                until not houselights.Enabled
            else
                repeat
                    workspace.Light:FindFirstChildWhichIsA("PointLight").Brightness = 0
                    task.wait()
                until not vape.Loaded
            end
        end,
        Tooltip = "Toggles the house's lights"
    })

    if workspace.Light:FindFirstChildWhichIsA("PointLight").Brightness > 0 and not houselights.Enabled then houselights:Toggle() end
end)

run(function()
    local chef
    local recipe
    local collectrecipe

    local CookingEvent = game:GetService("ReplicatedStorage"):WaitForChild("CookingEvent")
    local Purchase5 = game:GetService("ReplicatedStorage"):WaitForChild("Purchase5")

    local recipes = {
        ["Grilled Cheese"] = {
            Ingredients = {"Bread", "Cheese"},
            Temperature = 3
        },
        ["Pizza"] = {
            Ingredients = {"Flour", "Tomato", "Cheese"},
            Temperature = 2
        }
    }

    chef = vape.Categories.Utility:CreateModule({
        Name = "Chef",
        Function = function(callback)
            if callback then 
                if not recipe or not recipes[recipe.Value] then
                    notif("Chef", "Invalid or missing recipe.", 5, "warning")
                    return
                end
    
                local selectedRecipe = recipes[recipe.Value]
                local tempInWords = function(num)
                    return num == 1 and 'Low' or num == 2 and 'Medium' or 'High'
                end
    
                for _, ingredient in ipairs(selectedRecipe.Ingredients) do
                    Purchase5:FireServer(ingredient)
                    CookingEvent:FireServer("Add Ingredient", ingredient)
                    notif("Chef", "Purchased and Added to stove: ".. ingredient, 2.3)
                end
    
                CookingEvent:FireServer("Change Temperature", selectedRecipe.Temperature)
                notif("Chef", "Set temperature to:".. tempInWords(selectedRecipe.Temperature), 2.3)

                CookingEvent:FireServer("Cook")
                notif("Chef", "Cooking ".. recipe.Value, 5)

                chef:Toggle()

                workspace:WaitForChild(recipe.Value):GetChildren()[1].CFrame = lplr.Character:WaitForChild('HumanoidRootPart').CFrame
            end
        end
    })

    recipe = chef:CreateDropdown({
        Name = 'Recipe',
        List = {'Grilled Cheese', 'Pizza'},
        Function = function(val) end,
        Tooltip = 'Choose what recipe you want'
    })

    collectrecipe = chef:CreateToggle({
        Name = 'Collect Recipe',
        Function = function(val) end,
        Default = true,
        Tooltip = 'collects the recipe when done cooking'
    })
end)

run(function()
    local collectMeteorites
    local connection

    local function OnDescendantAdded(i)
        if i.Name == "Meteorite" and i:IsA("Tool") then
            local character = lplr.Character or lplr.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            
            if not humanoidRootPart then
                notif("CollectMeteorites", "HumanoidRootPart not found!", 3, "warning")
                collectMeteorites:Toggle()
                task.wait(1)
                return
            end

            i.CanCollide = false
            i.CFrame = humanoidRootPart.CFrame
        end
    end

    collectMeteorites = vape.Categories.World:CreateModule({
        Name = 'CollectMeteorites',
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
end)