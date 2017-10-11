# separation
Separation is a very simple fish theme for folks who, like me, prefer to have the output of each of their commands clearly delineated, and who prefer to always have enough space on the line to type a command without overflowing to a new line. To that end, this theme outputs a horizontal bar across the display for each and every prompt. On the second line, only the return status of the previous command (if it was not 0), your username, your hostname, and your working directory are displayed. If this information should ever happen to take up more than two fifths of the screen, the actual prompt is displayed on a third line, giving you plenty of space to type.

By default the full working directory without any of Fish's normal abbreviations will be displayed. This can be easily overridden by setting the "Use_Fish_PWD" variable to anything in your init file. Given that the prompt will go to a third line if the working directory is too long, I don't find the abbreviations to be very useful, but the choise is yours. You can also use the '%' character as your prompt instead of '$' by setting the "csh_junkie" variable to anything.

There is a noteable bug in Fish in which the "COLUMNS" variable, which stores the width of your terminal, is always set to 78 regardless of the terminal's actual size for the first prompt after starting Fish. Afterwards it is set correctly. This unfortunately means that the horizontal bar will be too short for that first prompt.

Pictures always speak a thousand words. Note the bug manifesting itself after switching to root.

<p align="center">
<img src="https://i.imgur.com/QftI04P.png">
</p>
