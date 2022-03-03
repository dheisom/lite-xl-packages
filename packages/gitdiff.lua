local net = require 'plugins.lxpm.net'
local logger = require 'plugins.lxpm.logger'

local gitdiff = logger:new("[gitdiff]")
local url = "https://github.com/vincens2005/lite-xl-gitdiff-highlight.git"

gitdiff:log("Clonning lite-xl-gitdiff-highlight...")
net.clone(
  url,
  USERDIR.."/plugins/gitdiff_highlight",
  function(ok)
    if ok then
      gitdiff:log("Installed with success! Restart to work.")
    else
      gitdiff:error("Failed to clone lite-xl-gitdiff-highlight!")
    end
  end
)

