%% 根据足底压力和（电平转换为压力的），寻找匹配的站起点和坐下点
function [standStartIdx,sitStartIdx] = FindSTSIdxs(p_listPlantar, unitScaling)
pressurePlantar = sum(p_listPlantar.pPlantarAnatomy,2);
pressureHeel = sum(p_listPlantar.pPlantarAnatomy(:,[6,12]),2);
pressurePlantarSmooth = smooth(pressurePlantar);
pressureD = pressurePlantar(2:end)-pressurePlantar(1:end-1);
pressureDS = pressurePlantarSmooth(2:end)-pressurePlantarSmooth(1:end-1);
dataLength = length(pressurePlantar);
%% 站起开始点
peaksStandIdx = [];
th1 = 5000*unitScaling; % 峰值阈值
th2 = 3000*unitScaling; % 上升阈值
th3 = 100*unitScaling; % 峰值稳定范围阈值
th4 = 30; % 斜率突变前后比值
th5 = 200*unitScaling; % 斜率突变阈值
th6 = 50*unitScaling; % 右边缘稳定范围
i = 11;
flagFindPeak = false;
while i <= dataLength-5
    if max(pressurePlantar(i-10:i))<th1
        flagFindPeak = true;
    end
    if flagFindPeak && pressurePlantar(i) == max(pressurePlantar(i-2:i+2)) && pressurePlantar(i)-min(pressurePlantar(i-5:i))>th2 && pressurePlantar(i)>th1
        % 查找峰值左侧是否有接近点
        for j = 3:-1:1
            if abs(pressurePlantar(i)-pressurePlantar(i-j)) < th3
                i = i-j;
                break;
            end
        end
        peaksStandIdx = [peaksStandIdx,i];
        flagFindPeak = false;
        i = i+3;
    end
    i = i+1;
end
standStartIdx = [];
for i = 1:length(peaksStandIdx)
    loc = peaksStandIdx(i)-10; % 峰值距站起开始点最小距离
    while loc>3
        % 最大点或斜率突变点（斜率突变大于阈值且斜率突变比例最大），左侧无斜率突变
        if  pressurePlantarSmooth(loc)==max(pressurePlantarSmooth(loc:loc+2)) ... % 大于右侧
                && (pressurePlantarSmooth(loc)==max(pressurePlantarSmooth(loc-2:loc)) ... % 最大点
                || (pressureDS(loc)/pressureDS(loc-1)>th4) && (pressureDS(loc)/pressureDS(loc-1)>pressureDS(loc-1)/pressureDS(loc-2))) ... % 斜率突变点（斜率突变大于阈值且斜率突变比例最大）
                && max(abs(pressureDS(loc-6:loc-1)))<th5 % 左侧5个点无斜率突变
            break;
        end
        loc = loc-1;
    end
    % 调整为峰值点
    for j = -1:1
        if pressurePlantar(loc+j) == max(pressurePlantar(loc-1:loc+1))
            loc = loc+j;
            break;
        end
    end
    % 移动至右边缘
    while loc+5<=dataLength && min(abs(pressurePlantar(loc+1:loc+2)-pressurePlantar(loc)))<th6
        for j = 2:-1:1
            if abs(pressurePlantar(loc+j)-pressurePlantar(loc))<th6
                loc = loc+j;
                break;
            end
        end
    end
    if loc>3
        standStartIdx = [standStartIdx,loc];
    end
end

if false
    figure; hold on;
    plot(pressurePlantar); 
    plot(standStartIdx,pressurePlantar(standStartIdx),'o');
    title('站起开始点');
end
%% 坐下开始点
peaksSitIdx = [];
th1 = 5000*unitScaling; % 峰值阈值
th2 = 3000*unitScaling; % 上升阈值
th3 = 100*unitScaling; % 峰值稳定范围阈值
th4 = 3000; % 斜率突变前后比值
th5 = 200*unitScaling; % 斜率突变阈值
th6 = 100*unitScaling; % 右边缘稳定范围
i = dataLength-10;
flagFindPeak = false;
while i > 5
    if max(pressurePlantar(i:i+10))<th1
        flagFindPeak = true;
    end
    if flagFindPeak && pressurePlantar(i) == max(pressurePlantar(i-2:i+2)) && pressurePlantar(i)-min(pressurePlantar(i:i+5))>th2 && pressurePlantar(i)>th1
        % 查找峰值右侧是否有接近点
        for j = 3:-1:1
            if abs(pressurePlantar(i)-pressurePlantar(i+j)) < th3
                i = i+j;
                break;
            end
        end
        peaksSitIdx = [peaksSitIdx,i];
        flagFindPeak = false;
    end
    i = i-1;
