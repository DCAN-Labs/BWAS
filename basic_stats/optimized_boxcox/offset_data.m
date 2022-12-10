function pos_data=offset_data(data)

pos_data=data;

for i=1:length(pos_data)
    x=data{i};
    
    pos_data{i}=x-min(x(:))+1;
end

