function [p_listV,p_listT,curves] = CalParameters(signals,basicInfos,ShowFig,SaveFig,CalPlantarRatio)
if nargin<5, CalPlantarRatio = false; end
if nargin<4, SaveFig = false; end
if nargin<3, ShowFig = false; end
%% 读取数据
fsInter = signals.fsInter;
times = signals.times;
streamInter = signals.streamInter;
jointMoment = signals.jointMoment;
pressurePlantar = signals.pressurePlantar;
pressurePlantar2D = signals.pressurePlantar2D;
pressureHip = signals.pressureHip;
copYPlantar = signals.copYPlantar;
% dataVicon = signals.dataVicon;

weightR = basicInfos.weightR;
heightR = basicInfos.heightR;
gender = basicInfos.gender;
idxSub = basicInfos.idxSub;
idxTest = basicInfos.idxTest;
idxSTS = basicInfos.idxSTS;

%% 运动学计算
jointAngles = CalJointAngles(streamInter);
names = fieldnames(jointAngles);
for i = 1:length(names)
    eval([names{i},' = jointAngles.',names{i},';']);
end
% 质心
[posCOMSegments,vCOMSegments,accCOMSegments] = Segments_Velocity_Acceleration(streamInter,gender,fsInter);
% PI, Postural Index
PI = (-(kneeAngleL+kneeAngleR)./2)./((ankleAngleL+ankleAngleR)./2+(hipFlexionL+hipFlexionR)./2+(-lumbarFlexion));


%% STS分段
[standStartIdx,sitStartIdx,idxAbsorb] = FindSTSIdxsManually(idxSub,idxTest);
tSTSStart = times.plantar(standStartIdx(idxSTS)); tSTSEnd = times.plantar(sitStartIdx(idxSTS));
% 根据关节角再调整tSTSEnd
aux = GetIdxTime(streamInter.wtime,[tSTSStart,tSTSEnd]); pKIS2 = aux(1); pKIE2 = aux(2);
data1 = hipFlexionL; data2 = kneeAngleL;
for i = min(pKIE2,length(data1)-5):-1:pKIE2-ceil(fsInter*0.5)
    if range(data1(i-5:i+5))<5 && range(data2(i-5:i+5))<5
        break;
    end
end
tSTSEnd = streamInter.wtime(i);
% 计算时间节点
aux = GetIdxTime(times.plantar,[tSTSStart,tSTSEnd]); pPS2 = aux(1); pPE2 = aux(2);
aux = GetIdxTime(times.hip,[tSTSStart,tSTSEnd]); pHS2 = aux(1); pHE2 = aux(2);
aux = GetIdxTime(streamInter.wtime,[tSTSStart,tSTSEnd]); pKIS2 = aux(1); pKIE2 = aux(2);
aux = GetIdxTime(times.vicon,[tSTSStart,tSTSEnd]); pVS2 = aux(1); pVE2 = aux(2);
aux = GetIdxTime(times.grf,[tSTSStart,tSTSEnd]); pGS2 = aux(1); pGE2 = aux(2);


%% 时间特征点
% 关键时间点：开始、髋关节矩的第一个谷、稳定点（根据髋膝关节角）
% COM：YZ最大斜率
% 足底：峰值、峰值前下降、峰值后下降、足跟占比
% 臀底：上升值
% 运动学：髋关节上升值（表明上半身的前屈）、膝关节下降值（上半身的前移）
% 动力学：髋关节最小值、髋关节最大值、最小前的上升

% 开始结束
tStart = tSTSStart; tEnd = tSTSEnd;
% 稳定，根据髋、膝关节角变化小于阈值
data1 = hipFlexionL; data2 = kneeAngleL;
for pStableKI = pKIS2+5:pKIE2-5
    if range(data1(pStableKI-5:pStableKI+5))<1 && range(data2(pStableKI-5:pStableKI+5))<1 && ...
            abs(data1(pStableKI)-data2(pStableKI))<40
        tStable = streamInter.wtime(pStableKI);
        break;
    end
