if command -v milli >/dev/null 2>&1; then
    echo "loading milli completion"
    source <(milli generate-completion)
fi
