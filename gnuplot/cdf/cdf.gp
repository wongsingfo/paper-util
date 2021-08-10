outputfile = "cdf"
call "../header.gp"

N=2
array datafiles[N] = ["normal.txt", "normal2.txt"]
array titles[N] = ["Distribution 1", "Distribution 2"]

set ylabel "CDF (%)"
set yrange [1:100]
set xlabel "X Label"

array line_counts[N]
do for [i = 1:N] { line_counts[i] = system(sprintf("cat %s | wc -l", datafiles[i])) }
plot for [i = 1:N] datafiles[i] u 1:(100.0/line_counts[i]) smooth cumulative w lp pt 7 ps 0 lw 5 title titles[i]

load "../footer.gp"
