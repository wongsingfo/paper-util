
set output sprintf("| ps2pdf -dEPSCrop %s.eps %s.pdf", outputfile, outputfile)
replot

### Output variants

# set size 1,0.75
# set output sprintf("%s_w.eps", outputfile)
# replot

print 'Done: '.outputfile
