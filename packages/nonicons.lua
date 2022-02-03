local core = require 'core'
local net = require 'plugins.lite-xl-pm.net'
local logger = require 'plugins.lite-xl-pm.logger'

local nonicons = logger:new("[nonicons-install]")

nonicons:log("Downloading nonicons plugin...")
net.download(
  USERDIR .. "/plugins/nonicons.lua",
  "https://github.com/lite-xl/lite-xl-plugins/blob/master/plugins/nonicons.lua?raw=1",
  function(ok, out)
    if not ok then
      return nonicons:log("Failed to download plugin: " .. out)
    end
    nonicons:log("Downloading nonicons font...")
    net.download(
      USERDIR .. "/fonts/nonicons.ttf",
      "https://github.com/yamatsum/nonicons/raw/master/dist/nonicons.ttf",
      function(ok, out)
        if not ok then
          nonicons:log("Failed to download font: " .. out)
          os.remove(USERDIR .. "/plugins/nonicons.lua")
          return
        end
        nonicons:log(prefix .. "Nonicons installed wih success, restart your editor")
      end
    )
  end
)
