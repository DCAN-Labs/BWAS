function x_scaled = scaled_dist(x_fit,x_raw)

min_y=min(x_raw);
max_y=max(x_raw);
delta=max_y-min_y;

% Move to zero
x_scaled=x_fit-min(x_fit);

% max to 1
x_scaled=x_scaled/max(x_scaled);


x_scaled=x_scaled*delta+min_y;