end
pStableP = GetIdxTime(times.plantar,tStable);
pStableH = GetIdxTime(times.hip,tStable);
% figure; hold on; plot(data1); plot(data2); plot(pStableKI,data1(pStableKI),'ro'); xlim([pKIS2,pKIE2]); title('关节角');

% 髋力矩最小
data = (jointMoment.Thigh_Left_proximal.x+jointMoment.Thigh_Right_proximal.x)./2;
for pHipMomentMin = pKIS2+10:pKIE2-10
    if data(pHipMomentMin) == min(data(pHipMomentMin-10:pHipMomentMin+10)) && ...
            range(data(pHipMomentMin-20:pHipMomentMin+20))>20 && max(data(pKIS2:pHipMomentMin))-data(pHipMomentMin)>30
        tHipMomentMin = streamInter.wtime(pHipMomentMin);
        vHipMomentMin = data(pHipMomentMin);
        break;
    end 
end
% figure; plot(data); xlim([pKIS2,pKIE2]); title('髋力矩');

%% COM
PartComParameters;
%% 足底
PartPlantarParameters;
%% 臀底
PartHipParameters;
%% 关节角
PartJointAngleParameters;
%% 关节矩
PartJointMomentParameters;
%% PI
PartPIParameters;
%% 肌肉利用率MUR, Muscular Utilization Ratio
PartMURParameters;


%% 足底压力分布
if CalPlantarRatio
    p_listPlantar = CalPlantarPressures(pressurePlantar2D(pPS2:pPE2,:,:),true,...
        ['../imgs/imgsPlantar/',num2str(idxSub),num2str(idxTest,'%02d'),num2str(idxSTS)]);
    ratioPLR = (p_listPlantar.pPlantarLeft-p_listPlantar.pPlantarRight)./max(p_listPlantar.pPlantarLeft,p_listPlantar.pPlantarRight);
    ratioPM = sum(p_listPlantar.pPlantarAnatomy(:,[1:4,7:10]),2)./sum(p_listPlantar.pPlantarAnatomy,2);
    ratioPL = sum(p_listPlantar.pPlantarAnatomy(:,[5,11]),2)./sum(p_listPlantar.pPlantarAnatomy,2);
    ratioPC = sum(p_listPlantar.pPlantarAnatomy(:,[6,12]),2)./sum(p_listPlantar.pPlantarAnatomy,2);
    
    [vMaxRatioPC,pMaxRatioPC] = max(ratioPC(1:pStableP-pPS2+1)); 
    tMaxRatioPC = times.plantar(pMaxRatioPC-1+pPS2);
    [vMaxRatioPM1,pMaxRatioPM1] = max(ratioPM(1:pMaxRatioPC)); tMaxRatioPM1 = times.plantar(pMaxRatioPM1-1+pPS2);
    [vMaxRatioPM2,pMaxRatioPM2] = max(ratioPM(pMaxRatioPC:pStableP-pPS2+1)); tMaxRatioPM2 = times.plantar(pMaxRatioPM2-1+(pMaxRatioPC-1+pPS2));
    
    p_listV.vStdRatioLR = std(ratioPLR(1:pStableP-pPS2+1));
    p_listV.vMaxRatioPM1 = vMaxRatioPM1;
    p_listV.vMaxRatioPM2 = vMaxRatioPM2;
    p_listV.vMaxRatioPC = vMaxRatioPC;
end


%% 时间点
p_listT.tEnd = tEnd;
p_listT.tStable = tStable;
p_listT.tComZMin = tComZMin;
p_listT.tComZVelMax = tComZVelMax;
p_listT.tComYVelMax = tComYVelMax;
p_listT.tPeakP = tPeakP;
p_listT.tCounterP = tCounterP;
p_listT.tReboundP = tReboundP;

if CalPlantarRatio
    p_listT.tMaxRatioPC = tMaxRatioPC;
    p_listT.tMaxRatioPM1 = tMaxRatioPM1;
    p_listT.tMaxRatioPM2 = tMaxRatioPM2;
end

