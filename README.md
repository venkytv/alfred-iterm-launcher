alfred-iterm-launcher
=====================

Workflow to launch processes in iTerm tabs.

In the basic pre-configured setup, launch ssh sessions in their own iTerm
tabs.  If a session is already active, switch to that tab instead of
launching another session.

With the optional ~/.iterm-launcher.conf file, the launcher could be configured
to run a different connect program instead of 'ssh'.  The same config file can
also be used to set up aliases for hostnames.

The list of matches for the workflow is picked from ~/.ssh/known\_hosts file,
and so, this is primarily geared towards ssh.  But with a different launch
script instead of "alfred-known-hosts.pl", the workflow could be set up to run
arbitrary commands in iTerm tabs.

Download the [latest version here](https://github.com/venkytv/alfred-iterm-launcher/raw/master/iTerm-Launcher.alfredworkflow).

You also need to copy the [iterm-launcher](https://raw.github.com/venkytv/alfred-iterm-launcher/master/iterm-launcher) script to your ~/bin directory.

If you have cloned this repo and have [Xcode command line tools installed](http://stackoverflow.com/a/9329325), "make install" will do all of this for you.

Dependencies:

- [Config::Tiny](https://metacpan.org/pod/Config::Tiny)
- [XML:Simple](https://metacpan.org/pod/XML::Simple)

Credits:

- Icon from the [War on Bad Design 2](http://www.iconarchive.com/show/war-on-bad-design-2-icons-by-icondesigner.net/WoBD-Terminal-icon.html) set.
- Applescript heavily culled from examples on the [iTerm2 wiki](http://code.google.com/p/iterm2/wiki/AppleScript), especially [this one](http://alexwlchan.dreamwidth.org/958.html).
