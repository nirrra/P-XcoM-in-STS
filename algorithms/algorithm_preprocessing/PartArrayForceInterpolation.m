% 阵列信号插值到streamInter
pressurePlantar2DInter = zeros(length(streamInter.wtime),32,32);
pressureHip2DInter = zeros(length(streamInter.wtime),32,32);
framelen = 11; order = 5;
for i = 1:32
    for j = 1:32
        aux = pressurePlantar2D(:,i,j);
        aux = sgolayfilt(aux,order,framelen); aux = interp1(timeP,aux(pPS1:pPE1),streamInter.wtime,'spline');
        pressurePlantar2DInter(:,i,j) = aux;

        aux = pressureHip2D(:,i,j);
        aux = sgolayfilt(aux,order,framelen); aux = interp1(timeH,aux(pHS1:pHE1),streamInter.wtime,'spline');
        pressureHip2DInter(:,i,j) = aux;
    end
end
%% 足底
grfPlantar_F.z = sum(reshape(sum(pressurePlantar2DInter,2),size(pressurePlantar2DInter,1),32),2); 
grfPlantar_F.x = zeros(size(grfPlantar_F.z)); grfPlantar_F.y = zeros(size(grfPlantar_F.z));

[p_listPlantarInter,ptsPartsAnotomy] = CalPlantarPressures(pressurePlantar2DInter);
grfPlantarLeft_F.z = p_listPlantarInter.pPlantarLeft; grfPlantarLeft_F.x = zeros(size(grfPlantarLeft_F.z)); grfPlantarLeft_F.y = zeros(size(grfPlantarLeft_F.z));
grfPlantarRight_F.z = p_listPlantarInter.pPlantarRight; grfPlantarRight_F.x = zeros(size(grfPlantarRight_F.z)); grfPlantarRight_F.y = zeros(size(grfPlantarRight_F.z));

% pts的i向右，j向前，左下角为(1,1)
ptsPlantarLeft = []; ptsPlantarRight = [];
for i = 1:6
    ptsPlantarLeft = [ptsPlantarLeft;ptsPartsAnotomy{1,i}];
    ptsPlantarRight = [ptsPlantarRight;ptsPartsAnotomy{2,i}];
end
%% 站立稳定段
% 膝关节角稳定
data = streamInter.KNEE_LEFT.z+streamInter.KNEE_RIGHT.z;
idxStream = [];
for i = 1+10:length(data)-10
    if range(data(i-10:i+10))<0.005
        idxStream = [idxStream,i];
    end
end

% 足底压力稳定
data = grfPlantar_F.z;
idxPlantar = [];
for i = 1+10:length(data)-10
    if data(i)>400 && range(data(i-10:i+10))<40
        idxPlantar = [idxPlantar,i];
    end
end

% 站立稳定点
idxStandStable = intersect(idxStream,idxPlantar);

% figure; hold on;
% plot(streamInter.wtime,data);
% plot(streamInter.wtime(idxStandStable),data(idxStandStable),'*');
% hold off; title('站立稳定点')
%% 臀底
[mid,ischialLeft,ischialRight,idxSitStable,ptsHipLeft,ptsHipRight,grfHipLeft_F,grfHipRight_F] = ...
    GetHipMidAndPressureLR(pressureHip2DInter,streamInter,grfPlantar_F,height);
grfHip_F.z = grfHipLeft_F.z+grfHipRight_F.z;
grfHip_F.x = grfHipLeft_F.x+grfHipRight_F.x;
grfHip_F.y = grfHipLeft_F.y+grfHipRight_F.y;

load valuesSeatoffHip.mat valuesSeatoffHip;
valueSeatoffHip = median(valuesSeatoffHip); % seat-off时的臀底阵列压力阈值

%% 读取根据机器学习得到的三维GRF力
if flag3DGRF
    % 足部
    strModel = 'splitLR_50epochs';
    load(['results_plantar_',strModel],'cellGRFs')
    aux = cellGRFs{idxSub}{idxTest};
    grfPlantar_GNN = FilterXYZAndInter(aux.grfAll,timeP,1,length(aux.grfAll),streamInter);
    grfPlantarLeft_GNN = FilterXYZAndInter(aux.grfLeft,timeP,1,length(aux.grfAll),streamInter);
    grfPlantarRight_GNN = FilterXYZAndInter(aux.grfRight,timeP,1,length(aux.grfAll),streamInter);

    % 臀部
    load(['results_hip_',strModel],'cellGRFs')
    aux = cellGRFs{idxSub}{idxTest};
    grfHip_GNN = FilterXYZAndInter(aux.grfAll,timeH,1,length(aux.grfAll),streamInter);
    grfHipLeft_GNN = FilterXYZAndInter(aux.grfLeft,timeH,1,length(aux.grfAll),streamInter);
    grfHipRight_GNN = FilterXYZAndInter(aux.grfRight,timeH,1,length(aux.grfAll),streamInter);
%     grfHipRight_GNN = FilterXYZAndInter(aux.grfRight,timeH,pHS1,pHE1,streamInter);
end

