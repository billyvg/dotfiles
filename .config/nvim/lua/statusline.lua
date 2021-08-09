local gl = require('galaxyline')
local condition = require('galaxyline.condition')
local gls = gl.section

gl.short_line_list = {'LuaTree','vista','dbui'}


local colors = {
  bg = '#2b2b2b',
  yellow = "#ffff87",
  purple = "#af87ff",
  green = "#A4E400",
  blue = "#62D8F1",
  darkblue = '#081633',
  cyan = "#62D8F1",
  magenta = "#FC1A70",
  red = '#ec5f67',
  orange = "#FF9700",
  white = "#ffffff",
  light_grey = "#bcbcbc",
  grey = "#8a8a8a",
  dark_grey = "#5f5f5f",
  darker_grey = "#444444",
  light_charcoal = "#2b2b2b",

  line_bg = "#2b2b2b",
  highlight = "#444444",
}

local function split(str, sep)
    local res = {}
    local n = 1
    for w in str:gmatch('([^' .. sep .. ']*)') do
        res[n] = res[n] or w -- only set once (so the blank after a string is ignored)
        if w == '' then
            n = n + 1
        end -- step forwards on a blank but not a string
    end
    return res
end

local is_file = function()
    return vim.bo.buftype ~= 'nofile'
end


local checkwidth = function()
  local squeeze_width  = vim.fn.winwidth(0) / 2
  if squeeze_width > 40 then
    return true
  end
  return false
end

local mode_color = {
  n = colors.magenta,
  i = colors.green,
  v = colors.blue,
  [""] = colors.blue,
  V = colors.blue,
  c = colors.dark_grey,
  no = colors.magenta,
  s = colors.orange,
  S = colors.orange,
  [""] = colors.orange,
  ic = colors.yellow,
  R = colors.purple,
  Rv = colors.purple,
  cv = colors.red,
  ce = colors.red,
  r = colors.cyan,
  rm = colors.cyan,
  ["r?"] = colors.cyan,
  ["!"] = colors.red,
  t = colors.red
}


table.insert(gls.left, {
  FirstElement = {
    provider = function() return '' end,
    highlight = {colors.line_bg, colors.highlight},
    separator = " ",
    separator_highlight = {colors.highlight, colors.highlight},
  }
})


table.insert(gls.left, {
  ViMode = {
    provider = function()
      local mode = vim.fn.mode()
      local alias = {n = 'N',i = 'I',c= 'C',v= 'V',V= 'VL', [''] = 'VB'}
      vim.cmd("hi GalaxyViMode guifg=" .. mode_color[mode])

      return (alias[mode] or colors.red) .. ' '
    end,
    highlight = {colors.line_bg, colors.highlight},
    separator = '',
    separator_highlight = {
      colors.highlight,
      function()
        if not condition.buffer_not_empty() then
          return colors.highlight
        end
        return colors.line_bg
      end
    },
  },
})


table.insert(gls.left, {
  Space = {
    provider = function() return ' ' end,
    condition = condition.buffer_not_empty,
    highlight = {colors.line_bg, colors.line_bg},
  },
})

table.insert(gls.left, {
  FileIcon = {
    provider = 'FileIcon',
    condition = condition.buffer_not_empty,
    highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color,colors.line_bg},
  },
})


table.insert(gls.left, {
    FilePath = {
        provider = function()
            local fp = vim.fn.fnamemodify(vim.fn.expand '%', ':~:.:h')
            local tbl = split(fp, '/')
            local len = #tbl

            if len > 2 and not len == 3 and not tbl[0] == '~' then
                return '…/' .. table.concat(tbl, '/', len - 1) .. '/' -- shorten filepath to last 2 folders
                -- alternative: only 1 containing folder using vim builtin function
                -- return '…/' .. vim.fn.fnamemodify(vim.fn.expand '%', ':p:h:t') .. '/'
            else
                return fp .. '/'
            end
        end,
        condition = function()
            return is_file() and checkwidth()
        end,
        highlight = { colors.light_grey, colors.line_bg },
    },
})

table.insert(gls.left, {
  FileName = {
    provider = {'FileName'},
    condition = condition.buffer_not_empty,
    separator = '',
    separator_highlight = {colors.line_bg,colors.highlight},
    highlight = {colors.white,colors.line_bg}
  }
})


table.insert(gls.left, {
  GitIcon = {
    provider = function() return '  ' end,
    condition = condition.check_git_workspace,
    highlight = {colors.light_grey,colors.highlight},
  }
})

table.insert(gls.left, {
  GitBranch = {
    provider = 'GitBranch',
    condition = condition.check_git_workspace,
    highlight = {colors.light_grey,colors.highlight},
    separator = " ",
    separator_highlight = {colors.highlight, colors.highlight},
  }
})


table.insert(gls.left, {
  DiffAdd = {
    provider = 'DiffAdd',
    condition = checkwidth,
    icon = '+',
    highlight = {colors.green,colors.highlight},
  }
})

table.insert(gls.left, {
  DiffModified = {
    provider = 'DiffModified',
    condition = checkwidth,
    icon = '~',
    highlight = {colors.orange,colors.highlight},
  }
})

table.insert(gls.left, {
  DiffRemove = {
    provider = 'DiffRemove',
    condition = checkwidth,
    icon = '-',
    highlight = {colors.red,colors.highlight},
  }
})

table.insert(gls.left, {
  LeftEnd = {
    provider = function() return '' end,
    -- separator = '',
    highlight = {colors.highlight,colors.line_bg},
    -- separator_highlight = {colors.highlight,colors.line_bg},
  }
})

table.insert(gls.left, {
  DiagnosticError = {
    provider = 'DiagnosticError',
    icon = '',
    highlight = {colors.red,colors.line_bg}
  }
})
-- table.insert(gls.left, {
  -- Space = {
    -- provider = function () return '' end,
    -- highlight = {colors.highlight,colors.line_bg},
  -- }
-- })
table.insert(gls.left, {
  DiagnosticWarn = {
    provider = 'DiagnosticWarn',
    icon = '',
    highlight = {colors.blue,colors.line_bg},
  }
})


table.insert(gls.right, {
  FileFormat = {
    provider = 'FileTypeName',
    condition = checkwidth,
    separator = ' ',
    separator_highlight = {colors.bg,colors.highlight},
    highlight = {colors.grey,colors.highlight},
  }
})

table.insert(gls.right, {
  SpaceRight = {
    provider = function () return ' ' end,
    highlight = {colors.highlight,colors.highlight},
  }
})

table.insert(gls.right, {
  LineInfo = {
    provider = 'LineColumn',
    highlight = {colors.light_grey,colors.bg},
    separator = ' ',
    separator_highlight = {colors.highlight, colors.bg},
  },
})


gls.short_line_left[1] = {
  FileIcon = {
    provider = 'FileIcon',
    condition = condition.buffer_not_empty,
    highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color,colors.highlight},
  },
}

gls.short_line_left[2] = {
  FileNameShort = {
    provider = {'FileName'},
    condition = condition.buffer_not_empty,
    separator = '',
    separator_highlight = {colors.highlight,colors.bg},
    highlight = {colors.light_grey,colors.highlight}
  }
}


gls.short_line_right[1] = {
  BufferIcon = {
    provider= 'BufferIcon',
    separator = '',
    separator_highlight = {colors.highlight,colors.bg},
    highlight = {colors.grey,colors.highlight}
  }
}
