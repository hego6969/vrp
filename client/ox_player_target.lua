local targetPerms = {}

local function refreshTargetPerms()
  targetPerms = lib.callback.await("vrp:targetPermissions", false) or {}
end

CreateThread(function()
  Wait(2000)
  refreshTargetPerms()
end)

RegisterNetEvent("vrp:refreshTargetPermissions", function()
  refreshTargetPerms()
end)

CreateThread(function()
  exports.ox_target:addGlobalPlayer({
    {
      name = "vrp_police_search",
      icon = "fa-solid fa-magnifying-glass",
      label = "Visiter",
      distance = 2.0,
      canInteract = function()
        return targetPerms.policeSearch == true
      end,
      onSelect = function()
        TriggerServerEvent("vrp:targetPoliceAction", "search")
      end
    },
    {
      name = "vrp_police_handcuff",
      icon = "fa-solid fa-handcuffs",
      label = "Håndjern / fjern håndjern",
      distance = 2.0,
      canInteract = function()
        return targetPerms.policeHandcuff == true
      end,
      onSelect = function()
        TriggerServerEvent("vrp:targetPoliceAction", "handcuff")
      end
    },
    {
      name = "vrp_police_putinveh",
      icon = "fa-solid fa-car",
      label = "Sæt i bil",
      distance = 2.0,
      canInteract = function()
        return targetPerms.policePutInVeh == true
      end,
      onSelect = function()
        TriggerServerEvent("vrp:targetPoliceAction", "putinveh")
      end
    },
    {
      name = "vrp_police_getoutveh",
      icon = "fa-solid fa-car-side",
      label = "Tag ud af bil",
      distance = 2.0,
      canInteract = function()
        return targetPerms.policeGetOutVeh == true
      end,
      onSelect = function()
        TriggerServerEvent("vrp:targetPoliceAction", "getoutveh")
      end
    },
    {
      name = "vrp_police_cpr",
      icon = "fa-solid fa-address-card",
      label = "CPR opslag",
      distance = 2.0,
      canInteract = function()
        return targetPerms.policeCpr == true
      end,
      onSelect = function()
        TriggerServerEvent("vrp:targetPoliceAction", "cpr")
      end
    },
    {
      name = "vrp_police_fine",
      icon = "fa-solid fa-money-bill",
      label = "Bøde",
      distance = 2.0,
      canInteract = function()
        return targetPerms.policeFine == true
      end,
      onSelect = function()
        TriggerServerEvent("vrp:targetPoliceAction", "fine")
      end
    },
    {
      name = "vrp_ems_revive",
      icon = "fa-solid fa-heart-pulse",
      label = "Genopliv",
      distance = 2.0,
      canInteract = function()
        return targetPerms.emsRevive == true
      end,
      onSelect = function()
        TriggerServerEvent("vrp:targetEmsAction", "revive")
      end
    },
    {
      name = "vrp_ems_heal",
      icon = "fa-solid fa-kit-medical",
      label = "Heal",
      distance = 2.0,
      canInteract = function()
        return targetPerms.emsHeal == true
      end,
      onSelect = function()
        TriggerServerEvent("vrp:targetEmsAction", "heal")
      end
    },
    {
      name = "vrp_ems_drag",
      icon = "fa-solid fa-truck-medical",
      label = "Træk person",
      distance = 2.0,
      canInteract = function()
        return targetPerms.emsDrag == true
      end,
      onSelect = function()
        TriggerServerEvent("vrp:targetEmsAction", "drag")
      end
    }
  })
end)