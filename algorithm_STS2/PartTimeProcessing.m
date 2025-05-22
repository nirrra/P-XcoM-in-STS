times = struct();
times.plantar = Datetime2Time(dataPlantar.datetimeF);
times.hip = Datetime2Time([dataPlantar.datetimeF(1);dataHip.datetimeF]); times.hip = times.hip(2:end);
times.kinect = stream.wtime;
times.grf = grf.time;
times.vicon = ik.time;

timeDelay1 = GetTimeDelayGRF2FSManually(times,idxFile);
timeDelay2 = GetTimeDelayKinect2ViconManually(times,idxFile);
times.grf = times.grf+timeDelay1;
times.vicon = times.vicon+timeDelay1;
times.kinect = times.kinect+timeDelay1+timeDelay2;

% 统一所有时间times
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

% 截取时间，time在timeStart和timeEnd间
aux = GetIdxTime(times.kinect,[timeStart,timeEnd]); pKS1 = aux(1); pKE1 = aux(2); timeK = times.kinect(pKS1:pKE1);
aux = GetIdxTime(times.vicon,[timeStart,timeEnd]); pVS1 = aux(1); pVE1 = aux(2); timeV = times.vicon(pVS1:pVE1);
aux = GetIdxTime(times.grf,[timeStart,timeEnd]); pGS1 = aux(1); pGE1 = aux(2); timeG = times.grf(pGS1:pGE1);
aux = GetIdxTime(times.plantar,[timeStart,timeEnd]); pPS1 = aux(1); pPE1 = aux(2); timeP = times.plantar(pPS1:pPE1);
aux = GetIdxTime(times.hip,[timeStart,timeEnd]); pHS1 = aux(1); pHE1 = aux(2); timeH = times.hip(pHS1:pHE1);

% 平均时间间隔，否则插值会检测到重复采样点
timeP = linspace(timeP(1),timeP(end),length(timeP))';
timeH = linspace(timeH(1),timeH(end),length(timeH))';

names = fieldnames(stream);
for i = 2:length(names)
    stream.(names{i,1}).x = stream.(names{i,1}).x(pKS1:pKE1);
    stream.(names{i,1}).y = stream.(names{i,1}).y(pKS1:pKE1);
    stream.(names{i,1}).z = stream.(names{i,1}).z(pKS1:pKE1);
end
stream.wtime = timeK;