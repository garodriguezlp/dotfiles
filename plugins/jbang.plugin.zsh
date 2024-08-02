# Add JBang to environment if the directory exists
if [[ -d "$HOME/.jbang/bin" ]]; then
  alias j!=jbang
  export PATH="$HOME/.jbang/bin:$PATH"
fi
