call "../../gnuplot_header.gp" plot .7

set style data histogram
set style histogram cluster gap 1
set style fill pattern 4 border
set ytics 5
set yrange [:25]

# set style histogram errorbars linewidth 2

# 95: 1.96
coe=1.96*(1/sqrt(50))


set key above vertical
# set key left top vertical 

set logscale y

set xtics ("S-80" 0, "R-80" 1, "S-160" 2, "R-160" 3)
set grid y

set key font ',14'

set xtics font ',14'

set ylabel "Power (mAH)"

# set arrow from 2.5, graph 0 to 2.5, graph 1 nohead filled lw 3


plot \
     'data.txt'  using 2 title "SmartBuff",\
   'data.txt' using  1 title 'TACK' ,\



call "../../gnuplot_footer.gp"