end
sitStartIdx = [];
for i = 1:length(peaksSitIdx)
    loc = peaksSitIdx(i)-10; % 峰值距坐下开始点最小距离
    while loc>3
        % 最大点或斜率突变点（斜率突变大于阈值且斜率突变比例最大），左侧无斜率突变
        if  pressurePlantarSmooth(loc)==max(pressurePlantarSmooth(loc:loc+2)) ... % 大于右侧
                && (pressurePlantarSmooth(loc)==max(pressurePlantarSmooth(loc-2:loc)) ... % 最大点
                || (pressureDS(loc)/pressureDS(loc-1)>th4) && (pressureDS(loc)/pressureDS(loc-1)>pressureDS(loc-1)/pressureDS(loc-2))) ... % 斜率突变点（斜率突变大于阈值且斜率突变比例最大）
                && max(abs(pressureDS(loc-6:loc-1)))<th5 % 左侧5个点无斜率突变
            break;
        end
        loc = loc-1;
    end
    % 调整为峰值点
    for j = -1:1
        if pressurePlantar(loc+j) == max(pressurePlantar(loc-1:loc+1))
            loc = loc+j;
            break;
        end
    end
    % 移动至右边缘
    while loc+5<=dataLength && min(abs(pressurePlantar(loc+1:loc+5)-pressurePlantar(loc)))<th6
        for j = 5:-1:1
            if abs(pressurePlantar(loc+j)-pressurePlantar(loc))<th6
                loc = loc+j;
                break;
            end
        end
    end
    if loc>3
        sitStartIdx = [sitStartIdx,loc];
    end
end

if false
    figure; hold on;
    plot(pressureHeel); 
    plot(sitStartIdx,pressureHeel(sitStartIdx),'o');
    title('坐下开始点');
end
%% 站起坐下点匹配
idxCombine = sort([standStartIdx,sitStartIdx]);
idxType = zeros(size(idxCombine));
idxType(ismember(idxCombine,standStartIdx)) = 1;

% 先站起后坐下，站起点取最后，坐下点取最前
newStandStartIdx = []; newSitStartIdx = [];
state = 1;
i = 1;
while i <= length(idxType)
    % 站起
    if state == 1
        while i<=length(idxType) && idxType(i) ~= 1
            i=i+1;
        end
        while i<length(idxType) && idxType(i+1) == 1
            i=i+1;
        end
        if i<length(idxType)
            newStandStartIdx = [newStandStartIdx,idxCombine(i)];
        end
    else
        while i<=length(idxType) && idxType(i) ~= 0
            i=i+1;
        end
        if i<=length(idxType)
            newSitStartIdx = [newSitStartIdx,idxCombine(i)];
        end
    end
    state = 1-state;
end
% 站起不能为最后一个点
if length(newStandStartIdx)>length(newSitStartIdx)
    newStandStartIdx = newStandStartIdx(1:end-1);
end
if true
    f = figure; f.WindowState='maximized'; hold on;
    plot(pressurePlantar);
%     plot(pressurePlantarSmooth);
    plot(pressureHeel);
    plot(newStandStartIdx,pressurePlantar(newStandStartIdx),'ro');
    plot(newSitStartIdx,pressurePlantar(newSitStartIdx),'go');
    plot(newStandStartIdx,pressureHeel(newStandStartIdx),'ro');
    plot(newSitStartIdx,pressureHeel(newSitStartIdx),'go');
    plot([peaksStandIdx,peaksSitIdx],pressurePlantar([peaksStandIdx,peaksSitIdx]),'bo');
    plot([standStartIdx,sitStartIdx],pressurePlantar([standStartIdx,sitStartIdx]),'k*');
    title('STS分段：站起坐下点匹配');
end
standStartIdx = newStandStartIdx;
sitStartIdx = newSitStartIdx;

str1 = ''; str2 = '';
for i = 1:7
    if i<=length(standStartIdx)
        str1 = [str1,num2str(standStartIdx(i)),' '];
        str2 = [str2,num2str(sitStartIdx(i)),' '];
    else
        str1 = [str1,'0 '];
        str2 = [str2,'0 '];
    end
end
str1 = [str1(1:end-1), '; ...'];
str2 = [str2(1:end-1), '; ...'];
disp(str1); disp(str2);
end