RegisterNetEvent("vrp:openOxPoliceMenu", function(title, options)
  local menuOptions = {}

  for _, option in ipairs(options) do
    menuOptions[#menuOptions + 1] = {
      title = option.title,
      description = option.description,
      icon = option.icon or "shield-halved",
      serverEvent = "vrp:oxPoliceMenuSelect",
      args = {
        action = option.action
      }
    }
  end

  lib.registerContext({
    id = "vrp_police_menu",
    title = title or "Politi",
    position = "top-right",
    options = menuOptions
  })

  lib.showContext("vrp_police_menu")
end)

RegisterNetEvent("vrp:openOxEmsMenu", function(title, options)
  local menuOptions = {}

  for _, option in ipairs(options) do
    menuOptions[#menuOptions + 1] = {
      title = option.title,
      description = option.description,
      icon = option.icon or "kit-medical",
      serverEvent = "vrp:oxEmsMenuSelect",
      args = {
        action = option.action
      }
    }
  end

  lib.registerContext({
    id = "vrp_ems_menu",
    title = title or "EMS",
    position = "top-right",
    options = menuOptions
  })

  lib.showContext("vrp_ems_menu")
end)