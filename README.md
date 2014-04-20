dotfiles
========

Great bash for Unix when using ZSH

### Using it

You'll have to clone dotfiles

```
git clone https://github.com/rodrigosaito/dotfiles.git .dotfiles
```

and clone prezto theme

```
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
```

create a few sym links: 

```
ln -s .zprezto/runcoms/zlogin .zlogin
ln -s .zprezto/runcoms/zlogout .zlogout
ln -s .zprezto/runcoms/zprofile .zprofile
ln -s .zprezto/runcoms/zshenv .zshenv
```

change your shell to zsh

```
chsh -s /bin/zsh
```

finally, override default zsh conf

```
ln -sf .dotfiles/zsh/zprezto/runcoms/zpreztorc .zpreztorc
ln -sf .dotfiles/zsh/zprezto/runcoms/zshrc .zshrc
```

create some cool functions

```
cd ~/.zprezto/modules/prompt/functions
ln -s ~/.dotfiles/zsh/zprezto/modules/prompt/functions/prompt_saito_setup
```

### Optional

If you want, you can change .gemrc and .gitconfig. Changing .gemrc makes --no-ri and --no-rdoc default when you gem install something. And .gitconfig are some cool alias for status, commit, branch and so on (Remember to change name, email and github name).

```
ln -s .dotfiles/gemrc .gemrc
ln -s .dotfiles/gitconfig .gitconfig
```
