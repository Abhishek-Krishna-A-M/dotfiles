# 1. Instant non-interactive exit
[ "${-#*i}" = "$-" ] && return

# 2. Fast Git Logic (HDD & Subfolder Optimized)
git_prompt_info() {
  local dir="$PWD"
  while [ "$dir" != "/" ]; do
    if [ -d "$dir/.git" ]; then
      if [ -f "$dir/.git/HEAD" ]; then
        local head
        read -r head < "$dir/.git/HEAD"
        # We use \001 and \002 so Bash knows these are non-printing characters
        case "$head" in
          ref:*) printf " \001\033[1;35m\002(%s)\001\033[0m\002" "${head#ref: refs/heads/}" ;;
          *) printf " \001\033[1;35m\002(detached)\001\033[0m\002" ;;
        esac
      fi
      return
    fi
    dir="$(dirname "$dir")"
  done
}

# Fuzzy find file and open in editor
fe() {
  local file
  file=$(fzf --preview 'bat --style=numbers --color=always --line-range :500 {}')
  [ -n "$file" ] && ${EDITOR:-nvim} "$file"
}

lf() {
    tmp="$(mktemp)"
    # -last-dir-path is the built-in lf flag for this
    command lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ] && [ "$dir" != "$(pwd)" ]; then
            cd "$dir"
        fi
    fi
}

# 3. The Classic Look (Fixed & Sharp)
# [user@host folder (branch)]$ 
PS1='[\[\033[1;32m\]\u@\h \[\033[1;34m\]\W\[\033[0m\]$(git_prompt_info)]\$ '

# 4. Essential Aliases
alias ls='ls --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias vi='vim'
alias nv='nvim'
alias clr='clear'
alias clock='tty-clock -sctC 7 -f "%A, %B %d, %Y"'
# Git Aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gl='git log --oneline --graph --all'
alias gp='git push'

# 5. Path & Environment
# Android SDK
export ANDROID_HOME=/opt/android-sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PNPM_HOME="$HOME/.local/share/pnpm"
export EDITOR="nvim"
export TERMINAL="st"
export PATH="/home/ak/.bun/bin:$PATH"
eval "$(direnv hook bash)"

# Add paths only if they exist
for d in "$ANDROID_HOME/cmdline-tools/latest/bin" "$ANDROID_HOME/platform-tools" "$PNPM_HOME"; do
    if [ -d "$d" ] && [[ ":$PATH:" != *":$d:"* ]]; then
        export PATH="$d:$PATH"
    fi
done
unset d
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:-}"


