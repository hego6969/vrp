local lang = vRP.lang

local OX_RESOURCE = 'ox_inventory'
local ox = exports.ox_inventory

local old = {
  getMoney = vRP.getMoney,
  setMoney = vRP.setMoney,
  tryPayment = vRP.tryPayment,
  giveMoney = vRP.giveMoney,
  giveInventoryItem = vRP.giveInventoryItem,
  tryGetInventoryItem = vRP.tryGetInventoryItem,
  getInventoryItemAmount = vRP.getInventoryItemAmount,
  getInventoryWeight = vRP.getInventoryWeight,
  getInventoryMaxWeight = vRP.getInventoryMaxWeight,
  clearInventory = vRP.clearInventory,
  openInventory = vRP.openInventory,
  openChest = vRP.openChest
}

local function oxStarted()
  return GetResourceState(OX_RESOURCE) == 'started'
end

local function oxCall(name, ...)
  if not oxStarted() then return nil end

  local fn = ox[name]
  if type(fn) ~= "function" then return nil end

  local ok, result = pcall(fn, ox, ...)
  if not ok then return nil end

  return result
end

local function oxItem(name)
  return oxCall('Items', name)
end

local function mapLegacyItemName(idname)
  if type(idname) ~= 'string' then return idname end

  local weaponName = idname:match('^wbody|(.+)$')
  if weaponName and weaponName:match('^WEAPON_') then
    return weaponName
  end

  weaponName = idname:match('^wammo|(.+)$')
  if weaponName then
    local weaponItem = oxItem(weaponName)

    if weaponItem and weaponItem.ammoname then
      return weaponItem.ammoname
    end
  end

  return idname
end

local function shouldShadowItem(itemName)
  local item = oxItem(itemName)

  if item and (item.weapon or item.ammoname or item.ammo) then
    return false
  end

  return type(itemName) ~= 'string' or not itemName:match('^ammo%-')
end

local function sourceFromUserId(user_id)
  if not user_id then return nil end
  return vRP.getUserSource(user_id)
end

local function notify(source, text, notifyType)
  if source then
    TriggerClientEvent("pNotify:SendNotification", source, {
      text = text,
      type = notifyType or "info",
      queue = "global",
      timeout = 3000,
      layout = "centerRight"
    })
  end
end

local function oxInventory(source)
  if not oxStarted() or not source then return nil end
  return oxCall('GetInventory', source)
end

local function syncShadowInventory(user_id)
  local source = sourceFromUserId(user_id)
  local inv = oxInventory(source)
  local data = vRP.getUserDataTable(user_id)

  if not inv or not data then return end

  data.inventory = {}

  for _, item in pairs(inv.items or {}) do
    if item and item.name and item.count and item.count > 0 and item.name ~= 'money' and shouldShadowItem(item.name) then
      data.inventory[item.name] = {
        amount = (data.inventory[item.name] and data.inventory[item.name].amount or 0) + item.count
      }
    end
  end
end

local function moneyCount(user_id)
  local source = sourceFromUserId(user_id)
  if not oxStarted() or not source then
    return old.getMoney(user_id)
  end

  return oxCall('GetItemCount', source, 'money') or old.getMoney(user_id)
end

function vRP.getMoney(user_id)
  return moneyCount(user_id)
end

function vRP.setMoney(user_id, value)
  local source = sourceFromUserId(user_id)

  if not oxStarted() or not source then
    return old.setMoney(user_id, value)
  end

  value = math.max(0, math.floor(tonumber(value) or 0))
  local success = oxCall('SetItem', source, 'money', value)

  if success == nil then
    return old.setMoney(user_id, value)
  end

  old.setMoney(user_id, value)

  return success
end

function vRP.tryPayment(user_id, amount)
  local source = sourceFromUserId(user_id)

  amount = math.floor(tonumber(amount) or 0)
  if amount <= 0 then return false end

  if not oxStarted() or not source then
    return old.tryPayment(user_id, amount)
  end

  local success = oxCall('RemoveItem', source, 'money', amount)

  if success == true then
    old.setMoney(user_id, math.max(0, old.getMoney(user_id) - amount))
  end

  return success == true
end

function vRP.giveMoney(user_id, amount)
  local source = sourceFromUserId(user_id)

  amount = math.floor(tonumber(amount) or 0)
  if amount <= 0 then return false end

  if not oxStarted() or not source then
    return old.giveMoney(user_id, amount)
  end

  local success = oxCall('AddItem', source, 'money', amount)

  if success then
    old.setMoney(user_id, old.getMoney(user_id) + amount)
    return success
  end

  return old.giveMoney(user_id, amount)
