function collapse_pwd {
    echo $(pwd | sed -e "s,^$HOME,~,")
}

function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '±' && return
    hg root >/dev/null 2>/dev/null && echo '☿' && return
    echo '○'
}

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

 function hg_prompt_info {
     hg prompt --angle-brackets "\
 < on %{$fg[magenta]%}<branch>%{$reset_color%}>\
 < at %{$fg[yellow]%}<tags|%{$reset_color%}, %{$fg[yellow]%}>%{$reset_color%}>\
 %{$fg[green]%}<status|modified|unknown><update>%{$reset_color%}<
 patches: <patches|join( → )|pre_applied(%{$fg[yellow]%})|post_applied(%{$reset_color%})|pre_unapplied(%{$fg_bold[black]%})|post_unapplied(%{$reset_color%})>>" 2>/dev/null
 }


function asdf_ps1 {
  # asdf_ruby_version=`asdf current ruby | sed -e 's/ .*//'`
  asdf_ruby_version=`asdf current ruby | sed 's/[^ ]* *//;s/ .*//;q'`
  echo "ruby-$asdf_ruby_version"
}

# Uncomment if you are using rbenv

# function rbenv_ps1 {
#   rbenv_ruby_version=`rbenv version | sed -e 's/ .*//'`
#   echo $rbenv_ruby_version
# }

# This one used to be main prompt
#PROMPT='
#%(?,%F{green},%F{red})%n%{$reset_color%} at %{$fg[yellow]%}%m%{$reset_color%} using %{$fg[blue]%}$(asdf_ps1)%{$reset_color%} in %{$fg_bold[green]%}$(collapse_pwd)%{$reset_color%}$(hg_prompt_info)$(git_prompt_info)
# $(virtualenv_info)$(prompt_char) '
PROMPT='
%(?,%F{green},%F{red})%n%{$reset_color%} using %{$fg[blue]%}$(asdf_ps1)%{$reset_color%} in %{$fg_bold[green]%}$(collapse_pwd)%{$reset_color%}$(hg_prompt_info)$(git_prompt_info)
$(virtualenv_info)$(prompt_char) '

RPROMPT=''

ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""
