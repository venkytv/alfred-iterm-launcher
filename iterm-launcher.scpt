#!/usr/bin/osascript

on run argv
  if count of argv < 3
    set myName to (POSIX path of (path to me) as string)
    return "Usage: osascript " & myName & " <profile-name> <session-name>
    <command-parameter> [<force-new-window>]"
  end if

  set profileName to item 1 of argv
  set sessionName to item 2 of argv
  set commandParam to item 3 of argv

  try
    set forceNewWindow to item 4 of argv
    set forceNewWindow to forceNewWindow as number
  on error errStr number errorNumber
    if errorNumber is -1728 then
      -- Fourth parameter not set
      set forceNewWindow to 0
    else if errorNumber is -1700 then
      -- Fourth parameter not a number; count it as set
      set forceNewWindow to 1
    else
      error errStr number errorNumber
    end if
  end try

  set myHome to (path to current user folder as string)
  set launcherPath to (myHome & "bin:iterm-launcher")
  set launcher to POSIX path of launcherPath
  set launcherCommand to "exec " & quoted form of launcher ¬
  	& " " & quoted form of sessionName & " " & quoted form of commandParam

  tell application "iTerm"
    activate

    set procRunning to false
    set myTermCount to count of terminal
    if myTermCount is 0 then
      -- No iTerm windows open
      set newTerm to (make new terminal)
      tell newTerm
        launch session profileName
        tell current session
          write text launcherCommand
          set name to sessionName
        end tell
        set procRunning to true
      end tell

    else
      -- iTerm windows open
      repeat with i from 1 to myTermCount by 1
        set myTerm to (terminal i)
        tell myTerm
          set myTabCount to count of session
          repeat with j from 1 to myTabCount by 1
            set mySession to (session j)
            tell mySession
              if name of mySession is sessionName then
                select myTerm
                select mySession
                set procRunning to true
              end if
            end tell -- mySession
          end repeat -- myTabCount
        end tell -- myTerm
      end repeat -- myTermCount
    end if -- myTermCount is 0

    if procRunning is false then
      -- Terminal windows open, but process not running

      -- If there is only one terminal window open, add a new tab
      -- Else, launch a new terminal window
      if myTermCount > 1 or forceNewWindow > 0 then
        set myTerm to (make new terminal)
      else
        set myTerm to (terminal 1)
      end if

      tell myTerm
        launch session profileName
        tell current session
          write text launcherCommand
          set name to sessionName
        end tell
        set procRunning to true
      end tell -- myTerm
    end if -- procRunning is false
  end tell -- "iTerm"
end run
