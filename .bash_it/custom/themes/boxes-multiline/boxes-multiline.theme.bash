SCM_THEME_PROMPT_PREFIX=""
SCM_THEME_PROMPT_SUFFIX=""

SCM_THEME_PROMPT_DIRTY=" \[\e[38;5;163m\]✗${normal}"
SCM_THEME_PROMPT_CLEAN=" \[\e[38;5;77m\]✓${normal}"
#SCM_GIT_CHAR='\[\e[38;5;184m\]±\[\e[0m\]'
SCM_GIT_CHAR="\[\e[38;5;184m\]\[\e[0m\]"

case $TERM in
	xterm*)
	TITLEBAR="\[\033]0;\w\007\]"
	;;
	*)
	TITLEBAR=""
	;;
esac

PS3=">> "
PS2=$(printf "%s" "\[\e[38;5;240m\]\342\210\231\[\e[38;5;250m\]\342\224\200➞\[\e[0m\] ")

boxes_scm_prompt() {
	CHAR=$(scm_char)
	if [[ "$CHAR" = "$SCM_NONE_CHAR" ]]; then
		return
	else
		echo "\033[38;5;250m]─[\033[0m$(scm_char) $(scm_prompt_info)\033[38;5;250m"
	fi
}

right_prompt() {
    printf "%*s" "$(($(tput cols) + 109))" "\[\e[38;5;238m\]\342\210\231\[\e[38;5;240m\]\342\210\231\[\e[38;5;250m\]\342\210\231[\[\e[38;5;116m\]\D{%a %d %b} \t\[\e[38;5;250m\]]"
}

nonzero_return() {
        local retval=$?

        if (( retval != 0 )); then
            echo -e '\033[38;5;163m:(\e[0m'
        else
            echo -e '\033[38;5;77m:)\e[0m'
        fi
}

prompt() {
     PS1="$(right_prompt)\r\[\e[38;5;250m\]┌─[\[\e[0m\]$(nonzero_return)\[\e[38;5;250m\]]─[\[\e[38;5;116m\]\u\[\e[38;5;207m\]@\[\e[38;5;217m\]\h\[\e[0m\]$(boxes_scm_prompt)\[\e[38;5;250m\]]─[\[\e[38;5;219m\]\w\[\e[0m\]\[\e[38;5;250m\]]─[\[\e[38;5;184m\]\#\[\e[38;5;250m\]]\342\210\231\[\e[38;5;240m\]\342\210\231\[\e[38;5;238m\]\342\210\231\n\[\e[38;5;250m\]└─➞\[\e[0m\] "
}

safe_append_prompt_command prompt

