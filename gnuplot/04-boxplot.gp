call 'header.gp' 04

set style data boxplot

#set xtics ('N1' 1, 'N2' 2)

set ylabel 'Data'
set xtics rotate by -25 left

# supress the outliers
# set style boxplot nooutliers


# using (X, Y, width)
# plot 'normal.txt' using (1):1:(0.3) notitle,\
#     'normal2.txt' using (2):1:(0.3) notitle

set linetype 51 lc 1
set linetype 52 lc 1
set linetype 53 lc 1
set linetype 54 lc 2
set linetype 55 lc 3
set linetype 56 lc 3
set linetype 57 lc 3
plot 'boxplot.txt' using (1):($8/1e6):(0):4 lt 51 lc variable not

call 'footer.gp'

