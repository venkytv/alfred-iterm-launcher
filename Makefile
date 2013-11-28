OUTFILE=iTerm-Launcher.alfredworkflow
INFILES= 5C5B2B8F-8A2D-4570-9240-F11550122D36.png \
	alfred-known-hosts.pl \
	icon.png \
	info.plist \
	iterm-launcher \
	iterm-launcher.scpt

$(OUTFILE): $(INFILES)
	$(RM) $(OUTFILE)
	zip $(OUTFILE) $(INFILES)

install: $(OUTFILE)
	open $(OUTFILE)

clean:
	$(RM) $(OUTFILE)
