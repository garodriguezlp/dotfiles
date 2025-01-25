# --- ----------------------------------------------------------------------------------------------
# --- Functions
# --- ----------------------------------------------------------------------------------------------
check_lpass_installed() {
  if ! command -v lpass &> /dev/null; then
    return 1
  fi
  return 0
}

check_lpass_login() {
  if ! lpass status -q; then
    return 1
  fi
  return 0
}

set_env_var_from_lpass() {
  local env_var=$1
  local lpass_id=$2

  # echo "Debug: Configuring environment variable '$env_var' using LastPass entry ID '$lpass_id'..."

  local value
  value=$(lpass show --password "$lpass_id" 2>/dev/null)
  if [[ $? -eq 0 ]]; then
    export "$env_var"="$value"
    # echo "Debug: Successfully set '$env_var' from LastPass CLI."
  else
    echo "Error: Unable to retrieve the secret for '$env_var' using LastPass CLI. Please verify that an entry exists for '$lpass_id'."
  fi
}

set_env_vars_from_lpass() {
  if [ ${#lpass_load_env_config[@]} -eq 0 ]; then
    # echo "Debug: No LastPass entries to load."
    return
  fi

  for entry in "${lpass_load_env_config[@]}"; do
    # echo "Debug: Loading LastPass entry: $entry"
    local key=${entry%%:*}
    local value=${entry##*:}
    set_env_var_from_lpass $key $value
  done
}

lpass_env_setup() {
  if check_lpass_installed && check_lpass_login; then
    set_env_vars_from_lpass
  else
    echo "Error: Failed to load secrets. Ensure LastPass CLI is installed and logged in."
  fi
}

# --- ----------------------------------------------------------------------------------------------
# --- Main
# --- ----------------------------------------------------------------------------------------------
lpass_env_setup
