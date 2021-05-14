### Environment

outputfile="output"
N=2
array datafiles[N] = ["../normal.txt", "../normal2.txt"]
array titles[N] = ["Distribution 1", "Distribution 2"]

### Output

set terminal postscript eps color "Arial" 28
set size 1,1
set key font "Arial,24"
set key left top
set output sprintf("%s.eps", outputfile)

### Labels

set ylabel "CDF (%)"
set yrange [1:100]
set xlabel "X Label"

### Main routine

array line_counts[N]
do for [i = 1:N] { line_counts[i] = system(sprintf("cat %s | wc -l", datafiles[i])) }
plot for [i = 1:N] datafiles[i] u 1:(100.0/line_counts[i]) smooth cumulative w lp pt 7 ps 0 lw 5 title titles[i]

### Output variants

set output sprintf("| ps2pdf -dEPSCrop %s.eps %s.pdf", outputfile, outputfile)
replot

set size 1,0.75
set output sprintf("%s_w.eps", outputfile)
replot
