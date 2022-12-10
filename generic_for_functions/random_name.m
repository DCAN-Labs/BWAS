function who_cares = random_name(N_random_char,extension)


%% Oscar Miranda-Dominguez
% First line of code: July 9, 2020
%%
% use this function to generate a random file name
if nargin<2
    extension='txt';
end

if nargin<1
    N_random_char=10;
end

ascii_char_map=[65:90 48:57 97:122];
ix=1:numel(ascii_char_map);
rand_ix=randi(numel(ix),N_random_char,1);
rand_part=char(ascii_char_map(rand_ix));
who_cares=['who_cares_' rand_part '.' extension];