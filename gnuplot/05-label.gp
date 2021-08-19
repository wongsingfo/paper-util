call 'header.gp' 05


set xrange[-pi:2*pi]

set arrow from -0.5,sin(-0.5) to pi+0.5,sin(pi+0.5) filled lc 5
set arrow from -0.4,sin(-0.4) to pi+0.4,sin(pi+0.4) nohead lw 5 dt 3 lc 2
set arrow from -0.6,sin(-0.6) to pi+0.6,sin(pi+0.6) heads lw 3 lc 3
set label "(0,0)" at 0,0 center 
set label "{/Symbol D}+0.5^2" at 0.1,0.5 center rotate by 65 textcolor lt 2
set label "at graph 0.8" at graph 0.8,0.2 tc ls 6
set arrow from -2, graph 0 to -2, graph 1 filled

plot sin(x)

call 'footer.gp'

