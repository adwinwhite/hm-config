{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packges = with pkgs; [
    nodePackages.pyright
    rnix-lsp
  ];

  programs = {
    neovim = {
      enable = true;
      package = pkgs.neovim-nightly;
      vimAlias = true;
      viAlias = true;
      defaultEditor = true;
      configure = {
        customRC = ''
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
          
          
          " Custom mappings
          let mapleader=";"
          inoremap jj <Esc>
          nnoremap : q:i
          inoremap <C-s> <Esc>:w<CR>a
          nnoremap <C-s> :w<CR>
           " Cycle through completions with tab
          inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
          inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
          set completeopt=menuone,noinsert,noselect
          set shortmess+=c
          " Nerd commenter
          "
          " Use compact syntax for prettified multi-line comments
          let g:NERDCompactSexyComs = 1
          " Add spaces after comment delimiters by default
          let g:NERDSpaceDelims = 1
          " Enable trimming of trailing whitespace when uncommenting
          let g:NERDTrimTrailingWhitespace = 1

          " Use completion-nvim in every buffer
          autocmd BufEnter * lua require'completion'.on_attach()

          lua << EOF
          local nvim_lsp = require('lspconfig')
          nvim_lsp['pyright'].setup {}
          nvim_lsp['clangd'].setup {}
          nvim_lsp['rnix'].setup {}

          require'nvim-treesitter.configs'.setup {
            ensure_installed = "maintained",
            highlight = {
              enable = true,
            },
          }
          EOF
          '';
          packages.vim = {
          start = with pkgs.vimPlugins; [
            onedark-nvim
            vim-airline
            vim-airline-themes
            nvim-lspconfig
            nvim-treesitter
            completion-nvim
            telescope-nvim
            friendly-snippets
            vim-nix
            nerdcommenter
          ];
        };
      };
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
  home.stateVersion = "21.11";
}
