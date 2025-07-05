-- credit toàn đẹp zai vcl
-- what are you looking at ???
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
	Name = "ayypwm hub | Build an Island V1 🇻🇳",
	LoadingTitle = "ayypwm Hub",
	LoadingSubtitle = "script loading",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "ayypwmhubIsland",
		FileName = "buildanislandayypwmhub"
	},
	KeySystem = false
})

local Tab_Info = Window:CreateTab("📄 Script Info", 4483362458)
Tab_Info:CreateParagraph({
	Title = "ayypwm Hub",
	Content = "Nokey Script"
})


Tab_Info:CreateParagraph({
    Title = "Support",
    Content = "If you find this script useful, please support me by passing through the link below so I have the motivation to develop the script. Thank you very much <3"
})

Tab_Info:CreateButton({
    Name = "Support via Linkvertise",
    Callback = function()
        setclipboard("https://link-hub.net/1365790/jeTrfosHqFEP") -- replace with your link
        warn("Support link copied to clipboard!")
    end
})

local Tab_Farm = Window:CreateTab("⚒️ Farm", 4483362458)

local SelectedPlayer = game.Players.LocalPlayer.Name
local AutoFarm = false
local PlayerList = {}
local Dropdown_FarmTarget = nil

local function getResources(playerName)
	local plots = game:GetService("Workspace"):WaitForChild("Plots")
	local targetPlot = plots:FindFirstChild(playerName)
	if targetPlot then
		return targetPlot:FindFirstChild("Resources")
	end
	return nil
end

Dropdown_FarmTarget = Tab_Farm:CreateDropdown({
	Name = "Select Island to Farm",
	Options = PlayerList,
	CurrentOption = SelectedPlayer,
	Flag = "FarmTarget",
	Callback = function(option)
		SelectedPlayer = option
		print("Island selected:", SelectedPlayer)
	end,
})

Tab_Farm:CreateButton({
	Name = "Update Players",
	Callback = function()
		PlayerList = {}
		for _, plr in ipairs(game.Players:GetPlayers()) do
			table.insert(PlayerList, plr.Name)
		end
		if Dropdown_FarmTarget then
			Dropdown_FarmTarget:UpdateOptions(PlayerList)
			print("Player list updated")
		end
	end,
})

Tab_Farm:CreateToggle({
	Name = "Auto Farm Entire Island (low-end PCs may drop to 0-10 FPS)",
	CurrentValue = false,
	Flag = "AutoFarm",
	Callback = function(state)
		AutoFarm = state
		if AutoFarm then
			print("Auto Farming island (low-end PCs may drop to 0-10 FPS):", SelectedPlayer)
			task.spawn(function()
				while AutoFarm do
					local res = getResources(SelectedPlayer)
					if res then
						for _, r in ipairs(res:GetChildren()) do
							if r:IsA("Model") then
								task.spawn(function()
									game:GetService("ReplicatedStorage")
										:WaitForChild("Communication")
										:WaitForChild("HitResource")
										:FireServer(r)
								end)
							end
						end
					end
					task.wait(0.5)
				end
			end)
		else
			print("Auto Farm is off (low-end PCs may drop to 0-10 FPS)")
		end
	end,
})

local expand_delay = 0.1

Tab_Farm:CreateToggle({
	Name = "Auto Island Upgrade",
	CurrentValue = false,
	Flag = "AutoExpand",
	Callback = function(Value)
		if Value then
			task.spawn(function()
				while Rayfield.Flags.AutoExpand.CurrentValue do
					local plr = game:GetService("Players").LocalPlayer
					local plot = workspace:WaitForChild("Plots"):FindFirstChild(plr.Name)
					if plot then
						local expand = plot:FindFirstChild("Expand")
						if expand then
							for _, exp in ipairs(expand:GetChildren()) do
								local top = exp:FindFirstChild("Top")
								if top then
									local bGui = top:FindFirstChild("BillboardGui")
									if bGui then
										for _, contribute in ipairs(bGui:GetChildren()) do
											if contribute:IsA("Frame") and contribute.Name ~= "Example" then
												local args = {
													exp.Name,
													contribute.Name,
													1
												}
												game:GetService("ReplicatedStorage")
													:WaitForChild("Communication")
													:WaitForChild("ContributeToExpand")
													:FireServer(unpack(args))
											end
										end
									end
								end
								task.wait(0.01)
							end
						end
					end
					task.wait(expand_delay)
				end
			end)
		end
	end,
})

Tab_Farm:CreateSlider({
	Name = "Expand Delay (seconds)",
	Range = {0.1, 5},
	Increment = 0.1,
	Suffix = "s",
	CurrentValue = expand_delay,
	Flag = "ExpandDelay",
	Callback = function(v)
		expand_delay = v
	end,
})

local Tab_Craft = Window:CreateTab("🛠️ Craft", 4483362458)
Tab_Craft:CreateParagraph({
	Title = "",
	Content = "beta"
})

local selected_crafter = nil
local auto_craft_enabled = false
local craft_delay = 2
local crafter_dropdown = nil

