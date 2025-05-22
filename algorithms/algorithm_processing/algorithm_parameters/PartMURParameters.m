% % 单侧极限归一化 https://www.sciencedirect.com/science/article/pii/S0169814115300391#sec3
% MUR = (jointMoment.Thigh_Left_proximal.x./419).^2+(jointMoment.Thigh_Right_proximal.x./419).^2+...
%     (jointMoment.Shank_Left_proximal.x./157).^2+(jointMoment.Shank_Right_proximal.x./157).^2+...
%     (jointMoment.Shank_Left_distal.x./237).^2+(jointMoment.Shank_Right_distal.x./237).^2;
% 双侧极限归一化 https://www.mdpi.com/2076-3417/10/24/8798
MUR = ((jointMoment.Thigh_Left_proximal.x+342)./(419+342)).^2+((jointMoment.Thigh_Right_proximal.x+342)./(419+342)).^2+...
    ((jointMoment.Shank_Left_proximal.x+318)./(157+318)).^2+((jointMoment.Shank_Right_proximal.x+318)./(157+318)).^2+...
    ((jointMoment.Foot_Left_proximal.x+42)./(237+42)).^2+((jointMoment.Foot_Right_proximal.x+42)./(237+42)).^2;

data = MUR;
[~,pMURMax] = max(data(pKIS2:pStableKI)); pMURMax = pMURMax-1+pKIS2;
tMURMax = streamInter.wtime(pMURMax); vMURMax = data(pMURMax);

for pMURMin1 = pMURMax:-1:max(max(pMURMax-ceil(fsInter*0.7),pKIS2),1+10)
    if data(pMURMin1) == min(data(pMURMin1-10:pMURMin1+10))
        tMURMin1 = streamInter.wtime(pMURMin1);
        vMURMin1 = data(pMURMin1);
        break;
    end
end
if pMURMin1 == max(max(pMURMax-ceil(fsInter*0.7),pKIS2),1+10)
    tMURMin1 = NaN; vMURMin1 = NaN;
end

for pMURMin2 = pMURMax:min(pMURMax+ceil(fsInter*1),pStableKI)
    if data(pMURMin2) == min(data(pMURMin2-10:pMURMin2+10))
        tMURMin2 = streamInter.wtime(pMURMin2);
        vMURMin2 = data(pMURMin2);
        break;
    end
end
if pMURMin2 == min(pMURMax+ceil(fsInter*1),pStableKI)
    tMURMin2 = NaN; vMURMin2 = NaN;
end

p_listV.vMURMin1 = vMURMin1;
p_listV.vMURMax = vMURMax;
p_listV.vMURMin2 = vMURMin2;
p_listV.MURSum = sum(MUR(pKIS2:pStableKI))./fsInter;

MURHip = ((jointMoment.Thigh_Left_proximal.x+342)./(419+342)).^2+((jointMoment.Thigh_Right_proximal.x+342)./(419+342)).^2;
MURKnee = ((jointMoment.Shank_Left_proximal.x+318)./(157+318)).^2+((jointMoment.Shank_Right_proximal.x+318)./(157+318)).^2;
MURAnkle = ((jointMoment.Foot_Left_proximal.x+42)./(237+42)).^2+((jointMoment.Foot_Right_proximal.x+42)./(237+42)).^2;
p_listV.MURHipSum = sum(MURHip(pKIS2:pStableKI))./fsInter;
p_listV.MURKneeSum = sum(MURKnee(pKIS2:pStableKI))./fsInter;
p_listV.MURAnkleSum = sum(MURAnkle(pKIS2:pStableKI))./fsInter;

p_listV.MURPower = p_listV.MURSum./(tStable-tStart);
p_listV.MURHipPower = p_listV.MURHipSum./(tStable-tStart);
p_listV.MURKneePower = p_listV.MURKneeSum./(tStable-tStart);
p_listV.MURAnklePower = p_listV.MURAnkleSum./(tStable-tStart);

