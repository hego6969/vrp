RegisterNetEvent("vrp:oxPrompt", function(requestId, title, default)
  local input = lib.inputDialog(title, {
    {
      type = "input",
      label = title,
      default = default or ""
    }
  })

  TriggerServerEvent("vrp:oxPromptResult", requestId, input and input[1] or "")
end)