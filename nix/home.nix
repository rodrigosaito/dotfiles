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

}
