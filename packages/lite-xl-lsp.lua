local core = require 'core'
local common = require 'core.common'
local util = require 'plugins.lite-xl-pm.util'
local logger = require 'plugins.lite-xl-pm.logger'

local lspinstall = logger:new("[lsp-install]")
local git = {
  lsp = "https://github.com/jgmdev/lite-xl-lsp.git",
  widgets = "https://github.com/jgmdev/lite-xl-widgets.git"
}

local function clone(url, path, callback)
  util.run(
    { "git", "clone", "--depth=1", url, path },
    callback
  )
end

local function remove(path)
  local ok, err = core.rm(path, true)
  if not ok then
    lspinstall:error("Failed to remove '"..path.."': "..err)
    return false
  end
  return true
end

lspinstall:log("Cloning lite-xl-lsp plugin...")
clone(git.lsp, DATADIR.."/lite-xl-lsp", function(ok)
  if not ok then
    return lspinstall:error("Failed to clone lite-xl-lsp!")
  end
  lspinstall:log("Cloning lite-xl-widgets")
  clone(git.widgets, DATADIR.."/widget", function(ok)
    if not ok then
      lspinstall:error("Failed to clone lite-xl-widgets!")
      core.rm(DATADIR.."/lite-xl-lsp", true)
      return
    end
    lspinstall:log("lite-xl-widgets installed, moving some files...")
    local ok, err = os.rename(DATADIR.."/lite-xl-lsp/lsp", DATADIR.."/plugins/lsp")
    if not ok then
      return lspinstall:error("Failed to move lite-xl-lsp/lsp to plugins/: "..err)
    end
    ok, err = os.rename(
      DATADIR.."/lite-xl-lsp/autocomplete.lua",
      DATADIR.."/plugins/autocomplete.lua"
    )
    if not ok then
      return lspinstall:error(
        "Failed to move lite-xl-lsp/autocomplete.lua to plugins/: "..err
      )
    end
    if not common.rm(DATADIR.."/lite-xl-lsp", true) then
      return lspinstall:log(
        "lite-xl-lsp installed but I got an error removing "..DATADIR.."/lite-xl-lsp"
      )
    end
    lspinstall:log("lite-xl-lsp installed with success")
  end)
end)
