%% 统一时间
% kinect和阵列时间统一
kinectDelay = GetKinectDelay(times,pressurePlantar2D,masterAll,subAll,idxSub,idxTest,unitScaling);
[times,~,~] = FindIndexTimeShare(datetimes,kinectDelay);
% vicon和阵列时间统一
viconDelay = GetViconDelay(times,pressurePlantar2D,dataVicon,unitScaling);
times.vicon = dataVicon.ik.time+viconDelay;
times.grf = dataVicon.grf.time+viconDelay;
% vicon和kinect时间统一
stream.wtime = times.kinect;
[timeLead,idxLead,maxICC] = GetViconLeadTime(times,stream,dataVicon);
% times.vicon = times.vicon+timeLead; times.grf = times.grf+timeLead; % vicon向kinect对齐（当kinect和阵列更接近时）
times.kinect = times.kinect-timeLead; % kinect向vicon对齐
% 统一所有时间
timeStart = []; timeEnd = [];
names = fieldnames(times);
for i = 1:length(names)
    timeStart(i) = times.(names{i})(1);
    timeEnd(i) = times.(names{i})(end);
end
timeStart = max(timeStart); timeEnd = min(timeEnd)-timeStart;
for i = 1:length(names)
    times.(names{i}) = times.(names{i})-timeStart;
end
timeStart = 0;

%% 根据统一时间截取Kinect信号
aux = GetIdxTime(times.kinect,[timeStart,timeEnd]); pKS1 = aux(1); pKE1 = aux(2); timeK = times.kinect(pKS1:pKE1);
aux = GetIdxTime(times.vicon,[timeStart,timeEnd]); pVS1 = aux(1); pVE1 = aux(2); timeV = times.vicon(pVS1:pVE1);
aux = GetIdxTime(times.grf,[timeStart,timeEnd]); pGS1 = aux(1); pGE1 = aux(2); timeG = times.grf(pGS1:pGE1);
aux = GetIdxTime(times.plantar,[timeStart,timeEnd]); pPS1 = aux(1); pPE1 = aux(2); timeP = times.plantar(pPS1:pPE1);
aux = GetIdxTime(times.hip,[timeStart,timeEnd]); pHS1 = aux(1); pHE1 = aux(2); timeH = times.hip(pHS1:pHE1);

% 平均时间间隔，否则插值会检测到重复采样点
timeP = linspace(timeP(1),timeP(end),length(timeP))';
timeH = linspace(timeH(1),timeH(end),length(timeH))';

names = fieldnames(stream);
for i = 1:3
    stream.(names{i,1}) = stream.(names{i,1})(pKS1:pKE1);
end
for i = 4:length(names)
    stream.(names{i,1}).x = stream.(names{i,1}).x(pKS1:pKE1);
    stream.(names{i,1}).y = stream.(names{i,1}).y(pKS1:pKE1);
    stream.(names{i,1}).z = stream.(names{i,1}).z(pKS1:pKE1);
end
stream.wtime = timeK;