local function getCrafters()
	local list = {}
	for _, c in pairs(game:GetService("Workspace").Plots[game.Players.LocalPlayer.Name]:GetDescendants()) do
		if c.Name == "Crafter" then
			local attachment = c:FindFirstChildOfClass("Attachment")
			if attachment then
				table.insert(list, c:GetFullName())
			end
		end
	end
	return list
end

crafter_dropdown = Tab_Craft:CreateDropdown({
	Name = "Select Craft Item",
	Options = getCrafters(),
	CurrentOption = "",
	Flag = "SelectCraftTarget",
	Callback = function(value)
		selected_crafter = value
		print("Selected:", value)
	end,
})

Tab_Craft:CreateButton({
	Name = "Refresh Crafter List",
	Callback = function()
		local new_list = getCrafters()
		crafter_dropdown:Refresh(new_list)
		print("Crafter list refreshed")
	end,
})

Tab_Craft:CreateSlider({
	Name = "Craft Delay (seconds)",
	Range = {1, 20},
	Increment = 1,
	CurrentValue = 2,
	Flag = "CraftDelay",
	Callback = function(Value)
		craft_delay = Value
		print("🛠️ Craft Delay:", Value .. " seconds")
	end,
})

Tab_Craft:CreateToggle({
	Name = "Auto Craft",
	CurrentValue = false,
	Flag = "AutoCraft",
	Callback = function(Value)
		auto_craft_enabled = Value
		if Value then
			print("Auto Craft enabled")
			task.spawn(function()
				while auto_craft_enabled and selected_crafter do
					local crafter = nil
					pcall(function()
						crafter = loadstring("return " .. selected_crafter)()
					end)
					if crafter then
						local attachment = crafter:FindFirstChildOfClass("Attachment")
						if attachment then
							game:GetService("ReplicatedStorage"):WaitForChild("Communication"):WaitForChild("Craft"):FireServer(attachment)
							print("🧪 Crafting at:", crafter:GetFullName())
						end
					end
					task.wait(craft_delay)
				end
			end)
		else
			print("Auto Craft disabled")
		end
	end
})

local Tab_Shop = Window:CreateTab("🛒 Shop", 4483362458)
Tab_Shop:CreateParagraph({
	Title = "beta",
	Content = "talk to the NPC merchant and buy a few items for the script to load items to buy"
})

local timerLabel

timerLabel = Tab_Shop:CreateParagraph({
	Title = "Shop resets in...",
	Content = "Loading..."
})

task.spawn(function()
	while true do
		local gui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
		if gui then
			local timer = gui:FindFirstChild("Main")
				and gui.Main:FindFirstChild("Menus")
				and gui.Main.Menus:FindFirstChild("Merchant")
				and gui.Main.Menus.Merchant.Inner
				and gui.Main.Menus.Merchant.Inner:FindFirstChild("Timer")

			if timer and timer:IsA("TextLabel") then
				timerLabel:Set({
					Title = "Merchant shop resets in:",
					Content = timer.Text
				})
			end
		end
		task.wait(1)
	end
end)

local selectedItems = {}
local shownItems = {}
local allItems = {}
local autoBuying = false

task.spawn(function()
	while true do
		local gui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
		if gui and gui:FindFirstChild("Main") and gui.Main:FindFirstChild("Menus") then
			local merchant = gui.Main.Menus:FindFirstChild("Merchant")
			if merchant and merchant.Visible and merchant.Inner then
				local frame = merchant.Inner:FindFirstChild("ScrollingFrame")
				if frame and frame:FindFirstChild("Hold") then
					for _, item in ipairs(frame.Hold:GetChildren()) do
						if item:IsA("Frame") and item.Name ~= "Example" and not table.find(shownItems, item.Name) then
							table.insert(allItems, item.Name)
							table.insert(shownItems, item.Name)

							Tab_Shop:CreateToggle({
								Name = item.Name,
								CurrentValue = false,
								Callback = function(state)
									if state then
										table.insert(selectedItems, item.Name)
									else
										for i, v in ipairs(selectedItems) do
											if v == item.Name then
												table.remove(selectedItems, i)
												break
											end
										end
									end
								end
							})
						end
					end
				end
			end
		end
		task.wait(5)
	end
end)

Tab_Shop:CreateToggle({
	Name = "Auto Buy Selected Items",
	CurrentValue = false,
	Callback = function(state)
		autoBuying = state
		if autoBuying then
			task.spawn(function()
				while autoBuying do
					for _, item in ipairs(selectedItems) do
						local args = {
							[1] = item,
							[2] = false
						}
						game:GetService("ReplicatedStorage").Communication.BuyFromMerchant:FireServer(unpack(args))
						task.wait(0.25)
					end
					task.wait(1)
				end
			end)
		end
	end
})

Tab_Shop:CreateParagraph({
	Title = "Shop Reset",
	Content = "List automatically updates when shop is opened"
})

