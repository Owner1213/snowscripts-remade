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

    sessioninfo:AddItem("Roommate's rent amount", 0, function(val) return workspace.Roommate.Head.Amt.Value == 1000000000 and "max" or workspace.Roommate.Head.Amt.Value end, true)
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
        if i.Name == "Money" and not i:IsA("Model") then
            pcall(function() i.Transparency = 1 end)
            local character = lplr.Character or lplr.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
            if not humanoidRootPart then
                notif("CollectMeteorites", "HumanoidRootPart not found within timeout!", 3, "warning")
                collectMeteorites:Toggle()
                task.wait(1)
                return
            end
            
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
                    if obj:IsA("Tool") and obj.Name == "Meteorite" then
                        OnDescendantAdded(obj)
                    end
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

    local function hasSSitems(inventory)
        local count = 0

        for _, item in ipairs(inventory) do
            if item:IsA("Instance") and item.Name then
                if item.Name == "Meteorite" then
                    count += 1
                elseif item.Name == "Almond Water" then
                    count += 1
                end
            end
        end

        return count >= 4
    end

    local recipes = {
        ["Grilled Cheese"] = {
            Ingredients = {"Bread", "Cheese"},
            Temperature = 3
        },
        ["Pizza"] = {
            Ingredients = {"Flour", "Tomato", "Cheese"},
            Temperature = 2
        },
        ["Spaghetti"] = {
            Ingredients = {"Beef", "Tomato", "Noodles"},
            Temperature = 2
        },
        ["Cake"] = {
            Ingredients = {"Egg", "Milk", "Sugar", "Flour"},
            Temperature = 1
        },
        ["Ramen"] = {
            Ingredients = {"Noodles", "Egg", "Soy Sauce"},
            Temperature = 2
        },
        ["Mac & Cheese"] = {
            Ingredients = {"Cheese", "Noodles", "Milk"},
            Temperature = 2
        },
        ["Salad"] = {
            Ingredients = {"Lettuce", "Lettuce", "Tomato"},
            Temperature = 3
        },
        ["Burger"] = {
            Ingredients = {"Bread", "Beef", "Lettuce", "Tomato"},
            Temperature = 1
        },
        ["Space Soup"] = {
            Ingredients = {"Almond Water", "Almond Water", "Meteorite", "Meteorite"},
            Temperature = 1
        }
    }
    
    local function getRecipeList() 
        local t = {}
    
        for recipeName, _ in pairs(recipes) do 
            table.insert(t, recipeName)
        end
    
        return t
    end

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
    
                if recipe.Value ~= "Space Soup" then 
                    for _, ingredient in ipairs(selectedRecipe.Ingredients) do
                        Purchase5:FireServer(ingredient)
                        CookingEvent:FireServer("Add Ingredient", ingredient)
                        notif("Chef", "Purchased and Added to stove: ".. ingredient, 2.3)
                    end
                else
                    if not hasSSitems(lplr.Backpack:GetChildren()) then 
                        notif('Chef', "You need at least 2 meteorites and 2 almond waters!", 4, 'warning')
                    end

                    for _, ingredient in ipairs(selectedRecipe.Ingredients) do
                        CookingEvent:FireServer("Add Ingredient", ingredient)
                        notif("Chef", ingredient ~= 'Meteorite' and "Purchased and Added to stove: ".. ingredient or "Added to stove: ".. ingredient, 2.3)
                    end
                end

                CookingEvent:FireServer("Change Temperature", selectedRecipe.Temperature)
                notif("Chef", "Set temperature to:".. tempInWords(selectedRecipe.Temperature), 2.3)

                CookingEvent:FireServer("Cook")
                notif("Chef", "Cooking ".. recipe.Value, 5)

                local recipeObject = workspace:WaitForChild(recipe.Value, 60)
                if recipeObject then
                    local obj = recipeObject:GetChildren()[1]
                    if obj and obj.CanCollide then obj.CanCollide = false end
                    if obj then
                        obj.CFrame = lplr.Character:WaitForChild('HumanoidRootPart').CFrame
                    else
                        notif("AutoCollectRecipe", "Failed to find a valid object for the recipe.", 5, "warning")
                    end
                else
                    notif("AutoCollectRecipe", "Recipe object not found within the timeout period.", 5, "warning")
                end
                if obj.CanCollide then obj.CanCollide = false end
                obj.CFrame = lplr.Character:WaitForChild('HumanoidRootPart').CFrame
            end
        end
    })

    recipe = chef:CreateDropdown({
        Name = 'Recipe',
        List = getRecipeList(),
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
        local humanoidRootPart = lplr.Character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            notif("CollectMeteorites", "HumanoidRootPart not found!", 3, "warning")
            return
        end

        local children = i:GetChildren()
        if #children == 0 then
            if not i.Notified then
                notif("CollectMeteorites", "Meteorite tool has no children!", 3, "warning")
                i.Notified = true
            end
            return
        end

        local child = children[1]
        if not child or not child:IsA("BasePart") then
            if not i.Notified then
                notif("CollectMeteorites", "Invalid or missing child for Meteorite tool!", 3, "warning")
                i.Notified = true
            end
            return
        end

        child.CanCollide = false
        child.CFrame = humanoidRootPart.CFrame
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
                    connection = nil
                end
            end
        end
    })
end)
