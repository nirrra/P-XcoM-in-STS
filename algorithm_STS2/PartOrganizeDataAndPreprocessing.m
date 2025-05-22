%% Organize

data = cellData{idxFile};
disp([num2str(data.idxSub,'%03d'),num2str(data.idxSTS,'%02d'),num2str(data.idxSTSTest,'%02d'),' 右脚：',num2str(data.isRight)]);

dataPlantar = data.plantar; dataHip = data.hip;
masterAll = data.kinect.master; [stream,stream2] = SelectSubjectLongest(masterAll);
groupStream2 = [12,13,27,28,29];
if ismember(idxFile,groupStream2)
    stream = stream2;
end

grf = data.grf;
ik = data.ik;
id = data.id;
analysisGround = data.analysis.analysisGround;
analysisParent = data.analysis.analysisParent;
analysis = analysisGround;

%% Kinect data and pressure sensor data preprossesing

[pressurePlantar,pressurePlantar2D] = SortOriginalData(dataPlantar.dataAllOri);
rotK = 2; pressurePlantar2D = rotDataAll(pressurePlantar2D, rotK);
[pressureHip,pressureHip2D] = SortOriginalData(dataHip.dataAllOri);

fsInter = 30; order_N = 3;
stream = Kinectstream_Rmoutliers_Filter_And_Interp_STS2(stream,fsInter,order_N);

weight = weights(data.idxSub); height = heights(data.idxSub); gender = genders(data.idxSub);

% time alignment
PartTimeProcessing;

PartFrameProcessing;

PartPressureCalibration;

PartSignalInter;

PartFilterOpenSim;

idxsKinect = intersect(find(streamInter.wtime>=timeStart),find(streamInter.wtime<=timeEnd));

times.union = streamInter.wtime;

filename = [num2str(data.idxSub,'%03d'),num2str(data.idxSTS,'%02d'),num2str(data.idxSTSTest,'%02d')];

% DrawKinectFrame(streamInter,100);

%% Calculate CoM & CoP

% CoM
[posCOMSegments,vCOMSegments,accCOMSegments] = Segments_Velocity_Acceleration(streamInter,gender,fsInter);

com = posCOMSegments.Trunk;
vcom = vCOMSegments.Trunk;
acom = accCOMSegments.Trunk;

% COP
[copPlantar.x,copPlantar.y] = calCOP(pressurePlantar2D,1); copPlantar.x = copPlantar.x*0.001; copPlantar.y = -copPlantar.y*0.001;
[copHip.x,copHip.y] = calCOP(pressureHip2D,1); copHip.x = copHip.x*0.001; copHip.y = -copHip.y*0.001;

[copPlantarInter.x,copPlantarInter.y] = calCOP(pressurePlantar2DInter,1);
copPlantarInter.x = copPlantarInter.x*0.001; copPlantarInter.y = -copPlantarInter.y*0.001;
[copHipInter.x,copHipInter.y] = calCOP(pressureHip2DInter,1);
copHipInter.x = copHipInter.x*0.001; copHipInter.y = -copHipInter.y*0.001;

%% Determine times of stable standing

time_stable_stand = times_stable_stand{idxFile};

seg_plantar = GetSegsTime(times.plantar,time_stable_stand);
seg_union = GetSegsTime(times.union,time_stable_stand);

%% Calibrate the plantar array and Kinect position

transform_plantar2kinect = [median(posCOMSegments.human.x(seg_union)),median(posCOMSegments.human.y(seg_union))] -...
    [median(copPlantar.x(seg_plantar)),median(copPlantar.y(seg_plantar))];
transform_plantar2kinect = [transform_plantar2kinect,0];

%% ======== Sit-to-stand segmentation =======
%% Locate the non-contact segment of the buttock bottom

aux = times.hip(find(sum(sum(pressureHip2D,2),3)<100));
differences = diff(aux);

indices = find(differences>0.5);

single_start_times = aux(1);
single_end_times = aux(max(1,indices(1) - 1));

for i = 1:length(indices) - 1
    single_start_times = [single_start_times, aux(indices(i) + 1)];
    single_end_times = [single_end_times, aux(indices(i + 1) - 1)];
end

single_start_times = [single_start_times, aux(indices(end) + 1)];
single_end_times = [single_end_times, aux(end)];

idx_segment_single = [];
for i = 1:length(single_start_times)
    aux = intersect(find(times.union>=single_start_times(i)),find(times.union<=single_end_times(i)));
    idx_segment_single = [idx_segment_single;aux];
end

idx_segment_both = setdiff(1:length(times.union),idx_segment_single);

%% STSs

times_sts = times_stss{idxFile};

times_start = times_sts(1:2:end);
times_end = times_sts(2:2:end);