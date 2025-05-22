function [viconDelay] = GetViconDelay(times,pressurePlantar2D,dataVicon,unitScaling)
grfVicon = dataVicon.grf;
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
% vicon的grf
posZ = grfVicon.plantar_force_pz;
frameVicon = 1;
for i = 300+1:length(posZ)
    if range(posZ(i-300:i))<0.03 && posZ(i)>max(posZ)-0.02
        frameVicon = i;
    end
end

figure; hold on; 
plot(posZ);
plot(frameVicon,posZ(frameVicon),'r*');
hold off;

viconDelay = times.plantar(framePlantar)-grfVicon.time(frameVicon);