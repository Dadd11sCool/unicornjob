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

local spawnCar = function(car)
	for k,v in pairs(Config.Garage) do
		local car = GetHashKey(car)

		RequestModel(car)
		while not HasModelLoaded(car) do
			RequestModel(car)
			Wait(0)
		end

		local vehicle = CreateVehicle(car, v.SpawnPoint, true, true)
		SetEntityAsMissionEntity(vehicle, true, true)
		SetVehicleNumberPlateText(vehicle, "Unicorn") -- PLAQUE
        ESX.ShowNotification("~p~Unicorn~s~~n~Vous avez sortie un véhicule")
	end
end

--- MENU ---
local open = false 
local mainMenu = RageUI.CreateMenu("Garage", "Rodeo Scripts")
mainMenu:SetRectangleBanner(68, 0, 144, 255)
mainMenu.Closed = function()
    open = false
end

function OpenGarage()
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

                RageUI.Separator("↓ ~p~Véhicules ~s~↓")

                for k,v in pairs(Config.VehicleInGarage) do
                    RageUI.Button(v.name, nil, {RightLabel = "→→"}, true , {
                        onSelected = function()
                            spawnCar(v.label)
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
        for k,v in pairs(Config.Garage) do
            local dst = #(v.PosDuMenu-playerPos)
            if dst <= 1.5 then
                interval = 0
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au Garage")
                if IsControlJustPressed(0, 51) then
                    OpenGarage()
                end
            end

            local dst2 = #(v.DeletePoint-playerPos)
            if dst2 <= 10.0 then
                DrawMarker(36, v.DeletePoint, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 0, 0, 255, true, false, true, true, false, false, false)
                interval = 0
                if dst2 <= 1.5 then
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ranger votre véhicule")
                    if IsControlJustPressed(0, 51) then
						local car = GetVehiclePedIsIn(PlayerPedId(), false)
                        DeleteEntity(car)
                        ESX.ShowNotification("~p~Unicorn~s~~n~Vous avez ranger votre véhicule")
                    end
                end
            end
        end
        Wait(interval)
    end
end)