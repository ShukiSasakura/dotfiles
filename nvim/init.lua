-- １文字入力毎に検索を行う
vim.opt.incsearch = true
-- 改行時に前の行のインデントを継続する
vim.opt.autoindent = true
-- 改行時に前の行の構文をチェックし次の行のインデントを増減する
vim.opt.smartindent = true
-- マウスでカーソル移動とスクロール
vim.opt.mouse = 'a'
-- タブ入力を複数の空白入力に置き換える
vim.opt.expandtab = true
-- 画面上でタブ文字が占める幅
vim.opt.tabstop = 4
-- smartindentで増減する幅
vim.opt.shiftwidth = 4
-- 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
vim.opt.softtabstop = 4
vim.api.nvim_create_augroup('indent_config', {})
vim.api.nvim_create_autocmd('FileType', {
    group = 'indent_config',
    pattern = 'make',
    callback = function()
        vim.opt_local.expandtab = false
        vim.opt_local.tabstop = 4
    end
})
vim.api.nvim_create_autocmd('FileType', {
    group = 'indent_config',
    pattern = 'markdown',
    callback = function()
        vim.opt_local.expandtab = true
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
    end
})
-- ターミナル内で true color を表示
vim.opt.termguicolors = true
-- 行番号を表示"
vim.opt.number = true
-- タブ文字と行末のスペースを表示
vim.opt.list = true
vim.opt.listchars = {tab='>-',trail='*'}
-- ヤンクでクリップボードにコピー
vim.opt.clipboard:append{'unnamedplus'}

---------------------
--mapping
---------------------
local map = vim.api.nvim_set_keymap

-- 画面上で複数行になっている1行についてj/kで見た目通りに移動できるようにする
map('n', 'j', 'gj', {noremap = true})
map('n', 'k', 'gk', {noremap = true})

-- jk で ESC
map('i', 'jk', '<ESC>', {noremap = true})

-- 検索結果を画面中央に表示するようにする
map('n', 'n', 'nzz', {})
map('n', 'N', 'Nzz', {})

-- 警告・エラーメッセージの表示
map('n', 'ge', '<cmd>lua vim.diagnostic.open_float()<CR>', {})
map('n', '[n', '<cmd>lua vim.diagnostic.goto_prev()<CR>', {})
map('n', ']n', '<cmd>lua vim.diagnostic.goto_next()<CR>', {})

-- ダークテーマとライトテーマを簡単に切り替える
vim.api.nvim_create_user_command(
    'SwitchBackgroundColor',
    function()
        if vim.o.background == 'dark' then
            vim.opt.background = 'light'
        else
            vim.opt.background = 'dark'
        end
    end,
    {}
)
map('n', 'zbc', ':SwitchBackgroundColor', {noremap = true})

-- カーソルが常に画面中央に来るようにする
vim.api.nvim_create_user_command(
    'CenteringCursorToggle',
    function()
        if vim.opt.scrolloff == 999 then
            vim.opt.scrolloff = 0
        else
            vim.opt.scrolloff = 999
        end
    end,
    {}
)
map('n', 'zx', ':CenteringCursorToggle', {noremap = true})

---------------------
--Plugin
---------------------
-- lazy.nvim のインストール
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin の管理
require("lazy").setup({
    -- カーソル上の単語と行を強調表示
    "yamatsum/nvim-cursorline",
    -- gccでコメントアウト・イン
    "tpope/vim-commentary",
    -- Neovim上でGit操作を可能にする
    "dinhhuy258/git.nvim",
    -- Git 管理ファイルの変更点を表示
    "lewis6991/gitsigns.nvim",
    -- status_line の色を変更
    "itchyny/lightline.vim",
    -- indent_line の追加
    "lukas-reineke/indent-blankline.nvim",
    -- keybindings をポップアップ表示
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
    },
    -- markdown preview
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },
    -- Directory browser
    {
        'simonmclean/triptych.nvim',
        event = 'VeryLazy',
        dependencies = {
            'nvim-lua/plenary.nvim', -- required
            'nvim-tree/nvim-web-devicons', -- optional
        }
    },
    -- filesystem をツリー表示
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        }
    },
    -- colorscheme
    { "catppuccin/nvim",lazy = false, name = "catppuccin", priority = 1000 },
    --LSP 関連
    -- lsp サーバーの管理
    "neovim/nvim-lspconfig",
    -- nvim-lspconfig を自動的に設定
    "simrat39/rust-tools.nvim",
    -- lsp をインストール，セットアップ
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    -- Completion
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "saadparwaiz1/cmp_luasnip",
    -- Snip
    {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
    },
    "rafamadriz/friendly-snippets",
})

