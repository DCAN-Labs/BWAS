function matched_table=match_table(tidyData,matched_participants,groups)
%% matched_table=match_table(tidyData,matched_participants,groups)
%
%
% Oscar Miranda-Dominguez, Feb 9, 2018

[n_subjects,n_groups]=size(matched_participants);

matched_table=[];

c=0;
for i=1:numel(groups)
    matched_table=[matched_table tidyData(matched_participants(:,i),:)];
    preffix=[groups{i} '_'];
    preffix = regexprep(preffix,' ','_');
    for j=1:size(tidyData,2)
        c=c+1;
        suffix=tidyData.Properties.VariableNames{j};
        matched_table.Properties.VariableNames{c}=[preffix suffix];
    end
end