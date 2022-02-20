cmd = stow --dotfiles

.PHONY: stow

stow:
	$(cmd) zsh
	$(cmd) tmux
	mkdir -p $(HOME)/.config/nvim
	$(cmd) -t $(HOME)/.config/nvim nvim
	mkdir -p $(HOME)/.config/git
	$(cmd) -t $(HOME)/.config/git git
