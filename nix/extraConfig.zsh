# Enabling OPTION+LEFT and OPTION+RIGHT to skip words
bindkey '^[^[[D' emacs-backward-word
bindkey '^[^[[C' emacs-forward-word

[ -f /opt/dev/dev.sh ] && source /opt/dev/dev.sh

for file in /Users/rodrigosaito/src/github.com/Shopify/cloudplatform/workflow-utils/*.bash; do source ${file}; done
kubectl-short-aliases
