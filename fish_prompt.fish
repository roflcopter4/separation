# vim: sw=2

# AUTHOR: RoflCopter4
# BUGS: For whatever reason, on the first time the prompt is displayed after
#       loading the shell the "$COLUMNS" variable will always equal 78. I
#       can't fathom why. My (much trickier to implement) zsh prompt does 
#       not do this.
# ----------------------------------------------------------------------------


# Had to do the horizontal bars and the return status in separate functions.
# For some reason fish just did not like having variables change in the main
# prompt function and would switch to the fallback prompt every time.
function _Disp_HBAR
  set BarWidth (math $COLUMNS - 2)
  set Hbar '─'
  for x in (seq $BarWidth)
    echo -n $Hbar
  end
end

function _Disp_RetStatus -a prev_status
  set_color normal
  set_color red
  echo -n $prev_status
  set_color blue
  echo -n ':'
end


# ----------------------------------------------------------------------------


function fish_prompt
  # Cache the status
  set -l prev_status $status

  # Setup a few special characters
  set -l UpperLeft  '┌'
  set -l LowerLeft  '└'
  set -l UpperRight '┐'

  # Could have also used these more rounded characters...
  #set -l UpperLeft  '╭'
  #set -l LowerLeft  '╰'

  if [ $Use_Fish_PWD ]
    set _Prompt_PWD (prompt_pwd)
  else
    # Get the FULL prompt
    set _Prompt_PWD (pwd | sed "s|$HOME|~|")
  end

  # Calculate the length of the second line of the prompt
  if [ $prev_status -eq 0 ]
    set Prompt_Size (string length "$LowerLeft($USER@$HOSTNAME) $_Prompt_PWD \$ ")
  else
    set Prompt_Size (string length "$LowerLeft($prev_status:$USER@$HOSTNAME) $_Prompt_PWD \$ ")
  end 

  # Determine the size of 2 fifths of the current display. If the prompt is
  # longer than that we will split it into 3 lines.
  set -l MaxPromptSize (math (math 2 \* $COLUMNS) \/ 5)

  # ------------------------------------------------------------------------

  # Display the horizontal bar
  set_color -o blue
  echo -n $UpperLeft
  _Disp_HBAR
  echo $UpperRight

  # Display the lead in to the prompt
  echo -n $LowerLeft
  #echo -n '─'
  echo -n '('

  # Display the return status of the previous command if it was not 0
  if not [ $prev_status -eq 0 ]
    _Disp_RetStatus $prev_status
  end

  # Display username in red if root or fakeroot, and green otherwise.
  # Might as well also determine which prompt character to display later.
  if test $USER = root -o $USER = toor
    set_color -o red
    set Prompt_Char '# '
  else
    set_color normal
    set_color green
    if [ "$csh_junkie" ]
      set Prompt_Char '% '
    else
      set Prompt_Char '$ '
    end
  end
  echo -n $USER

  # Just an '@' sign, in non-bold blue
  set_color normal
  set_color blue
  echo -n '@'

  # Display the host name and the closing parenthesis
  set_color yellow
  echo -n $HOSTNAME
  set_color -o blue
  echo -n ') '

  # Display the working directory
  set_color normal
  set_color magenta
  echo -n $_Prompt_PWD

  # If the prompt is too big, echo an empty line
  if [ $Prompt_Size -gt $MaxPromptSize ]
    echo ''
  else
    echo -n ' '
  end

  set_color normal
  echo -n $Prompt_Char
end


