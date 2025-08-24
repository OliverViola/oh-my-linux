
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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

require("lazy").setup({
    -- 主题
    "tanvirtin/monokai.nvim",

    -- nvim-tree 配置
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,  -- 立即加载
        priority = 1000,  -- 优先加载
        dependencies = {
            "nvim-tree/nvim-web-devicons", -- 可选，用于文件图标
        },
        keys = {
            {
                "<leader>e",
                function() require("nvim-tree.api").tree.toggle() end,
                desc = "Toggle NvimTree"
            },
        },

        config = function()
            -- 禁用内置 netrw（防止冲突）
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
            -- 启用 24 位颜色
            vim.opt.termguicolors = true

            -- 定义自定义快捷键的 on_attach 函数
            local function my_on_attach(bufnr)
                local api = require "nvim-tree.api"

                -- opts 用来给快捷键添加描述，方便 :map 查看
                local function opts(desc)
                    return {    desc = "nvim-tree: " .. desc, 
                    buffer = bufnr, 
                    noremap = true, 
                    silent = true, 
                    nowait = true }
                end

                -- 保留官方默认映射
                api.config.mappings.default_on_attach(bufnr)

                -- 自定义增强映射
                vim.keymap.set("n", "<Tab>", api.node.open.preview,            opts("Preview File"))
                vim.keymap.set("n", "l",     api.node.open.edit,               opts("Open"))
                vim.keymap.set("n", "h",     api.node.navigate.parent_close,   opts("Close Directory"))
                vim.keymap.set("n", "P",     api.tree.change_root_to_node,     opts("CD to Node"))
                vim.keymap.set("n", "s",     api.node.open.vertical,           opts("Open: Vertical Split"))
                vim.keymap.set("n", "t",     api.node.open.tab,                opts("Open: New Tab"))
                vim.keymap.set("n", "Y",     api.fs.copy.absolute_path,        opts("Copy Absolute Path"))
                vim.keymap.set("n", "gy",    api.fs.copy.relative_path,        opts("Copy Relative Path"))
            end

            -- 传递给 nvim-tree.setup
            require("nvim-tree").setup({
                sort = { sorter = "case_sensitive" },
                view = { width = 30 },
                renderer = { group_empty = true },
                filters = { dotfiles = false },
                on_attach = my_on_attach, -- 挂载自定义映射
            })
        end
    },
    -- 自动补全blink,cmp
    {
        "saghen/blink.cmp",
        -- optional: provides snippets for the snippet source
        dependencies = { "rafamadriz/friendly-snippets" },

        -- use a release tag to download pre-built binaries
        version = "*",
        -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = 'cargo build --release',
        -- If you use nix, you can build from source using the latest nightly rust with:
        -- build = 'nix run .#build-plugin',

        opts = {
            -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
            -- 'super-tab' for mappings similar to VSCode (tab to accept)
            -- 'enter' for enter to accept
            -- 'none' for no mappings
            --
            -- All presets have the following mappings:
            -- C-space: Open menu or open docs if already open
            -- C-n/C-p or Up/Down: Select next/previous item
            -- C-e: Hide menu
            -- C-k: Toggle signature help (if signature.enabled = true)
            --
            -- See :h blink-cmp-config-keymap for defining your own keymap
            keymap = {
                -- Each keymap may be a list of commands and/or functions
                preset = "enter",
                -- Select completions
                ["<Up>"] = { "select_prev", "fallback" },
                ["<Down>"] = { "select_next", "fallback" },
                ["<Tab>"] = { "select_next", "fallback" },
                ["<S-Tab>"] = { "select_prev", "fallback" },
                -- Scroll documentation
                ["<C-b>"] = { "scroll_documentation_up", "fallback" },
                ["<C-f>"] = { "scroll_documentation_down", "fallback" },
                -- Show/hide signature
                ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
            },

            appearance = {
                -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = "mono",
            },

            sources = {
                -- `lsp`, `buffer`, `snippets`, `path`, and `omni` are built-in
                -- so you don't need to define them in `sources.providers`
                default = { "lsp", "path", "snippets", "buffer" },

                -- Sources are configured via the sources.providers table
            },

            -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
            -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
            -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
            --
            -- See the fuzzy documentation for more information
            fuzzy = { implementation = "prefer_rust_with_warning" },
            completion = {
                -- The keyword should only match against the text before
                keyword = { range = "prefix" },
                menu = {
                    -- Use treesitter to highlight the label text for the given list of sources
                    draw = {
                        treesitter = { "lsp" },
                    },
                },
                -- Show completions after typing a trigger character, defined by the source
                trigger = { show_on_trigger_character = true },
                documentation = {
                    -- Show documentation automatically
                    auto_show = true,
                },
            },

            -- Signature help when tying
            signature = { enabled = true }
        },
        opts_extend = { "sources.default" }
    },
    -- LSP manager
	{ "mason-org/mason.nvim", opts = {} },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        opts = {
            ensure_installed = { "pylsp" },
        }
    },
    {
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")

			lspconfig.pylsp.setup({})
		end
	}
})
