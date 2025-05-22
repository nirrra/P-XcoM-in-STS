% 髋关节角最大
data = (hipFlexionL+hipFlexionR)./2;
[~,pHipFlexionMax] = max(data(pKIS2:pKIE2)); pHipFlexionMax = pHipFlexionMax-1+pKIS2;
tHipFlexionMax = streamInter.wtime(pHipFlexionMax); vHipFlexionMax = data(pHipFlexionMax);
p_listV.vHipFlexionMax = vHipFlexionMax;

% 膝关节角最小
data = (kneeAngleL+kneeAngleR)./2;
[~,pKneeAngleMin] = min(data(pKIS2:pKIE2)); pKneeAngleMin = pKneeAngleMin-1+pKIS2;
tKneeAngleMin = streamInter.wtime(pKneeAngleMin); vKneeAngleMin = data(pKneeAngleMin);
p_listV.vKneeAngleMin = vKneeAngleMin;