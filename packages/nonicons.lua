local net = require 'plugins.lxpm.net'
local logger = require 'plugins.lxpm.logger'

local nonicons = logger:new("[nonicons-install]")

local function finish(ok, err)
  if not ok then
    nonicons:log("Failed to download font: " .. err)
    os.remove(USERDIR .. "/plugins/nonicons.lua")
    return
  end
  nonicons:log("Nonicons installed wih success, restart your editor")
end

local function download_font(ok, out)
  if not ok then
    return nonicons:log("Failed to download plugin: " .. out)
  end
  nonicons:log("Downloading nonicons font...")
  net.download(
    USERDIR .. "/fonts/nonicons.ttf",
    "https://github.com/yamatsum/nonicons/raw/master/dist/nonicons.ttf",
    finish
  )
end

nonicons:log("Downloading nonicons plugin...")
net.download(
  USERDIR .. "/plugins/nonicons.lua",
  "https://github.com/lite-xl/lite-xl-plugins/blob/master/plugins/nonicons.lua?raw=1",
  download_font
)
