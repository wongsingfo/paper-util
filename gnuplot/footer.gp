
# eps -> pdf
system(sprintf("ps2pdf -dEPSCrop %s.eps %s.pdf", outputfile, outputfile))
# pdf -> png
system(sprintf("pdftoppm %s.pdf %s -png -f 1 -singlefile", outputfile, outputfile))

# set size 1,0.75
# set output sprintf("%s_w.eps", outputfile)
# replot

print 'Done: '.outputfile
