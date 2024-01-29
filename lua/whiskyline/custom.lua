local p = require('whiskyline.provider')
local utils = require('whiskyline.utils')
local helpers = require('whiskyline.helpers')

local line = {}
local custom = {}

-- #region line
-- Show full mode name, og shorts its to 3 characters and upper cases its
function line.mode()
  local alias = helpers.alias_mode()
  local color = vim.api.nvim_get_hl(0, { name = 'PreProc' })
  local result = {
    stl = function()
      local mode = vim.api.nvim_get_mode().mode
      local m = alias[mode] or alias[string.sub(mode, 1, 1)] or 'Unknown'
      return m
    end,
    name = 'mode',
    default = 'Normal',
    event = { 'ModeChanged' },
    attr = {
      fg = color.fg,
      bg = 'black',
      bold = true,
    },
  }
  return result
end

-- OG as %P after the file name
-- TODO what to do when file name exeeds 50 characters
function line.fileinfo()
  local result = {
    stl = '%f',
    name = 'fileinfo',
    event = { 'BufEnter' },
    attr = helpers.stl_attr('Comment'),
  }

  return result
end

-- OG only shows one, I want to see all attached lsps
function line.lsp()
  local function lsp_stl(args)
    local clients = vim.lsp.get_clients({ bufnr = args.buf })

    if #clients == 0 then
      return ''
    elseif args.event == 'LspDetach' then
      return ''
    end

    local names = {}

    for _, client in pairs(clients) do
      -- Maybe not all lsps...
      if client.name ~= 'null-ls' then
        table.insert(names, client.name)
      end
    end

    if #names > 0 then
      return utils.dim('lsp: ' .. table.concat(names, ', '))
    end

    return ''
  end

  local result = {
    stl = lsp_stl,
    name = 'Lsp',
    event = { 'LspProgress', 'LspAttach', 'LspDetach', 'BufEnter' },
    attr = helpers.stl_attr('Comment'),
  }

  return result
end

function line.gitadd()
  local sign = helpers.git_icons('added')
  local result = {
    stl = function(args)
      local res = helpers.gitsigns_data(args.buf, 'added')
      return res > 0 and ('%s%s%s'):format(sign, res, ' ') or ''
    end,
    name = 'gitadd',
    event = { 'User GitSignsUpdate', 'BufEnter' },
    attr = helpers.stl_attr('GitSignsAdd', true), -- change of color
  }

  return result
end

function line.gitchange()
  local sign = helpers.git_icons('changed')
  local result = {
    stl = function(args)
      local res = helpers.gitsigns_data(args.buf, 'changed')
      return res > 0 and ('%s%s%s'):format(sign, res, ' ') or ''
    end,
    name = 'gitchange',
    event = { 'User GitSignsUpdate', 'BufEnter' },
    attr = helpers.stl_attr('GitSignsChange', true), -- change of color
  }
  return result
end

function line.gitdelete()
  local sign = helpers.git_icons('deleted')
  local result = {
    stl = function(args)
      local res = helpers.gitsigns_data(args.buf, 'removed')
      return res > 0 and ('%s%s'):format(sign, res) or ''
    end,
    name = 'gitdelete',
    event = { 'User GitSignsUpdate', 'BufEnter' },
    attr = helpers.stl_attr('GitSignsDelete', true), -- change of color
  }
  return result
end

function line.branch()
  local result = {
    stl = function(args)
      local branch = helpers.gitsigns_data(args.buf, 'head')
      -- Changed icon and colored the branch name
      local icon, color = utils.get_icon_by_filetype('git')
      local r = icon .. ' ' .. '%#' .. color .. '#' .. branch
      return branch and r or 'UNKNOWN'
    end,
    name = 'gitbranch',
    event = { 'User GitSignsUpdate' },
  }
  return result
end

function line.modified()
  return {
    stl = utils.dim(' %m') .. '%#Normal#',
    name = 'modified',
    event = { 'BufModifiedSet' },
  }
end

-- #endregion

custom.segments = {
  line.mode(),
  p.space(),

  line.branch(),
  p.space(),

  line.fileinfo(),
  line.modified(),

  p.space(),

  line.gitadd(),
  line.gitchange(),
  line.gitdelete(),

  p.pad(),

  -- Move this to winbar
  p.diagError(),
  p.diagWarn(),
  p.diagHint(),
  p.diagInfo(),

  p.space(),

  line.lsp(),
  p.space(),
}

vim.cmd([[ hi clear StatusLine ]])

return custom
