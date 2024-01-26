local helpers = {}

-- 1:1 copy but exposed to custom
function helpers.alias_mode()
  return {
    --Normal
    ['n'] = 'Normal',
    ['no'] = 'O-Pending',
    ['nov'] = 'O-Pending',
    ['noV'] = 'O-Pending',
    ['no\x16'] = 'O-Pending',
    ['niI'] = 'Normal',
    ['niR'] = 'Normal',
    ['niV'] = 'Normal',
    ['nt'] = 'Normal',
    ['ntT'] = 'Normal',
    ['v'] = 'Visual',
    ['vs'] = 'Visual',
    ['V'] = 'V-Line',
    ['Vs'] = 'V-Line',
    ['\x16'] = 'V-Block',
    ['\x16s'] = 'V-Block',
    ['s'] = 'Select',
    ['S'] = 'S-Line',
    ['\x13'] = 'S-Block',
    ['i'] = 'Insert',
    ['ic'] = 'Insert',
    ['ix'] = 'Insert',
    ['R'] = 'Replace',
    ['Rc'] = 'Replace',
    ['Rx'] = 'Replace',
    ['Rv'] = 'V-Replace',
    ['Rvc'] = 'V-Replace',
    ['Rvx'] = 'V-Replace',
    ['c'] = 'Command',
    ['cv'] = 'Ex',
    ['ce'] = 'Ex',
    ['r'] = 'Replace',
    ['rm'] = 'More',
    ['r?'] = 'Confirm',
    ['!'] = 'Shell',
    ['t'] = 'Terminal',
  }
end

-- 1:1 copy but exposed to custom
local function get_stl_bg()
  local res = vim.api.nvim_get_hl(0, { name = 'StatusLine' })
  if vim.tbl_isempty(res) then
    vim.notify('[Custom Whisky] colorschem missing StatusLine config')
    return
  end
  return res.bg
end

-- 1:1 copy but exposed to custom
local stl_bg
if not stl_bg then
  stl_bg = get_stl_bg()
end

helpers.stl_bg = stl_bg

-- 1:1 copy but exposed to custom
function helpers.stl_attr(group, trans)
  local color = vim.api.nvim_get_hl(0, { name = group, link = false })
  trans = trans or false
  return {
    bg = trans and 'NONE' or stl_bg,
    fg = color.fg,
  }
end

-- 1:1 copy but exposed to custom
function helpers.gitsigns_data(bufnr, type)
  local ok, dict = pcall(vim.api.nvim_buf_get_var, bufnr, 'gitsigns_status_dict')
  if not ok or vim.tbl_isempty(dict) or not dict[type] then
    return 0
  end

  return dict[type]
end

-- 1:1 copy but exposed to custom
function helpers.git_icons(type)
  local tbl = {
    ['added'] = '+',
    ['changed'] = '~',
    ['deleted'] = '-',
  }
  return tbl[type]
end

return helpers
