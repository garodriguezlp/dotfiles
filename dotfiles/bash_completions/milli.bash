#!/usr/bin/env bash
#
# milli Bash Completion
# =======================
#
# Bash completion support for the `milli` command,
# generated by [picocli](https://picocli.info/) version 4.7.0.
#
# Installation
# ------------
#
# 1. Source all completion scripts in your .bash_profile
#
#   cd $YOUR_APP_HOME/bin
#   for f in $(find . -name "*_completion"); do line=". $(pwd)/$f"; grep "$line" ~/.bash_profile || echo "$line" >> ~/.bash_profile; done
#
# 2. Open a new bash console, and type `milli [TAB][TAB]`
#
# 1a. Alternatively, if you have [bash-completion](https://github.com/scop/bash-completion) installed:
#     Place this file in a `bash-completion.d` folder:
#
#   * /etc/bash-completion.d
#   * /usr/local/etc/bash-completion.d
#   * ~/bash-completion.d
#
# Documentation
# -------------
# The script is called by bash whenever [TAB] or [TAB][TAB] is pressed after
# 'milli (..)'. By reading entered command line parameters,
# it determines possible bash completions and writes them to the COMPREPLY variable.
# Bash then completes the user input if only one entry is listed in the variable or
# shows the options if more than one is listed in COMPREPLY.
#
# References
# ----------
# [1] http://stackoverflow.com/a/12495480/1440785
# [2] http://tiswww.case.edu/php/chet/bash/FAQ
# [3] https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
# [4] http://zsh.sourceforge.net/Doc/Release/Options.html#index-COMPLETE_005fALIASES
# [5] https://stackoverflow.com/questions/17042057/bash-check-element-in-array-for-elements-in-another-array/17042655#17042655
# [6] https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion.html#Programmable-Completion
# [7] https://stackoverflow.com/questions/3249432/can-a-bash-tab-completion-script-be-used-in-zsh/27853970#27853970
#

if [ -n "$BASH_VERSION" ]; then
  # Enable programmable completion facilities when using bash (see [3])
  shopt -s progcomp
elif [ -n "$ZSH_VERSION" ]; then
  # Make alias a distinct command for completion purposes when using zsh (see [4])
  setopt COMPLETE_ALIASES
  alias compopt=complete

  # Enable bash completion in zsh (see [7])
  # Only initialize completions module once to avoid unregistering existing completions.
  if ! type compdef > /dev/null; then
    autoload -U +X compinit && compinit
  fi
  autoload -U +X bashcompinit && bashcompinit
fi

# CompWordsContainsArray takes an array and then checks
# if all elements of this array are in the global COMP_WORDS array.
#
# Returns zero (no error) if all elements of the array are in the COMP_WORDS array,
# otherwise returns 1 (error).
function CompWordsContainsArray() {
  declare -a localArray
  localArray=("$@")
  local findme
  for findme in "${localArray[@]}"; do
    if ElementNotInCompWords "$findme"; then return 1; fi
  done
  return 0
}
function ElementNotInCompWords() {
  local findme="$1"
  local element
  for element in "${COMP_WORDS[@]}"; do
    if [[ "$findme" = "$element" ]]; then return 1; fi
  done
  return 0
}

# The `currentPositionalIndex` function calculates the index of the current positional parameter.
#
# currentPositionalIndex takes three parameters:
# the command name,
# a space-separated string with the names of options that take a parameter, and
# a space-separated string with the names of boolean options (that don't take any params).
# When done, this function echos the current positional index to std_out.
#
# Example usage:
# local currIndex=$(currentPositionalIndex "mysubcommand" "$ARG_OPTS" "$FLAG_OPTS")
function currentPositionalIndex() {
  local commandName="$1"
  local optionsWithArgs="$2"
  local booleanOptions="$3"
  local previousWord
  local result=0

  for i in $(seq $((COMP_CWORD - 1)) -1 0); do
    previousWord=${COMP_WORDS[i]}
    if [ "${previousWord}" = "$commandName" ]; then
      break
    fi
    if [[ "${optionsWithArgs}" =~ ${previousWord} ]]; then
      ((result-=2)) # Arg option and its value not counted as positional param
    elif [[ "${booleanOptions}" =~ ${previousWord} ]]; then
      ((result-=1)) # Flag option itself not counted as positional param
    fi
    ((result++))
  done
  echo "$result"
}

