{ pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    # ══════════════════════════════════════════════════════════════
    # Editor Options
    # ══════════════════════════════════════════════════════════════
    opts = {
      number = true;
      relativenumber = false;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      smartindent = true;
      wrap = false;
      ignorecase = true;
      smartcase = true;
      termguicolors = true;
      signcolumn = "yes";
      scrolloff = 8;
      updatetime = 50;
      undofile = true;
      clipboard = "unnamedplus";
      cursorline = true;
    };

    globals = {
      mapleader = " ";
      maplocalleader = " ";

      # ── vim-visual-multi Configuration ──
      VM_default_mappings = 1;
      VM_mouse_mappings = 1;
      VM_theme = "codedark";
      VM_highlight_matches = "underline";
      VM_show_warnings = 1;
      VM_maps = {
        "Find Under" = "<C-n>";
        "Find Subword Under" = "<C-n>";
        "Select All" = "\\\\A";
        "Start Regex Search" = "\\\\/";
        "Add Cursor Down" = "<C-Down>";
        "Add Cursor Up" = "<C-Up>";
        "Switch Mode" = "<Tab>";
        "Skip Region" = "q";
        "Remove Region" = "Q";
      };
    };

    # ══════════════════════════════════════════════════════════════
    # Colorscheme: Catppuccin
    # ══════════════════════════════════════════════════════════════
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
        transparent_background = false;
        integrations = {
          gitsigns = true;
          native_lsp.enabled = true;
          treesitter = true;
          which_key = true;
          flash = true;
        };
      };
    };

    # ══════════════════════════════════════════════════════════════
    # Plugins (Essential Only - No Snacks Replacement)
    # ══════════════════════════════════════════════════════════════
    plugins = {
      # ── UI ──
      lualine.enable = true;
      web-devicons.enable = true;

      # ── Syntax Highlighting ──
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
          ensure_installed = [
            "javascript" "typescript" "tsx"
            "python" "rust" "go" "c" "cpp"
            "nix" "lua" "json" "yaml"
            "html" "css" "markdown" "markdown_inline" "bash"
          ];
        };
      };

      # ── LSP ──
      lsp = {
        enable = true;
        servers = {
          ts_ls.enable = true;
          pyright.enable = true;
          ruff.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
          clangd.enable = true;
          gopls.enable = true;
          nil_ls.enable = true;
          lua_ls.enable = true;
          html.enable = true;
          cssls.enable = true;
          jsonls.enable = true;
        };
      };

      # ── Completion ──
      blink-cmp = {
        enable = true;
        settings = {
          keymap.preset = "default";
          appearance.nerd_font_variant = "mono";
          sources.default = [ "lsp" "path" "snippets" "buffer" ];
          completion = {
            documentation = {
              auto_show = true;
              auto_show_delay_ms = 200;
            };
            menu.draw.columns = [
              { __unkeyed-1 = "kind_icon"; }
              { __unkeyed-1 = "label"; __unkeyed-2 = "label_description"; gap = 1; }
            ];
          };
          signature.enabled = true;
        };
      };

      # ── Formatting ──
      conform-nvim = {
        enable = true;
        settings.formatters_by_ft = {
          python = [ "ruff_format" ];
          javascript = [ "prettier" ];
          typescript = [ "prettier" ];
          javascriptreact = [ "prettier" ];
          typescriptreact = [ "prettier" ];
          json = [ "prettier" ];
          html = [ "prettier" ];
          css = [ "prettier" ];
          rust = [ "rustfmt" ];
          go = [ "gofmt" "goimports" ];
          c = [ "clang-format" ];
          cpp = [ "clang-format" ];
          nix = [ "nixfmt" ];
          lua = [ "stylua" ];
          markdown = [ "prettier" ];
          yaml = [ "prettier" ];
        };
      };

      # ── Git Signs ──
      gitsigns = {
        enable = true;
        settings = {
          current_line_blame = false;
          signs = {
            add = { text = "│"; };
            change = { text = "│"; };
            delete = { text = "_"; };
            topdelete = { text = "‾"; };
            changedelete = { text = "~"; };
          };
          on_attach.__raw = ''
            function(bufnr)
              local gs = package.loaded.gitsigns
              local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
              end

              -- Navigation
              map('n', ']c', function()
                if vim.wo.diff then return ']c' end
                vim.schedule(function() gs.next_hunk() end)
                return '<Ignore>'
              end, {expr=true, desc='Next hunk'})

              map('n', '[c', function()
                if vim.wo.diff then return '[c' end
                vim.schedule(function() gs.prev_hunk() end)
                return '<Ignore>'
              end, {expr=true, desc='Previous hunk'})

              -- Staging
              map('n', '<leader>hs', gs.stage_hunk, {desc='Stage hunk'})
              map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {desc='Stage hunk'})
              map('n', '<leader>hS', gs.stage_buffer, {desc='Stage buffer'})
              map('n', '<leader>hu', gs.undo_stage_hunk, {desc='Undo stage hunk'})

              -- Reset
              map('n', '<leader>hr', gs.reset_hunk, {desc='Reset hunk'})
              map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {desc='Reset hunk'})
              map('n', '<leader>hR', gs.reset_buffer, {desc='Reset buffer'})

              -- Preview & Diff
              map('n', '<leader>hp', gs.preview_hunk, {desc='Preview hunk'})
              map('n', '<leader>hd', gs.diffthis, {desc='Diff this'})
              map('n', '<leader>hD', function() gs.diffthis('~') end, {desc='Diff this ~'})

              -- Blame
              map('n', '<leader>hb', function() gs.blame_line{full=true} end, {desc='Blame line'})
              map('n', '<leader>tb', gs.toggle_current_line_blame, {desc='Toggle line blame'})
              map('n', '<leader>td', gs.toggle_deleted, {desc='Toggle deleted'})

              -- Text object
              map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', {desc='Select hunk'})
            end
          '';
        };
      };

      # ── Which Key ──
      which-key = {
        enable = true;
        settings.spec = [
          { __unkeyed-1 = "<leader>f"; group = "Find"; icon = " "; }
          { __unkeyed-1 = "<leader>c"; group = "Code"; icon = " "; }
          { __unkeyed-1 = "<leader>g"; group = "Git"; icon = "󰊢 "; }
          { __unkeyed-1 = "<leader>h"; group = "Git Hunk"; icon = " "; }
          { __unkeyed-1 = "<leader>x"; group = "Diagnostics"; icon = "󱖫 "; }
          { __unkeyed-1 = "<leader>s"; group = "Search/Split"; icon = " "; }
          { __unkeyed-1 = "<leader>t"; group = "Toggle"; icon = " "; }
          { __unkeyed-1 = "<leader>u"; group = "UI Toggle"; icon = "󰙵 "; }
          { __unkeyed-1 = "<leader>b"; group = "Buffer"; icon = " "; }
          { __unkeyed-1 = "<leader>d"; group = "Debug/Profiler"; icon = " "; }
          { __unkeyed-1 = "g"; group = "Go to"; }
          { __unkeyed-1 = "["; group = "Previous"; }
          { __unkeyed-1 = "]"; group = "Next"; }
          { __unkeyed-1 = "ys"; group = "Add surround"; }
          { __unkeyed-1 = "cs"; group = "Change surround"; }
          { __unkeyed-1 = "ds"; group = "Delete surround"; }
        ];
      };

      # ── Flash Navigation ──
      flash = {
        enable = true;
        settings = {
          labels = "asdfghjklqwertyuiopzxcvbnm";
          search.mode = "fuzzy";
          jump.autojump = false;
          modes = {
            char = {
              enabled = true;
              jump_labels = true;
              multi_line = true;
            };
            search.enabled = true;
          };
        };
      };

      # ── Editing Helpers ──
      nvim-surround.enable = true;

      treesj = {
        enable = true;
        settings = {
          use_default_keymaps = false;
          max_join_length = 120;
        };
      };
    };

    # ══════════════════════════════════════════════════════════════
    # Extra Plugins
    # ══════════════════════════════════════════════════════════════
    extraPlugins = with pkgs.vimPlugins; [
      # vim-visual-multi - Multi-cursor support
      (pkgs.vimUtils.buildVimPlugin {
        name = "vim-visual-multi";
        src = pkgs.fetchFromGitHub {
          owner = "mg979";
          repo = "vim-visual-multi";
          rev = "master";
          sha256 = "sha256-KzBWkB/PYph6OfuF0GgNFYgqUAwMYbQQZbaaG9XuWZY=";
        };
      })
      # snacks.nvim - Batteries-included plugin collection
      (pkgs.vimUtils.buildVimPlugin {
        name = "snacks-nvim";
        src = pkgs.fetchFromGitHub {
          owner = "folke";
          repo = "snacks.nvim";
          rev = "main";
          sha256 = "sha256-vRedYg29QGPGW0hOX9qbRSIImh1d/SoDZHImDF2oqKM=";
        };
        doCheck = false;
      })
    ];

    # ══════════════════════════════════════════════════════════════
    # Snacks.nvim Configuration (ALL Modules Enabled)
    # ══════════════════════════════════════════════════════════════
    extraConfigLua = ''
      -- ══════════════════════════════════════════════════════════════
      -- snacks.nvim - All 27 modules enabled with defaults
      -- ══════════════════════════════════════════════════════════════

      require("snacks").setup({
        -- ── Animation ──
        animate = { enabled = true },

        -- ── Big Files ──
        bigfile = { enabled = true },

        -- ── Buffer Delete ──
        bufdelete = { enabled = true },

        -- ── Dashboard ──
        dashboard = {
          enabled = true,
          sections = {
            { section = "header" },
            { section = "keys", gap = 1, padding = 1 },
            { section = "recent_files", limit = 5, padding = 1 },
          },
        },

        -- ── Dim Inactive ──
        dim = { enabled = true },

        -- ── Explorer ──
        explorer = {
          enabled = true,
          replace_netrw = true,
        },

        -- ── GitHub ──
        gh = { enabled = true },

        -- ── Git ──
        git = { enabled = true },
        gitbrowse = { enabled = true },

        -- ── Image ──
        image = { enabled = true },

        -- ── Indent ──
        indent = {
          enabled = true,
          char = "│",
          scope = { enabled = true },
        },

        -- ── Input ──
        input = { enabled = true },

        -- ── Layout ──
        layout = { enabled = true },

        -- ── Lazygit ──
        lazygit = { enabled = true },

        -- ── Notifier ──
        notifier = {
          enabled = true,
          timeout = 3000,
          style = "compact",
        },

        -- ── Picker ──
        picker = {
          enabled = true,
          sources = {
            files = { hidden = true },
            grep = { hidden = true },
            explorer = {
              layout = { layout = { position = "right" } },
            },
          },
        },

        -- ── Profiler ──
        profiler = { enabled = true },

        -- ── Quickfile ──
        quickfile = { enabled = true },

        -- ── Rename ──
        rename = { enabled = true },

        -- ── Scope ──
        scope = { enabled = true },

        -- ── Scratch ──
        scratch = { enabled = true },

        -- ── Scroll ──
        scroll = {
          enabled = true,
          animate = {
            duration = { step = 15, total = 250 },
          },
        },

        -- ── Status Column ──
        statuscolumn = {
          enabled = true,
          left = { "mark", "sign" },
          right = { "fold", "git" },
          folds = {
            open = false,
            git_hl = false,
          },
          git = {
            patterns = { "GitSign", "MiniDiffSign" },
          },
        },

        -- ── Terminal ──
        terminal = {
          enabled = true,
          win = {
            style = "float",
            border = "rounded",
          },
        },

        -- ── Toggle ──
        toggle = { enabled = true },

        -- ── Words (LSP References) ──
        words = { enabled = true },

        -- ── Zen ──
        zen = { enabled = true },
      })

      -- ══════════════════════════════════════════════════════════════
      -- Snacks Keymaps
      -- ══════════════════════════════════════════════════════════════

      local map = vim.keymap.set

      -- ── Picker (Files/Buffers/Search) ──
      map("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find files" })
      map("n", "<leader>fg", function() Snacks.picker.grep() end, { desc = "Live grep" })
      map("n", "<leader>fw", function() Snacks.picker.grep_word() end, { desc = "Grep word" })
      map("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Recent files" })
      map("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
      map("n", "<leader>fj", function() Snacks.picker.jumps() end, { desc = "Jumps" })
      map("n", "<leader>f/", function() Snacks.picker.lines() end, { desc = "Buffer lines" })
      map("n", "<leader>fs", function() Snacks.picker.lsp_symbols() end, { desc = "Symbols" })
      map("n", "<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "Workspace symbols" })

      -- ── Picker (Diagnostics/LSP) ──
      map("n", "<leader>fd", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })
      map("n", "<leader>xd", function() Snacks.picker.diagnostics_buffer() end, { desc = "Buffer diagnostics" })
      map("n", "<leader>xx", function() Snacks.picker.diagnostics() end, { desc = "Workspace diagnostics" })

      -- ── Picker (Git) ──
      map("n", "<leader>gc", function() Snacks.picker.git_log() end, { desc = "Git commits" })
      map("n", "<leader>gb", function() Snacks.picker.git_branches() end, { desc = "Git branches" })
      map("n", "<leader>gs", function() Snacks.picker.git_status() end, { desc = "Git status" })
      map("n", "<leader>gS", function() Snacks.picker.git_stash() end, { desc = "Git stash" })
      map("n", "<leader>gd", function() Snacks.picker.git_diff() end, { desc = "Git diff" })

      -- ── Picker (Vim) ──
      map("n", "<leader>fh", function() Snacks.picker.help() end, { desc = "Help" })
      map("n", "<leader>fc", function() Snacks.picker.commands() end, { desc = "Commands" })
      map("n", "<leader>fk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
      map("n", "<leader>fm", function() Snacks.picker.marks() end, { desc = "Marks" })
      map("n", "<leader>fq", function() Snacks.picker.qflist() end, { desc = "Quickfix" })
      map("n", "<leader>fu", function() Snacks.picker.undo() end, { desc = "Undo history" })
      map("n", "<leader>fn", function() Snacks.picker.notifications() end, { desc = "Notifications" })

      -- ── Quick Access ──
      map("n", "<leader><space>", function() Snacks.picker.smart() end, { desc = "Smart find" })
      map("n", "<leader>,", function() Snacks.picker.buffers() end, { desc = "Buffers" })
      map("n", "<leader>/", function() Snacks.picker.grep() end, { desc = "Grep" })

      -- ── LSP Go-to ──
      map("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Definition" })
      map("n", "gr", function() Snacks.picker.lsp_references() end, { desc = "References" })
      map("n", "gi", function() Snacks.picker.lsp_implementations() end, { desc = "Implementations" })
      map("n", "gy", function() Snacks.picker.lsp_type_definitions() end, { desc = "Type definition" })

      -- ── Words (LSP References) ──
      map({ "n", "t" }, "]]", function() Snacks.words.jump(vim.v.count1) end, { desc = "Next reference" })
      map({ "n", "t" }, "[[", function() Snacks.words.jump(-vim.v.count1) end, { desc = "Prev reference" })

      -- ── Explorer ──
      map("n", "<leader>e", function() Snacks.explorer() end, { desc = "Explorer" })

      -- ── Terminal ──
      map("n", "<C-\\>", function() Snacks.terminal.toggle() end, { desc = "Terminal" })
      map("t", "<C-\\>", function() Snacks.terminal.toggle() end, { desc = "Terminal" })

      -- ── Buffer ──
      map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete buffer" })

      -- ── Git Features ──
      map("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" })
      map("n", "<leader>gB", function() Snacks.gitbrowse() end, { desc = "Browse in GitHub" })

      -- ── Extra Features ──
      map("n", "<leader>z", function() Snacks.zen() end, { desc = "Zen mode" })
      map("n", "<leader>Z", function() Snacks.zen.zoom() end, { desc = "Zoom window" })
      map("n", "<leader>.", function() Snacks.scratch() end, { desc = "Scratch buffer" })
      map("n", "<leader>n", function() Snacks.notifier.show_history() end, { desc = "Notifications" })

      -- ── Toggles ──
      Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
      Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
      Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
      Snacks.toggle.diagnostics():map("<leader>ud")
      Snacks.toggle.line_number():map("<leader>ul")
      Snacks.toggle.treesitter():map("<leader>uT")
      Snacks.toggle.inlay_hints():map("<leader>uh")
      Snacks.toggle.indent():map("<leader>ug")
      Snacks.toggle.dim():map("<leader>uD")

      -- ── Profiler ──
      Snacks.toggle.profiler():map("<leader>dpp")
      Snacks.toggle.profiler_highlights():map("<leader>dph")
    '';

    # ══════════════════════════════════════════════════════════════
    # Keymaps
    # ══════════════════════════════════════════════════════════════
    keymaps = [
      # ── General ──
      { mode = "n"; key = "<Esc>"; action = "<cmd>nohlsearch<CR>"; options.desc = "Clear highlight"; }

      # ── Terminal ──
      { mode = "t"; key = "<Esc>"; action = "<C-\\><C-n>"; options.desc = "Exit terminal"; }
      { mode = "t"; key = "<C-h>"; action = "<C-\\><C-n><C-w>h"; options.desc = "Left window"; }
      { mode = "t"; key = "<C-j>"; action = "<C-\\><C-n><C-w>j"; options.desc = "Down window"; }
      { mode = "t"; key = "<C-k>"; action = "<C-\\><C-n><C-w>k"; options.desc = "Up window"; }
      { mode = "t"; key = "<C-l>"; action = "<C-\\><C-n><C-w>l"; options.desc = "Right window"; }

      # ── LSP ──
      { mode = "n"; key = "gD"; action = "<cmd>lua vim.lsp.buf.declaration()<CR>"; options.desc = "Declaration"; }
      { mode = "n"; key = "K"; action = "<cmd>lua vim.lsp.buf.hover()<CR>"; options.desc = "Hover"; }
      { mode = ["n" "i"]; key = "<C-k>"; action = "<cmd>lua vim.lsp.buf.signature_help()<CR>"; options.desc = "Signature"; }
      { mode = ["n" "v"]; key = "<leader>ca"; action = "<cmd>lua vim.lsp.buf.code_action()<CR>"; options.desc = "Code action"; }
      { mode = "n"; key = "<leader>rn"; action = "<cmd>lua vim.lsp.buf.rename()<CR>"; options.desc = "Rename"; }
      { mode = "n"; key = "<leader>cl"; action = "<cmd>lua vim.lsp.codelens.run()<CR>"; options.desc = "CodeLens"; }
      { mode = "n"; key = "[d"; action = "<cmd>lua vim.diagnostic.goto_prev()<CR>"; options.desc = "Prev diagnostic"; }
      { mode = "n"; key = "]d"; action = "<cmd>lua vim.diagnostic.goto_next()<CR>"; options.desc = "Next diagnostic"; }
      { mode = "n"; key = "<leader>cd"; action = "<cmd>lua vim.diagnostic.open_float()<CR>"; options.desc = "Show diagnostic"; }

      # ── Formatting ──
      { mode = "n"; key = "<leader>cf"; action = "<cmd>lua require('conform').format()<CR>"; options.desc = "Format"; }
      { mode = "v"; key = "<leader>cf"; action = "<cmd>lua require('conform').format()<CR>"; options.desc = "Format"; }

      # ── Flash ──
      { mode = ["n" "x" "o"]; key = "s"; action.__raw = "function() require('flash').jump() end"; options.desc = "Flash"; }
      { mode = ["n" "x" "o"]; key = "S"; action.__raw = "function() require('flash').treesitter() end"; options.desc = "Flash Treesitter"; }
      { mode = "o"; key = "r"; action.__raw = "function() require('flash').remote() end"; options.desc = "Remote Flash"; }
      { mode = ["o" "x"]; key = "R"; action.__raw = "function() require('flash').treesitter_search() end"; options.desc = "Treesitter Search"; }
      { mode = "c"; key = "<C-s>"; action.__raw = "function() require('flash').toggle() end"; options.desc = "Toggle Flash"; }

      # ── TreeSJ ──
      { mode = "n"; key = "<leader>m"; action = "<cmd>TSJToggle<CR>"; options.desc = "Toggle split/join"; }
      { mode = "n"; key = "<leader>sj"; action = "<cmd>TSJJoin<CR>"; options.desc = "Join"; }
      { mode = "n"; key = "<leader>ss"; action = "<cmd>TSJSplit<CR>"; options.desc = "Split"; }

      # ── Window Navigation ──
      { mode = "n"; key = "<C-h>"; action = "<C-w>h"; options.desc = "Left window"; }
      { mode = "n"; key = "<C-j>"; action = "<C-w>j"; options.desc = "Down window"; }
      { mode = "n"; key = "<C-k>"; action = "<C-w>k"; options.desc = "Up window"; }
      { mode = "n"; key = "<C-l>"; action = "<C-w>l"; options.desc = "Right window"; }

      # ── Buffer Navigation ──
      { mode = "n"; key = "<S-h>"; action = "<cmd>bprevious<CR>"; options.desc = "Prev buffer"; }
      { mode = "n"; key = "<S-l>"; action = "<cmd>bnext<CR>"; options.desc = "Next buffer"; }
      { mode = "n"; key = "<Tab>"; action = "<cmd>bnext<CR>"; options.desc = "Next buffer"; }
      { mode = "n"; key = "<S-Tab>"; action = "<cmd>bprevious<CR>"; options.desc = "Prev buffer"; }

      # ── Indenting ──
      { mode = "v"; key = "<"; action = "<gv"; options.desc = "Indent left"; }
      { mode = "v"; key = ">"; action = ">gv"; options.desc = "Indent right"; }

      # ── Move Lines ──
      { mode = "n"; key = "<A-j>"; action = "<cmd>m .+1<CR>=="; options.desc = "Move down"; }
      { mode = "n"; key = "<A-k>"; action = "<cmd>m .-2<CR>=="; options.desc = "Move up"; }
      { mode = "v"; key = "<A-j>"; action = ":m '>+1<CR>gv=gv"; options.desc = "Move down"; }
      { mode = "v"; key = "<A-k>"; action = ":m '<-2<CR>gv=gv"; options.desc = "Move up"; }
    ];
  };
}
