call 'header.gp' 06

set xrange [0:11]
set yrange [2:11]
set xtics 2
set ytics 2
set grid x
set key above
set key maxcols 2

style = "w lp"

plot 'iter.txt' u 1:2 @style title 'IC-1', \
        '' u 1:3 @style title 'IC-2', \
        '' u 1:4 @style title 'IC-3',

call 'footer.gp'
