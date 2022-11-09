reset session
call '../template.gp' '01-layout' 1.0 1.5

set multiplot layout 3,1 # 3 rows, 1 column

# datafile in CSV
set datafile separator ','
set datafile columnheaders

set ytics 1
# Offsets provide a mechanism to expand these ranges to leave empty space
# between the data and the plot borders.
set offsets 1,0,0,0 # <left>, <right>, <top>, <bottom>
plot 'data.csv' using 1:2 title columnhead(2) with lp
unset offsets

set ytics 1
set ylabel '{/Symbol \260}C' offset -1,0

# The size and origin are in screen coordinates.
set size 1, 0.2
set origin 0, 0.333 # 0,0 is the lower left corner

plot sin(x)

# The size and origin conflicts with the margin settings
unset size
unset origin
# The margin is the distance between the plot border and the outer edge of the
# canvas. The units of <margin> are character heights or widths:
set lmargin 4
set rmargin 0
# Or a fraction of the full drawing area (This placement ignores the current
# values of set origin and set size, and is intended as an alternative method
# for positioning graphs within a multiplot.):
set tmargin at screen 0.33
set bmargin at screen 0.1
plot sin(x)

unset multiplot
reset session
call '../template.gp' '02-label'

set xrange[-pi:2*pi]

set arrow from -0.5,sin(-0.5) to pi+0.5,sin(pi+0.5) filled lc 5
set arrow from -0.4,sin(-0.4) to pi+0.4,sin(pi+0.4) nohead lw 5 dt 3 lc 2
set arrow from -0.6,sin(-0.6) to pi+0.6,sin(pi+0.6) heads lw 3 lc 3
set label "(0,0)" at 0,0 center 
set label "{/Symbol D}+0.5^2" at 0.1,0.5 center rotate by 65 textcolor lt 2
set label "at graph 0.8" at graph 0.8,0.2 tc ls 6
set arrow from -2, graph 0 to -2, graph 1 filled

plot sin(x)

reset session
call '../template.gp' '03-boxplot'

set style data boxplot
#set xtics ('N1' 1, 'N2' 2)
set ylabel 'Data'
set xtics rotate by 25 right

# supress the outliers
# set style boxplot nooutliers

set linetype 51 lc 1
set linetype 52 lc 1
set linetype 53 lc 1
set linetype 54 lc 2
set linetype 55 lc 3
set linetype 56 lc 3
set linetype 57 lc 3
plot 'boxplot.txt' using (1):($8/1e6):(0):4 ps 0.5 lt 51 lc variable not

reset session
call '../template.gp' '04-cdf'

# datafile in CSV
set datafile separator ','
set datafile columnheaders

set yrange [0:100]
set key left top
set ylabel 'CDF (%)'
set xlabel 'value'
num_line = 1000

filename = 'cdf.csv'
N = 2
array line_counts[N]

do for [i=1:N] {
    stats filename using i name "STATS" nooutput
    # The result is affected by yrange
    line_counts[i] = STATS_records + STATS_outofrange
}

plot for [i=1:N] filename using i:(100.0/line_counts[i]) \
    smooth cumulative title columnhead(i) with l

reset session
call '../template.gp' '05-newhistogram'

# set key samplen 2
set key maxrows 1
# set key vertical # limited by maxrows
# set key horizontal # limited by maxcols
set key left top
set style data histograms
set style histogram rowstacked title offset 0,0.2 
set bmargin 5
set xlabel "Utilization" offset 0,-0.4
set ylabel "Number of pieces used"
set yrange [0:30]

# ref: http://www.bersch.net/gnuplot-doc/histograms.html#newhistogram
# newhistogram {"<title>" {font "name,size"} {tc <colorspec>}} 
#              {lt <linetype>} {fs <fillstyle>} {at <x-coord>}

fill_option='fillstyle pattern 4+i lc i+1'

plot newhistogram "1.3", 'newhistogram.txt' u 2:xtic(1) t "used" fs pattern 4,\
                                         '' u 3         t "usable",\
                                         '' u 4         t "wasted",\
    newhistogram "1.5", for [i=0:2] '' u (column(8+i)):xtic(1)  @fill_option notitle,\
    newhistogram "1.7", for [i=0:2] '' u (column(8+i)):xtic(1)  @fill_option notitle,\
    newhistogram "1.8", for [i=0:2] '' u (column(11+i)):xtic(1) @fill_option notitle,\
    newhistogram '2.0', for [i=0:2] '' u (column(14+i)):xtic(1) @fill_option notitle,\


reset session
call '../template.gp' '06-lines'

# Bessel functions (after Bronstein 2001, eq. 9.54a)
besj2(x) = 2*1/x * besj1(x) - besj0(x)
besj3(x) = 2*2/x * besj2(x) - besj1(x)
besj4(x) = 2*3/x * besj3(x) - besj2(x)
besj5(x) = 2*4/x * besj4(x) - besj3(x)
besj6(x) = 2*5/x * besj5(x) - besj4(x)
besj0_(x) = x<5 ? besj0(x) : 1/0

set label 'J_0' at 1.4,0.90 center tc lt 1
set label 'J_1' at 1.9,0.67 center tc lt 2
set label 'J_2' at 3.2,0.57 center tc lt 3
set label 'J_3' at 4.3,0.51 center tc lt 4
set label 'J_4' at 5.4,0.48 center tc lt 5
set label 'J_5' at 6.5,0.45 center tc lt 6
set label 'J_6' at 7.6,0.43 center tc lt 7

set xrange [0:15]
unset key

line_options = 'w lp pn 6'
plot besj0(x) @line_options, \
     besj1(x) @line_options, \
     besj2(x) @line_options, \
     besj3(x) @line_options, \
     besj4(x) @line_options, \
     besj5(x) @line_options, \
     besj6(x) @line_options
