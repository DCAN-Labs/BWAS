function x_in = get_x_in_to_simulate_dist(y)

min_y=min(y);
max_y=max(y);
delta=min(abs(diff(y)));
x_in=min_y:delta:max_y+delta;