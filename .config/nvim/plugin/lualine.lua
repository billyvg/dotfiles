require("lualine").setup({
  sections = {
    lualine_c = {
      {
        "filename",
        file_status = true,
        newfile_status = false,
        path = 4,
        shorting_target = 40,
        symbols = {
          modified = "[+]",
          readonly = "[-]",
          unnamed = "[No Name]",
          newfile = "[New]",
        },
      },
    },
  },
  inactive_sections = {
    lualine_c = {
      {
        "filename",
        file_status = true,
        newfile_status = false,
        path = 3,
        symbols = {
          modified = "[+]",
          readonly = "[-]",
          unnamed = "[No Name]",
          newfile = "[New]",
        },
      },
    },
  },
})
