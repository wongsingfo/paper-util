### Environment

outputfile = "histogram"
default_font = "Arial,24"

inputfile = "histogram.txt"

### Output

set terminal postscript eps color default_font
set size 1,1
set key font default_font
set output sprintf("%s.eps", outputfile)

### Labels

set style data histogram
set style histogram cluster gap 1
set style fill pattern 4 border
set style histogram errorbars linewidth 1
set ylabel "values"
set xlabel "X Labels"
set yrange [0:]

### Main routine

# set arrow 1 nohead from graph 0,0 to graph 1,1 
plot inputfile using ($2):($3):xtic(1) notitle, 100 title "line"

### Output variants

set output sprintf("| ps2pdf -dEPSCrop %s.eps %s.pdf", outputfile, outputfile)
replot

set size 1,0.75
set output sprintf("%s_w.eps", outputfile)
replot
