% 信号分段，并标注每段的状态 
function [posSTS,dataStatus] = FindSTSPos(grfHip,grfHip_F,grfPlantar,grfPlantar_F,valueSeatoffHip,showFig)
    if nargin<6, showFig = false; end
    %% 说明 
    % 各个特征点说明
    %     站起
    %     seat-on：足底压力减小、臀底切向力增大。
    %     seat-off：臀底压力变为0/小于阈值。
    %     seat-end：足底压力稳定。
    %     坐下
    %     stand-on：足底压力减小。
    %     stand-off：臀底压力大于阈值。
    %     stand-end：足底压力稳定。
    %
    % dataStatus为信号每个离散点所属的STS状态
    %     0：无状态
    %     1：静坐
    %     2：站起1，seat-on到seat-off
    %     3：站起2，seat-off到seat-end
    %     4：静站
    %     5：坐下1，stand-on到stand-off
    %     6：坐下2，stand-off到stand-end
    %% 查看
%     figure;
%     hold on;
%     plot(grfHip.y);
%     plot(grfPlantar.y);
%     plot(grfHip.z);
%     plot(grfHip_F.z);
%     plot(grfPlantar.z,'LineWidth',2);
%     plot(grfPlantar_F.z);
%     legend('臀底 y','足底 y','臀底 测力台','臀底 阵列','足底 测力台','足底 阵列'); hold off;
    %% 寻找seat-on点
    % 足底压力减小、臀底切向力增大
    posSeatOn = [];
    for i = 1+10:length(grfHip.y)-20
        if min(grfHip.y(i-5:i))>2 && max(grfHip.y(i-5:i))<20 && min(grfHip.y(i+1:i+10)-grfHip.y(i:i+9))>0 && ...
                range(grfHip.y(i-5:i))<3 && range(grfHip.y(i-4:i+1))>=3 && grfHip.y(i+20)>20
            posSeatOn = [posSeatOn,i-3];
        end
    end
    posSeatOn = DeleteFormer(posSeatOn,100);

    posSeatOn_F = [];
    for i = 1+30:length(grfPlantar_F.z)-50
%         if max(grfPlantar_F.z(i))<200 && grfPlantar_F.z(i+50)>200 && range(grfPlantar_F.z(i-30:i))<8 && ...
%                 max(abs(grfPlantar_F.z(i-9:i)-grfPlantar_F.z(i-10:i-1)))<1
        if max(grfPlantar_F.z(i))<200 && grfPlantar_F.z(i+50)>200 && grfPlantar_F.z(i+49)<=200
            posSeatOn_F = [posSeatOn_F,i;];
        end
    end
    posSeatOn_F = DeleteFormer(posSeatOn_F,100);

%     figure; hold on;
%     plot(grfHip.y);
%     plot(grfPlantar_F.z);
%     plot(posSeatOn,grfHip.y(posSeatOn),'ro');
%     plot(posSeatOn_F,grfPlantar_F.z(posSeatOn_F),'bo');
%     hold off;
    %% 寻找seat-off点
    % 臀底压力变为0/小于阈值
    posSeatOff = []; posSeatOff_F = [];
    for i = 1+10:length(grfHip.z)
        if grfHip.z(i)<2 && min(grfHip.z(i-5:i-1))>2 && max(grfHip.z(i-10:i))>10
            posSeatOff = [posSeatOff,i];
        end
        if grfHip_F.z(i)<valueSeatoffHip && min(grfHip_F.z(i-5:i-1))>valueSeatoffHip && max(grfHip_F.z(i-10:i))>100
            posSeatOff_F = [posSeatOff_F,i];
        end
    end
    posSeatOff = DeleteFormer(posSeatOff,100);
    posSeatOff_F = DeleteFormer(posSeatOff_F,100);

%     figure; hold on;
%     plot(grfHip.z);
%     plot(grfHip_F.z);
%     plot(posSeatOff,grfHip.z(posSeatOff),'ro');
%     plot(posSeatOff_F,grfHip_F.z(posSeatOff_F),'b*');
%     legend('测力台','阵列');
    %% 寻找seat-end点
    % 足底压力稳定
    posSeatEnd = []; posSeatEnd_F = [];
    for i = 1+20:length(grfPlantar_F.z)-50
        if grfPlantar_F.z(i)>400 && grfPlantar_F.z(i)-grfPlantar_F.z(i-20)>30 && range(grfPlantar_F.z(i:i+5))<5 && grfPlantar_F.z(i)<min(grfPlantar.z(i+30:i+50))
            posSeatEnd_F = [posSeatEnd_F,i];
        end
    end
    posSeatEnd_F = DeleteLater(posSeatEnd_F,100);
    
    for i = 1+20:length(grfPlantar.z)-50
        if grfPlantar.z(i)>400 && range(grfPlantar.z(i:i+20))<20 && range(grfPlantar.z(i-20:i))>50
            posSeatEnd = [posSeatEnd,i];
        end
    end
    posSeatEnd = DeleteLater(posSeatEnd,100);

