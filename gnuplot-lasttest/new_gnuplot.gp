set terminal png
set output 'overnight_response_times.png'
set title "Overnight Load Test Response Times"
set datafile separator ","
set xlabel "Run Number"
set ylabel "Response Time (ms)"
set grid
plot "overnight_test_results.csv" using 1:3 with linespoints title "Response Time"

