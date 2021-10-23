# This script accepts three arguments:
#   ARG1: The output file name
#   ARG2: Size scale in X dimension
#   ARG3: Size scale in Y dimension
# By default, the output is 3.33 inch x 2.22 inch (column width is 3.33 inch in most conference)

arg1=ARG1
arg2=ARG2
arg3=ARG3

# Shell script for compiling Gnuplot on save:
#   inotifywait -qme close_write $(find . -name '*.gp' ) | while read -r file event; do  ( cd $(dirname $file) &&  gnuplot $(basename $file) ); done

# Gnuplot resources:
# - http://www.gnuplotting.org/
# - http://www.bersch.net/gnuplot-doc/gnuplot.html

set macros
# Print to stdout.
set print '-'

# Utility functions and macros:

is_empty_string(str) = '' eq str

# Double column format with each column having dimensions
# 9.25 inches x 3.33 inches, a space of 0.33 inches between
# the two columns.

# 3:2
plot_width=3.33
plot_height=2.22

# 16:9
# plot_height=1.873

default_font = "Arial,18"

if (!is_empty_string(arg1)) {
        outputfile=arg1
}
if (!is_empty_string(arg2)) {
        plot_width = plot_width * arg2
        plot_height = plot_height * (is_empty_string(arg3) ? arg2 : arg3)
}

set terminal postscript eps color default_font size plot_width,plot_height
print 'Output: '.outputfile.'.{eps,pdf}'

## Set styles, use the command `test` to see the example.

## Set linetypes
# usage: plot sin linetype { id | rgb hex }

# Palettes:
# https://github.com/Gnuplotting/gnuplot-palettes

# line styles for ColorBrewer Dark2
# for use with qualitative/categorical data
# provides 8 dark colors based on Set2
# compatible with gnuplot >=4.2
# author: Anna Schneider


# palette: rdylgn.pal
set palette maxcolors 8
set palette defined ( 0 '#D73027',\
    	    	      1 '#F46D43',\
		      2 '#FDAE61',\
		      3 '#FEE08B',\
		      4 '#D9EF8B',\
		      5 '#A6D96A',\
		      6 '#66BD63',\
		      7 '#1A9850' )

# matlab.pal

# Linestyles vs linetypes:
#    A linestyle is a temporary association of properties, while
# linetypes are permanent.
linetype_properties = "lw 4 ps 2"
set linetype 1 lc rgb '#0071BC' pt 5 @linetype_properties # red
set linetype 2 lc rgb '#D85218' pt 7 @linetype_properties # blue
set linetype 3 lc rgb '#ECB01F' pt 9 @linetype_properties # green
set linetype 4 lc rgb '#7D2E8D' pt 11 @linetype_properties # purple
set linetype 5 lc rgb '#76AB2F' pt 13 @linetype_properties # orange
set linetype 6 lc rgb '#4CBDED' pt 15 @linetype_properties # dark banana
set linetype 7 lc rgb '#A1132E' pt 3 @linetype_properties # brown
set linetype 8 lc rgb '#F781BF' pt 4 @linetype_properties # pink

# Default settings
set grid y
set style fill transparent pattern 4 border
# set style fill transparent solid 0.2

set output sprintf("%s.eps", outputfile)