p_listT.tPeakH = tPeakH;
p_listT.tHipFlexionMax = tHipFlexionMax;
p_listT.tKneeAngleMin = tKneeAngleMin;
p_listT.tHipMomentMax1 = tHipMomentMax1;
p_listT.tHipMomentMin = tHipMomentMin;
p_listT.tHipMomentMax2 = tHipMomentMax2;
p_listT.tKneeMomentMax = tKneeMomentMax;
p_listT.tAnkleMomentMax1 = tAnkleMomentMax1;
p_listT.tAnkleMomentMin = tAnkleMomentMin;
p_listT.tAnkleMomentMax2 = tAnkleMomentMax2;

p_listT.tPIMin = tPIMin;
p_listT.tPIMax = tPIMax;

p_listT.tMURMin1 = tMURMin1;
p_listT.tMURMax = tMURMax;
p_listT.tMURMin2 = tMURMin2;

names = fieldnames(p_listT);
for i = 1:length(names)
    name = names{i};
    p_listT.(name) = p_listT.(name)-tStart;
    if p_listT.(name) < 0
        p_listT.(name) = 0;
    end
end

%% 保存曲线
aux = -(copYPlantar-mean(copYPlantar))./1000; curves.copYPlnatar = aux(pPS2:pStableP);
aux = posCOMSegments.human.y-mean(posCOMSegments.human.y); curves.comY = aux(pKIS2:pStableKI);
aux = posCOMSegments.human.z-mean(posCOMSegments.human.z); curves.comZ = aux(pKIS2:pStableKI);
aux = sum(pressurePlantar,2); curves.pressurePlantar = aux(pPS2:pStableP);
aux = sum(pressureHip,2); curves.pressureHip = aux(pHS2:pStableH);
aux = hipFlexionL; curves.hipFlexion = aux(pKIS2:pStableKI);
aux = kneeAngleL; curves.kneeAngle = aux(pKIS2:pStableKI);
aux = ankleAngleL; curves.ankleAngle = aux(pKIS2:pStableKI);
aux = jointMoment.Thigh_Left_proximal.x; curves.momentHip = aux(pKIS2:pStableKI);
aux = jointMoment.Shank_Right_proximal.x; curves.momentKnee = aux(pKIS2:pStableKI);
aux = -jointMoment.Shank_Left_distal.x; curves.momentAnkle = aux(pKIS2:pStableKI);
aux = PI; curves.PI = aux(pKIS2:pStableKI);
aux = MUR; curves.MUR = aux(pKIS2:pStableKI);


%% 作图
if ShowFig || SaveFig
    if ShowFig
        figure('Visible','on');
    else
        figure('Visible','off');
    end 
    subplot(7,1,1); hold on; 
    plot(times.plantar,-(copYPlantar-mean(copYPlantar))./1000);
    plot(streamInter.wtime,posCOMSegments.human.y-mean(posCOMSegments.human.y));
    plot(streamInter.wtime,posCOMSegments.human.z-mean(posCOMSegments.human.z));
