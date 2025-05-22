close all; clear; clc
addpath(genpath('../../data'));
addpath('../../correctionValue');
addpath(genpath('../../mat_data'));
addpath(genpath('../algorithm_preprocessing'));
addpath(genpath('../algorithm_processing'));
addpath(genpath('../algorithm_model_newton_euler'));
addpath(genpath('../algorithm_pressure_moment'));
%% 初始化
flag3DGRF = false;
ages = 2023-[1994 1998 2001]';
heights = [170 173 188]';
weights = [68 66 90]';
genders = 'MMM';
unitScaling = 1; % 默认压力单位为kg，用以调整阈值
numSub = 3;
% 读取校准文件
ks1024 = ones(1,1024); bs1024 = zeros(1,1024);
%% 作图初始化
colorSet.c1 = [204, 204, 51]./255; colorSet.c2 = [153, 51, 153]./255; colorSet.c3 = [0, 0, 0]./255;
colorSet.c4 = [102, 102, 102]./255; colorSet.c5 = [0, 51, 102]./255; colorSet.c6 = [153, 204, 51]./255;
%% 读取阵列数据
cellData = ReadAndSortData('../../data/KinectMat');
%% 整理数据
% 初始化
valuesSeatoffHip = [];
numTests = [10,10,11];
for idxSub = 1:3
    for idxTest = 1:numTests(idxSub)
        dataSub = cellData{idxSub};
        weight = weights(idxSub); gender = genders(idxSub); height = heights(idxSub);
        weightR = mean(weights)/weight; heightR = mean(heights)/heights(idxSub);
        %% ========== 一次测试的数据 ==========
        disp(['idxSub: ',num2str(idxSub),'; idxTest: ',num2str(idxTest)]);
        data = dataSub{idxTest};
        dataPlantar = data.plantar; dataHip = data.hip; 
        masterAll = data.kinect.master; subAll = data.kinect.sub;
        stream = SelectSubjectLongest(masterAll);
        dataVicon = data.vicon;
        
        datetimes.plantar = dataPlantar.datetimeF; datetimes.hip = dataHip.datetimeF; datetimes.kinect = stream.wtime;
        datatimes.vicon = dataVicon.grf.time;
        
        [times,~,~] = FindIndexTimeShare(datetimes,0);
         
        [pressurePlantar,pressurePlantar2D] = SortOriginalData(dataPlantar.dataAllOri);
        
        % 逆时针旋转k*90度，使足印向前
        rotK = 2; pressurePlantar2D = rotDataAll(pressurePlantar2D, rotK);
        
        [pressureHip,pressureHip2D] = SortOriginalData(dataHip.dataAllOri);
        
        %% 时间处理
        PartTimePreprocessing;
        %% 压力校准
        PartPressureCalibration;
        %% 坐标转换
        PartFramePreprocessing;
        
        %% 计算COP、COM
        [copXPlantar,copYPlantar] = calCOP(pressurePlantar2D,ratioV2P_P);
        [copXHip,copYHip] = calCOP(pressureHip2D,ratioV2P_H);
        [comX,comY,comZ] = GravityKinectAzure(stream,gender);
        
        %% stream滤波插值
        fsInter = 50; % 插值后的频率
        order_N = 21; % hamming
        order_N = 3; % butter
        streamInter = Kinectstream_Rmoutliers_Filter_And_Interp(stream,fsInter,order_N); % kinect关节点与时间插值
        
        %% STS分段
        % [standStartIdx,sitStartIdx] = FindSTSIdxs(p_listPlantar, ratioV2P_P); % 自动分段
        [standStartIdx,sitStartIdx,idxAbsorb] = FindSTSIdxsManually(idxSub,idxTest);
        
        %% 力和力矩插值到streamInter的时间
        PartArrayForceInterpolation;
        PartGRFInterpolation;
        
        %% 根据测力台，判断阵列seat-off时阵列的平均大小
        % 判断seat-off时间（臀底测力台接近0）
        for i = 1+10:length(grfHip.z)
            if grfHip.z(i)<2 && min(grfHip.z(i-5:i-1))>2 && max(grfHip.z(i-10:i))>10
                valuesSeatoffHip = [valuesSeatoffHip,grfHip_F.z(i)];
            end
        end
    end
end

meanSeatoffHip = mean(valuesSeatoffHip);

save ../../mat_data/valuesSeatoffHip.mat valuesSeatoffHip;