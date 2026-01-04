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
                filetype = "neo-tree";
                text = "File Explorer";
                highlight = "Directory";
                separator = true;
              }
            ];
          };
        };
      };

      # Toggleterm - floating terminal
      # Keymaps: <C-\>=toggle, <Esc>=exit terminal mode
      toggleterm = {
        enable = true;
        settings = {
          direction = "float";
          open_mapping = "[[<C-\\>]]";
          float_opts = {
            border = "curved";
            winblend = 0;
          };
          size = 20;
        };
      };

      # Alpha Dashboard - configured via extraConfigLua
      # Uses itachi.lua from ~/.config/nix/ascii/
      # Note: We only enable the plugin, setup is done in extraConfigLua

      # Indent guides
      indent-blankline = {
        enable = true;
        settings = {
          indent = {
            char = "│";
          };
          scope = {
            enabled = true;
            show_start = true;
          };
          exclude = {
            filetypes = [ "help" "alpha" "dashboard" "neo-tree" "Trouble" "lazy" ];
          };
        };
      };

      # Fidget - LSP progress
      fidget = {
        enable = true;
        settings = {
          notification = {
            window = {
              winblend = 0;
            };
          };
          progress = {
            display = {
              done_ttl = 3;
            };
          };
        };
      };

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
      # Telescope - Fuzzy Finder
      # Inside Telescope picker:
      #   i-mode: <C-n>/<C-p>=next/prev, <CR>=confirm, <C-x>=split, <C-v>=vsplit
      #          <C-t>=tab, <C-u>/<C-d>=scroll preview, <C-/>/?=help, <C-c>=close
      #          <Tab>=toggle+next, <C-q>=send all to qf, <M-q>=send selected to qf
      #   n-mode: j/k=next/prev, gg/G=first/last, <Esc>=close
      # ────────────────────────────────────────────────────────────
      telescope = {
        enable = true;
        keymaps = {
          # ── File Pickers ──
          "<leader>ff" = { action = "find_files"; options.desc = "Find files"; };
          "<leader>fg" = { action = "live_grep"; options.desc = "Live grep"; };
          "<leader>fw" = { action = "grep_string"; options.desc = "Grep word under cursor"; };
          "<leader>fr" = { action = "oldfiles"; options.desc = "Recent files"; };

          # ── Buffer & Window ──
          "<leader>fb" = { action = "buffers"; options.desc = "Buffers"; };
          "<leader>fj" = { action = "jumplist"; options.desc = "Jump list"; };

          # ── Search ──
          "<leader>f/" = { action = "current_buffer_fuzzy_find"; options.desc = "Fuzzy find in buffer"; };
          "<leader>fs" = { action = "lsp_document_symbols"; options.desc = "Document symbols"; };
          "<leader>fS" = { action = "lsp_workspace_symbols"; options.desc = "Workspace symbols"; };

          # ── LSP Pickers ──
          "<leader>fd" = { action = "diagnostics"; options.desc = "Diagnostics"; };
          "<leader>fD" = { action = "lsp_definitions"; options.desc = "LSP definitions"; };
          "<leader>fi" = { action = "lsp_implementations"; options.desc = "LSP implementations"; };
          "<leader>fR" = { action = "lsp_references"; options.desc = "LSP references"; };
          "<leader>fy" = { action = "lsp_type_definitions"; options.desc = "LSP type definitions"; };

          # ── Git Pickers ──
          "<leader>gc" = { action = "git_commits"; options.desc = "Git commits"; };
          "<leader>gb" = { action = "git_branches"; options.desc = "Git branches"; };
          "<leader>gs" = { action = "git_status"; options.desc = "Git status"; };
          "<leader>gS" = { action = "git_stash"; options.desc = "Git stash"; };

          # ── Vim Pickers ──
          "<leader>fh" = { action = "help_tags"; options.desc = "Help tags"; };
          "<leader>fc" = { action = "commands"; options.desc = "Commands"; };
          "<leader>fk" = { action = "keymaps"; options.desc = "Keymaps"; };
          "<leader>fm" = { action = "marks"; options.desc = "Marks"; };
          "<leader>fq" = { action = "quickfix"; options.desc = "Quickfix list"; };
          "<leader>fl" = { action = "loclist"; options.desc = "Location list"; };
          "<leader>f:" = { action = "command_history"; options.desc = "Command history"; };
          "<leader>f'" = { action = "registers"; options.desc = "Registers"; };
        };
      };

      # ────────────────────────────────────────────────────────────
      # Neo-tree - File Explorer
      # Keymaps (inside neo-tree window):
      #   Navigation: <CR>=open, <Space>=toggle, q=close, ?=help
      #   Splits: S=horizontal, s=vertical, t=new tab, w=pick window
      #   File ops: a=new file, A=new dir, d=delete, r=rename
      #   Clipboard: y=copy, x=cut, p=paste, c=copy-to, m=move-to
      #   View: P=preview, l=focus preview, z=close all, R=refresh
      #   Git: [g/]g=prev/next modified, H=toggle hidden
      #   Order: oc/od/og/om/on/os/ot = by created/diag/git/modified/name/size/type
      # ────────────────────────────────────────────────────────────
      neo-tree = {
        enable = true;
        settings = {
          close_if_last_window = true;
          window = {
            width = 40;
            position = "right";
            mappings = {
              # ── Navigation & Opening ──
              "<CR>" = "open";
              "<2-LeftMouse>" = "open";
              "<Space>" = "toggle_node";
              "<Esc>" = "cancel";
              "q" = "close_window";
              "?" = "show_help";
              "<" = "prev_source";
              ">" = "next_source";

              # ── Split/Tab Opening ──
              "S" = "open_split";
              "s" = "open_vsplit";
              "t" = "open_tabnew";
              "w" = "open_with_window_picker";

              # ── Preview ──
              "P" = "toggle_preview";
              "l" = "focus_preview";

              # ── Node Operations ──
              "C" = "close_node";
              "z" = "close_all_nodes";
              "R" = "refresh";

              # ── File Operations ──
              "a" = "add";
              "A" = "add_directory";
              "d" = "delete";
              "r" = "rename";

              # ── Clipboard ──
              "y" = "copy_to_clipboard";
              "x" = "cut_to_clipboard";
              "p" = "paste_from_clipboard";
              "c" = "copy";
              "m" = "move";

              # ── File Info ──
              "i" = "show_file_details";
            };
          };

          # Filesystem-specific mappings
          filesystem = {
            window = {
              mappings = {
                # ── Directory Navigation ──
                "<BS>" = "navigate_up";
                "." = "set_root";

                # ── Filtering ──
                "H" = "toggle_hidden";
                "/" = "fuzzy_finder";
                "f" = "filter_on_submit";
                "<C-x>" = "clear_filter";

                # ── Git Navigation ──
                "[g" = "prev_git_modified";
                "]g" = "next_git_modified";

                # ── Order by (prefix: o) ──
                "oc" = "order_by_created";
                "od" = "order_by_diagnostics";
                "og" = "order_by_git_status";
                "om" = "order_by_modified";
                "on" = "order_by_name";
                "os" = "order_by_size";
                "ot" = "order_by_type";
              };
            };
            filtered_items = {
              visible = false;
              hide_dotfiles = false;
              hide_gitignored = true;
            };
          };
        };
      };

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
            # ── Find (Telescope) ──
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

            # ── Toggle ──
            { __unkeyed-1 = "<leader>t"; group = "Toggle"; icon = " "; }

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
      alpha-nvim  # Dashboard plugin, configured in extraConfigLua
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
    ];

    extraConfigLua = ''
      -- Smear Cursor Animation
      require("smear_cursor").setup({
        stiffness = 0.8,
        trailing_stiffness = 0.5,
        distance_stop_animating = 0.5,
        legacy_computing_symbols_support = true,
      })

      -- Alpha Dashboard with Itachi ASCII art
      local alpha = require("alpha")

      -- Load itachi.lua directly (it defines highlight groups and returns header)
      local itachi_path = vim.fn.expand("~/.config/nix/ascii/itachi.lua")
      local header = dofile(itachi_path)

      -- Dashboard buttons with working keymaps
      local function button(sc, txt, keybind, keybind_opts)
        local sc_clean = sc:gsub("%s", ""):gsub("SPC", "<leader>")
        local opts = {
          position = "center",
          shortcut = sc,
          cursor = 3,
          width = 50,
          align_shortcut = "right",
          hl_shortcut = "Keyword",
          keymap = { "n", sc_clean, keybind, keybind_opts or { noremap = true, silent = true, nowait = true } },
        }
        local on_press = function()
          local key = vim.api.nvim_replace_termcodes(keybind, true, false, true)
          vim.api.nvim_feedkeys(key, "t", false)
        end
        return {
          type = "button",
          val = txt,
          on_press = on_press,
          opts = opts,
        }
      end

      local buttons = {
        type = "group",
        val = {
          button("e", "  New File", "<cmd>ene<CR>"),
          button("f", "  Find File", "<cmd>Telescope find_files<CR>"),
          button("r", "  Recent Files", "<cmd>Telescope oldfiles<CR>"),
          button("g", "  Find Word", "<cmd>Telescope live_grep<CR>"),
          button("c", "  Configuration", "<cmd>e ~/.config/nix/modules/home/neovim.nix<CR>"),
          button("q", "  Quit", "<cmd>qa<CR>"),
        },
        opts = { spacing = 1 },
      }

      -- Footer with Itachi quote
      local footer = {
        type = "text",
        val = {
          "",
          "\"One's Reality Might Be Another's Illusion.\"",
          "                              - Itachi Uchiha",
        },
        opts = { position = "center", hl = "Comment" },
      }

      -- Layout
      local layout = {
        { type = "padding", val = 2 },
        header,
        { type = "padding", val = 2 },
        buttons,
        { type = "padding", val = 1 },
        footer,
      }

      alpha.setup({ layout = layout })
    '';

    # ══════════════════════════════════════════════════════════════
    # Keymaps
    # ══════════════════════════════════════════════════════════════
    keymaps = [
      # ──────────────────────────────────────────────────────────
      # General
      # ──────────────────────────────────────────────────────────
      { mode = "n"; key = "<Esc>"; action = "<cmd>nohlsearch<CR>"; options.desc = "Clear search highlight"; }
      { mode = "n"; key = "<leader>e"; action = "<cmd>Neotree toggle<CR>"; options.desc = "Toggle file explorer"; }

      # ──────────────────────────────────────────────────────────
      # Terminal (toggleterm)
      # <C-\>=toggle, <Esc>=exit terminal mode, <C-h/j/k/l>=navigate
      # ──────────────────────────────────────────────────────────
      { mode = "n"; key = "<C-\\>"; action = "<cmd>ToggleTerm<CR>"; options.desc = "Toggle terminal"; }
      { mode = "t"; key = "<C-\\>"; action = "<cmd>ToggleTerm<CR>"; options.desc = "Toggle terminal"; }
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
      # Navigation: gd=definition, gD=declaration, gr=references, gi=impl, gy=type
      # Info: K=hover, <C-k>=signature
      # Actions: <leader>ca=code action, <leader>rn=rename, <leader>cf=format
      # Diagnostics: [d/]d=prev/next, <leader>cd=show float
      # ──────────────────────────────────────────────────────────
      # Go to (using Telescope for better UI)
      { mode = "n"; key = "gd"; action = "<cmd>Telescope lsp_definitions<CR>"; options.desc = "Go to definition"; }
      { mode = "n"; key = "gD"; action = "<cmd>lua vim.lsp.buf.declaration()<CR>"; options.desc = "Go to declaration"; }
      { mode = "n"; key = "gr"; action = "<cmd>Telescope lsp_references<CR>"; options.desc = "Go to references"; }
      { mode = "n"; key = "gi"; action = "<cmd>Telescope lsp_implementations<CR>"; options.desc = "Go to implementation"; }
      { mode = "n"; key = "gy"; action = "<cmd>Telescope lsp_type_definitions<CR>"; options.desc = "Go to type definition"; }
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
