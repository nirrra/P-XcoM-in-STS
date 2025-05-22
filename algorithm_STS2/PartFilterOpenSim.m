%% 滤波器
Fs = 100;
Fc = 6;
Wn = Fc / (Fs/2);
n = 4;
[b,a] = butter(n,Wn,'low');

funcFilter = @(data) filter(b,a,data);
%% 滤波
names = ik.Properties.VariableNames;
for i = 2:size(ik,2)
    ik.(names{i}) = funcFilter(ik.(names{i}));
end

names = id.Properties.VariableNames;
for i = 2:size(id,2)
    id.(names{i}) = funcFilter(id.(names{i}));
end

names = analysis.Properties.VariableNames;
for i = 1:size(analysis,2)
    if contains(names{i},'time')
        continue;
    end
    analysis.(names{i}) = funcFilter(analysis.(names{i}));
end