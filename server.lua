--ESX INIT--

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--VARIABLES INIT--

local balances = {}

local _source = source
local xPlayer = ESX.GetPlayerFromId(_source)

--FUNCTIONS

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.abs(math.floor(num * mult + 0.5) / mult)
end

--EVENTS--

RegisterServerEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if amount >= 10 and amount <= xPlayer.getMoney() then
      xPlayer.removeMoney(amount)
      xPlayer.addAccountMoney('bank', amount)
      TriggerClientEvent("pNotify:SendNotification", source, {
        text = "Vous avez déposé : <b style='color:LightGreen'>" .. amount .. "$</b> dans votre compte en banque",
        type = "success",
        queue = "global",
        timeout = 5000,
        layout = "bottomRight"
        })
    else
      TriggerClientEvent("pNotify:SendNotification", source, {
        text = "Montant <b style='color:Red'>invalide</b>",
        type = "error",
        queue = "global",
        timeout = 4000,
        layout = "bottomRight"
        })
    end
end)

RegisterServerEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    amount = tonumber(amount)
    base = xPlayer.getAccount('bank').money

    if amount <= base then
      xPlayer.removeAccountMoney('bank', amount)
      xPlayer.addMoney(amount)
      TriggerClientEvent("pNotify:SendNotification", source, {
        text = "Vous avez retiré : <b style='color:LightGreen'>" .. amount .. "$</b> de votre compte en banque",
        type = "success",
        queue = "global",
        timeout = 5000,
        layout = "bottomRight"
        })
    else
      TriggerClientEvent("pNotify:SendNotification", source, {
        text = "Montant <b style='color:Red'>invalide</b>",
        type = "error",
        queue = "global",
        timeout = 4000,
        layout = "bottomRight"
        })
    end
end)

RegisterServerEvent('bank:transfer')
AddEventHandler('bank:transfer', function(toPlayer, amount)

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
  local zPlayer = ESX.GetPlayerFromId(toPlayer)

  local nomexpe = GetPlayerName(_source)
  local nomrece = GetPlayerName(toPlayer)
  
  local bankflouze = 0
  
	bankflouze = xPlayer.getAccount('bank').money
	zbankflouze = zPlayer.getAccount('bank').money
	
	if tonumber(_source) == tonumber(toPlayer) then
		TriggerClientEvent("pNotify:SendNotification", _source, {
      text = "Vous ne pouvez pas vous transferer a vous même",
      type = "error",
      queue = "global",
      timeout = 5000,
      layout = "bottomRight"
    })
	else
		if bankflouze <= 0 or bankflouze < tonumber(amount) or tonumber(amount) <= 0 then
			TriggerClientEvent("pNotify:SendNotification", _source, {
        text = "Vous n'avez pas assez d'argent dans votre compte",
        type = "error",
        queue = "global",
        timeout = 5000,
        layout = "bottomRight"
      })
		else
			xPlayer.removeAccountMoney('bank', amount)
      TriggerClientEvent("pNotify:SendNotification", source, {
        text = "Vous avez envoyé : <b style='color:LightGreen'>" .. amount .. "$</b> à " .. nomrece,
        type = "success",
        queue = "global",
        timeout = 5000,
        layout = "bottomRight"
      })
			zPlayer.addAccountMoney('bank', amount)
      TriggerClientEvent("pNotify:SendNotification", toPlayer, {
        text = "Vous avez reçu : <b style='color:LightGreen'>" .. amount .. "$</b> de la part de : " .. nomexpe,
        type = "success",
        queue = "global",
        timeout = 5000,
        layout = "bottomRight"
      })
		end
	end
end)