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

# 3. The Classic Look (Fixed & Sharp)
# [user@host folder (branch)]$ 
PS1='[\[\033[1;32m\]\u@\h \[\033[1;34m\]\W\[\033[0m\]$(git_prompt_info)]\$ '

# 4. Essential Aliases
alias ls='ls --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias vi='vim'
alias nv='nvim'
alias clr='clear'

# Git Aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gl='git log --oneline --graph --all'
alias gp='git push'

# 5. Path & Environment
export ANDROID_HOME="$HOME/Android/Sdk"
export PNPM_HOME="$HOME/.local/share/pnpm"
export EDITOR="nvim"

# Add paths only if they exist
for d in "$ANDROID_HOME/cmdline-tools/latest/bin" "$ANDROID_HOME/platform-tools" "$PNPM_HOME"; do
    if [ -d "$d" ] && [[ ":$PATH:" != *":$d:"* ]]; then
        export PATH="$d:$PATH"
    fi
done
unset d
