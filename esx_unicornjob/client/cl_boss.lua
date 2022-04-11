Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

local function KeyboardInput(TextEntry, ExampleText, MaxStringLength)

	AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ':')
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end

local societymoney = {}

local function RefreshSocietyMoney(unicorn)
	if ESX.PlayerData.job.name == "unicorn" then
		ESX.TriggerServerCallback("esx_unicorn:argent", function(money)
			societymoney = money
		end, "society_unicorn")
	end
end

--- MENU ---
local open = false 
local mainMenu = RageUI.CreateMenu("Boss Actions", "Rodeo Scripts")
mainMenu:SetRectangleBanner(68, 0, 144, 255)
mainMenu.Closed = function()
  	open = false
end

function OpenMenuBoss()
	if open then 
		open = false
		RageUI.Visible(mainMenu, false)
		return
	else
		open = true 
		RageUI.Visible(mainMenu, true)
		CreateThread(function()
			while open do 
				RageUI.IsVisible(mainMenu,function()  

					RefreshSocietyMoney(unicorn)

					RageUI.Separator(("Argent : ~p~%s ~s~$"):format(tostring(societymoney)))

					RageUI.Button("~p~→ ~s~Deposer Argent", "~y~Information : ~s~Déposer de l'argent !", {RightLabel = "→→"}, true, {
						onSelected = function()
							local valueDeposit = KeyboardInput("Montant à déposer ?", "", 8)
							if valueDeposit ~= nil then
								TriggerServerEvent("esx_unicorn:deposerargent", tonumber(valueDeposit))
								RefreshSocietyMoney(unicorn)
							else
								ESX.ShowNotification("Merci de rentrer un montant de dépot !")
							end
							RefreshSocietyMoney(unicorn)
						end
					})
					RageUI.Button("~p~→ ~s~Retirer Argent", "~y~Information : ~s~Retirer de l'argent !", {RightLabel = "→→"}, true, {
						onSelected = function()
							local valueRetire = KeyboardInput("Montant à retirer ?", "", 8)
							if valueRetire ~= nil then
								TriggerServerEvent("esx_unicorn:retirerargent", tonumber(valueRetire))
								RefreshSocietyMoney(unicorn)
							else
								ESX.ShowNotification("Merci de rentrer un montant de retrait !")
							end
							RefreshSocietyMoney(unicorn)
						end
					})

					RageUI.Button("~p~→ ~s~Accéder aux actions de Management", nil, {RightLabel = "→→"}, true , {
						onSelected = function()
							TriggerEvent('esx_society:openBossMenu', 'unicorn', function(data, menu)
								menu.close()
							end, {wash = false})

							RageUI.CloseAll()
							Wait(500)
							open = false
						end
					})

				end)
			Wait(0)
			end
	 	end)
  	end
end

Citizen.CreateThread(function()
	while true do
		local interval = 250
		local playerPos = GetEntityCoords(PlayerPedId())
		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'unicorn' then
			for k,v in pairs(Config.PosBossActions) do
				local dst = #(v.pos-playerPos)
				if dst <= 10.0 then
					DrawMarker(22, v.pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 68, 0, 144, 255, true, false, true, true, false, false, false)
					interval = 0
					if dst <= 1.5 then
						ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au Boss Actions")
						if IsControlJustPressed(0, 51) then
							OpenMenuBoss()
						end
					end
				end
			end
		end
		Wait(interval)
	end
end)