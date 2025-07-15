-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Always yank to clipboard
vim.opt.clipboard = "unnamedplus"

-- setup plugins
require("lazy").setup({
  spec = {
    -- Inline plugins
    {
	    "lewis6991/gitsigns.nvim",
	    config = function()
		    require("gitsigns").setup()
	    end,
    },
    {"nvim-lualine/lualine.nvim"},
    {
            "github/copilot.vim",
	     lazy = false,
            event = "InsertEnter",
    },
   {
     "akinsho/bufferline.nvim",
     version = "*",
     dependencies = "nvim-tree/nvim-web-devicons",
     config = function()
       require("bufferline").setup{}
       vim.opt.termguicolors = true
       vim.opt.showtabline = 2
     end,
    },
    {
	    "folke/tokyonight.nvim",
	    lazy = false,
	    priority = 1000,
	    opts = {},
	    config = function()
              vim.cmd("colorscheme tokyonight")
            end,
    },
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    { "nvim-treesitter/nvim-treesitter",
       build = ":TSUpdate",
       config = function()
	       require("nvim-treesitter.configs").setup({
		       ensure_installed = { "go", "lua", "python", "bash" },
		       highlight = {
			       enable = true,
			       additional_vim_regex_highlighting = false,
		       },
	       })
       end,
    },
    {
      "yetone/avante.nvim",
      build = "make",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "stevearc/dressing.nvim",
        "nvim-tree/nvim-web-devicons",
        {
          "MeanderingProgrammer/render-markdown.nvim",
          opts = { file_types = { "markdown", "Avante" } },
          ft = { "markdown", "Avante" },
        },
      },
      opts = {
              provider = "copilot",

      },
    },

    -- Imported plugin configs
    { import = "plugins" },
  },
})

-- map ./ telescope find_files command
vim.keymap.set("n", ",/", function()
  require("telescope.builtin").find_files()
end, { noremap = true, silent = true, desc = "Find files with Telescope" })

-- find the symbols within project
vim.keymap.set("n", ",fg", require("telescope.builtin").live_grep, { desc = "Live Grep in Project" })

-- find the word undercursor within project
vim.keymap.set("n", ",fw", require("telescope.builtin").grep_string, { desc = "Search Word Under Cursor" })

-- setup bottom line details like git branch file etc
require('lualine').setup({
  options = {
    theme = 'tokyonight',  -- Or any other theme
    section_separators = {'', ''},
    component_separators = {'', ''},
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},  -- Git branch
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'},
  },
})
