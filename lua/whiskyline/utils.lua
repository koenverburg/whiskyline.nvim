local utils = {}
function utils.dim(text)
  if text == "" then
    return
  end
  return "%#Comment#" .. text .. "%#Normal#"
end

function utils.get_icon_by_filetype(name)
  local ok, icons = pcall(require, "nvim-web-devicons")

  if not ok then
    return ""
  end

  local icon, color = icons.get_icon_by_filetype(name)
  if not icon then
    return ""
  end

  return "%#" .. color .. "#" .. icon .. "%#Normal#", color
end

function utils.get_icon(name)
  local ok, icons = pcall(require, "nvim-web-devicons")

  if not ok then
    return ""
  end

  local icon, _ = icons.get_icon(name)
  if not icon then
    return ""
  end

  return icon
end

return utils
