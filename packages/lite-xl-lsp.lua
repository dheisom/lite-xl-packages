local core = require 'core'
local common = require 'core.common'
local net = require 'plugins.lite-xl-pm.net'
local logger = require 'plugins.lite-xl-pm.logger'

local lspinstall = logger:new("[lsp-install]")
local git = {
  lsp = "https://github.com/jgmdev/lite-xl-lsp.git",
  widgets = "https://github.com/jgmdev/lite-xl-widgets.git",
  lintplus = "https://github.com/liquidev/lintplus"
}

local function install_linplus(ok, err)
  if not ok then
    lspinstall:error("Failed to clone lintplus: " .. err)
  else
    lspinstall:log("Lintplus installed")
  end
  coroutine.yield(2)
end

local function install_widget(ok, err)
  if not ok then
    lspinstall:error("Failed to clone lite-xl-widgets: " .. err)
    common.rm(DATADIR.."/plugins/lsp", true)
    common.rm(DATADIR.."/plugins/autocomplete.lua")
    os.rename(
      DATADIR.."/plugins/autocomplete.lua.old",
      DATADIR.."/plugins/autocomplete.lua"
    )
    return
  end
  core.command_view:enter(
    "Do you want to install lintplus",
    function(text, item)
      local option = text or item.text
      if option == "No" then
        return
      end
      lspinstall:log("Cloning lintplus...")
      net.clone(git.lintplus, DATADIR.."/plugins/lintplus", install_linplus)
    end,
    function(text)
      local options = { "Yes", "No" }
      return common.fuzzy_match(options, text)
    end
  )
  lspinstall:log("lite-xl-lsp installed with success")
end

local function install_lsp(ok, err)
  if not ok then
    return lspinstall:error("Failed to clone lite-xl-lsp: " .. err)
  end
  lspinstall:log("lite-xl-lsp installed, moving some files...")
  local renamed
  renamed, err = os.rename(
    DATADIR.."/lite-xl-lsp/lsp",
    DATADIR.."/plugins/lsp"
  )
  if not renamed then
    lspinstall:error("Failed to move lite-xl-lsp/lsp to plugins/: " .. err)
    return common.rm(DATADIR.."/lite-xl-lsp", true)
  end
  -- Make a backup of default autocomplete.lua
  os.rename(
    DATADIR.."/plugins/autocomplete.lua",
    DATADIR.."/plugins/autocomplete.lua.old"
  )
  -- Replace default autocomplete by lite-xl-lsp autocomplete
  os.rename(
    DATADIR.."/lite-xl-lsp/autocomplete.lua",
    DATADIR.."/plugins/autocomplete.lua"
  )
  common.rm(DATADIR .. "/lite-xl-lsp", true)
  lspinstall:log("Cloning lite-xl-widgets...")
  net.clone(git.widgets, DATADIR.."/widget", install_widget)
end

lspinstall:log("Cloning lite-xl-lsp plugin...")
net.clone(git.lsp, DATADIR.."/lite-xl-lsp", install_lsp)