# compReplyArray generates a list of completion suggestions based on an array, ensuring all values are properly escaped.
#
# compReplyArray takes a single parameter: the array of options to be displayed
#
# The output is echoed to std_out, one option per line.
#
# Example usage:
# local options=("foo", "bar", "baz")
# local IFS=$'\n'
# COMPREPLY=($(compReplyArray "${options[@]}"))
function compReplyArray() {
  declare -a options
  options=("$@")
  local curr_word=${COMP_WORDS[COMP_CWORD]}
  local i
  local quoted
  local optionList=()

  for (( i=0; i<${#options[@]}; i++ )); do
    # Double escape, since we want escaped values, but compgen -W expands the argument
    printf -v quoted %q "${options[i]}"
    quoted=\'${quoted//\'/\'\\\'\'}\'

    optionList[i]=$quoted
  done

  # We also have to add another round of escaping to $curr_word.
  curr_word=${curr_word//\\/\\\\}
  curr_word=${curr_word//\'/\\\'}

  # Actually generate completions.
  local IFS=$'\n'
  echo -e "$(compgen -W "${optionList[*]}" -- "$curr_word")"
}

# Bash completion entry point function.
# _complete_milli finds which commands and subcommands have been specified
# on the command line and delegates to the appropriate function
# to generate possible options and subcommands for the last specified subcommand.
function _complete_milli() {
  # Edge case: if command line has no space after subcommand, then don't assume this subcommand is selected (remkop/picocli#1468).
  if [ "${COMP_LINE}" = "${COMP_WORDS[0]} generate-completion" ];    then _picocli_milli; return $?; fi
  if [ "${COMP_LINE}" = "${COMP_WORDS[0]} help" ];    then _picocli_milli; return $?; fi
  if [ "${COMP_LINE}" = "${COMP_WORDS[0]} token" ];    then _picocli_milli; return $?; fi
  if [ "${COMP_LINE}" = "${COMP_WORDS[0]} user" ];    then _picocli_milli; return $?; fi
  if [ "${COMP_LINE}" = "${COMP_WORDS[0]} uuid" ];    then _picocli_milli; return $?; fi
  if [ "${COMP_LINE}" = "${COMP_WORDS[0]} user find" ];    then _picocli_milli_user; return $?; fi
  if [ "${COMP_LINE}" = "${COMP_WORDS[0]} user create" ];    then _picocli_milli_user; return $?; fi

  # Find the longest sequence of subcommands and call the bash function for that subcommand.
  local cmds0=(generate-completion)
  local cmds1=(help)
  local cmds2=(token)
  local cmds3=(user)
  local cmds4=(uuid)
  local cmds5=(user find)
  local cmds6=(user create)

  if CompWordsContainsArray "${cmds6[@]}"; then _picocli_milli_user_create; return $?; fi
  if CompWordsContainsArray "${cmds5[@]}"; then _picocli_milli_user_find; return $?; fi
  if CompWordsContainsArray "${cmds4[@]}"; then _picocli_milli_uuid; return $?; fi
  if CompWordsContainsArray "${cmds3[@]}"; then _picocli_milli_user; return $?; fi
  if CompWordsContainsArray "${cmds2[@]}"; then _picocli_milli_token; return $?; fi
  if CompWordsContainsArray "${cmds1[@]}"; then _picocli_milli_help; return $?; fi
  if CompWordsContainsArray "${cmds0[@]}"; then _picocli_milli_generatecompletion; return $?; fi

  # No subcommands were specified; generate completions for the top-level command.
  _picocli_milli; return $?;
}

# Generates completions for the options and subcommands of the `milli` command.
function _picocli_milli() {
  # Get completion data
  local curr_word=${COMP_WORDS[COMP_CWORD]}

  local commands="generate-completion help token user uuid"
  local flag_opts="-h --help -V --version"
  local arg_opts=""

  if [[ "${curr_word}" == -* ]]; then
    COMPREPLY=( $(compgen -W "${flag_opts} ${arg_opts}" -- "${curr_word}") )
  else
    local positionals=""
    local IFS=$'\n'
    COMPREPLY=( $(compgen -W "${commands// /$'\n'}${IFS}${positionals}" -- "${curr_word}") )
  fi
}

# Generates completions for the options and subcommands of the `generate-completion` subcommand.
function _picocli_milli_generatecompletion() {
  # Get completion data
  local curr_word=${COMP_WORDS[COMP_CWORD]}

  local commands=""
  local flag_opts="-h --help -V --version"
  local arg_opts=""

  if [[ "${curr_word}" == -* ]]; then
    COMPREPLY=( $(compgen -W "${flag_opts} ${arg_opts}" -- "${curr_word}") )
  else
    local positionals=""
    local IFS=$'\n'
    COMPREPLY=( $(compgen -W "${commands// /$'\n'}${IFS}${positionals}" -- "${curr_word}") )
  fi
}

# Generates completions for the options and subcommands of the `help` subcommand.
function _picocli_milli_help() {
  # Get completion data
  local curr_word=${COMP_WORDS[COMP_CWORD]}

  local commands="generate-completion token user uuid"
  local flag_opts="-h --help"
  local arg_opts=""

  if [[ "${curr_word}" == -* ]]; then
    COMPREPLY=( $(compgen -W "${flag_opts} ${arg_opts}" -- "${curr_word}") )
  else
    local positionals=""
    local IFS=$'\n'
    COMPREPLY=( $(compgen -W "${commands// /$'\n'}${IFS}${positionals}" -- "${curr_word}") )
  fi
}

# Generates completions for the options and subcommands of the `token` subcommand.
function _picocli_milli_token() {
  # Get completion data
  local curr_word=${COMP_WORDS[COMP_CWORD]}
  local prev_word=${COMP_WORDS[COMP_CWORD-1]}

  local commands=""
  local flag_opts="-c --clipboard -h --help -V --version"
  local arg_opts="-e --email -p --password --env"
  local environment_option_args=("DEV" "STAGING") # --env values

  type compopt &>/dev/null && compopt +o default

  case ${prev_word} in
    -e|--email)
      return
      ;;
    -p|--password)
      return
      ;;
    --env)
      local IFS=$'\n'
      COMPREPLY=( $( compReplyArray "${environment_option_args[@]}" ) )
      return $?
      ;;
  esac

  if [[ "${curr_word}" == -* ]]; then
    COMPREPLY=( $(compgen -W "${flag_opts} ${arg_opts}" -- "${curr_word}") )
  else
    local positionals=""
    local IFS=$'\n'
    COMPREPLY=( $(compgen -W "${commands// /$'\n'}${IFS}${positionals}" -- "${curr_word}") )
  fi
}

# Generates completions for the options and subcommands of the `user` subcommand.
function _picocli_milli_user() {
  # Get completion data
  local curr_word=${COMP_WORDS[COMP_CWORD]}

  local commands="find create"
  local flag_opts="-h --help -V --version"
  local arg_opts=""

  if [[ "${curr_word}" == -* ]]; then
    COMPREPLY=( $(compgen -W "${flag_opts} ${arg_opts}" -- "${curr_word}") )
  else
    local positionals=""
    local IFS=$'\n'
    COMPREPLY=( $(compgen -W "${commands// /$'\n'}${IFS}${positionals}" -- "${curr_word}") )
  fi
}

# Generates completions for the options and subcommands of the `uuid` subcommand.
function _picocli_milli_uuid() {
  # Get completion data
  local curr_word=${COMP_WORDS[COMP_CWORD]}

  local commands=""
  local flag_opts="-c --clipboard -h --help -V --version"
  local arg_opts=""

  if [[ "${curr_word}" == -* ]]; then
    COMPREPLY=( $(compgen -W "${flag_opts} ${arg_opts}" -- "${curr_word}") )
  else
    local positionals=""
    local IFS=$'\n'
    COMPREPLY=( $(compgen -W "${commands// /$'\n'}${IFS}${positionals}" -- "${curr_word}") )
  fi
}

# Generates completions for the options and subcommands of the `find` subcommand.
function _picocli_milli_user_find() {
  # Get completion data
  local curr_word=${COMP_WORDS[COMP_CWORD]}
  local prev_word=${COMP_WORDS[COMP_CWORD-1]}

  local commands=""
  local flag_opts="-h --help -V --version"
  local arg_opts="-i --id -e --email -p --partyId --env"
  local environment_option_args=("DEV" "STAGING") # --env values

  type compopt &>/dev/null && compopt +o default

  case ${prev_word} in
    -i|--id)
      return
      ;;
    -e|--email)
      return
      ;;
    -p|--partyId)
      return
      ;;
    --env)
      local IFS=$'\n'
      COMPREPLY=( $( compReplyArray "${environment_option_args[@]}" ) )
      return $?
      ;;
  esac

  if [[ "${curr_word}" == -* ]]; then
    COMPREPLY=( $(compgen -W "${flag_opts} ${arg_opts}" -- "${curr_word}") )
  else
    local positionals=""
    local IFS=$'\n'
    COMPREPLY=( $(compgen -W "${commands// /$'\n'}${IFS}${positionals}" -- "${curr_word}") )
  fi
}

