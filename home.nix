{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    nodePackages.pyright
    rnix-lsp
    ccls
    rust-analyzer
    clang
    gopls
  ];
  xdg.configFile."nvim/parser/c.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-c}/parser";
  xdg.configFile."nvim/parser/cpp.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-cpp}/parser";
  xdg.configFile."nvim/parser/lua.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-lua}/parser";
  xdg.configFile."nvim/parser/rust.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-rust}/parser";
  xdg.configFile."nvim/parser/python.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-python}/parser";
  xdg.configFile."nvim/parser/nix.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-nix}/parser";
  xdg.configFile."nvim/parser/json.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-json}/parser";
  xdg.configFile."nvim/parser/latex.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-latex}/parser";
  xdg.configFile."nvim/parser/go.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-go}/parser";
  xdg.configFile."nvim/parser/markdown.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-markdown}/parser";
  xdg.configFile."nvim/parser/julia.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-julia}/parser";

  programs = {
    go.enable = true;
    neovim = {
      enable = true;
      package = pkgs.neovim-nightly;
      vimAlias = true;
      viAlias = true;
      extraConfig = ''
        set wildmode=longest,list,full
        " syntax on
        " set tabstop=8 softtabstop=0 expandtab shiftwidth=2 smarttab
        set backspace=indent,eol,start
        set number
        set showcmd
        set ignorecase
        set autoindent
        set incsearch
        set nowrap
        set scrolloff=8
        set sidescroll=1
        set sidescrolloff=8
        set cmdwinheight=1
        set clipboard+=unnamedplus
        
        filetype plugin indent on
        let g:tex_flavor = "latex"

        " Airline
        let g:airline_powerline_fonts = 1
        let g:airline#extensions#tabline#enabled = 1


        " Color scheme
        let g:onedark_hide_endofbuffer = 1
        let g:onedark_terminal_italics = 1
        let g:onedark_termcolors = 256
        let g:airline_theme='onedark'
        colorscheme onedark
        set termguicolors

        " Fold
        " set foldmethod=syntax
        set foldlevel=2
        set foldnestmax=2
        " set foldclose=all
        " hi Folded ctermbg=242
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
        
        
        " Custom mappings
        let mapleader=";"
        inoremap jj <Esc>
        nnoremap : q:i
        inoremap <C-s> <Esc>:w<CR>a
        nnoremap <C-s> :w<CR>
        nnoremap <F6> :source ~/.config/nvim/init.vim<cr>

        " Completion-nvim
        " Use completion-nvim in every buffer
        autocmd BufEnter * lua require'completion'.on_attach()
         " Cycle through completions with tab
        inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
        inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
        set completeopt=menuone,noinsert,noselect
        set shortmess+=c
        let g:completion_enable_snippet = 'vim-vsnip'
        let g:completion_chain_complete_list = {
            \ 'default': [
            \    {'complete_items': ['lsp', 'path', 'snippet']},
            \    {'mode': '<c-p>'},
            \    {'mode': '<c-n>'}
            \],
            \ 'TelescopePrompt' : [ ]
        \}
        let g:completion_auto_change_source = 1
        let g:completion_matching_ignore_case = 1

        " Nerd commenter
        " Use compact syntax for prettified multi-line comments
        let g:NERDCompactSexyComs = 1
        " Add spaces after comment delimiters by default
        let g:NERDSpaceDelims = 1
        " Enable trimming of trailing whitespace when uncommenting
        let g:NERDTrimTrailingWhitespace = 1

        " Telescope
        nnoremap <C-t> :lua require'telescope.builtin'.file_browser()<cr>
        nnoremap <C-f> :lua require'telescope.builtin'.live_grep()<cr>
        nnoremap <C-d> :lua require'telescope.builtin'.lsp_definitions()<cr>

        " Formatter
        nnoremap <silent> <leader><Space>f :Format<CR>



        lua << EOF
        local nvim_lsp = require'lspconfig'
        nvim_lsp.pyright.setup {}
        nvim_lsp.rnix.setup {}
        nvim_lsp.rust_analyzer.setup {}
        nvim_lsp.gopls.setup {}
        nvim_lsp.ccls.setup {
          init_options = {
            cache = {
              directory = ".ccls-cache";
            };
          }
        }

        require'nvim-treesitter.configs'.setup {
          highlight = {
            enable = true,             
          },
        }

        local actions = require('telescope.actions')
        require('telescope').setup{
          defaults = {
            mappings = {
              i = {
                ["<Tab>"] = false,
              },
              n = {
                ["<Tab>"] = false,
                ["<C-c>"] = actions.close,
              },
            },
          }
        }
        require('formatter').setup({
          filetype = {
            c = {
               function()
                  return {
                    exe = "clang-format",
                    args = {"--assume-filename", vim.api.nvim_buf_get_name(0), "--sort-includes=0"},
                    stdin = true,
                    cwd = vim.fn.expand('%:p:h')  -- Run clang-format in cwd of the file.
                  }
                end
            },
            cpp = {
               function()
                  return {
                    exe = "clang-format",
                    args = {"--assume-filename", vim.api.nvim_buf_get_name(0)},
                    stdin = true,
                    cwd = vim.fn.expand('%:p:h')  -- Run clang-format in cwd of the file.
                  }
                end
            },
            rust = {
              function()
                return {
                  exe = "rustfmt",
                  args = {"--emit=stdout"},
                  stdin = true
                }
              end
            },
            go = {
              function()
                return {
                  exe = "gofmt",
                  args = { vim.api.nvim_buf_get_name(0)},
                  stdin = true
                }
              end
            },
          }
        })

        vim.opt.listchars = {
          space = "⋅",
          eol = "↴",
        }

        require("indent_blankline").setup {
            space_char_blankline = " ",
            show_current_context = true,
        }
        EOF
      '';
      plugins = with pkgs.vimPlugins; [
        onedark-vim
        vim-airline
        vim-airline-themes
        nvim-lspconfig
        nvim-treesitter
        completion-nvim
        telescope-nvim
        completion-buffers
        vim-vsnip
        friendly-snippets
        vim-nix
        nerdcommenter
        formatter-nvim
        indent-blankline-nvim
        vim-sleuth
      ];
    };
  };

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "adwin";
  home.homeDirectory = "/home/adwin";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  # home.stateVersion = "21.11";
}
