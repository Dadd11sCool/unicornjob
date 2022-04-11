TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'unicorn', 'alerte unicorn', true, true)

TriggerEvent('esx_society:registerSociety', 'unicorn', 'unicorn', 'society_unicorn', 'society_unicorn', 'society_unicorn', {type = 'public'})

--- ANNONCE OUVERTURE ---
RegisterServerEvent('Ouvre:Unicorn')
AddEventHandler('Ouvre:Unicorn', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Unicorn', '~p~Annonce', 'L\'Unicorn est désormais ~g~Ouvert~s~!', 'CHAR_MP_STRIPCLUB_PR', 8)
	end
end)

--- ANNONCE FERMETURE ---
RegisterServerEvent('Ferme:Unicorn')
AddEventHandler('Ferme:Unicorn', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Unicorn', '~p~Annonce', 'L\'Unicorn est désormais ~r~Fermer~s~!', 'CHAR_MP_STRIPCLUB_PR', 8)
	end
end)

--- NOURITURE DANS LE BAR ---
for k,v in pairs(Config.Nourriture) do
	RegisterNetEvent("esx_unicorn:"..v.label)
	AddEventHandler("esx_unicorn"..v.label, function()
		local _src = source
		local xPlayer = ESX.GetPlayerFromId(_src)

		xPlayer.addInventoryItem(v.label, 1)
	end)
end

--- BOISSON DANS LE BAR ---
for k,v in pairs(Config.Boisson) do
	RegisterNetEvent("esx_unicorn:"..v.label)
	AddEventHandler("esx_unicorn"..v.label, function()
		local _src = source
		local xPlayer = ESX.GetPlayerFromId(_src)

		xPlayer.addInventoryItem(v.label, 1)
	end)
end

--- ARGENT ---
ESX.RegisterServerCallback("esx_unicorn:argent", function(source, cb, Society)
	local info = MySQL.Sync.fetchAll('SELECT * FROM addon_account_data WHERE account_name = @account_name', {
        ['@account_name'] = Society
    })
    cb(info[1].money)
end)

--- DEPOSER ARGENT ---
RegisterNetEvent("esx_unicorn:deposerargent")
AddEventHandler("esx_unicorn:deposerargent", function(value)
    local xPlayer = ESX.GetPlayerFromId(source)

    if "unicorn" == xPlayer.getJob().name then
        if xPlayer.getMoney() >= value then
            TriggerEvent('esx_addonaccount:getSharedAccount', "society_unicorn", function(account)
                xPlayer.removeMoney(value)
                account.addMoney(value)
                TriggerClientEvent('esx:showNotification', xPlayer.source, '~p~Unicorn~n~~s~Vous avez déposer '..value..'$ !')
            end)
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, '~p~Unicorn~n~~s~Le montant d\'argent que tu as saisie n\'est pas bon !')
        end
    end
end)

--- RETIRER ARGENT ---
RegisterNetEvent("esx_unicorn:retirerargent")
AddEventHandler("esx_unicorn:retirerargent", function(value)
    local xPlayer = ESX.GetPlayerFromId(source)

    if "unicorn" == xPlayer.getJob().name then
        TriggerEvent('esx_addonaccount:getSharedAccount', "society_unicorn", function(account)
            if account.money >= value then
                account.removeMoney(value)
                xPlayer.addMoney(value)
                TriggerClientEvent('esx:showNotification', xPlayer.source, '~p~Unicorn~n~~s~Vous avez retirer '..value..'$ !')
            else
                TriggerClientEvent('esx:showNotification', xPlayer.source, '~p~Unicorn~n~~s~Le montant d\'argent que tu as saisie n\'est pas bon !')
            end
        end)
    end
end)