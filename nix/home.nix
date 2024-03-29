{ config, lib, pkgs, buildGoModule
, ... }:

let 
  kubectl-neat = pkgs.callPackage ./kubectl-neat {};

  nvim-cmp = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "nvim-cmp";
    src = pkgs.fetchFromGitHub {
      owner = "hrsh7th";
      repo = "nvim-cmp";
      rev = "f15be9e3ec7703b80d733ab6b40ef1022be4e69e";
      sha256 = "00kmv638hqp9pj4pab808armmklkmihrrqs838djkdv6fs18qbs5";
    };
  };

  cmp-nvim-lsp = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "cmp-nvim-lsp";
    src = pkgs.fetchFromGitHub {
      owner = "hrsh7th";
      repo = "cmp-nvim-lsp";
      rev = "134117299ff9e34adde30a735cd8ca9cf8f3db81";
      sha256 = "1jnspl08ilz9ggkdddk0saxp3wzf05lll5msdfb4770q3bixddwc";
    };
  };

  cmp-buffer = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "cmp-buffer";
    src = pkgs.fetchFromGitHub {
      owner = "hrsh7th";
      repo = "cmp-buffer";
      rev = "a706dc69c49110038fe570e5c9c33d6d4f67015b";
      sha256 = "05sir021wgrkbv0lwpsy5x18q51bhagify83hcidwsckjzbsrm8m";
    };
  };

  cmp-path = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "cmp-path";
    src = pkgs.fetchFromGitHub {
      owner = "hrsh7th";
      repo = "cmp-path";
      rev = "81518cf6ae29f5f0c79cd47770ae90ff5225ee13";
      sha256 = "11k1xb07cyw2p4ylcrwyddyf9ixarakjd3sa31csa5kybmrlg8yj";
    };
  };

  cmp-cmdline = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "cmp-cmdline";
    src = pkgs.fetchFromGitHub {
      owner = "hrsh7th";
      repo = "cmp-cmdline";
      rev = "e5aa12620b6cae9ba5ce27aed2c47a99b81f004f";
      sha256 = "03zjy4xwzm1898pabz0gzydc5zlcnsprkqlk0aavz0aw21mmywkh";
    };
  };

  cmp-nvim-ultisnips = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "cmp-nvim-ultisnips";
    src = pkgs.fetchFromGitHub {
      owner = "quangnguyen30192";
      repo = "cmp-nvim-ultisnips";
      rev = "78a9452d61bc7f1c3aeb33f6011513760f705bdf";
      sha256 = "1007b5ihf788r05fy04689p24n5fbsrds5v2444fki5hq3i85f5a";
    };
  };
in {
  nixpkgs.overlays = [
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.bat.enable = true;

  home.packages = with pkgs; [
    jq
    tree
    pstree
    fzf
    kubectl-neat
  ];

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

    # workaround https://github.com/nix-community/home-manager/issues/2133#issuecomment-865456452
    extraConfig = ''
      if !exists("homemanagerbug")
        let homemanagerbug = "yes"
      '' + builtins.readFile ./extraConfig.vim
      + "endif\n";

    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    plugins = with pkgs.vimPlugins; [
      # lsp
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp-nvim-ultisnips

      # language support
      vim-nix
      ultisnips
      vim-snippets

      # ui
      vim-colorschemes
      vim-gitgutter 
      lightline-vim
      nvim-treesitter

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