local Tab_Sell = Window:CreateTab("💰 Sell", 4483362458)
Tab_Sell:CreateParagraph({
	Title = "",
	Content = "beta."
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local plr = Players.LocalPlayer

local AutoSell = false

Tab_Sell:CreateToggle({
	Name = "Auto Sell (every 3 seconds)",
	CurrentValue = false,
	Flag = "AutoSell",
	Callback = function(Value)
		AutoSell = Value
		if AutoSell then
			task.spawn(function()
				while AutoSell do
					for _, item in pairs(plr.Backpack:GetChildren()) do
						if item:GetAttribute("Sellable") then
							local hash = item:GetAttribute("Hash")
							if hash then
								ReplicatedStorage.Communication.SellToMerchant:FireServer(false, {hash})
								print("💰 Sold:", item.Name)
							end
						end
					end
					task.wait(3)
				end
			end)
		end
	end
})

local Tab_Collect = Window:CreateTab("📦 Collect", 4483362458)
Tab_Collect:CreateParagraph({
	Title = "Fish harvesting feature will be updated later",
	Content = ""
})

Tab_Collect:CreateToggle({
	Name = "Auto Harvest Plants",
	CurrentValue = false,
	Flag = "AutoHarvest",
	Callback = function(Value)
		getgenv().CollectHarvest = Value
		task.spawn(function()
			while getgenv().CollectHarvest do
				local plot = game:GetService("Workspace"):WaitForChild("Plots"):FindFirstChild(game.Players.LocalPlayer.Name)
				if plot and plot:FindFirstChild("Plants") then
					for _, crop in pairs(plot.Plants:GetChildren()) do
						game:GetService("ReplicatedStorage"):WaitForChild("Communication"):WaitForChild("Harvest"):FireServer(crop.Name)
					end
				end
				task.wait()
			end
		end)
	end
})

Tab_Collect:CreateToggle({
	Name = "Auto Collect Honey",
	CurrentValue = false,
	Flag = "AutoHoney",
	Callback = function(Value)
		getgenv().CollectHoney = Value
		task.spawn(function()
			while getgenv().CollectHoney do
				local land = game:GetService("Workspace"):WaitForChild("Plots"):FindFirstChild(game.Players.LocalPlayer.Name):FindFirstChild("Land")
				for _, spot in ipairs(land:GetDescendants()) do
					if spot:IsA("Model") and spot.Name:match("Spot") then
						game:GetService("ReplicatedStorage"):WaitForChild("Communication"):WaitForChild("Hive"):FireServer(spot.Parent.Name, spot.Name, 2)
					end
				end
				task.wait()
			end
		end)
	end
})

Tab_Collect:CreateToggle({
	Name = "Auto Collect Gold",
	CurrentValue = false,
	Flag = "AutoGold",
	Callback = function(Value)
		getgenv().CollectGold = Value
		task.spawn(function()
			while getgenv().CollectGold do
				local land = game:GetService("Workspace"):WaitForChild("Plots"):FindFirstChild(game.Players.LocalPlayer.Name):FindFirstChild("Land")
				for _, mine in pairs(land:GetDescendants()) do
					if mine:IsA("Model") and mine.Name == "GoldMineModel" then
						game:GetService("ReplicatedStorage"):WaitForChild("Communication"):WaitForChild("Goldmine"):FireServer(mine.Parent.Name, 2)
					end
				end
				task.wait()
			end
		end)
	end
})

local Tab_Events = Window:CreateTab("🎉 Events", 4483362458)
Tab_Events:CreateParagraph({
	Title = "No features yet",
	Content = "Events feature will be updated later :(("
})

local Tab_Misc = Window:CreateTab("🧩 Misc", 4483362458)
Tab_Misc:CreateParagraph({
	Title = "",
	Content = "beta"
})

local AntiAFKConnection = nil

Tab_Misc:CreateToggle({
	Name = "Anti-AFK",
	CurrentValue = false,
	Flag = "AntiAFK",
	Callback = function(Value)
		if Value then
			local vu = game:GetService("VirtualUser")
			AntiAFKConnection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
				vu:CaptureController()
				vu:ClickButton2(Vector2.new())
				print("AFK bypass simulated")
			end)
			print("Anti-AFK Enabled")
		else
			if AntiAFKConnection then
				AntiAFKConnection:Disconnect()
				AntiAFKConnection = nil
				print("Anti-AFK Disabled")
			end
		end
	end,
})


Tab_Misc:CreateSlider({
	Name = "Player Speed",
	Range = {16, 50},
	Increment = 1,
	CurrentValue = 16,
	Flag = "WalkSpeed",
	Callback = function(Value)
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
	end,
})


Tab_Misc:CreateToggle({
	Name = "Infinity Jump",
	CurrentValue = false,
	Flag = "InfJump",
	Callback = function(state)
		if state then

			infJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
				local player = game.Players.LocalPlayer
				local character = player.Character or player.CharacterAdded:Wait()
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
				end
			end)
		else

			if infJumpConnection then
				infJumpConnection:Disconnect()
			end
		end
	end,
})

Tab_Misc:CreateButton({
	Name = "Rejoin Server (only works on public servers)",
	Callback = function()
		local ts = game:GetService("TeleportService")
		local plr = game.Players.LocalPlayer
		ts:Teleport(game.PlaceId, plr)
	end,
})

