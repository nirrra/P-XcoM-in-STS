function [kinectDelay] = GetKinectDelay(times,pressurePlantar2D,masterAll,subAll,idxSub,idxTest,unitScaling)
stream = SelectSubjectLongest(masterAll);
% 对齐抬脚后悬空的最后一刻
% 足底点
p_listPlantar = CalPlantarPressures(pressurePlantar2D); % 计算足底各部分压力
th1 = 30*unitScaling;
aux = union(find(p_listPlantar.pPlantarLeft<th1),find(p_listPlantar.pPlantarRight<th1));
for i = length(aux):-1:1
    framePlantar = aux(i);
    if framePlantar<size(pressurePlantar2D,1)-300 && ...
            (max(p_listPlantar.pPlantarLeft(framePlantar-5:framePlantar))<th1 || ...
            max(p_listPlantar.pPlantarRight(framePlantar-5:framePlantar))<th1)
        break;
    end
end
% f = figure; f.WindowState='maximized';  hold on;
% plot(p_listPlantar.pPlantarLeft);
% plot(p_listPlantar.pPlantarRight); 
% plot([framePlantar,framePlantar],[p_listPlantar.pPlantarLeft(framePlantar),p_listPlantar.pPlantarRight(framePlantar)],'r*'); 
% hold off; legend('Left','Right');
% img = reshape(pressurePlantar2D(framePlantar,:),32,32);
% figure; imshow(mat2gray(img),'InitialMagnification','fit'); colormap jet; title([num2str(framePlantar),'帧']);

% kinect点
% 根据视频选取时间
timeKinects = {[5.266,5.233,3.934,5.267,3.300,4.500,4.067,3.633,3.801,2.666],...
    [2.667,3.566,10.867,3.869,2.666,12.067,4.267,3.669,3.466,3.900],...
    [6.634,4.000,12.766,6.933,11.399,6.567,3.367,4.333,4.366,5.533,6.167]};

% 时间减去kinect最小时间
aux = [];
for i = 1:length(masterAll)
    aux = [aux,masterAll{i}.ktime(1)];
end
for i = 1:length(subAll)
    aux = [aux,subAll{i}.ktime(1)];
end
ktimeStart = min(aux); % kinect数据开始记录时间，kinect时间
[~,frameKinect] = min(abs(ktimeStart+timeKinects{idxSub}(idxTest)*1e6-stream.ktime));

% figure; hold on; 
% plot(stream.ANKLE_LEFT.y); plot(stream.KNEE_LEFT.y); plot(stream.FOOT_LEFT.y); 
% plot(stream.ANKLE_RIGHT.y); plot(stream.KNEE_RIGHT.y); plot(stream.FOOT_RIGHT.y); 
% legend('AL','KL','FL','AR','KR','FR');
% hold off;

% 计算kinectDelay
kinectDelay = times.plantar(framePlantar)-times.kinect(frameKinect);