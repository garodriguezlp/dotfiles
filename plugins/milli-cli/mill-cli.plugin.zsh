alias m!=milli

if (( ! $+commands[milli] )); then
  return
fi

z4h source <(milli generate-completion)
