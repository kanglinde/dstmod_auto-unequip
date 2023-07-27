name = "Auto-Unequip on Low Durability"
author = "kanglinde"
version = "2.2.0"
description = "version: "..version
api_version = 10

icon_atlas = "modicon.xml"
icon = "modicon.tex"

dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false
client_only_mod = true

local function AddConfigOpt(min, max, step)
     local options = {}
     local pos = 1
     for i = min, max, step do
          options[pos] = {description = i, data = i, hover = "Auto-unequip when item durability drops below "..i}
          pos = pos + 1
     end
     return options
end

configuration_options = {
     {
          name = "Threshold",
          label = "Durability Threshold (%)",
          options = AddConfigOpt(1, 20, 1),
          default = 5,
     },
     {
          name = "Notify",
          label = "Notify on unequip",
          options = {
               {description = "Yes", data = true, hover = "Your character speaks upon auto-unequip"},
			{description = "No", data = false, hover = "Your character is quiet upon auto-unequip"},
          },
          default = true,
     },
}