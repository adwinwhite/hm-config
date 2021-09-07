{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    nodePackages.pyright
    rnix-lsp
    ccls
    rust-analyzer
  ];

  programs = {
    neovim = {
      enable = true;
      package = pkgs.neovim-nightly;
      vimAlias = true;
      viAlias = true;
      extraConfig = ''
        set wildmode=longest,list,full
        syntax on
        set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
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
        set foldmethod=syntax
        set foldlevel=0
        set foldnestmax=1
        " set foldclose=all
        " hi Folded ctermbg=242
        
        
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
            \    {'complete_items': ['lsp', 'buffers', 'path', 'snippet']},
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



        lua << EOF
        local nvim_lsp = require'lspconfig'
        nvim_lsp.pyright.setup {}
        nvim_lsp.rnix.setup {}
        nvim_lsp.rust_analyzer.setup {}
        nvim_lsp.ccls.setup {
          init_options = {
            cache = {
              directory = ".ccls-cache";
            };
          }
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
        EOF
      '';
      plugins = with pkgs.vimPlugins; [
        onedark-vim
        vim-airline
        vim-airline-themes
        nvim-lspconfig
        completion-nvim
        telescope-nvim
        completion-buffers
        vim-vsnip
        friendly-snippets
        vim-nix
        nerdcommenter
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
