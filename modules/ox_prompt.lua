local oxPromptCallbacks = {}

local oldPrompt = vRP.prompt

function vRP.oxPrompt(player, title, default, cb)
  local requestId = tostring(math.random(100000, 999999))

  oxPromptCallbacks[requestId] = {
    cb = cb,
    player = player
  }

  TriggerClientEvent("vrp:oxPrompt", player, requestId, title, default or "")
end

function vRP.prompt(player, title, default, cb)
  vRP.oxPrompt(player, title, default, cb)
end

RegisterNetEvent("vrp:oxPromptResult")
AddEventHandler("vrp:oxPromptResult", function(requestId, result)
  local player = source
  local data = oxPromptCallbacks[requestId]

  if data == nil then return end
  if data.player ~= player then return end

  oxPromptCallbacks[requestId] = nil
  data.cb(player, result or "")
end)