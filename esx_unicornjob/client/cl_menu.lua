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

local function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)

    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
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

function OpenBillingMenu()
	  
	local amount = KeyboardInput("AMENDE UNICORN", "", 5)
	local player, distance = ESX.Game.GetClosestPlayer()

	if player ~= -1 and distance <= 3.0 then

		if amount == nil then
			ESX.ShowNotification("~r~Problèmes~s~: Montant invalide")
		else
		local playerPed = GetPlayerPed(-1)
		TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', 0, true)
		Citizen.Wait(5000)
			TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_unicorn', ('unicorn'), amount)
			ESX.ShowNotification("~p~Unicorn~n~~s~Vous avez bien envoyer la facture")
		end

	else
		ESX.ShowNotification("~p~Unicorn~n~~s~Aucun joueur à proximitée !")
	end
end

-- MENU FUNCTION --
local open = false 
local mainMenu = RageUI.CreateMenu('Unicorn', 'Rodeo Life')
local subMenu = RageUI.CreateSubMenu(mainMenu, "Annonces", "Rodeo Life")
mainMenu:SetRectangleBanner(68, 0, 144, 255)
subMenu:SetRectangleBanner(68, 0, 144, 255)
mainMenu.Closed = function()
  	open = false
end

function OpenMenuF6()
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

				RageUI.Button("Annonces", nil, {RightLabel = "→→"}, true , {}, subMenu)

				RageUI.Button("Faire une Facture", nil, {RightLabel = "→→"}, true , {
					onSelected = function()
						OpenBillingMenu()
					end
				})

			end)

			RageUI.IsVisible(subMenu,function() 

				RageUI.Button("Annonce Ouvertures", nil, {RightLabel = "→"}, true , {
					onSelected = function()
						TriggerServerEvent('Ouvre:Unicorn')
					end
				})

				RageUI.Button("Annonce Fermetures", nil, {RightLabel = "→"}, true , {
					onSelected = function()
						TriggerServerEvent('Ferme:Unicorn')
					end
				})

		   	end)
		 Wait(0)
		end
	 end)
  end
end

--- OUVERTURE DU MENU ---
Keys.Register('F6', 'Unicorn', 'Ouvrir le menu Unicorn', function()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'unicorn' then
    	OpenMenuF6()
	end
end)