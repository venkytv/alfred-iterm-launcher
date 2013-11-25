#!/usr/bin/osascript

on run argv
  if count of argv < 3
    set myName to (POSIX path of (path to me) as string)
    return "Usage: osascript " & myName & " <profile-name> <session-name> <command-parameter> [<attach-session-name>]"
  end if

  set profileName to item 1 of argv
  set sessionName to item 2 of argv
  set commandParam to item 3 of argv

  try
    set attachSessionName to item 4 of argv
  on error
    set attachSessionName to ""
  end try

  set myHome to (path to current user folder as string)
  set launcherPath to (myHome & "bin:iterm-launcher")
  set launcher to POSIX path of launcherPath
  set launcherCommand to "exec " & quoted form of launcher ¬
       & " " & quoted form of commandParam & " " & quoted form of sessionName

  tell application "iTerm"
    activate

    set procRunning to false
    set myTermCount to count of terminal
    set attachTerm to 0

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
              set mySessionName to name of mySession
              if mySessionName is sessionName then
                select myTerm
                select mySession
                set procRunning to true
              else if mySessionName is attachSessionName then
                -- Found terminal window with session <attach-session-name>
                -- Attach to this window if required to create a new tab
                set attachTerm to i
              end if
            end tell -- mySession
          end repeat -- myTabCount
        end tell -- myTerm
      end repeat -- myTermCount
    end if -- myTermCount is 0

    if procRunning is false then
      -- Terminal windows open, but process not running
      if attachTerm > 0
        set myTerm to (terminal attachTerm)
      else
        set myTerm to (make new terminal)
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
