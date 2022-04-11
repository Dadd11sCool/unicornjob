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

--- MENU ---
local open = false 
local mainMenu = RageUI.CreateMenu("Bar Unicorn", "RODEO SCRIPTS")
mainMenu:SetRectangleBanner(68, 0, 144, 255)
mainMenu.Closed = function()
	open = false
end

function OpenMenuBar()
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

                RageUI.Separator("↓ ~p~Boissons ~s~↓")

				for k,v in pairs(Config.Boisson) do
					RageUI.Button(v.name, nil, {RightLabel = "→"}, true , {
						onSelected = function()
							TriggerServerEvent("esx_unicorn:"..v.label)
						end
					})
				end

				RageUI.Separator("↓ ~p~Nourritures ~s~↓")

				for k,v in pairs(Config.Nourriture) do
					RageUI.Button(v.name, nil, {RightLabel = "→"}, true , {
						onSelected = function()
							TriggerServerEvent("esx_unicorn:"..v.label)
						end
					})
				end

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
			for k,v in pairs(Config.PosBar) do
				local dst = #(v.pos-playerPos)
				if dst <= 5.0 then
					DrawMarker(22, v.pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 68, 0, 144, 255, true, false, true, true, false, false, false)
					interval = 0
					if dst <= 1.5 then
						ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au bar")
						if IsControlJustPressed(0, 51) then
							OpenMenuBar()
						end
					end
				end
			end
		end
		Wait(interval)
	end
end)