# Enabling OPTION+LEFT and OPTION+RIGHT to skip words
bindkey '^[^[[D' emacs-backward-word
bindkey '^[^[[C' emacs-forward-word

if [ -e /home/ubuntu/.nix-profile/etc/profile.d/nix.sh ]; then . /home/ubuntu/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

[ -f /opt/dev/dev.sh ] && source /opt/dev/dev.sh

[ -d /Users/rodrigosaito/src/github.com/Shopify/cloudplatform ] && for file in /Users/rodrigosaito/src/github.com/Shopify/cloudplatform/workflow-utils/*.bash; do source ${file}; done

if type kubectl-short-aliases > /dev/null; then
  kubectl-short-aliases
fi