%% 计算内功
IWHip = abs(jointMoment.Thigh_Left_proximal.x(pKIS2+1:pStableKI+1)-jointMoment.Thigh_Left_proximal.x(pKIS2:pStableKI));
IWKnee = abs(jointMoment.Shank_Left_proximal.x(pKIS2+1:pStableKI+1)-jointMoment.Shank_Left_proximal.x(pKIS2:pStableKI));
IWAnkle = abs(jointMoment.Foot_Left_proximal.x(pKIS2+1:pStableKI+1)-jointMoment.Foot_Left_proximal.x(pKIS2:pStableKI));
p_listV.IWHipSum = sum(IWHip)./fsInter;
p_listV.IWKneeSum = sum(IWKnee)./fsInter;
p_listV.IWAnkleSum = sum(IWAnkle)./fsInter;
p_listV.IWSum = p_listV.IWHipSum+p_listV.IWKneeSum+p_listV.IWAnkleSum;

p_listV.IWHipPower = p_listV.IWHipSum./(tStable-tStart);
p_listV.IWKneePower = p_listV.IWKneeSum./(tStable-tStart);
p_listV.IWAnklePower = p_listV.IWAnkleSum./(tStable-tStart);
p_listV.IWSumPower = p_listV.IWSum./(tStable-tStart);

% 髋 正为屈曲
aux = (IWHip+(jointMoment.Thigh_Left_proximal.x(pKIS2+1:pStableKI+1)-jointMoment.Thigh_Left_proximal.x(pKIS2:pStableKI)))./2;
p_listV.IWHipFlexion = sum(aux)./fsInter;
p_listV.IWHipFlexionPower = p_listV.IWHipFlexion/(tStable-tStart)*length(aux)/numel(find(aux>0));
aux = (IWHip-(jointMoment.Thigh_Left_proximal.x(pKIS2+1:pStableKI+1)-jointMoment.Thigh_Left_proximal.x(pKIS2:pStableKI)))./2;
p_listV.IWHipExtension = sum(aux)./fsInter;
p_listV.IWHipExtensionPower = p_listV.IWHipExtension/(tStable-tStart)*length(aux)/numel(find(aux>0));
% 膝 正为伸展
aux = (IWKnee-(jointMoment.Shank_Left_proximal.x(pKIS2+1:pStableKI+1)-jointMoment.Shank_Left_proximal.x(pKIS2:pStableKI)))./2;
p_listV.IWKneeFlexion = sum(aux)./fsInter;
p_listV.IWKneeFlexionPower = p_listV.IWKneeFlexion/(tStable-tStart)*length(aux)/numel(find(aux>0));
aux = (IWKnee+(jointMoment.Shank_Left_proximal.x(pKIS2+1:pStableKI+1)-jointMoment.Shank_Left_proximal.x(pKIS2:pStableKI)))./2;
p_listV.IWKneeExtension = sum(aux)./fsInter;
p_listV.IWKneeExtensionPower = p_listV.IWKneeExtension/(tStable-tStart)*length(aux)/numel(find(aux>0));
% 踝 正为屈曲
aux = (IWHip+(jointMoment.Foot_Left_proximal.x(pKIS2+1:pStableKI+1)-jointMoment.Foot_Left_proximal.x(pKIS2:pStableKI)))./2;
p_listV.IWAnkleFlexion = sum(aux)./fsInter;
p_listV.IWAnkleFlexionPower = p_listV.IWAnkleFlexion/(tStable-tStart)*length(aux)/numel(find(aux>0));
aux = (IWHip-(jointMoment.Foot_Left_proximal.x(pKIS2+1:pStableKI+1)-jointMoment.Foot_Left_proximal.x(pKIS2:pStableKI)))./2;
p_listV.IWAnkleExtension = sum(aux)./fsInter;
p_listV.IWAnkleExtensionPower = p_listV.IWAnkleExtension/(tStable-tStart)*length(aux)/numel(find(aux>0));
