{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.bat.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "19.09";

  home.packages = with pkgs; [
    jq
    tree
  ];

  home.file.".config/nvim/coc-settings.json".source = ./coc-settings.json;

  programs.zsh = {
    enable = true;
    # enableCompletion = true;
    # enableAutoSuggestions = true;
    oh-my-zsh  = {
      enable = true;

      theme = "avit";
    };

    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.6.3";
          sha256 = "1h8h2mz9wpjpymgl2p7pc146c1jgb3dggpvzwm9ln3in336wl95c";
        };
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "be3882aeb054d01f6667facc31522e82f00b5e94";
          sha256 = "0w8x5ilpwx90s2s2y56vbzq92ircmrf0l5x8hz4g1nx3qzawv6af";
        };
      }
    ];

    sessionVariables = rec {
      EDITOR = "vim";
      VISUAL = EDITOR;

      GOPATH = "$HOME/go";
    };
  };

  programs.git = {
    enable = true;
    userName = "Rodrigo Saito";
    userEmail = "rodrigo.saito@gmail.com";
    aliases = {
      co = "checkout";
      st = "status";
      ci = "commit";
    };
    extraConfig = {
      github.user = "rodrigosaito";
      core = {
        editor = "vim";
      };
    };
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraConfig = builtins.readFile ./extraConfig.vim;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    plugins = with pkgs.vimPlugins; [
      # language support
      vim-nix
      vim-go
      ultisnips
      coc-nvim

      # ui
      vim-colorschemes
      vim-gitgutter 
      lightline-vim

      # editor features
      ctrlp
      vim-tmux-navigator
    ];
  };

  programs.tmux = {
    enable = true;
    shortcut = "a";
    terminal = "screen-256color";
    keyMode = "vi";
    historyLimit = 10000;
    extraConfig = builtins.readFile ./extraConfig.tmux;
    secureSocket = false;
    newSession = true;

    plugins = with pkgs.tmuxPlugins; [
      sensible
    ];
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };
}
