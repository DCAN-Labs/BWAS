function x_map = map_dots(x_raw,x_scaled)


%% count size
n_x_raw=numel(x_raw);
n_x_scaled=numel(x_scaled);
%%
% sort raw data
[foo1, ix_1]=sort(x_raw);

% Find the inverse sorting order (Thanks Loren!
% https://blogs.mathworks.com/loren/2007/08/21/reversal-of-a-sort/)
unsorted=1:n_x_raw;
ix_1_inverse=ix_1;
ix_1_inverse(ix_1_inverse)=unsorted;

% sort mapped data
[x_scaled_sorted, ix_2]=sort(x_scaled);

% find equidistant points
ix=round(linspace(1,n_x_scaled,n_x_raw));

% decimate based on the linearly spaced dots
x_map=x_scaled_sorted(ix);

% apply the inverse mapping
x_map=x_map(ix_1_inverse);

% scatter(x_raw,x_map)