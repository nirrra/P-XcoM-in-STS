%% 提取SelectPosManually.m手动选取的站起点和坐下点
function [standStartIdx,sitStartIdx,idxAbsorb] = FindSTSIdxsManually(idxSub,idxTest,p_listPlantar)
savePNG = false; % 保存站起坐下点位置图
load stsStartIdxs stsStartIdxsCell idxAbsorb;
stsStartIdxs = stsStartIdxsCell{idxSub,1};
standStartIdx = stsStartIdxs(2*idxTest-1,:);
sitStartIdx = stsStartIdxs(2*idxTest,:);
standStartIdx = standStartIdx(standStartIdx>0);
sitStartIdx = sitStartIdx(sitStartIdx>0);

%% 作图
if nargin == 3
    if savePNG
        pressurePlantar = sum(p_listPlantar.pPlantarAnatomy,2);
        pressureHeel = sum(p_listPlantar.pPlantarAnatomy(:,[6,12]),2);
        pressurePlantarSmooth = smooth(pressurePlantar);
        pressureD = pressurePlantar(2:end)-pressurePlantar(1:end-1);
        pressureDS = pressurePlantarSmooth(2:end)-pressurePlantarSmooth(1:end-1);
        dataLength = length(pressurePlantar);

        f = figure('Visible','off');
        f.WindowState='maximized'; hold on;
        plot(pressurePlantar);
        plot(pressureHeel);
        plot(standStartIdx,pressurePlantar(standStartIdx),'ro');
        plot(sitStartIdx,pressurePlantar(sitStartIdx),'go');
        title('STS分段：手动选取站起坐下点');
        set(gcf,'Position',[100,100,1280,720]);
        print(['../imgs/STSPosCheck/',num2str(idxSub),num2str(idxTest,'%02d')],'-dpng','-r300');
    end
end

end