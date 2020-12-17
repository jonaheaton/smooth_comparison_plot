# smooth_comparison_plot
 Matlab code to make gaussian smoothed comparison plots accross multiple data sets. Use fine bins for the x-data, but each data point can be multiple bins and we use gaussian weights so that a data point is not counted more than once accross the entire data set. The guassian weight assigned to a data point for a specific bin is based on the x-value of the data point's distance from the center of the bin. The y-values of the data within a bin are averaged using the assigned weights. Error boundries on the data change based on the amount of smoothing that is done, and the amount of smoothing can be varied by the width of the gaussian used for the weighting. 

the pre_smooth_plot is a wrapper function so your plots always look nice. 
comments still need to be added, and this description can be a lot cleaner
