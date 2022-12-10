function new_names = sort_network_network_names(within_headers)
delimiter=' and ';
newStr = split(table2cell(within_headers),delimiter);

new_names=newStr;
if size(new_names,2)>1
    n=size(within_headers,1);
    new_names=cell(n,1);
    for i=1:n
        s=sort(newStr(i,:));
        new_names{i}=[s{1} delimiter s{2}];
    end
end

new_names=table(new_names);