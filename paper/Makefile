# usenix sigconf ieeeconf
ENTRY=usenix

all:
	latexmk -pdf -synctex=1 $(ENTRY).tex
	# refresh
	pkill -HUP mupdf

preview:
	# Use -pvc option to let Latexmk to continuously check all input files
	# for changes and re-compile the whole thing
	latexmk -pdf -synctex=1 $(ENTRY).tex -pvc

clean:
	latexmk -c
	# rm *.log *.fdb_latexmk *.aux *.bbl *.blg *.fls *.out *.xcp
