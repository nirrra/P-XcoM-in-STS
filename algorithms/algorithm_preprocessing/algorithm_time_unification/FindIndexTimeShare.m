%% datetimes转换为time，并获得共享的开始结束时间，校准Kinect时间
function [times,timeStart,timeEnd] = FindIndexTimeShare(datetimes,kinectDelay)
    flagTimeAverage = false; % 时间间隔是否要平均

    timeStart = []; timeEnd = [];
    if isfield(datetimes,'plantar')
        timeStart = [timeStart;datetimes.plantar(1)];
        timeEnd = [timeEnd;datetimes.plantar(end)];
    end
    if isfield(datetimes,'hip')
        timeStart = [timeStart;datetimes.hip(1)];
        timeEnd = [timeEnd;datetimes.hip(end)];
    end
    if isfield(datetimes,'kinect')
        % ============kinect系统时间有问题，时间序列第1到2点存在突变============
%         aux = Datetime2Time(datetimes.kinect);
%         kinect12Delay = aux(2)-aux(1)-mean(aux(2:end)-aux(1:end-1));
%         datetimes.kinect(2:end) = datetimes.kinect(2:end)-seconds(kinect12Delay);
        datetimes.kinect = datetimes.kinect+seconds(kinectDelay); % 校准Kinect时间
        timeStart = [timeStart;datetimes.kinect(1)];
        timeEnd = [timeEnd;datetimes.kinect(end)];
    end
    timeStart = max(timeStart); timeEnd = min(timeEnd);

    if isfield(datetimes,'plantar')
        aux = Datetime2Time([timeStart;datetimes.plantar]);
        aux = aux(2:end);
        if flagTimeAverage
            aux = linspace(aux(1),aux(end),length(aux))';
        end
        times.plantar = aux;
    end
    if isfield(datetimes,'hip')
        aux = Datetime2Time([timeStart;datetimes.hip]);
        aux = aux(2:end);
        if flagTimeAverage
            aux = linspace(aux(1),aux(end),length(aux))';
        end
        times.hip = aux;
    end    
    if isfield(datetimes,'kinect')
        aux = Datetime2Time([timeStart;datetimes.kinect]);
        aux = aux(2:end);
        if flagTimeAverage
            aux = linspace(aux(1),aux(end),length(aux))';
        end
        times.kinect = aux;
    end
    aux = Datetime2Time([timeStart;timeEnd]);
    timeStart = aux(1); timeEnd = aux(2);

end