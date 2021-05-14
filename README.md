# paper-util
Utilities for paper writing.

## google_scholar.py

This tool searches for literature by title on Google Scholar. It can also automatically add the corresponding BibTeX entry to a specified `.bib` file. It works as follows:

1. Check if the literature already exists in the `.bib` file. It performs a fuzzy and patial lookup on the title. For example, both "Snap" and "microkernel approach" will match the literature "Snap: a Microkernel Approach to Host Network". 
2. Perform a lookup on Google Scholar.
3. Add the BibTeX entry to the `.bib` file.

The program will prompt user to ask if a specific action should be performed.

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

