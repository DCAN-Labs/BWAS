function network=short_name_bezgiin(bezgiin_network)


foo=char(bezgiin_network);
foo=foo(:,3:end);

n=size(foo,1);
network=cell(n,1);

for i=1:n
    network{i}=get_short(strtrim(foo(i,:)));
end

function short=get_short(long)

switch long
    case 'auditory'
        short='Aud';
    case 'default mode'
        short='Def';
    case 'dorsal attention'
        short='DoA';
    case 'insular-opercular'
        short='InO';
    case 'limbic'
        short='Lmb';
    case 'somatomotor'
        short='SoM';
    case 'unknown'
        short='Non';
    case 'visual'
        short='Vis';
        
end