-- nvim-cursorline のセットアップ
require('nvim-cursorline').setup {
  cursorline = {
    enable = true,
    timeout = 1000,
    number = false,
  },
  cursorword = {
    enable = true,
    min_length = 3,
    hl = { underline = true },
  }
}

-- git.nvim のセットアップ
require('git').setup {}

-- gitsigns.nvim のセットアップ
require('gitsigns').setup {
  signs = {
    add          = { text = '│' },
    change       = { text = '│' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    follow_files = true
  },
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000, -- Disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
  yadm = {
    enable = false
  },
}

-- lightline.vim のセットアップ
vim.g['lightline'] = {
    colorscheme = 'catppuccin',
    background  = 'dark'
}

-- indent_blankline.nvim のセットアップ
require("ibl").setup()

-- triptych.nvim のセットアップ
require 'triptych'.setup()

--catppuccin(colorscheme) のセットアップ
require("catppuccin").setup({
    flavor = "auto",
    background = { -- :h background
        light = "latte",
        dark = "mocha",
    },
    integrations = {
        cmp = true,
        gitsigns = true,
        indent_blankline = { enabled = true },
        mason = true,
        -- nvimtree = true,
        -- treesitter = true,
        -- notify = false,
    }
})
-- setup must be called before loading
vim.cmd.colorscheme "catppuccin-mocha"

---------------------
--LSP のセットアップ
---------------------
-- lspconfig のセットアップ
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- nvim-cmp のセットアップ
local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ['<Tab>'] = cmp.mapping(function(fallback)
          local col = vim.fn.col('.') - 1

          if cmp.visible() then
              cmp.select_next_item()
          elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
              fallback()
          else
              cmp.complete()
          end
      end, {'i', 's'}),

      ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
              cmp.select_prev_item()
          else
              fallback()
          end
      end, {'i', 's'}),
  }),
  sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      -- { name = 'vsnip' }, -- For vsnip users.
      { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
  }, {
      { name = 'buffer' },
      { name = 'path' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- keybindings
local on_attach = function(client, bufnr)
end

-- none, single, double, rounded, solid, shadow
require("mason").setup({ ui = { border = "single"} })

require('mason-lspconfig').setup({
    ensure_installed = {
        "lua_ls",
        "marksman",
        "rust_analyzer",
        "solargraph",
        "texlab",
    },
    automatic_installation = true,
})

require('mason-lspconfig').setup_handlers({
    function (server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup {}
    end,
    ["lua_ls"] = function()
        require("lspconfig")["lua_ls"].setup({
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
                Lua = {
                    diagnostics = {
                        -- `vim`グローバル変数を認識させる
                        globals = {'vim'},
                    },
                }
            },
        })
    end,
    ["marksman"] = function()
        require("lspconfig")["marksman"].setup({
            on_attach = on_attach,
            capabilities = capabilities,
        })
    end,
    ["solargraph"] = function()
        require("lspconfig")["solargraph"].setup({
            on_attach = on_attach,
            capabilities = capabilities,
        })
    end,
    ["rust_analyzer"] = function()
        require("rust-tools").setup({
            server = {
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    ["rust-analyzer"] = {
                        checkOnSave = {
                            command = "clippy"
                        },
                    }
                },
            }
        })
    end,
    ["texlab"] = function()
        require("lspconfig")["texlab"].setup({
            on_attach = on_attach,
            capabilities = capabilities,
        })
    end,
})