end

function vRP.giveInventoryItem(user_id, idname, amount, shouldNotify)
  local source = sourceFromUserId(user_id)

  amount = math.floor(tonumber(amount) or 0)
  if amount <= 0 then return false end

  if not oxStarted() or not source then
    return old.giveInventoryItem(user_id, idname, amount, shouldNotify)
  end

  local oxName = mapLegacyItemName(idname)
  local success = oxCall('AddItem', source, oxName, amount)

  if success == nil then
    return old.giveInventoryItem(user_id, idname, amount, shouldNotify)
  end

  if success then
    syncShadowInventory(user_id)

    if shouldNotify ~= false then
      notify(source, ("Modtog %sx %s"):format(amount, vRP.getItemName(idname)), "success")
    end
  end

  return success
end

function vRP.tryGetInventoryItem(user_id, idname, amount, shouldNotify)
  local source = sourceFromUserId(user_id)

  amount = math.floor(tonumber(amount) or 0)
  if amount <= 0 then return false end

  if not oxStarted() or not source then
    return old.tryGetInventoryItem(user_id, idname, amount, shouldNotify)
  end

  local oxName = mapLegacyItemName(idname)
  local success = oxCall('RemoveItem', source, oxName, amount)

  if success == nil then
    return old.tryGetInventoryItem(user_id, idname, amount, shouldNotify)
  end

  if success then
    syncShadowInventory(user_id)

    if shouldNotify ~= false then
      notify(source, ("Fjernede %sx %s"):format(amount, vRP.getItemName(idname)), "info")
    end
  elseif shouldNotify ~= false then
    notify(source, ("Du mangler %sx %s"):format(amount, vRP.getItemName(idname)), "error")
  end

  return success == true
end

function vRP.getInventoryItemAmount(user_id, idname)
  local source = sourceFromUserId(user_id)

  if not oxStarted() or not source then
    return old.getInventoryItemAmount(user_id, idname)
  end

  return oxCall('GetItemCount', source, mapLegacyItemName(idname)) or old.getInventoryItemAmount(user_id, idname)
end

function vRP.hasInventoryItem(user_id, idname)
  return vRP.getInventoryItemAmount(user_id, idname) > 0
end

function vRP.getInventoryWeight(user_id)
  local source = sourceFromUserId(user_id)
  local inv = oxInventory(source)

  if not inv then
    return old.getInventoryWeight(user_id)
  end

  return (inv.weight or 0) / 1000
end

function vRP.getInventoryMaxWeight(user_id)
  local source = sourceFromUserId(user_id)
  local inv = oxInventory(source)

  if not inv then
    return old.getInventoryMaxWeight(user_id)
  end

  return (inv.maxWeight or GetConvarInt('inventory:weight', 30000)) / 1000
end

function vRP.clearInventory(user_id)
  local source = sourceFromUserId(user_id)

  if not oxStarted() or not source then
    return old.clearInventory(user_id)
  end

  local fn = ox.ClearInventory
  local ok = type(fn) == "function" and pcall(fn, ox, source)

  if not ok then
    return old.clearInventory(user_id)
  end

  syncShadowInventory(user_id)
end

function vRP.openInventory(source)
  if not oxStarted() then
    return old.openInventory(source)
  end

  TriggerClientEvent('ox_inventory:vrp:openInventory', source)
end

function vRP.openChest(source, name, max_weight, cb_close, cb_in, cb_out)
  if not oxStarted() then
    return old.openChest(source, name, max_weight, cb_close, cb_in, cb_out)
  end

  local stashWeight = math.floor((tonumber(max_weight) or 50) * 1000)

  pcall(function()
    oxCall('RegisterStash', name, name, 100, stashWeight, false)
  end)

  TriggerClientEvent('ox_inventory:openInventory', source, 'stash', {
    id = name
  })
end

AddEventHandler('vRP:playerSpawn', function(user_id, source, first_spawn)
  if first_spawn then
    SetTimeout(3000, function()
      syncShadowInventory(user_id)
    end)
  end
end)

CreateThread(function()
  while true do
    Wait(15000)

    if oxStarted() then
      for user_id in pairs(vRP.getUsers()) do
        syncShadowInventory(tonumber(user_id))
      end
    end
  end
end)

print('[vRP] ox_inventory compatibility layer loaded')
