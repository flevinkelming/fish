function fst; set_color -o blue; end
function snd; set_color -o yellow; end
function trd; set_color -o f06; end
function dim; set_color    666; end
function off; set_color normal; end
function ylw; set_color yellow; end

function fish_prompt
	test $status -ne 0;
    	and set -l colors 600 900 c00
    	or set -l colors 005cbb blue brblue
	
    set -l pwd (prompt_pwd)
  	set -l base (basename "$pwd")

  	set -l expr "s|~|"(fst)"~"(off)"|g; \
                 s|/|"(snd)"/"(off)"|g;  \
                 s|"$base"|"(fst)$base(off)" |g"

    echo -n (ylw)"Δ "(off)"$USER "
	
	echo -n (echo "$pwd" | sed -e $expr)(off)

	for color in $colors
    	echo -n (set_color $color)">"
  	end

  	echo -n " "
end

function git::is_stashed
  command git rev-parse --verify --quiet refs/stash >/dev/null
end

function git::get_ahead_count
  echo (command git log ^/dev/null | grep '^commit' | wc -l | tr -d " ")
end

function git::branch_name
  command git symbolic-ref --short HEAD
end

function git::is_touched
  test -n (echo (command git status --porcelain))
end

function fish_right_prompt
  set -l code $status
  test $code -ne 0; and echo (dim)"("(trd)"$code"(dim)") "(off)

  if test -n "$SSH_CONNECTION"
     printf (trd)":"(dim)"$HOSTNAME "(off)
   end

  if git rev-parse 2> /dev/null
    git::is_stashed; and echo (trd)"^"(off)
    printf (snd)"("(begin
      if git::is_touched
        echo (trd)"*"(off)
      else
        echo ""
      end
    end)(fst)(git::branch_name)(snd)(begin
      set -l count (git::get_ahead_count)
        if test $count -eq 0
          echo ""
        else
          echo (trd)"+"(fst)$count
        end
    end)(snd)") "(off)
  end
  printf (dim)(date +%H(fst):(dim)%M(fst):(dim)%S)(off)" "
end

function fish_greeting
  echo -n ""
end

# Aliases
alias ls="ls -GFh"
alias vscode='open -a "Visual Studio Code"'
alias chrome='open -a "Google Chrome"'
alias vpn='open -a "ExpressVPN"'
alias kindle='open -a "Kindle"'
alias home="cd ~"

# Notes
# echo $LINES; and echo $COLUMNS (the `; and` is for example purposes...)