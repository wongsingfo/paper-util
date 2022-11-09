# Author: Chengke Wang (chengke@pku.edu.cn)

# Call the script with the following line:
#   call template.gp <output_file> <scale_X> <scale_Y>
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

# Submissions must be in two-column format, using 10-point type on 12-point
# (single-spaced) leading, in a text block 7'' wide x 9'' deep, with .33''
# inter-column space, formatted for 8.5'' x 11'' paper.
#
# 1 in = 96 px

plot_width=3.33
plot_height=plot_width / 3 * 2

# Gnuplot use a defalut font scale of 0.5
default_font = "Arial,12"

if (!is_empty_string(arg1)) {
        outputfile=arg1
}
if (!is_empty_string(arg2)) {
        plot_width = plot_width * arg2
        plot_height = plot_height * (is_empty_string(arg3) ? arg2 : arg3)
}

# set terminal postscript eps color default_font size plot_width,plot_height
# set output sprintf("%s.eps", outputfile)

set terminal pdfcairo enhanced color font default_font size plot_width,plot_height
set output sprintf("%s.pdf", outputfile)

## Set styles, use the command `test` to see the example.

## Color scheme that is friendly to colorblind people
# Tol, Paul. 2021. “Colour Schemes.” Technical note SRON/EPS/TN/09-002 3.2. SRON.
# link: https://personal.sron.nl/~pault/data/colourschemes.pdf

# Diverging Colour Schemes
set palette defined (\
0 '#364B9A',\
1 '#4A7BB7',\
2 '#6EA6CD',\
3 '#98CAE1',\
4 '#C2E4EF',\
5 '#EAECCC',\
6 '#FEDA8B',\
7 '#FDB366',\
8 '#F67E4B',\
9 '#DD3D2D',\
10 '#A50026')

# Qualitative Colour Schemes
set linetype 1 lc rgb '#4477AA' pt 4  # blue
set linetype 2 lc rgb '#EE6677' pt 6  # red
set linetype 3 lc rgb '#228833' pt 8  # green
set linetype 4 lc rgb '#CCBB44' pt 10 # yellow
set linetype 5 lc rgb '#66CCEE' pt 12 # cyan
set linetype 6 lc rgb '#AA3377' pt 14 # purple
set linetype 7 lc rgb '#BBBBBB' pt 3  # grey

# Default settings
set grid y
# set style fill transparent pattern 4  # Use multiplot to draw the pattern!
set style fill transparent solid 1.0 border -1

## Common Questions
#
# Q: What is difference between linestyle and linetype?
# A: A linestyle is a temporary association of properties, while linetypes are
# permanent (that is, they are not affected by the reset command).
#