%     figure; hold on;
%     plot(grfPlantar.z);
%     plot(grfPlantar_F.z);
%     plot(posSeatEnd,grfPlantar.z(posSeatEnd),'ro');
%     plot(posSeatEnd_F,grfPlantar_F.z(posSeatEnd_F),'b*');
%     hold off;
    %% 寻找stand-on点
    % 足底压力减小
    posStandOn = []; posStandOn_F = [];
    for i = 1+50:length(grfPlantar.z)-20
        if grfPlantar.z(i)>400 && max(grfPlantar.z(i+1:i+5)-grfPlantar.z(i:i+4))<=0 && grfPlantar.z(i)-grfPlantar.z(i-1)>0 && ...
                range(grfPlantar.z(i-50:i))<40 && range(grfPlantar.z(i:i+20))>50
            posStandOn = [posStandOn,i];
        end
    end
    
    for i = 1+20:length(grfPlantar_F.z)-20
        if grfPlantar_F.z(i)>400 && max(grfPlantar_F.z(i+1:i+5)-grfPlantar_F.z(i:i+4))<=0 && grfPlantar_F.z(i)-grfPlantar_F.z(i-1)>0 && ...
                range(grfPlantar_F.z(i-20:i))<40 && grfPlantar_F.z(i)-min(grfPlantar_F.z(i:i+15))>30
            posStandOn_F = [posStandOn_F,i];
        end
    end
    posStandOn = DeleteLater(posStandOn,100);
    posStandOn_F = DeleteLater(posStandOn_F,100);

%     figure; hold on;
%     plot(grfPlantar.z);
%     plot(grfPlantar_F.z);
%     plot(posStandOn,grfPlantar.z(posStandOn),'ro');
%     plot(posStandOn_F,grfPlantar_F.z(posStandOn_F),'b*');
%     hold off;
    %% 寻找stand-off点
    % 臀底压力大于阈值
    posStandOff = []; posStandOff_F = [];
    for i = 1:length(grfHip.z)-10
        if grfHip.z(i)<2 && min(grfHip.z(i+1:i+5))>2 && max(grfHip.z(i:i+10))>10
            posStandOff = [posStandOff,i];
        end
    end
    for i = 1:length(grfHip_F.z)-10
        if grfHip_F.z(i)<2 && min(grfHip_F.z(i+1:i+5))>2 && max(grfHip_F.z(i:i+10))>10
            posStandOff_F = [posStandOff_F,i];
        end
    end
    posStandOff = DeleteLater(posStandOff,100);
    posStandOff_F = DeleteLater(posStandOff_F,100);

%     figure; hold on;
%     plot(grfHip.z);
%     plot(grfHip_F.z);
%     plot(posStandOff,grfHip.z(posStandOff),'ro');
%     plot(posStandOff_F,grfHip_F.z(posStandOff_F),'b*');
%     legend('测力台','阵列');
    %% 寻找stand-end点
    % 足底压力稳定
    posStandEnd = []; posStandEnd_F = [];
    for i = 1+50:length(grfPlantar_F.z)-30
        if grfPlantar_F.z(i)<200 && grfPlantar_F.z(i-50)>200 && range(grfPlantar_F.z(i:i+30))<10
            posStandEnd_F = [posStandEnd_F,i];
        end
    end
    posStandEnd_F = DeleteLater(posStandEnd_F,100);
    
    for i = 1+50:length(grfPlantar.z)-30
        if grfPlantar.z(i)<200 && grfPlantar.z(i-50)>200 && range(grfPlantar.z(i:i+30))<10
            posStandEnd = [posStandEnd,i];
        end
    end
    posStandEnd = DeleteLater(posStandEnd,100);

