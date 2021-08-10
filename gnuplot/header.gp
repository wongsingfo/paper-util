default_font = "Arial,18"

# Double column format with each column having dimensions
# 9.25 inches x 3.33 inches, a space of 0.33 inches between
# the two columns.
set terminal postscript eps color default_font size 3.33in,2.22in
# use 'set size [scale]' to resize the output

# set key font default_font
# set key left top

# print to stdout
set print '-'
print 'Output: '.outputfile.'.{eps,pdf}'

set output sprintf("%s.eps", outputfile)
