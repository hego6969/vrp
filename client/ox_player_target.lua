local targetPerms = {}

local function refreshTargetPerms()
  TriggerServerEvent("vrp:requestTargetPermissions")
end

RegisterNetEvent("vrp:receiveTargetPermissions", function(perms)
  targetPerms = perms or {}
end)

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
      label = "Politi: Visiter",
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
      label = "Politi: Håndjern / fjern håndjern",
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
      label = "Politi: Sæt i bil",
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
      label = "Politi: Tag ud af bil",
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
      label = "Politi: CPR opslag",
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
      label = "Politi: Bøde",
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
      label = "EMS: Genopliv",
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
      label = "EMS: Heal",
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
      label = "EMS: Træk person",
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