# Generates completions for the options and subcommands of the `create` subcommand.
function _picocli_milli_user_create() {
  # Get completion data
  local curr_word=${COMP_WORDS[COMP_CWORD]}
  local prev_word=${COMP_WORDS[COMP_CWORD-1]}

  local commands=""
  local flag_opts="-h --help -V --version"
  local arg_opts="-s --suffix --env"
  local environment_option_args=("DEV" "STAGING") # --env values

  type compopt &>/dev/null && compopt +o default

  case ${prev_word} in
    -s|--suffix)
      return
      ;;
    --env)
      local IFS=$'\n'
      COMPREPLY=( $( compReplyArray "${environment_option_args[@]}" ) )
      return $?
      ;;
  esac

  if [[ "${curr_word}" == -* ]]; then
    COMPREPLY=( $(compgen -W "${flag_opts} ${arg_opts}" -- "${curr_word}") )
  else
    local positionals=""
    local IFS=$'\n'
    COMPREPLY=( $(compgen -W "${commands// /$'\n'}${IFS}${positionals}" -- "${curr_word}") )
  fi
}

# Define a completion specification (a compspec) for the
# `milli`, `milli.sh`, and `milli.bash` commands.
# Uses the bash `complete` builtin (see [6]) to specify that shell function
# `_complete_milli` is responsible for generating possible completions for the
# current word on the command line.
# The `-o default` option means that if the function generated no matches, the
# default Bash completions and the Readline default filename completions are performed.
complete -F _complete_milli -o default milli milli.sh milli.bash

