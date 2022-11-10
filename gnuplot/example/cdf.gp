call '../template.gp' 'cdf'

# datafile in CSV
set datafile separator comma
set datafile columnheaders

set yrange [0:100]
set key left top
set ylabel 'CDF (%)'
set xlabel 'Value'

filename = 'cdf.csv'
stats filename name 'STATS' nooutput
N = STATS_columns
array line_counts[N]

do for [i=1:N] {
    stats filename using i name 'STATS' nooutput
    line_counts[i] = STATS_records + STATS_outofrange
}

plot for [i=1:N] filename using i:(100.0/line_counts[i]) \
    smooth cumulative title columnhead(i) with lp pn 5
