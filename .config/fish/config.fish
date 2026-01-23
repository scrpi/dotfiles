# PATH setup
fish_add_path ~/.local/bin
fish_add_path ~/.cargo/bin
fish_add_path /usr/local/go/bin
fish_add_path ~/go/bin
fish_add_path /opt/nvim-linux-x86_64/bin

# NVM setup (using nvm.fish or bass)
set -gx NVM_DIR "$HOME/.nvm"
if test -s "$NVM_DIR/nvm.sh"
    # If you have bass installed: bass source "$NVM_DIR/nvm.sh"
    # Otherwise, add the active node version directly:
    if test -d "$NVM_DIR/versions/node"
        set -l node_version (ls "$NVM_DIR/versions/node" | sort -V | tail -1)
        if test -n "$node_version"
            fish_add_path "$NVM_DIR/versions/node/$node_version/bin"
        end
    end
end

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

# Async dotfiles status check - runs in background and caches result
function __dotfiles_check_async
    set -l dotfiles_dir ~/dotfiles
    set -l cache_file ~/.cache/dotfiles_status

    # Ensure cache dir exists
    mkdir -p ~/.cache

    # Fetch latest (the slow part)
    git -C $dotfiles_dir fetch --quiet 2>/dev/null

    # Check status
    set -l ahead (git -C $dotfiles_dir rev-list @{u}..HEAD --count 2>/dev/null)
    set -l behind (git -C $dotfiles_dir rev-list HEAD..@{u} --count 2>/dev/null)
    set -l dirty (git -C $dotfiles_dir status --porcelain 2>/dev/null | wc -l | tr -d ' ')

    # Write cache
    echo "$ahead $behind $dirty" > $cache_file
end

# Display cached dotfiles status
function __dotfiles_status_display
    set -l cache_file ~/.cache/dotfiles_status

    if test -f $cache_file
        read -l ahead behind dirty < $cache_file

        set -l status_parts

        if test "$dirty" -gt 0 2>/dev/null
            set -a status_parts (set_color --bold black --background yellow)" $dirty uncommitted "(set_color normal)
        end
        if test "$ahead" -gt 0 2>/dev/null
            set -a status_parts (set_color --bold white --background blue)" $ahead to push "(set_color normal)
        end
        if test "$behind" -gt 0 2>/dev/null
            set -a status_parts (set_color --bold white --background red)" $behind to pull "(set_color normal)
        end

        if test (count $status_parts) -gt 0
            echo
            echo -e " \e[1mDotfiles:\e[0m "(string join " " $status_parts)
            echo
        end
    end

    # Kick off async update for next time
    fish -c '__dotfiles_check_async' &
    disown 2>/dev/null
end

# Informative greeting with system stats
function fish_greeting
    echo
    echo -e (uname -rs | awk '{print " \\\\e[1mOS: \\\\e[0;32m"$0"\\\\e[0m"}')
    echo -e (uptime | sed 's/^.*up  *\([^,]*\),.*/\1/' | awk '{print " \\\\e[1mUptime: \\\\e[0;32m"$0"\\\\e[0m"}')
    echo -e (hostname -s | awk '{print " \\\\e[1mHostname: \\\\e[0;32m"$0"\\\\e[0m"}')
    echo -e " \\e[1mDisk usage:\\e[0m"
    echo
    if test (uname) = "Darwin"
        # macOS: show only root
        echo -ne (df -lh / | tail -1 | awk '{printf "\\\\t%s\\\\t%4s / %4s  %s\\\\n", $9, $3, $2, $5}' | \
            sed -e 's/^\(.*\([8][5-9]\|[9][0-9]\)%.*\)$/\\\\e[0;31m\1\\\\e[0m/' -e 's/^\(.*\([7][5-9]\|[8][0-4]\)%.*\)$/\\\\e[0;33m\1\\\\e[0m/')
    else
        # Linux: show real disks
        echo -ne (\
            df -lh | grep -E '/dev/(sd|nvme|mapper)' | \
            awk '{printf "\\\\t%s\\\\t%4s / %4s  %s\\\\n\n", $6, $3, $2, $5}' | \
            sed -e 's/^\(.*\([8][5-9]\|[9][0-9]\)%.*\)$/\\\\e[0;31m\1\\\\e[0m/' -e 's/^\(.*\([7][5-9]\|[8][0-4]\)%.*\)$/\\\\e[0;33m\1\\\\e[0m/' | \
            tr -d '\n'\
        )
    end
    echo

    echo -e " \\e[1mNetwork:\\e[0m"
    echo
    if test (uname) = "Darwin"
        # macOS
        for iface in (networksetup -listallhardwareports | awk '/Device:/{print $2}')
            set ip (ipconfig getifaddr $iface 2>/dev/null)
            if test -n "$ip"
                echo -e "\\t\\e[36m$iface\\e[0m\\t$ip"
            end
        end
    else if command -q ip
        # Linux
        ip -4 addr show scope global | awk '/inet/{split($2,a,"/"); print a[1], $NF}' | while read ip iface
            echo -e "\\t\\e[36m$iface\\e[0m\\t$ip"
        end
    end
    echo

    # Show dotfiles status (from cache) and trigger async update
    __dotfiles_status_display

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

# Homebrew (macOS only)
if test -x /opt/homebrew/bin/brew
    eval "$(/opt/homebrew/bin/brew shellenv)"
end
