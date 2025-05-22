% 根据最大ICC寻找Vicon的提前时间，若vicon提前于kinect，则timeLead>0。
% timeV_k = timeV+timeLead
% timeK_v = timeK-timeLead
function [timeLead,idxLead,maxICC] = GetViconLeadTime(times,stream,dataVicon)
    % stream滤波插值
    fsInter = 50; order_N = 3; % butter
    streamInter = Kinectstream_Rmoutliers_Filter_And_Interp(stream,fsInter,order_N); % kinect关节点与时间插值
    timeK = streamInter.wtime;
    % 髋关节角度
    [~,hipFlexionL] = CalKinectJointAngle(streamInter.SPINE_NAVAL,streamInter.HIP_LEFT,streamInter.KNEE_LEFT);
    hipFlexionL = hipFlexionL{1};
    hipFlexionL = 170-hipFlexionL; 
    dataK = hipFlexionL;
    % vicon数据插值到kinect
    timeV = times.vicon;
    dataV = dataVicon.ik.hip_flexion_l;
    % 选择相同时间段
    timeStart = max([timeV(1),timeK(1)]); timeEnd = min([timeV(end),timeK(end)]);
    aux = GetIdxTime(timeV,[timeStart,timeEnd]); timeV = timeV(aux(1):aux(2)); dataV = dataV(aux(1):aux(2));
    aux = GetIdxTime(timeK,[timeStart,timeEnd]); timeK = timeK(aux(1):aux(2)); dataK = dataK(aux(1):aux(2));
    % vicon数据插值到kinect长度
    dataV = interp1(timeV,dataV,timeK,'spline');
    % 寻找最大ICC
    maxICC = 0;
    for i = 0:50
        k = dataK(1+i:end);
        v = dataV(1:length(k));
        icc = ICC([k,v],'C-1');
        if icc>maxICC
            maxICC = icc;
            idxLead = i;
        end
    end
    for i = 1:50
        v = dataV(1+i:end);
        k = dataK(1:length(v));
        icc = ICC([k,v],'C-1');
        if icc>maxICC
            maxICC = icc;
            idxLead = -i;
        end
    end
    if idxLead >= 0
        timeLead = timeK(1+idxLead)-timeK(1);
    else
        timeLead = timeK(end+idxLead)-timeK(end);
    end
end