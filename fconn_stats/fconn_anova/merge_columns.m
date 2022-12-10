function unicolumn=merge_columns(multicolumn,juncture_text,order_matters_flag)

[r,c]=size(multicolumn);
unicolumn=cell(r,1);
for i=1:r
    temp=multicolumn{i,:};
    if order_matters_flag==0
        temp=sort(temp);
    end
    unicolumn{i}=[temp{1} juncture_text temp{2}];
    for j=3:c
        unicolumn{i}=[unicolumn{i} juncture_text temp{j}];
    end
end

unicolumn=char(unicolumn); 
unicolumn=table(unicolumn);
unicolumn.Properties.VariableNames={'Contrast'};
% 
% function c=merge_columns(c1,c2,juncture_text,order_matters_flag)
% % c1, first column to merge
% % c2, second column to merge
% 
% r=size(c1,1);
% 
% if order_matters_flag
%     c=[char(c1{:,1}) repmat(juncture_text,r,1) char(c2{:,1})];
% else
%     c=cell(r,1);
%     for i=1:r
%         temp=sort([c1{i,1} c2{i,1}]);
%         c{i}=[temp{1} juncture_text temp{2}];
%     end
%     c=char(c); 
% end