### Environment

outputfile = "stack"
default_font = "Arial,24"

inputfile = "stack.txt"

### Output

set terminal postscript eps color default_font
set size 1,1
set key font default_font
set key top left
set output sprintf("%s.eps", outputfile)

### Labels

set style histogram rowstacked # or columnstacked
set style data histogram
set key autotitle columnheader
set style fill pattern 4 border
set boxwidth 0.7
set ylabel 'CPU usage(%)' font default_font
set xtics rotate by 330 font default_font

### Main routine

num_cols = system(sprintf("awk 'NR == 1 { print NF; exit }' %s", inputfile))

plot for [i=2:num_cols] inputfile using i:xtic(1)

### Output variants

set output sprintf("| ps2pdf -dEPSCrop %s.eps %s.pdf", outputfile, outputfile)
replot

set size 1,0.75
set output sprintf("%s_w.eps", outputfile)
replot
