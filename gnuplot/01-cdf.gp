call 'header.gp' 01

N=2
array datafiles[N] = ["normal.txt", "normal2.txt"]
array titles[N] = ["Dist 1", "Dist 2"]

set key right bottom
set ylabel "CDF (%)"
set yrange [1:100]
set xlabel "X Label"
set xrange [-3:4]

array line_counts[N]
do for [i = 1:N] { line_counts[i] = system(sprintf("cat %s | wc -l", datafiles[i])) }
plot for [i = 1:N] datafiles[i] u 1:(100.0/line_counts[i]) smooth cumulative w lp \
    pointinterval 70 title titles[i]

call 'footer.gp'

