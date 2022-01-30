local core = require 'core'
local net = require 'plugins.lite-xl-pm.net'

local prefix = "[nonicons-install] "

core.log(prefix .. "Downloading nonicons plugin...")
net.download(
  USERDIR .. "/plugins/nonicons.lua",
  "https://github.com/lite-xl/lite-xl-plugins/blob/master/plugins/nonicons.lua?raw=1",
  function(ok, out)
    if not ok then
      return core.log(prefix .. "Failed to download plugin: " .. out)
    end
    core.log(prefix .. "Downloading nonicons font...")
    net.download(
      USERDIR .. "/fonts/nonicons.ttf",
      "https://github.com/yamatsum/nonicons/raw/master/dist/nonicons.ttf",
      function(ok, out)
        if not ok then
          core.log(prefix .. "Failed to download font: " .. out)
          os.remove(USERDIR .. "/plugins/nonicons.lua")
          return
        end
        core.log(prefix .. "Nonicons installed wih success, restart your editor")
      end
    )
  end
)
