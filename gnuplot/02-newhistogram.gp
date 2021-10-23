call 'header.gp' 02

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


call 'footer.gp'

