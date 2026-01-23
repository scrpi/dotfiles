abbr -a ll ls -lah
abbr -a glo git log --oneline
abbr -a vi nvim


if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Fish git prompt settings
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate ''
set __fish_git_prompt_showupstream 'none'
set -g fish_prompt_pwd_dir_length 3

# Custom prompt with time, hostname, directory, and git status
function fish_prompt
    set_color brblack
    echo -n "["(date "+%H:%M")"] "
    set_color blue
    echo -n (hostname -s)
    if [ $PWD != $HOME ]
        set_color brblack
        echo -n ':'
        set_color yellow
        echo -n (basename $PWD)
    end
    set_color green
    printf '%s ' (__fish_git_prompt)
    set_color red
    echo -n '| '
    set_color normal
end

# Informative greeting with system stats
function fish_greeting
    echo
    echo -e (uname -rs | awk '{print " \\\\e[1mOS: \\\\e[0;32m"$0"\\\\e[0m"}')
    echo -e (uptime | sed 's/^.*up  *\([^,]*\),.*/\1/' | awk '{print " \\\\e[1mUptime: \\\\e[0;32m"$0"\\\\e[0m"}')
    echo -e (hostname -s | awk '{print " \\\\e[1mHostname: \\\\e[0;32m"$0"\\\\e[0m"}')
    echo -e " \\e[1mDisk usage:\\e[0m"
    echo
    echo -ne (\
        df -lh | grep -E '/dev/disk' | \
        awk '{printf "\\\\t%s\\\\t%4s / %4s  %s\\\\n\n", $9, $3, $2, $5}' | \
        sed -e 's/^\(.*\([8][5-9]\|[9][0-9]\)%.*\)$/\\\\e[0;31m\1\\\\e[0m/' -e 's/^\(.*\([7][5-9]\|[8][0-4]\)%.*\)$/\\\\e[0;33m\1\\\\e[0m/' | \
        paste -sd ''\
    )
    echo

    echo -e " \\e[1mNetwork:\\e[0m"
    echo
    for iface in (networksetup -listallhardwareports | awk '/Device:/{print $2}')
        set ip (ipconfig getifaddr $iface 2>/dev/null)
        if test -n "$ip"
            echo -e "\\t\\e[36m$iface\\e[0m\\t$ip"
        end
    end
    echo

    set_color normal
end

# Sync VS Code extensions with dotfiles
function vscode-sync-extensions
    if test "$argv[1]" = "save"
        code --list-extensions > ~/dotfiles/.config/Code/extensions.txt
        echo "Saved "(wc -l < ~/dotfiles/.config/Code/extensions.txt | tr -d ' ')" extensions"
    else if test "$argv[1]" = "install"
        cat ~/dotfiles/.config/Code/extensions.txt | xargs -L 1 code --install-extension
    else
        echo "Usage: vscode-sync-extensions [save|install]"
    end
end

string match -q "$TERM_PROGRAM" "kiro" and . (kiro --locate-shell-integration-path fish)
eval "$(/opt/homebrew/bin/brew shellenv)"
