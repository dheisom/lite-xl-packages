local core = require 'core'
local util = require 'plugins.lite-xl-pm.util'

local prefix = "[lsp-install] "

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
  local ok, err = util.rmtree(path)
  if not ok then
    core.log(prefix.."Failed to remove '"..path.."': "..err)
    return false
  end
  return true
end

core.log(prefix .. "Cloning lite-xl-lsp plugin...")
clone(git.lsp, DATADIR.."/lite-xl-lsp", function(ok)
  if not ok then
    return core.log(prefix.."Failed to clone lite-xl-lsp!")
  end
  core.log(prefix.."Cloning lite-xl-widgets")
  clone(git.widgets, DATADIR.."/widget", function(ok)
    if not ok then
      return core.log(prefix.."Failed to clone lite-xl-widgets!")
    end
    core.log(prefix.."lite-xl-widgets installed, moving some files...")
    local ok, err = os.rename(DATADIR.."/lite-xl-lsp/lsp", DATADIR.."/plugins/lsp")
    if not ok then
      return core.log(prefix.."Failed to move lite-xl-lsp/lsp to plugins/: "..err)
    end
    ok, err = os.rename(
      DATADIR.."/lite-xl-lsp/autocomplete.lua",
      DATADIR.."/plugins/autocomplete.lua"
    )
    if not ok then
      return core.log(
        prefix.."Failed to move lite-xl-lsp/autocomplete.lua to plugins/: "..err
      )
    end
    if not remove(DATADIR.."/lite-xl-lsp") then return end
    core.log(prefix.."lite-xl-lsp installed with success")
  end)
end)
