% 髋关节矩为正，表示力使大腿近端向下向后，使髋关节屈曲。
% 膝关节矩为正，表示力使小腿近端向后，使膝关节伸展。
% 踝关节矩为正，表示力使小腿远端向后，使踝关节屈曲。
%% 髋关节
% 髋关节矩最小值前的最大值
data = (jointMoment.Thigh_Left_proximal.x+jointMoment.Thigh_Right_proximal.x)./2;
for pHipMomentMax1 = pHipMomentMin:-1:pHipMomentMin-ceil(fsInter*1)
    if data(pHipMomentMax1) == max(data(pHipMomentMax1-10:pHipMomentMax1+10))
        tHipMomentMax1 = streamInter.wtime(pHipMomentMax1);
        vHipMomentMax1 = data(pHipMomentMax1);
        break;
    end
end
if pHipMomentMax1 == pHipMomentMin-ceil(fsInter*1)
    tHipMomentMax1 = NaN; 
    vHipMomentMax1 = NaN;
end

% 髋关节矩最小值后的最大值
for pHipMomentMax2 = pHipMomentMin:pHipMomentMin+ceil(fsInter*0.7)
    if data(pHipMomentMax2) == max(data(pHipMomentMax2-10:pHipMomentMax2+10))
        tHipMomentMax2 = streamInter.wtime(pHipMomentMax2);
        vHipMomentMax2 = data(pHipMomentMax2);
        break;
    end
end
if pHipMomentMax2 == pHipMomentMin+ceil(fsInter*0.7)
    tHipMomentMax2 = NaN;
    vHipMomentMax2 = NaN;
end

p_listV.vHipMomentMax1 = vHipMomentMax1;
p_listV.vHipMomentMin = vHipMomentMin;
p_listV.vHipMomentMax2 = vHipMomentMax2;
data = data(pKIS2:pStableKI);
p_listV.hipMomentApEn = ApEn(2,0.2*std(data),data,1);
% p_listV.hipMomentPEn = permutationEntropy(data, 2, 1);

%% 膝关节
% 膝关节矩最大
data = (jointMoment.Shank_Left_proximal.x+jointMoment.Shank_Right_proximal.x)./2;
% [~,pKneeMomentMax] = max(data(pKIS2:pHipFlexionMax+ceil(fsInter*1)));
[~,pKneeMomentMax] = max(data(pKIS2:pStableKI));
pKneeMomentMax = pKneeMomentMax-1+pKIS2; 
tKneeMomentMax = streamInter.wtime(pKneeMomentMax);
vKneeMomentMax = data(pKneeMomentMax);

p_listV.vKneeMomentMax = vKneeMomentMax;
data = data(pKIS2:pStableKI);
p_listV.KneeMomentApEn = ApEn(2,0.2*std(data),data,1);
% p_listV.KneeMomentPEn = permutationEntropy(data, 2, 1);

%% 踝关节
% 踝关节矩最大（有的踝关节曲线在髋关节最小值附近会存在一个最小值）
data = (jointMoment.Foot_Left_proximal.x+jointMoment.Foot_Right_proximal.x)./2;
for pAnkleMomentMax1 = pHipMomentMin:-1:pHipMomentMin-ceil(fsInter*0.5)
    if data(pAnkleMomentMax1) == max(data(pAnkleMomentMax1-10:pAnkleMomentMax1+10))
        tAnkleMomentMax1 = streamInter.wtime(pAnkleMomentMax1);
        vAnkleMomentMax1 = data(pAnkleMomentMax1);
        break;
    end
end
if pAnkleMomentMax1 == pHipMomentMin-ceil(fsInter*0.5)
    tAnkleMomentMax1 = NaN; 
    vAnkleMomentMax1 = NaN;
end

for pAnkleMomentMax2 = pHipMomentMin:pHipMomentMin+ceil(fsInter*0.5)
    if data(pAnkleMomentMax2) == max(data(pAnkleMomentMax2-10:pAnkleMomentMax2+10))
        tAnkleMomentMax2 = streamInter.wtime(pAnkleMomentMax2);
        vAnkleMomentMax2 = data(pAnkleMomentMax2);
        break;
    end
end
if pAnkleMomentMax2 == pHipMomentMin+ceil(fsInter*0.5)
    tAnkleMomentMax2 = NaN; 
    vAnkleMomentMax2 = NaN;
end

% 踝关节矩最小
[~,pAnkleMomentMin] = min(data(pAnkleMomentMax1:pAnkleMomentMax2));
pAnkleMomentMin = pAnkleMomentMin-1+pAnkleMomentMax1;
if data(pAnkleMomentMin) == min(data(pAnkleMomentMin-10:pAnkleMomentMin+10))
    tAnkleMomentMin = streamInter.wtime(pAnkleMomentMin);
    vAnkleMomentMin = data(pAnkleMomentMin);
else
    pAnkleMomentMin = 1; tAnkleMomentMin = NaN; vAnkleMomentMin = NaN;
end

p_listV.vAnkleMomentMax1 = vAnkleMomentMax1;
p_listV.vAnkleMomentMin = vAnkleMomentMin;
p_listV.vAnkleMomentMax2 = vAnkleMomentMax2;
data = data(pKIS2:pStableKI);
p_listV.AnkleMomentApEn = ApEn(2,0.2*std(data),data,1);
% p_listV.AnkleMomentPEn = permutationEntropy(data, 2, 1);