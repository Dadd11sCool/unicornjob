--- PED ---
Citizen.CreateThread(function()
    for k,v in pairs(Config.Ped) do
        local hash = GetHashKey(v.name)
        while not HasModelLoaded(hash) do
        RequestModel(hash)
        Wait(20)
        end
        ped = CreatePed("PED_TYPE_CIVFEMALE", v.name, v.pos, false, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        FreezeEntityPosition(ped, true)
    end
end)

--- BLIPS ---
Citizen.CreateThread(function()
    for k,v in pairs(Config.Blips) do

        local blip = AddBlipForCoord(v.PosBlips)

        SetBlipSprite (blip, v.model) -- Model du blip
        SetBlipDisplay(blip, 4)
        SetBlipScale  (blip, v.taille) -- Taille du blip
        SetBlipColour (blip, v.color) -- Couleur du blip
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(v.name) -- Nom du blip
        EndTextCommandSetBlipName(blip)
    end
end)
