function [paras] = CalJointParas(seg,showFig)
    if nargin<2, showFig = false; end
    time = seg.time;
    %% 髋关节
    % X
    data = seg.l_hip_force_x;
    [pks,locs] = findpeaks(data);
    [pks2,locs2] = findpeaks(-data); pks2 = -pks2;
    maxD = 0;
    posHipLeftXMax1 = 1; posHipLeftXMin2 = 1;
    for i = 1:length(locs)
        for j = 1:length(locs2)
            if locs(i)<locs2(j) && pks(i)-pks2(j)>maxD
                maxD = pks(i)-pks2(j);
                posHipLeftXMax1 = locs(i);
                posHipLeftXMin2 = locs2(j);
            end
        end
    end
    paras.posHipLeftXMax1 = posHipLeftXMax1;
    paras.posHipLeftXMin2 = posHipLeftXMin2;
    %% Y
    data = seg.l_hip_force_y;
    [~,posHipLeftYMax1] = max(data);
    paras.posHipLeftYMax1 = posHipLeftYMax1;
    %% Z
    data = seg.l_hip_force_z;
    [~,posHipLeftZMin1] = min(data);
    paras.posHipLeftZMin1 = posHipLeftZMin1;
    %% 膝关节
    % X
    data = seg.l_knee_force_x;[pks,locs] = findpeaks(data);
    [pks2,locs2] = findpeaks(-data); pks2 = -pks2;
    maxD = 0;
    posKneeLeftXMax1 = 1; posKneeLeftXMin2 = 1;
    for i = 1:length(locs)
        for j = 1:length(locs2)
            if locs(i)<locs2(j) && pks(i)-pks2(j)>maxD
                maxD = pks(i)-pks2(j);
                posKneeLeftXMax1 = locs(i);
                posKneeLeftXMin2 = locs2(j);
            end
        end
    end
    paras.posKneeLeftXMax1 = posKneeLeftXMax1;
    paras.posKneeLeftXMin2 = posKneeLeftXMin2;
    %% Y
    data = seg.l_knee_force_y;
    [~,posKneeLeftYMax1] = max(data);
    paras.posKneeLeftYMax1 = posKneeLeftYMax1;
    %% Z
    data = seg.l_knee_force_z;
    [~,posKneeLeftZMin1] = min(data);
    paras.posKneeLeftZMin1 = posKneeLeftZMin1;
    %% 踝关节
    % X
    data = seg.l_ankle_force_x;
    %% Y
    data = seg.l_ankle_force_y;
    [~,posAnkleLeftYMin1] = min(data);
    paras.posAnkleLeftYMin1 = posAnkleLeftYMin1;
    %% Z
    data = seg.l_ankle_force_z;
    [pks,locs] = findpeaks(data);
    [pks2,locs2] = findpeaks(-data); pks2 = -pks2;
    maxD = 0;
    posAnkleLeftZMax1 = 1; posAnkleLeftZMin2 = 1; posAnkleLeftZMax3 = 1;
    for i = 1:length(locs)
        for j = 1:length(locs2)
            if locs(i)>locs2(j) && pks(i)-pks2(j)>maxD
                maxD = pks(i)-pks2(j);
                posAnkleLeftZMax3 = locs(i);
                posAnkleLeftZMin2 = locs2(j);
            end
        end
    end
    maxD = 0;
    for i = 1:length(locs)
        if locs(i)<posAnkleLeftZMin2 && pks(i)-data(posAnkleLeftZMin2)>maxD
            maxD = pks(i)-data(posAnkleLeftZMin2);
            posAnkleLeftZMax1 = locs(i);
        end
    end
    paras.posAnkleLeftZMax1 = posAnkleLeftZMax1;
    paras.posAnkleLeftZMin2 = posAnkleLeftZMin2;
    paras.posAnkleLeftZMax3 = posAnkleLeftZMax3;

    %% ======================= 右 ======================
    %% 髋关节
    % X
    data = -seg.r_hip_force_x;
    [pks,locs] = findpeaks(data);
    [pks2,locs2] = findpeaks(-data); pks2 = -pks2;
    maxD = 0;
    posHipRightXMax1 = 1; posHipRightXMin2 = 1;
    for i = 1:length(locs)
        for j = 1:length(locs2)
            if locs(i)<locs2(j) && pks(i)-pks2(j)>maxD
                maxD = pks(i)-pks2(j);
                posHipRightXMax1 = locs(i);
                posHipRightXMin2 = locs2(j);
            end
        end
    end
    paras.posHipRightXMax1 = posHipRightXMax1;
    paras.posHipRightXMin2 = posHipRightXMin2;
    %% Y
    data = seg.r_hip_force_y;
    [~,posHipRightYMax1] = max(data);
    paras.posHipRightYMax1 = posHipRightYMax1;
    %% Z
    data = seg.r_hip_force_z;
    [~,posHipRightZMin1] = min(data);
    paras.posHipRightZMin1 = posHipRightZMin1;
    %% 膝关节
    % X
    data = -seg.r_knee_force_x;
    [pks,locs] = findpeaks(data);
    [pks2,locs2] = findpeaks(-data); pks2 = -pks2;
    maxD = 0;
    posKneeRightXMax1 = 1; posKneeRightXMin2 = 1;
    for i = 1:length(locs)
        for j = 1:length(locs2)
            if locs(i)<locs2(j) && pks(i)-pks2(j)>maxD
                maxD = pks(i)-pks2(j);
                posKneeRightXMax1 = locs(i);
                posKneeRightXMin2 = locs2(j);
            end
        end
    end
    paras.posKneeRightXMax1 = posKneeRightXMax1;
    paras.posKneeRightXMin2 = posKneeRightXMin2;
    %% Y
    data = seg.r_knee_force_y;
    [~,posKneeRightYMax1] = max(data);
    paras.posKneeRightYMax1 = posKneeRightYMax1;
    %% Z
    data = seg.r_knee_force_z;
    [~,posKneeRightZMin1] = min(data);
    paras.posKneeRightZMin1 = posKneeRightZMin1;
    %% 踝关节
    % X
    data = -seg.r_ankle_force_x;
    %% Y
    data = seg.r_ankle_force_y;
    [~,posAnkleRightYMin1] = min(data);
    paras.posAnkleRightYMin1 = posAnkleRightYMin1;
    %% Z
    data = seg.r_ankle_force_z;
    [pks,locs] = findpeaks(data);
    [pks2,locs2] = findpeaks(-data); pks2 = -pks2;
    maxD = 0;
    posAnkleRightZMax1 = 1; posAnkleRightZMin2 = 1; posAnkleRightZMax3 = 1;
    for i = 1:length(locs)
        for j = 1:length(locs2)
            if locs(i)>locs2(j) && pks(i)-pks2(j)>maxD
                maxD = pks(i)-pks2(j);
                posAnkleRightZMax3 = locs(i);
                posAnkleRightZMin2 = locs2(j);
            end
        end
    end
    maxD = 0;
    for i = 1:length(locs)
        if locs(i)<posAnkleRightZMin2 && pks(i)-data(posAnkleRightZMin2)>maxD
            maxD = pks(i)-data(posAnkleRightZMin2);
            posAnkleRightZMax1 = locs(i);
        end
    end
    paras.posAnkleRightZMax1 = posAnkleRightZMax1;
    paras.posAnkleRightZMin2 = posAnkleRightZMin2;
    paras.posAnkleRightZMax3 = posAnkleRightZMax3;

    %% 写入paras
    % 转换到0-1的时间坐标系
    names = fieldnames(paras);
    for i = 1:length(names)
        if ~isnan(paras.(names{i}))
            paras.(names{i}) = (time(paras.(names{i}))-time(1))./range(time); 
        end 
    end
    %% 作图
    if showFig
        figure;
        subplot(3,3,1); hold on;
        plot(time,seg.l_hip_force_x);
        plot(time,seg.r_hip_force_x);
        plot(time(posHipLeftXMax1),seg.l_hip_force_x(posHipLeftXMax1),'ro');
        plot(time(posHipLeftXMin2),seg.l_hip_force_x(posHipLeftXMin2),'g*');
        plot(time(posHipRightXMax1),seg.r_hip_force_x(posHipRightXMax1),'ro');
        plot(time(posHipRightXMin2),seg.r_hip_force_x(posHipRightXMin2),'g*');
        hold off;
        subplot(3,3,2); hold on;
        plot(time,seg.l_hip_force_y);
        plot(time,seg.r_hip_force_y);
        plot(time(posHipLeftYMax1),seg.l_hip_force_y(posHipLeftYMax1),'ro');
        plot(time(posHipRightYMax1),seg.r_hip_force_y(posHipRightYMax1),'ro');
        hold off; title('髋关节');
        subplot(3,3,3); hold on;
        plot(time,seg.l_hip_force_z);
        plot(time,seg.r_hip_force_z);
        plot(time(posHipLeftZMin1),seg.l_hip_force_z(posHipLeftZMin1),'g*');
        plot(time(posHipRightZMin1),seg.r_hip_force_z(posHipRightZMin1),'g*');
        hold off;
        subplot(3,3,4); hold on;
        plot(time,seg.l_knee_force_x);
        plot(time,seg.r_knee_force_x);
        plot(time(posKneeLeftXMax1),seg.l_knee_force_x(posKneeLeftXMax1),'ro');
        plot(time(posKneeLeftXMin2),seg.l_knee_force_x(posKneeLeftXMin2),'g*');
        plot(time(posKneeRightXMax1),seg.r_knee_force_x(posKneeRightXMax1),'ro');
        plot(time(posKneeRightXMin2),seg.r_knee_force_x(posKneeRightXMin2),'g*');
        hold off;
        subplot(3,3,5); hold on;
        plot(time,seg.l_knee_force_y);
        plot(time,seg.r_knee_force_y);
        plot(time(posKneeLeftYMax1),seg.l_knee_force_y(posKneeLeftYMax1),'ro');
        plot(time(posKneeRightYMax1),seg.r_knee_force_y(posKneeRightYMax1),'ro');
        hold off; title('膝关节');
        subplot(3,3,6); hold on;
        plot(time,seg.l_knee_force_z);
        plot(time,seg.r_knee_force_z);
        plot(time(posKneeLeftZMin1),seg.l_knee_force_z(posKneeLeftZMin1),'g*');
        plot(time(posKneeRightZMin1),seg.r_knee_force_z(posKneeRightZMin1),'g*');
        hold off;
        subplot(3,3,7); hold on;
        plot(time,seg.l_ankle_force_x);
        plot(time,seg.r_ankle_force_x);
        hold off;
        subplot(3,3,8); hold on;
        plot(time,seg.l_ankle_force_y);
        plot(time,seg.r_ankle_force_y);
        plot(time(posAnkleLeftYMin1),seg.l_ankle_force_y(posAnkleLeftYMin1),'ro');
        plot(time(posAnkleRightYMin1),seg.r_ankle_force_y(posAnkleRightYMin1),'ro');
        hold off; title('踝关节');
        subplot(3,3,9); hold on;
        plot(time,seg.l_ankle_force_z);
        plot(time,seg.r_ankle_force_z);
        plot(time(posAnkleLeftZMax1),seg.l_ankle_force_z(posAnkleLeftZMax1),'ro');
        plot(time(posAnkleLeftZMin2),seg.l_ankle_force_z(posAnkleLeftZMin2),'g*');
        plot(time(posAnkleLeftZMax3),seg.l_ankle_force_z(posAnkleLeftZMax3),'ro');
        plot(time(posAnkleRightZMax1),seg.r_ankle_force_z(posAnkleRightZMax1),'ro');
        plot(time(posAnkleRightZMin2),seg.r_ankle_force_z(posAnkleRightZMin2),'g*');
        plot(time(posAnkleRightZMax3),seg.r_ankle_force_z(posAnkleRightZMax3),'ro');
        hold off;
    end
end