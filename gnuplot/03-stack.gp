call 'header.gp' 03

inputfile = "stack.txt"
N = 3
array titles[N] = ["user", "sys", "irq"]

set key top left

set style histogram rowstacked # or columnstacked
set style data histogram
# set key autotitle columnheader
set style fill pattern 4 border
set boxwidth 0.6
set ylabel 'CPU usage(%)' font default_font
set xtics rotate by 330 font default_font

# num_cols = system(sprintf("awk 'NR == 1 { print NF; exit }' %s", inputfile))
plot for [i=1:N] inputfile using (column(i+1)):xtic(1) t titles[i] 

call 'footer.gp'


