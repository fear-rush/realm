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
      # Multi-cursor plugin (like Ctrl+D in VS Code)
      # Keymaps:
      #   <C-n>       = Select word under cursor / Add next occurrence
      #   <C-Down>    = Add cursor below
      #   <C-Up>      = Add cursor above
      #   n/N         = Next/previous occurrence
      #   q           = Skip current, select next
      #   Q           = Remove current cursor
      #   <Tab>       = Switch between cursor/extend mode
      #   \\A         = Select all occurrences
      #   \\/         = Regex search
      #   \\c         = Case setting (smart/sensitive/ignore)
      #   <Esc>       = Exit multi-cursor mode
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
        flavour = "mocha"; # Options: latte, frappe, macchiato, mocha
        transparent_background = false;
        integrations = {
          bufferline = true;
          gitsigns = true;
          indent_blankline.enabled = true;
          native_lsp.enabled = true;
          neotree = true;
          telescope.enabled = true;
          treesitter = true;
          which_key = true;
        };
      };
    };

    # ══════════════════════════════════════════════════════════════
    # Plugins
    # ══════════════════════════════════════════════════════════════
    plugins = {
      # ────────────────────────────────────────────────────────────
      # UI Plugins
      # ────────────────────────────────────────────────────────────
      lualine.enable = true;
      web-devicons.enable = true;

      # Bufferline - buffer tabs like VSCode
      # Keymaps: <Tab>=next, <S-Tab>=prev, <leader>bp=pin, <leader>bo=close others
      bufferline = {
        enable = true;
        settings = {
          options = {
            mode = "buffers";
            diagnostics = "nvim_lsp";
            separator_style = "thin";
            show_buffer_close_icons = true;
            show_close_icon = false;
            always_show_bufferline = true;
            offsets = [
              {
                filetype = "snacks_picker_list";
                text = "Explorer";
                highlight = "Directory";
                separator = true;
              }
            ];
          };
        };
      };

      # ────────────────────────────────────────────────────────────
      # REPLACED BY snacks.nvim:
      # - toggleterm → Snacks.terminal
      # - alpha-nvim → Snacks.dashboard
      # - indent-blankline → Snacks.indent
      # - fidget → Snacks.notifier
      # All configured in extraConfigLua
      # ────────────────────────────────────────────────────────────

      # ────────────────────────────────────────────────────────────
      # Treesitter - Syntax Highlighting
      # ────────────────────────────────────────────────────────────
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
          ensure_installed = [
            "javascript"
            "typescript"
            "tsx"
            "python"
            "rust"
            "go"
            "c"
            "cpp"
            "nix"
            "lua"
            "json"
            "yaml"
            "html"
            "css"
            "markdown"
            "markdown_inline"
            "bash"
          ];
        };
      };

      # ────────────────────────────────────────────────────────────
      # Telescope - REPLACED BY snacks.nvim picker
      # Keymaps now in extraConfigLua via Snacks.picker
      # ────────────────────────────────────────────────────────────

      # ────────────────────────────────────────────────────────────
      # Neo-tree - REPLACED BY snacks.nvim explorer
      # Keymaps now in extraConfigLua via Snacks.explorer
      # ────────────────────────────────────────────────────────────

      # ────────────────────────────────────────────────────────────
      # LSP - Language Server Protocol
      # ────────────────────────────────────────────────────────────
      lsp = {
        enable = true;
        servers = {
          ts_ls.enable = true;         # TypeScript/JavaScript
          pyright.enable = true;        # Python
          ruff.enable = true;           # Python linting
          rust_analyzer = {             # Rust (uses project toolchain via direnv)
            enable = true;
            installCargo = false;
            installRustc = false;
          };
          clangd.enable = true;         # C/C++
          gopls.enable = true;          # Go
          nil_ls.enable = true;         # Nix
          lua_ls.enable = true;         # Lua
          html.enable = true;           # HTML
          cssls.enable = true;          # CSS
          jsonls.enable = true;         # JSON
        };
      };

      # ────────────────────────────────────────────────────────────
      # Completion - blink.cmp
      # Keymaps (default preset):
      #   <C-Space> = Show/toggle completion menu
      #   <C-n>/<Down> = Next item
      #   <C-p>/<Up> = Previous item
      #   <C-y> = Accept completion
      #   <C-e> = Close menu
      #   <C-b>/<C-f> = Scroll docs up/down
      #   <Tab>/<S-Tab> = Snippet jump forward/backward
      #   <C-k> = Toggle signature help
      # ────────────────────────────────────────────────────────────
      blink-cmp = {
        enable = true;
        settings = {
          keymap = {
            preset = "default";
          };
          appearance = {
            nerd_font_variant = "mono";
          };
          sources = {
            default = [ "lsp" "path" "snippets" "buffer" ];
          };
          completion = {
            documentation = {
              auto_show = true;
              auto_show_delay_ms = 200;
            };
            menu = {
              draw = {
                columns = [
                  { __unkeyed-1 = "kind_icon"; }
                  { __unkeyed-1 = "label"; __unkeyed-2 = "label_description"; gap = 1; }
                ];
              };
            };
          };
          signature = {
            enabled = true;
          };
        };
      };

      # ────────────────────────────────────────────────────────────
      # Conform - Formatting
      # ────────────────────────────────────────────────────────────
      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
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
      };

      # ────────────────────────────────────────────────────────────
      # Trouble - Diagnostics Panel
      # ────────────────────────────────────────────────────────────
      trouble = {
        enable = true;
        settings = {
          auto_close = true;
          focus = true;
        };
      };

      # ────────────────────────────────────────────────────────────
      # Todo Comments
      # ────────────────────────────────────────────────────────────
      todo-comments = {
        enable = true;
        settings = {
          signs = true;
          highlight = {
            multiline = true;
            comments_only = true;
          };
        };
      };

      # ────────────────────────────────────────────────────────────
      # Git Integration
      # Keymaps (see on_attach in extraConfigLua):
      #   Navigation: ]c/[c = next/prev hunk
      #   Staging: <leader>hs=stage hunk, <leader>hS=stage buffer
      #           <leader>hu=undo stage, <leader>hr=reset hunk, <leader>hR=reset buffer
      #   View: <leader>hp=preview, <leader>hd=diff, <leader>hD=diff ~
      #   Blame: <leader>hb=blame line, <leader>tb=toggle blame
      #   Text object: ih = select hunk (in visual/operator mode)
      # ────────────────────────────────────────────────────────────
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

      # ────────────────────────────────────────────────────────────
      # Editing Helpers
      # ────────────────────────────────────────────────────────────

      # Comment.nvim - Toggle comments (built-in keymaps)
      # Normal mode:
      #   gcc = Toggle line comment
      #   gbc = Toggle block comment
      #   [count]gcc = Toggle [count] lines
      # Operator-pending:
      #   gc{motion} = Comment with motion (e.g., gcip = comment paragraph)
      #   gb{motion} = Block comment with motion
      # Extra:
      #   gco = Insert comment below
      #   gcO = Insert comment above
      #   gcA = Insert comment at end of line
      # Visual mode:
      #   gc = Toggle linewise comment
      #   gb = Toggle blockwise comment
      comment.enable = true;

      # nvim-surround - Surround text with pairs (built-in keymaps)
      # Normal mode:
      #   ys{motion}{char} = Add surround (e.g., ysiw" = surround word with ")
      #   yss{char} = Surround entire line
      #   ds{char} = Delete surround (e.g., ds" = remove quotes)
      #   cs{old}{new} = Change surround (e.g., cs'" = change ' to ")
      # Visual mode:
      #   S{char} = Surround selection
      nvim-surround.enable = true;

      # Flash - Quick Navigation
      # Keymaps:
      #   s = Flash jump (n/x/o modes)
      #   S = Flash Treesitter (n/x/o modes)
      #   r = Remote Flash (operator mode)
      #   R = Treesitter Search (o/x modes)
      #   <C-s> = Toggle Flash in search mode (c mode)
      # Enhanced char motions (automatic):
      #   f/F/t/T + char = jump with labels
      #   ; = next match, , = previous match
      flash = {
        enable = true;
        settings = {
          labels = "asdfghjklqwertyuiopzxcvbnm";
          search = {
            mode = "fuzzy";
          };
          jump = {
            autojump = false;
          };
          modes = {
            char = {
              enabled = true;
              jump_labels = true;
              multi_line = true;
            };
            search = {
              enabled = true;
            };
          };
        };
      };

      # TreeSJ - Split/Join
      treesj = {
        enable = true;
        settings = {
          use_default_keymaps = false;
          max_join_length = 120;
        };
      };

      # ────────────────────────────────────────────────────────────
      # Which Key - Keybinding Help
      # Press <leader> and wait to see all available keybindings
      # ────────────────────────────────────────────────────────────
      which-key = {
        enable = true;
        settings = {
          spec = [
            # ── Find (Snacks.picker) ──
            { __unkeyed-1 = "<leader>f"; group = "Find"; icon = " "; }

            # ── Code/LSP ──
            { __unkeyed-1 = "<leader>c"; group = "Code"; icon = " "; }
            { __unkeyed-1 = "<leader>r"; group = "Refactor"; icon = " "; }

            # ── Git ──
            { __unkeyed-1 = "<leader>g"; group = "Git"; icon = "󰊢 "; }
            { __unkeyed-1 = "<leader>h"; group = "Git Hunk"; icon = " "; }

            # ── Trouble/Diagnostics ──
            { __unkeyed-1 = "<leader>x"; group = "Trouble"; icon = "󱖫 "; }

            # ── Search/Split ──
            { __unkeyed-1 = "<leader>s"; group = "Search/Split"; icon = " "; }

            # ── Toggle (vim options) ──
            { __unkeyed-1 = "<leader>t"; group = "Toggle"; icon = " "; }

            # ── UI Toggles (Snacks.toggle) ──
            { __unkeyed-1 = "<leader>u"; group = "UI Toggle"; icon = "󰙵 "; }

            # ── Buffer ──
            { __unkeyed-1 = "<leader>b"; group = "Buffer"; icon = " "; }

            # ── Go to ──
            { __unkeyed-1 = "g"; group = "Go to"; }

            # ── Brackets navigation ──
            { __unkeyed-1 = "["; group = "Previous"; }
            { __unkeyed-1 = "]"; group = "Next"; }

            # ── Surround (nvim-surround) ──
            { __unkeyed-1 = "ys"; group = "Add surround"; }
            { __unkeyed-1 = "cs"; group = "Change surround"; }
            { __unkeyed-1 = "ds"; group = "Delete surround"; }

            # ── Window Navigation ──
            { __unkeyed-1 = "<C-w>"; group = "Window"; icon = " "; }
          ];
        };
      };
    };

    # ══════════════════════════════════════════════════════════════
    # Extra Plugins (not in nixvim modules)
    # ══════════════════════════════════════════════════════════════
    extraPlugins = with pkgs.vimPlugins; [
      smear-cursor-nvim
      # vim-visual-multi - Multi-cursor support (like Ctrl+D in VS Code)
      (pkgs.vimUtils.buildVimPlugin {
        name = "vim-visual-multi";
        src = pkgs.fetchFromGitHub {
          owner = "mg979";
          repo = "vim-visual-multi";
          rev = "master";
          sha256 = "sha256-KzBWkB/PYph6OfuF0GgNFYgqUAwMYbQQZbaaG9XuWZY=";
        };
      })
      # snacks.nvim - batteries-included plugin collection
      # Replaces: telescope, neo-tree, alpha-nvim, toggleterm, indent-blankline, fidget
      (pkgs.vimUtils.buildVimPlugin {
        name = "snacks-nvim";
        src = pkgs.fetchFromGitHub {
          owner = "folke";
          repo = "snacks.nvim";
          rev = "fe7cfe9800a182274d0f868a74b7263b8c0c020b";
          sha256 = "sha256-vRedYg29QGPGW0hOX9qbRSIImh1d/SoDZHImDF2oqKM=";
        };
        # Disable all checks - snacks.nvim modules need runtime setup
        doCheck = false;
      })
    ];

    extraConfigLua = ''
      -- Smear Cursor Animation
      require("smear_cursor").setup({
        stiffness = 0.8,
        trailing_stiffness = 0.5,
        distance_stop_animating = 0.5,
        legacy_computing_symbols_support = true,
      })

      -- ══════════════════════════════════════════════════════════════
      -- snacks.nvim - Batteries included plugin collection
      -- Replaces: telescope, neo-tree, alpha-nvim, toggleterm,
      --           indent-blankline, fidget
      -- ══════════════════════════════════════════════════════════════

      require("snacks").setup({
        -- ── Core Features ──
        bigfile = { enabled = true },
        quickfile = { enabled = true },
        input = { enabled = true },
        scope = { enabled = true },
        words = { enabled = true },

        -- ── UI Features ──
        notifier = {
          enabled = true,
          timeout = 3000,
          style = "compact",
        },

        indent = {
          enabled = true,
          char = "│",
          scope = { enabled = true },
        },

        scroll = {
          enabled = true,
          animate = {
            duration = { step = 15, total = 250 },
          },
        },

        -- ── Picker (replaces Telescope) ──
        picker = {
          enabled = true,
          sources = {
            files = { hidden = true },
            grep = { hidden = true },
            -- Explorer on the right side
            explorer = {
              layout = { layout = { position = "right" } },
            },
          },
        },

        -- ── Explorer (replaces Neo-tree) ──
        explorer = {
          enabled = true,
          replace_netrw = true,
        },

        -- ── Terminal (replaces toggleterm) ──
        terminal = {
          enabled = true,
          win = {
            style = "float",
            border = "rounded",
          },
        },

        -- ── Dashboard ──
        dashboard = {
          enabled = true,
          sections = {
            { section = "header" },
            { section = "keys", gap = 1, padding = 1 },
          },
        },

        -- ── Extra Features ──
        lazygit = { enabled = true },
        zen = { enabled = true },
        toggle = { enabled = true },
        rename = { enabled = true },
        dim = { enabled = true },
        git = { enabled = true },
        gitbrowse = { enabled = true },
      })

      -- ══════════════════════════════════════════════════════════════
      -- Snacks Keymaps
      -- ══════════════════════════════════════════════════════════════

      local map = vim.keymap.set

      -- ── Picker (File/Buffer/Search) ──
      map("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find files" })
      map("n", "<leader>fg", function() Snacks.picker.grep() end, { desc = "Live grep" })
      map("n", "<leader>fw", function() Snacks.picker.grep_word() end, { desc = "Grep word under cursor" })
      map("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Recent files" })
      map("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
      map("n", "<leader>fj", function() Snacks.picker.jumps() end, { desc = "Jump list" })
      map("n", "<leader>f/", function() Snacks.picker.lines() end, { desc = "Fuzzy find in buffer" })
      map("n", "<leader>fs", function() Snacks.picker.lsp_symbols() end, { desc = "Document symbols" })
      map("n", "<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "Workspace symbols" })

      -- ── Picker (Diagnostics/LSP) ──
      map("n", "<leader>fd", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })
      map("n", "<leader>fD", function() Snacks.picker.lsp_definitions() end, { desc = "LSP definitions" })
      map("n", "<leader>fi", function() Snacks.picker.lsp_implementations() end, { desc = "LSP implementations" })
      map("n", "<leader>fR", function() Snacks.picker.lsp_references() end, { desc = "LSP references" })
      map("n", "<leader>fy", function() Snacks.picker.lsp_type_definitions() end, { desc = "LSP type definitions" })

      -- ── Picker (Git) ──
      map("n", "<leader>gc", function() Snacks.picker.git_log() end, { desc = "Git commits" })
      map("n", "<leader>gb", function() Snacks.picker.git_branches() end, { desc = "Git branches" })
      map("n", "<leader>gs", function() Snacks.picker.git_status() end, { desc = "Git status" })
      map("n", "<leader>gS", function() Snacks.picker.git_stash() end, { desc = "Git stash" })
      map("n", "<leader>gd", function() Snacks.picker.git_diff() end, { desc = "Git diff" })
      map("n", "<leader>gf", function() Snacks.picker.git_log_file() end, { desc = "Git log file" })

      -- ── Picker (Vim) ──
      map("n", "<leader>fh", function() Snacks.picker.help() end, { desc = "Help tags" })
      map("n", "<leader>fc", function() Snacks.picker.commands() end, { desc = "Commands" })
      map("n", "<leader>fk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
      map("n", "<leader>fm", function() Snacks.picker.marks() end, { desc = "Marks" })
      map("n", "<leader>fq", function() Snacks.picker.qflist() end, { desc = "Quickfix list" })
      map("n", "<leader>fl", function() Snacks.picker.loclist() end, { desc = "Location list" })
      map("n", "<leader>f:", function() Snacks.picker.command_history() end, { desc = "Command history" })
      map("n", "<leader>f'", function() Snacks.picker.registers() end, { desc = "Registers" })

      -- ── Picker (Extra) ──
      map("n", "<leader><space>", function() Snacks.picker.smart() end, { desc = "Smart find files" })
      map("n", "<leader>,", function() Snacks.picker.buffers() end, { desc = "Buffers" })
      map("n", "<leader>/", function() Snacks.picker.grep() end, { desc = "Grep" })
      map("n", "<leader>fu", function() Snacks.picker.undo() end, { desc = "Undo history" })
      map("n", "<leader>fp", function() Snacks.picker.projects() end, { desc = "Projects" })
      map("n", "<leader>fn", function() Snacks.picker.notifications() end, { desc = "Notifications" })

      -- ── LSP Go-to (using Snacks picker) ──
      map("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Go to definition" })
      map("n", "gr", function() Snacks.picker.lsp_references() end, { desc = "Go to references" })
      map("n", "gi", function() Snacks.picker.lsp_implementations() end, { desc = "Go to implementation" })
      map("n", "gy", function() Snacks.picker.lsp_type_definitions() end, { desc = "Go to type definition" })

      -- ── Explorer ──
      map("n", "<leader>e", function() Snacks.explorer() end, { desc = "Toggle explorer" })

      -- ── Terminal ──
      map("n", "<C-\\>", function() Snacks.terminal.toggle() end, { desc = "Toggle terminal" })
      map("t", "<C-\\>", function() Snacks.terminal.toggle() end, { desc = "Toggle terminal" })

      -- ── Extra Features ──
      map("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" })
      map("n", "<leader>z", function() Snacks.zen() end, { desc = "Zen mode" })
      map("n", "<leader>Z", function() Snacks.zen.zoom() end, { desc = "Zoom window" })
      map("n", "<leader>.", function() Snacks.scratch() end, { desc = "Scratch buffer" })
      map("n", "<leader>n", function() Snacks.notifier.show_history() end, { desc = "Notification history" })

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
    '';

    # ══════════════════════════════════════════════════════════════
    # Keymaps
    # ══════════════════════════════════════════════════════════════
    keymaps = [
      # ──────────────────────────────────────────────────────────
      # General
      # ──────────────────────────────────────────────────────────
      { mode = "n"; key = "<Esc>"; action = "<cmd>nohlsearch<CR>"; options.desc = "Clear search highlight"; }
      # <leader>e (explorer) and <C-\> (terminal) are now in extraConfigLua via Snacks

      # ──────────────────────────────────────────────────────────
      # Terminal navigation (Snacks.terminal handles toggle via extraConfigLua)
      # ──────────────────────────────────────────────────────────
      { mode = "t"; key = "<Esc>"; action = "<C-\\><C-n>"; options.desc = "Exit terminal mode"; }
      { mode = "t"; key = "<C-h>"; action = "<C-\\><C-n><C-w>h"; options.desc = "Move to left window"; }
      { mode = "t"; key = "<C-j>"; action = "<C-\\><C-n><C-w>j"; options.desc = "Move to bottom window"; }
      { mode = "t"; key = "<C-k>"; action = "<C-\\><C-n><C-w>k"; options.desc = "Move to top window"; }
      { mode = "t"; key = "<C-l>"; action = "<C-\\><C-n><C-w>l"; options.desc = "Move to right window"; }

      # ──────────────────────────────────────────────────────────
      # Bufferline (buffer tabs)
      # <Tab>=next, <S-Tab>=prev, <leader>b*=buffer actions
      # ──────────────────────────────────────────────────────────
      { mode = "n"; key = "<Tab>"; action = "<cmd>BufferLineCycleNext<CR>"; options.desc = "Next buffer"; }
      { mode = "n"; key = "<S-Tab>"; action = "<cmd>BufferLineCyclePrev<CR>"; options.desc = "Previous buffer"; }
      { mode = "n"; key = "<leader>bp"; action = "<cmd>BufferLineTogglePin<CR>"; options.desc = "Pin buffer"; }
      {
        mode = "n";
        key = "<leader>bP";
        action = ''
          <cmd>lua
            local modified = vim.tbl_filter(function(buf) return vim.bo[buf].modified end, vim.api.nvim_list_bufs())
            if #modified > 0 then
              local choice = vim.fn.confirm(#modified .. " unsaved buffer(s). Save all?", "&Yes\n&No\n&Cancel", 1)
              if choice == 1 then vim.cmd("wa") elseif choice ~= 2 then return end
            end
            vim.cmd("BufferLineGroupClose ungrouped")
          <CR>
        '';
        options.desc = "Close unpinned buffers";
      }
      {
        mode = "n";
        key = "<leader>bo";
        action = ''
          <cmd>lua
            local current = vim.api.nvim_get_current_buf()
            local modified = vim.tbl_filter(function(buf) return buf ~= current and vim.bo[buf].modified end, vim.api.nvim_list_bufs())
            if #modified > 0 then
              local choice = vim.fn.confirm(#modified .. " unsaved buffer(s). Save all?", "&Yes\n&No\n&Cancel", 1)
              if choice == 1 then vim.cmd("wa") elseif choice ~= 2 then return end
            end
            vim.cmd("BufferLineCloseOthers")
          <CR>
        '';
        options.desc = "Close other buffers";
      }
      {
        mode = "n";
        key = "<leader>bl";
        action = ''
          <cmd>lua
            local modified = vim.tbl_filter(function(buf) return vim.bo[buf].modified end, vim.api.nvim_list_bufs())
            if #modified > 0 then
              local choice = vim.fn.confirm(#modified .. " unsaved buffer(s). Save all?", "&Yes\n&No\n&Cancel", 1)
              if choice == 1 then vim.cmd("wa") elseif choice ~= 2 then return end
            end
            vim.cmd("BufferLineCloseRight")
          <CR>
        '';
        options.desc = "Close buffers to right";
      }
      {
        mode = "n";
        key = "<leader>bh";
        action = ''
          <cmd>lua
            local modified = vim.tbl_filter(function(buf) return vim.bo[buf].modified end, vim.api.nvim_list_bufs())
            if #modified > 0 then
              local choice = vim.fn.confirm(#modified .. " unsaved buffer(s). Save all?", "&Yes\n&No\n&Cancel", 1)
              if choice == 1 then vim.cmd("wa") elseif choice ~= 2 then return end
            end
            vim.cmd("BufferLineCloseLeft")
          <CR>
        '';
        options.desc = "Close buffers to left";
      }
      { mode = "n"; key = "<leader>b1"; action = "<cmd>BufferLineGoToBuffer 1<CR>"; options.desc = "Go to buffer 1"; }
      { mode = "n"; key = "<leader>b2"; action = "<cmd>BufferLineGoToBuffer 2<CR>"; options.desc = "Go to buffer 2"; }
      { mode = "n"; key = "<leader>b3"; action = "<cmd>BufferLineGoToBuffer 3<CR>"; options.desc = "Go to buffer 3"; }
      {
        mode = "n";
        key = "<leader>bd";
        action = ''
          <cmd>lua
            local buf = vim.api.nvim_get_current_buf()
            if vim.bo[buf].modified then
              local choice = vim.fn.confirm("Save changes?", "&Yes\n&No\n&Cancel", 1)
              if choice == 1 then
                vim.cmd("write")
                vim.cmd("bdelete")
              elseif choice == 2 then
                vim.cmd("bdelete!")
              end
            else
              vim.cmd("bdelete")
            end
          <CR>
        '';
        options.desc = "Close buffer (prompt if unsaved)";
      }

      # ──────────────────────────────────────────────────────────
      # LSP - Language Server Protocol
      # Navigation: gd, gr, gi, gy are now in extraConfigLua via Snacks.picker
      # Info: K=hover, <C-k>=signature
      # Actions: <leader>ca=code action, <leader>rn=rename, <leader>cf=format
      # Diagnostics: [d/]d=prev/next, <leader>cd=show float
      # ──────────────────────────────────────────────────────────
      # Go to declaration (not in Snacks)
      { mode = "n"; key = "gD"; action = "<cmd>lua vim.lsp.buf.declaration()<CR>"; options.desc = "Go to declaration"; }
      # Info
      { mode = "n"; key = "K"; action = "<cmd>lua vim.lsp.buf.hover()<CR>"; options.desc = "Hover documentation"; }
      { mode = ["n" "i"]; key = "<C-k>"; action = "<cmd>lua vim.lsp.buf.signature_help()<CR>"; options.desc = "Signature help"; }
      # Actions
      { mode = ["n" "v"]; key = "<leader>ca"; action = "<cmd>lua vim.lsp.buf.code_action()<CR>"; options.desc = "Code actions"; }
      { mode = "n"; key = "<leader>rn"; action = "<cmd>lua vim.lsp.buf.rename()<CR>"; options.desc = "Rename symbol"; }
      { mode = "n"; key = "<leader>cl"; action = "<cmd>lua vim.lsp.codelens.run()<CR>"; options.desc = "CodeLens action"; }
      # Diagnostics
      { mode = "n"; key = "[d"; action = "<cmd>lua vim.diagnostic.goto_prev()<CR>"; options.desc = "Previous diagnostic"; }
      { mode = "n"; key = "]d"; action = "<cmd>lua vim.diagnostic.goto_next()<CR>"; options.desc = "Next diagnostic"; }
      { mode = "n"; key = "<leader>cd"; action = "<cmd>lua vim.diagnostic.open_float()<CR>"; options.desc = "Show diagnostic"; }
      { mode = "n"; key = "<leader>cq"; action = "<cmd>lua vim.diagnostic.setloclist()<CR>"; options.desc = "Diagnostics to loclist"; }

      # ──────────────────────────────────────────────────────────
      # Formatting
      # ──────────────────────────────────────────────────────────
      { mode = "n"; key = "<leader>cf"; action = "<cmd>lua require('conform').format()<CR>"; options.desc = "Format buffer"; }
      { mode = "v"; key = "<leader>cf"; action = "<cmd>lua require('conform').format()<CR>"; options.desc = "Format selection"; }

      # ──────────────────────────────────────────────────────────
      # Trouble - Diagnostics Panel
      # Inside Trouble window:
      #   j/k = navigate, <CR> = jump, o = jump+close
      #   <C-s>/<C-v> = split/vsplit, p/P = preview/toggle
      #   q/<Esc> = close, r = refresh, ? = help
      #   Folds: zo/zc/za = open/close/toggle, zR/zM = open all/close all
      # ──────────────────────────────────────────────────────────
      { mode = "n"; key = "<leader>xx"; action = "<cmd>Trouble diagnostics toggle<CR>"; options.desc = "Toggle Trouble"; }
      { mode = "n"; key = "<leader>xd"; action = "<cmd>Trouble diagnostics toggle filter.buf=0<CR>"; options.desc = "Buffer diagnostics"; }
      { mode = "n"; key = "<leader>xw"; action = "<cmd>Trouble diagnostics toggle<CR>"; options.desc = "Workspace diagnostics"; }
      { mode = "n"; key = "<leader>xq"; action = "<cmd>Trouble qflist toggle<CR>"; options.desc = "Quickfix list"; }
      { mode = "n"; key = "<leader>xl"; action = "<cmd>Trouble loclist toggle<CR>"; options.desc = "Location list"; }
      { mode = "n"; key = "<leader>xr"; action = "<cmd>Trouble lsp_references toggle<CR>"; options.desc = "LSP references"; }
      { mode = "n"; key = "<leader>xs"; action = "<cmd>Trouble symbols toggle focus=false<CR>"; options.desc = "Symbols outline"; }

      # ──────────────────────────────────────────────────────────
      # Todo Comments
      # ──────────────────────────────────────────────────────────
      { mode = "n"; key = "]t"; action.__raw = "function() require('todo-comments').jump_next() end"; options.desc = "Next TODO"; }
      { mode = "n"; key = "[t"; action.__raw = "function() require('todo-comments').jump_prev() end"; options.desc = "Previous TODO"; }
      { mode = "n"; key = "<leader>st"; action = "<cmd>TodoTelescope<CR>"; options.desc = "Search TODOs"; }
      { mode = "n"; key = "<leader>xt"; action = "<cmd>Trouble todo toggle<CR>"; options.desc = "TODOs in Trouble"; }

      # ──────────────────────────────────────────────────────────
      # Flash - Quick Navigation
      # ──────────────────────────────────────────────────────────
      { mode = ["n" "x" "o"]; key = "s"; action.__raw = "function() require('flash').jump() end"; options.desc = "Flash jump"; }
      { mode = ["n" "x" "o"]; key = "S"; action.__raw = "function() require('flash').treesitter() end"; options.desc = "Flash Treesitter"; }
      { mode = "o"; key = "r"; action.__raw = "function() require('flash').remote() end"; options.desc = "Remote Flash"; }
      { mode = ["o" "x"]; key = "R"; action.__raw = "function() require('flash').treesitter_search() end"; options.desc = "Treesitter Search"; }
      { mode = "c"; key = "<C-s>"; action.__raw = "function() require('flash').toggle() end"; options.desc = "Toggle Flash Search"; }
      { mode = ["n" "x" "o"]; key = "f"; action.__raw = "function() require('flash').jump({mode = 'char', search = {mode = 'search'}}) end"; options.desc = "Flash f"; }
      { mode = ["n" "x" "o"]; key = "F"; action.__raw = "function() require('flash').jump({mode = 'char', search = {mode = 'search', forward = false}}) end"; options.desc = "Flash F"; }
      { mode = ["n" "x" "o"]; key = "t"; action.__raw = "function() require('flash').jump({mode = 'char', search = {mode = 'search'}, jump = {offset = -1}}) end"; options.desc = "Flash t"; }
      { mode = ["n" "x" "o"]; key = "T"; action.__raw = "function() require('flash').jump({mode = 'char', search = {mode = 'search', forward = false}, jump = {offset = 1}}) end"; options.desc = "Flash T"; }

      # ──────────────────────────────────────────────────────────
      # Gitsigns - See on_attach in gitsigns settings above
      # ──────────────────────────────────────────────────────────
      # Note: All git hunk keymaps are defined in gitsigns.settings.on_attach

      # ──────────────────────────────────────────────────────────
      # TreeSJ - Split/Join
      # ──────────────────────────────────────────────────────────
      { mode = "n"; key = "<leader>m"; action = "<cmd>TSJToggle<CR>"; options.desc = "Toggle split/join"; }
      { mode = "n"; key = "<leader>sj"; action = "<cmd>TSJJoin<CR>"; options.desc = "Join code block"; }
      { mode = "n"; key = "<leader>ss"; action = "<cmd>TSJSplit<CR>"; options.desc = "Split code block"; }

      # ──────────────────────────────────────────────────────────
      # Window/Split Navigation
      # ──────────────────────────────────────────────────────────
      # Navigation:
      #   <C-h/j/k/l> = Move to left/down/up/right window
      # Split creation:
      #   <C-w>s or :split = Horizontal split
      #   <C-w>v or :vsplit = Vertical split
      # Split management:
      #   <C-w>q = Close current window
      #   <C-w>o = Close all other windows (only keep current)
      #   <C-w>= = Equalize window sizes
      #   <C-w>_ = Maximize height
      #   <C-w>| = Maximize width
      #   <C-w>r = Rotate windows
      #   <C-w>x = Swap with next window
      # Trouble panel:
      #   <leader>xx = Toggle Trouble panel
      #   q or <Esc> = Close Trouble (when focused)
      #   j/k = Navigate items in Trouble
      # ──────────────────────────────────────────────────────────
      { mode = "n"; key = "<C-h>"; action = "<C-w>h"; options.desc = "Move to left window"; }
      { mode = "n"; key = "<C-j>"; action = "<C-w>j"; options.desc = "Move to bottom window"; }
      { mode = "n"; key = "<C-k>"; action = "<C-w>k"; options.desc = "Move to top window"; }
      { mode = "n"; key = "<C-l>"; action = "<C-w>l"; options.desc = "Move to right window"; }

      # ──────────────────────────────────────────────────────────
      # Buffer navigation
      # ──────────────────────────────────────────────────────────
      { mode = "n"; key = "<S-h>"; action = "<cmd>bprevious<CR>"; options.desc = "Previous buffer"; }
      { mode = "n"; key = "<S-l>"; action = "<cmd>bnext<CR>"; options.desc = "Next buffer"; }
      { mode = "n"; key = "<leader>bd"; action = "<cmd>bdelete<CR>"; options.desc = "Delete buffer"; }

      # ──────────────────────────────────────────────────────────
      # Better indenting (stay in visual mode)
      # ──────────────────────────────────────────────────────────
      { mode = "v"; key = "<"; action = "<gv"; options.desc = "Indent left"; }
      { mode = "v"; key = ">"; action = ">gv"; options.desc = "Indent right"; }

      # ──────────────────────────────────────────────────────────
      # Move lines up/down
      # ──────────────────────────────────────────────────────────
      { mode = "n"; key = "<A-j>"; action = "<cmd>m .+1<CR>=="; options.desc = "Move line down"; }
      { mode = "n"; key = "<A-k>"; action = "<cmd>m .-2<CR>=="; options.desc = "Move line up"; }
      { mode = "v"; key = "<A-j>"; action = ":m '>+1<CR>gv=gv"; options.desc = "Move selection down"; }
      { mode = "v"; key = "<A-k>"; action = ":m '<-2<CR>gv=gv"; options.desc = "Move selection up"; }

      # ──────────────────────────────────────────────────────────
      # Multi-Cursor (vim-visual-multi)
      # ──────────────────────────────────────────────────────────
      # Note: These keymaps are managed by vim-visual-multi plugin (see globals.VM_maps)
      #
      # Selection:
      #   <C-n>       = Select word under cursor, add next occurrence
      #   <C-n>       = From visual mode: select without word boundaries
      #   <C-Down>    = Add cursor below
      #   <C-Up>      = Add cursor above
      #   \\A         = Select ALL occurrences of word
      #   \\/         = Start regex search for multi-select
      #   \\c         = Toggle case sensitivity
      #
      # Navigation (in multi-cursor mode):
      #   n/N         = Go to next/previous occurrence
      #   [/]         = Go to previous/next cursor
      #
      # Editing:
      #   q           = Skip current occurrence, select next
      #   Q           = Remove current cursor/region
      #   <Tab>       = Switch between Cursor mode and Extend mode
      #   i/a/I/A     = Enter insert mode (like normal vim)
      #   c/s/r       = Change/substitute/replace
      #   <Esc>       = Exit multi-cursor mode
      #
      # Extend Mode (visual-like):
      #   Use motions to extend selection at all cursors
      # ──────────────────────────────────────────────────────────
    ];
  };
}
