call '../template.gp' 'histogram'

# datafile in CSV
set datafile separator comma
set datafile columnheaders

set yr [0:800]
set xr [-0.6:2.6]

set key samplen 3 maxrows 4
set key right top

set grid y
set xtics nomirror
set ytics 200

set style data histogram
set style histogram cluster gap 2
set style histogram errorbars lw 1

set xl 'Signal Strength (dBm)' offset 0,0.5,0
set yl 'Throughput (Mbps)'

set multiplot
set style fill transparent solid 0.5 border -1
plot 'histogram.csv' using (column("ours")):(column("ours_var")):xtic(1) title "Ours" ,\
     '' using (column("udp")):(column("udp_var")) title "UDP",\
     '' using (column("udp2")):(column("udp2_var")) title "UDP2",\
     '' using (column("tack")):(column("tack_var")) title "TACK",\
     '' using (column("bbr")):(column("bbr_var")) title "BBR",\
     '' using (column("cubic")):(column("cubic_var")) title "CUBIC",\
     '' using (column("quic")):(column("quic_var")) title "QUIC"

set style fill transparent pattern 4
replot
unset multiplot
