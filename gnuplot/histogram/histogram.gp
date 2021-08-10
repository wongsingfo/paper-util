outputfile = "histogram"
load '../header.gp'

inputfile = "histogram.txt"
N = 2
array titles[N] = ["P", "Q"]

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
plot for [i=1:N] inputfile using (column(i*2)):(column(i*2+1)):xtic(1) t titles[i], 100 title "line"

load '../footer.gp'
