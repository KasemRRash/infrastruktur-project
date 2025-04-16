set terminal png
set output "response_times.png"

set title "Login Request Response Times"
set datafile separator ","
set xlabel "Request Number"
set ylabel "Response Time (ms)"
set grid

plot "logfile.txt" using 1:2 with lines title "Response Time"

