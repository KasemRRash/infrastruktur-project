set terminal png
set output 'response_times_plot.png'

set title "Login Request Response Times"
set datafile separator ","
set xlabel "Run Number"
set ylabel "Response Time (ms)"
set grid

plot "logfile.txt" using 1:3 with linespoints title "Response Time (ms)"

