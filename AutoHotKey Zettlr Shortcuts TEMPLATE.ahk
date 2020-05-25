;AutoHotKey Zettlr Shortcuts TEMPLATE. You will need to change the folder locations for the first two scripts (marked with *)

;Create Quick Note that creates a new dated note from anywhere on your computer. New note will have auto-filled Numercial ID and dated title in YAML header, and time stamp as heading for new entries.

  ;Shortcut (CTRL + ALT + N)
    ^!N::
    
  ;Show the Input Box to the user
    ;Gui, Color, 1CB27E ;Optional green background color, remove the ';' in front of 'Gui'
    Gui, Add, Text,, Text (can format in MD):
    Gui, Add, Edit, w400 h100 vtext
    Gui, Add, Button, gokay_pressed, Okay
    Gui, Add, Button, cancel X+8 YP+0, Cancel
    Gui, Show, Center autosize, Add Quick Note to Zettlr
  Return

    GuiClose:
    GuiEscape:
    ButtonCancel:
    Gui, Destroy
  return

    okay_pressed:
    Gui Submit
    Gui Destroy
    
  ;Create ID
    FormatTime, CurrentDateTime,, yyyyMMddHHmm ;(add 'ss' to the end if using seconds)
    id=%CurrentDateTime%
    
  ;Create date stamp
    FormatTime, CurrentDate,, MMMM d, yyyy
    dateStamp=%CurrentDate%
    
  ;Format the time stamp
    timeStamp=%A_Hour%:%A_Min%
    
  ;Define folder. CHANGE THIS TO YOUR ZETTLR WORKING FOLDER WHERE YOU WANT NEW FILE TO BE CREATED!
    zettlrFolder=C:\Users\---\Dropbox\Personal
    
    ;Write text to a new Zettlr file if not existing, or append to existing one. ADD IN YOUR FOLDER LOCATION PATH AT THE ASTERISK (same as above).
    if FileExist("C:\*\" dateStamp ".md") {
        FileAppend, 
        (
# %timeStamp%
%text%`n`n
        ), %zettlrFolder%\%dateStamp%.md
    } else {
        FileAppend, 
        (
---
id: %id%
title: %dateStamp%
---
# %timeStamp%
%text%`n`n
        ), %zettlrFolder%\%dateStamp%.md
    }
return

;The following scripts only work when Zettlr is open

#IfWinActive ahk_exe Zettlr.exe

;Create Linked Child Zettel. Highlight the text you want the new note to be titled as, then press the shortcut keys. New note will be automatically given a filename with Numerical ID, and auto-fill ID and Title in YAML header.

  ;Shortcut (CTRL + ALT + Z)
    ^!Z::
    KeyWait, Ctrl
    KeyWait, Shift
    
  ;Copy current text selection to clipboard
    Send {Ctrl down}{c}{Ctrl up}
    
  ;Clipboard to variable
    titleText=%clipboard%
    
  ;Create date time string
    FormatTime, CurrentDateTime,, yyyyMMddHHmm ;(add 'ss' to the end if using seconds)
    id=%CurrentDateTime%
    
  ;Paste date time string + titletext to current text cursor position
    clipboard= [[%id%]] %titleText%
    Send {Ctrl down}{v}{Ctrl up}
    
  ;Copy current file name to clipboard using Zettlr GUI and shortcut
    Send {Ctrl down}{r}{Ctrl up}
    Send {Ctrl down}{c}{Ctrl up}
    Send {Esc}
    
  ;Clipboard to variable
    currentFileName= %clipboard%
    
  ;Take prefix .md away from currentFileName string
    StringReplace,currentFileName,currentFileName,.md,, All
    
  ;Define folder. CHANGE THIS TO YOUR ZETTLR WORKING FOLDER WHERE YOU WANT NEW FILE TO BE CREATED!
    zettlrFolder=C:\*
    
  ;Write to new file. First line is link to currentFileName. After that, two newlines.
    FileAppend, ---`nid: %id%`ntitle: %titleText%`n---`nLink: [[%currentFileName%]]`n`n, %zettlrFolder%\%id%.md
    
return

;Auto YAML Formatter. Automatically generates ID.

  ;Shortcut (CTRL + ALT + Y)
    ^!Y::
    
  ;Create date time string 
    FormatTime, CurrentDateTime,, yyyyMMddHHmm ;(add 'ss' to the end if using seconds)
    id=%CurrentDateTime%

  ;YAML Layout (modify as needed)  
    Send, 
    (
---
id: %id%
title:
---
    )
return