%     figure; hold on;
%     plot(grfPlantar.z); 
%     plot(grfPlantar_F.z);
%     plot(posStandEnd,grfPlantar.z(posStandEnd),'ro');
%     plot(posStandEnd_F,grfPlantar_F.z(posStandEnd_F),'b*');
%     hold off;
    %% 采用阵列得到的
    posSeatOn = posSeatOn_F; posSeatOff = posSeatOff_F; posSeatEnd = posSeatEnd_F;
    posStandOn = posStandOn_F; posStandOff = posStandOff_F; posStandEnd = posStandEnd_F;
    %% 分段
    dataStatus = zeros(size(grfPlantar_F.z));
    ptsPos = [posSeatOn,posSeatOff,posSeatEnd,posStandOn,posStandOff,posStandEnd];
    ptsPos = sort(ptsPos);
    ptsStatus = zeros(size(ptsPos));
    ptsStatus(ismember(ptsPos,posSeatOn)) = 1;
    ptsStatus(ismember(ptsPos,posSeatOff)) = 2;
    ptsStatus(ismember(ptsPos,posSeatEnd)) = 3;
    ptsStatus(ismember(ptsPos,posStandOn)) = 4;
    ptsStatus(ismember(ptsPos,posStandOff)) = 5;
    ptsStatus(ismember(ptsPos,posStandEnd)) = 6;

    for i = 1:length(ptsStatus)-1
        switch ptsStatus(i)
        case 6
            if ptsStatus(i+1) == 1 && max(grfPlantar_F.z(ptsPos(i):ptsPos(i+1)))<400
                dataStatus(ptsPos(i)+1:ptsPos(i+1)) = 1; % 静坐
            end
        case 1
            if ptsStatus(i+1) == 2 && ptsPos(i+1)-ptsPos(i)<200
                dataStatus(ptsPos(i)+1:ptsPos(i+1)) = 2; % 站起1
            end
        case 2
            if ptsStatus(i+1) == 3 && ptsPos(i+1)-ptsPos(i)<200
                dataStatus(ptsPos(i)+1:ptsPos(i+1)) = 3; % 站起2
            end
        case 3
            if ptsStatus(i+1) == 4 && min(grfPlantar_F.z(ptsPos(i):ptsPos(i+1)))>200
                dataStatus(ptsPos(i)+1:ptsPos(i+1)) = 4; % 静站
            end
        case 4
            if ptsStatus(i+1) == 5 && ptsPos(i+1)-ptsPos(i)<200
                dataStatus(ptsPos(i)+1:ptsPos(i+1)) = 5; % 坐下1
            end
        case 5
            if ptsStatus(i+1) == 6 && ptsPos(i+1)-ptsPos(i)<200
                dataStatus(ptsPos(i)+1:ptsPos(i+1)) = 6; % 坐下2
            end
        end
    end
    %% 多点匹配
    [posSeatOnM,posSeatOffM] = MatchPts(posSeatOn,posSeatOff);
    [posSeatOffM,posSeatEndM] = MatchPts(posSeatOffM,posSeatEnd);
    [posSeatOnM,posSeatOffM] = MatchPts(posSeatOnM,posSeatOffM);
    
    [posStandOnM,posStandOffM] = MatchPts(posStandOn,posStandOff);
    [posStandOffM,posStandEndM] = MatchPts(posStandOffM,posStandEnd);
    [posStandOnM,posStandOffM] = MatchPts(posStandOnM,posStandOffM);

    %% 作图
    if showFig
        figure; hold on;
        plot(posSeatOn,grfPlantar_F.z(posSeatOn),'r*');
        plot(posSeatOff,grfHip_F.z(posSeatOff),'g*');
        plot(posSeatEnd,grfPlantar_F.z(posSeatEnd),'b*');
        plot(posStandOn,grfPlantar_F.z(posStandOn),'ro');
        plot(posStandOff,grfHip_F.z(posStandOff),'go');
        plot(posStandEnd,grfPlantar_F.z(posStandEnd),'bo');
        plot(grfPlantar_F.z);
        plot(grfHip_F.z);
        ShowSTS(posSeatOnM,posSeatOffM,grfPlantar_F.z);
        ShowSTS(posSeatOffM,posSeatEndM,grfPlantar_F.z);
        ShowSTS(posStandOnM,posStandOffM,grfPlantar_F.z);
        ShowSTS(posStandOffM,posStandEndM,grfPlantar_F.z);
%         aux = find(dataStatus==1); plot(aux,grfPlantar_F.z(aux),'k*','MarkerSize',3);
        legend('seat-on','seat-off','seat-end','stand-on','stand-off','stand-end');
        hold off; title('STS标志点');
    end
    %% 保存结果
    posSTS.seatOn = posSeatOn;
    posSTS.seatOff = posSeatOff;
    posSTS.seatEnd = posSeatEnd;
    posSTS.standOn = posStandOn;
    posSTS.standOff = posStandOff;
    posSTS.standEnd = posStandEnd;
end

%% 匹配两种特征点
function [na, nb] = MatchPts(a, b)
    a = sort(a);
    b = sort(b);
    
    na = [0]; nb = [0];

    i = 1; j = 1;
    while i<=length(a) && j<=length(b)
        while a(i)<=nb(end) && i<length(a)
            i = i+1;
        end
        while a(i)>=b(j) && j<length(b)
            j = j+1;
        end
        if a(i)<b(j) && a(i)>nb(end)
            na = [na,a(i)]; nb = [nb,b(j)];
        end
        i = i+1; j = j+1;
    end
    
    na(1) = []; nb(1) = [];
end
%% 连续特征点删除前者
function pos = DeleteFormer(pos,distance)
    i = 2;
    while i <= length(pos)
        if pos(i)-pos(i-1)<distance
            pos(i) = [];
        else
            i = i+1;
        end
    end
end
%% 连续特征点删除后者
function pos = DeleteLater(pos,distance)
    i = 1;
    while i < length(pos)
        if pos(i+1)-pos(i)<distance
            pos(i) = [];
        else
            i = i+1;
        end
    end
end