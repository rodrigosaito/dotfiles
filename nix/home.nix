{ config, lib, pkgs
, ... }:

let 
  deps-overlay = self: super: {
    golangci-lint = super.golangci-lint.overrideAttrs (old: {
      # for some reason the postInstall hook fails on macos, so overriding it
      postInstall = "";
    });
  };
in {
  nixpkgs.overlays = [
    deps-overlay
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.bat.enable = true;

  home.packages = with pkgs; [
    jq
    tree
    pstree
    fzf
  ];

  home.file.".config/nvim/coc-settings.json".source = ./coc-settings.json;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;

    oh-my-zsh  = {
      enable = true;

      theme = "dst";
      plugins = [
        "fzf"
      ];
    };

    initExtra = builtins.readFile ./extraConfig.zsh;

    plugins = [
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

      GOPATH = "$HOME";

      HOME_MANAGER_CONFIG="$HOME/.dotfiles/nix/home.nix";

      # zsh-autosuggestions
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=10";

      # shopify
      KUBECONFIG = "${KUBECONFIG:+$KUBECONFIG:}/Users/rodrigosaito/.kube/config:/Users/rodrigosaito/.kube/config.shopify.cloudplatform";
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
      color = {
        branch = "auto";
        diff = "auto";
        nteractive = "auto";
        status = "auto";
      };
      protocol.version = "2";
      gc.writeCommitGraph = true;
      url."https://github.com/Shopify/".insteadOf = [
        "git@github.com:Shopify/"
        "git@github.com:shopify/"
        "ssh://git@github.com/Shopify/"
        "ssh://git@github.com/shopify/"
      ];
      diff.algorithm = "patience";
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
      coc-solargraph
      coc-go

      # ui
      vim-colorschemes
      vim-gitgutter 
      lightline-vim

      # editor features
      fzf-vim
      vim-tmux-navigator
    ];
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    shortcut = "a";
    keyMode = "vi";
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      nord
    ];

    extraConfig = ''
      # smart pane switching with awareness of vim splits http://robots.thoughtbot.com/seamlessly-navigate-vim-and-tmux-splits
      is_vim='echo "#{pane_current_command}" | grep -iqE "(^|\/)g?(view|n?vim?)(diff)?$"'
      bind -n C-h if-shell "$is_vim" "send-keys C-h" "select-pane -L"
      bind -n C-j if-shell "$is_vim" "send-keys C-j" "select-pane -D"
      bind -n C-k if-shell "$is_vim" "send-keys C-k" "select-pane -U"
      bind -n C-l if-shell "$is_vim" "send-keys C-l" "select-pane -R"

      # use PREFIX | to split window horizontally and PREFIX - to split vertically
      bind | split-window -h
      bind - split-window -v
    '';
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };
}
