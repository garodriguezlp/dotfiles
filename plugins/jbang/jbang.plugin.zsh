# Add JBang to environment
alias j!=jbang
export PATH="$HOME/.jbang/bin:$PATH"

if (( ! $+commands[jbang] )); then
  return
fi

z4h source <(jbang completion)
