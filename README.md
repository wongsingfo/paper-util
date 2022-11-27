# paper-util

This repo includes utilities for paper writing.

## google_scholar.py

This tool searches for literature by title on Google Scholar. It can also automatically add the corresponding BibTeX entry to a specified `.bib` file. It works as follows:

1. Check if the literature already exists in the `.bib` file. It performs a fuzzy and partial lookup on the title. For example, both "Snap" and "microkernel approach" will match the literature "Snap: a Microkernel Approach to Host Network". 
2. Perform a lookup on Google Scholar.
3. Add the BibTeX entry to the `.bib` file.

The program will prompt the user to ask if a specific action should be taken.

```
usage: google_scholar.py [-h] [-f bibtex] pubs

Get bibtex from Google Scholar

positional arguments:
  pubs        publication title

optional arguments:
  -h, --help  show this help message and exit
  -f bibtex   look up this bibtex before searching Google Scholar

Examples:
    ./google_scholar.py 'ZygOS: Achieving Low Tail Latency for Microsecond-scale Networked Tasks'
    ./google_scholar.py 'Snap: a Microkernel Approach to Host Network' -f ref.bib
```

## gnuplot

Gnuplot scirpts.

## gnuplot_watchdog.py

This script replots the figures when you save your plot scripts or data file.

## Kuroko

[Kuroko-CLI](https://github.com/shioyadan/kuroko-cli) developed by [shioyadan](https://github.com/shioyadan) is an amazing command line tool to convert from EMF to PDF. Now you can create PDF files from PowerPoint/Excel for use in LaTeX. This tool also has [the GUI counterpart](https://github.com/shioyadan/kuroko).

This tool is extremely useful for Windows users. On macOS, you can use the Preview application to do the same thing.

```
$ ./kuroko-cli.exe
Kuroko version 0.03
Usage:
  kuroko -b PDF_FILE_NAME
    Capture EMF data in a clipboard and convert it to a PDF file.
  kuroko -c EMF_FILE_NAME [PDF_FILE_NAME]
    Convert an EMF file to a PDF file.
  kuroko -i
    Install a dedicated printer for Kuroko. You should install it before use.
  kuroko -k
    Check whether a dedicated printer is installed.
```

## Latex Table

https://tableconvert.com/latex-generator

