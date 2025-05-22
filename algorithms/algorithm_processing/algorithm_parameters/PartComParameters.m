BasicMathematicalMethod = application_BasicMathematicalMethod;
% com范围和熵
data = posCOMSegments.human.x(pKIS2:pStableKI);
p_listV.comXRMSD = rms(data-mean(data))*heightR;
p_listV.comXApEn = ApEn(2,0.2*std(data),data,1);
% p_listV.comXPEn = permutationEntropy(data, 3, 10);

data = posCOMSegments.human.y(pKIS2:pStableKI);
p_listV.comYRMSD = rms(data-mean(data))*heightR;
p_listV.comYApEn = ApEn(2,0.2*std(data),data,1);
% p_listV.comYPEn = permutationEntropy(data, 3, 10);

data = posCOMSegments.human.z(pKIS2:pStableKI);
[vComZMin,pComZMin] = min(data); pComZMin = pComZMin-1+pKIS2;
tComZMin = streamInter.wtime(pComZMin);
p_listV.comZRMSD = rms(data-mean(data))*heightR;
p_listV.comZApEn = ApEn(2,0.2*std(data),data,1);
% p_listV.comZPEn = permutationEntropy(data, 3, 10);

% comZ变化最快
data = CalDerivative(posCOMSegments.human.z,fsInter);
[vComZVelMax,pComZVelMax] = max(data(pKIS2:pStableKI)); pComZVelMax = pComZVelMax-1+pKIS2;
tComZVelMax = streamInter.wtime(pComZVelMax);

% comY变化最快
data = CalDerivative(posCOMSegments.human.y,fsInter);
[vComYVelMax,pComYVelMax] = max(data(pKIS2:pStableKI)); pComYVelMax = pComYVelMax-1+pKIS2;
tComYVelMax = streamInter.wtime(pComYVelMax);

p_listV.vComZMin = vComZMin*heightR; p_listV.vComZVelMax = vComZVelMax*heightR; p_listV.vComYVelMax = vComYVelMax*heightR;