%     plot(times.vicon,dataVicon.analysis.pos_center_of_mass_X-mean(dataVicon.analysis.pos_center_of_mass_X));
%     plot(times.vicon,dataVicon.analysis.pos_center_of_mass_Y-mean(dataVicon.analysis.pos_center_of_mass_Y));
    plot(tComYVelMax,posCOMSegments.human.y(pComYVelMax)-mean(posCOMSegments.human.y),'ro','MarkerSize',10);
    plot(tComZVelMax,posCOMSegments.human.z(pComZVelMax)-mean(posCOMSegments.human.z),'ro','MarkerSize',10);
    title('COP/COM'); legend('阵列copY','Kinect comY','Kinect comZ'); hold off; xlim([tSTSStart,tSTSEnd]);
    subplot(7,1,2); hold on;
    plot(times.plantar,sum(pressurePlantar,2));
    plot(times.hip,sum(pressureHip,2));
    plot(tPeakP,sum(pressurePlantar(pPeakP,:),2),'ro','MarkerSize',10);
    plot(tCounterP,sum(pressurePlantar(pCounterP,:),2),'ro','MarkerSize',10);
    plot(tReboundP,sum(pressurePlantar(pReboundP,:),2),'ro','MarkerSize',10);
    plot(tPeakH,sum(pressureHip(pPeakH,:),2),'ro','MarkerSize',10);
    title('压力'); legend('足底','臀底'); hold off; xlim([tSTSStart,tSTSEnd]);
    subplot(7,1,3); hold on;
    if CalPlantarRatio
        plot(times.plantar(pPS2:pPE2),ratioPLR);
        plot(times.plantar(pPS2:pPE2),ratioPM);
        plot(times.plantar(pPS2:pPE2),ratioPL);
        plot(times.plantar(pPS2:pPE2),ratioPC);
        plot(tMaxRatioPC,vMaxRatioPC,'ro','MarkerSize',10);
        plot(tMaxRatioPM1,vMaxRatioPM1,'ro','MarkerSize',10);
        plot(tMaxRatioPM2,vMaxRatioPM2,'ro','MarkerSize',10);
        legend('L/R','M','L','C'); 
    end
    title('足底分区压力占比'); hold off; xlim([tSTSStart,tSTSEnd]); 
    subplot(7,1,4); hold on; 
    plot(streamInter.wtime,hipFlexionL);
    plot(streamInter.wtime,kneeAngleL);
    plot(streamInter.wtime,ankleAngleL);
    plot(tStable,hipFlexionL(pStableKI),'ro','MarkerSize',10);
    plot(tHipFlexionMax,hipFlexionL(pHipFlexionMax),'ro','MarkerSize',10);
    plot(tKneeAngleMin,kneeAngleL(pKneeAngleMin),'ro','MarkerSize',10);
    title('关节角'); legend('髋','膝','踝'); hold off; xlim([tSTSStart,tSTSEnd]);
    subplot(7,1,5); hold on; 
    plot(streamInter.wtime,jointMoment.Thigh_Left_proximal.x);
    plot(streamInter.wtime,jointMoment.Shank_Right_proximal.x);
    plot(streamInter.wtime,-jointMoment.Shank_Left_distal.x);
    plot(tHipMomentMin,jointMoment.Thigh_Left_proximal.x(pHipMomentMin),'bo','MarkerSize',10);
    plot(tHipMomentMax1,jointMoment.Thigh_Left_proximal.x(pHipMomentMax1),'bo','MarkerSize',10);
    plot(tHipMomentMax2,jointMoment.Thigh_Left_proximal.x(pHipMomentMax2),'bo','MarkerSize',10);
    plot(tKneeMomentMax,jointMoment.Shank_Right_proximal.x(pKneeMomentMax),'ro','MarkerSize',10);
    plot(tAnkleMomentMax1,-jointMoment.Shank_Left_distal.x(pAnkleMomentMax1),'go','MarkerSize',10);
    plot(tAnkleMomentMax2,-jointMoment.Shank_Left_distal.x(pAnkleMomentMax2),'go','MarkerSize',10);
    plot(tAnkleMomentMin,-jointMoment.Shank_Left_distal.x(pAnkleMomentMin),'go','MarkerSize',10);
    title('关节矩'); legend('髋','膝','踝'); hold off; xlim([tSTSStart,tSTSEnd]);
    subplot(7,1,6); hold on;
    plot(streamInter.wtime,PI);
    plot(tPIMin,PI(pPIMin),'ro','MarkerSize',10);
    plot(tPIMax,PI(pPIMax),'ro','MarkerSize',10);
    title('PI'); hold off; xlim([tSTSStart,tSTSEnd]);
    subplot(7,1,7); hold on;
    plot(streamInter.wtime,MUR);
    plot(tMURMin1,MUR(pMURMin1),'ro','MarkerSize',10);
    plot(tMURMax,MUR(pMURMax),'ro','MarkerSize',10);
    plot(tMURMin2,MUR(pMURMin2),'ro','MarkerSize',10);
    title('MUR'); hold off; xlim([tSTSStart,tSTSEnd]);

    if SaveFig
        set(gcf,'Position',[100,100,1280,960]);
        print(['../imgs/imgsSTS/',num2str(idxSub),num2str(idxTest,'%02d'),num2str(idxSTS)],'-dpng','-r300');
    end

end