close all; clear; clc
addpath(genpath('./data'));
% addpath(genpath('./mat_data'));
addpath(genpath('./algorithms'));
addpath(genpath('./algorithm_STS2'));

%% Initialization

flag_draw_bos = false;

PartInitialization;

%% Load Data

cellData = ReadAndSortDataKinect2();
% load('cellData','cellData');

%% Data Processing
if true % set true when first run
    cellSegs = {};
    for idxFile = 1:length(cellData)
        close all;
        disp([num2str(idxFile),' / ',num2str(length(cellData))]);
        if ismember(idxFile,[2,8]), continue; end % abandoned data
        
        %% Data Preprocessing
        PartOrganizeDataAndPreprocessing;
        
        %% Rotary Inertia

        inertia_rotary = CalRotaryInertia(gender,weight,streamInter,posCOMSegments);
    
        %% Joint power calculation

        jointPower = struct();
        jointPower.hip_flexion_l = id.hip_flexion_l_moment.*funcDiffAngle(ik.hip_flexion_l,ik.time);
        jointPower.hip_adduction_l = id.hip_adduction_l_moment.*funcDiffAngle(ik.hip_adduction_l,ik.time);
        jointPower.hip_rotation_l = id.hip_rotation_l_moment.*funcDiffAngle(ik.hip_rotation_l,ik.time);
        jointPower.knee_angle_l = id.knee_angle_l_moment.*funcDiffAngle(ik.knee_angle_l,ik.time);
        jointPower.ankle_angle_l = id.ankle_angle_l_moment.*funcDiffAngle(ik.ankle_angle_l,ik.time);
        jointPower.hip_flexion_r = id.hip_flexion_r_moment.*funcDiffAngle(ik.hip_flexion_r,ik.time);
        jointPower.hip_adduction_r = id.hip_adduction_r_moment.*funcDiffAngle(ik.hip_adduction_r,ik.time);
        jointPower.hip_rotation_r = id.hip_rotation_r_moment.*funcDiffAngle(ik.hip_rotation_r,ik.time);
        jointPower.knee_angle_r = id.knee_angle_r_moment.*funcDiffAngle(ik.knee_angle_r,ik.time);
        jointPower.ankle_angle_r = id.ankle_angle_r_moment.*funcDiffAngle(ik.ankle_angle_r,ik.time);
        jointPower.lumbar_extension = id.lumbar_extension_moment.*funcDiffAngle(ik.lumbar_extension,ik.time);
        jointPower.lumbar_bending = id.lumbar_bending_moment.*funcDiffAngle(ik.lumbar_bending,ik.time);
        jointPower.lumbar_rotation = id.lumbar_rotation_moment.*funcDiffAngle(ik.lumbar_rotation,ik.time);

        %% Joint angles calculated from kinect data
        
        jointAngles = CalJointAngles_xcom(streamInter);

        %% Calculate the angle between the CoM ankle joint and the vertical axis

        % Origin
        origin.x = 0.*(streamInter.ANKLE_LEFT.x + streamInter.ANKLE_RIGHT.x) / 2;
        origin.y = 0.*(streamInter.ANKLE_LEFT.y + streamInter.ANKLE_RIGHT.y) / 2;
        origin.z = 0.*(streamInter.ANKLE_LEFT.z + streamInter.ANKLE_RIGHT.z) / 2;
        
        vector.x = origin.x - com.x;
        vector.y = origin.y - com.y;
        vector.z = origin.z - com.z;
        
        vector_length = sqrt(vector.x.^2 + vector.y.^2 + vector.z.^2);
        
        % a·b = |a||b|cosθ
        cos_theta = vector.z ./ vector_length;
        theta_deg = acos(cos_theta);
        
        omega_deg = FiniteDifference(theta_deg,fsInter);
        alpha_deg = FiniteDifference(omega_deg,fsInter);

        %% Pendulum Length, pendulum_length1 is used

        pendulum_length1 = vector_length;
        pendulum_length2 = inertia_rotary./com.z;

        pendulum_length1_d = FiniteDifference(pendulum_length1,fsInter);
        pendulum_length1_d2 = FiniteDifference(pendulum_length1_d,fsInter);

        pendulum_length2_d = FiniteDifference(pendulum_length2,fsInter);
        pendulum_length2_d2 = FiniteDifference(pendulum_length2_d,fsInter);

        %% ======== P-XcoM =======
        %% P-XcoM calculation
        
        % P-XcoM without k
        xcom_o.x = com.x+vcom.x./(weight.*(g-acom.z).*com.z./inertia_rotary).^0.5;
        xcom_o.y = com.y+vcom.y./(weight.*(g-acom.z).*com.z./inertia_rotary).^0.5;
       
        % P-XcoM
        xcom.x = com.x+vcom.x./(weight.*(g-acom.z).*com.z./inertia_rotary+pendulum_length1_d2./pendulum_length1).^0.5;
        xcom.y = com.y+vcom.y./(weight.*(g-acom.z).*com.z./inertia_rotary+pendulum_length1_d2./pendulum_length1).^0.5;

        %% Sit-to-stand phases segmentation according to joint angles

        sts_segments = struct();
        sts_segments.idx_start = zeros(length(times_start),1);  sts_segments.time_start = zeros(length(times_start),1);
        sts_segments.idx_p1 = zeros(length(times_start),1);     sts_segments.time_p1 = zeros(length(times_start),1);
        sts_segments.idx_p2 = zeros(length(times_start),1);     sts_segments.time_p2 = zeros(length(times_start),1);
        sts_segments.idx_p3 = zeros(length(times_start),1);     sts_segments.time_p3 = zeros(length(times_start),1);
        sts_segments.idx_p4 = zeros(length(times_start),1);     sts_segments.time_p4 = zeros(length(times_start),1);
        sts_segments.idx_end = zeros(length(times_start),1);    sts_segments.time_end = zeros(length(times_start),1);
        
        for i = 1:length(times_start)
            time_start = times_start(i);
            idx_start = GetIdxTime(times.union,time_start);
            time_end = times_end(i);
            idx_end = GetIdxTime(times.union,time_end);
        
            % Locate the lowest point of PELVIS, HIP_LEFT, and HIP-RIGHT
            aux = median([streamInter.PELVIS.z,streamInter.HIP_LEFT.z,streamInter.HIP_RIGHT.z],2);
            aux = aux(idx_start:idx_end);
            [~,idx_p1] = min(aux); idx_p1 = idx_p1-1+idx_start;
            time_p1 = times.union(idx_p1);
            
            % time for the buttocks to leave the cushion
            aux = find(idx_segment_single>idx_start,1);
            idx_p2 = idx_segment_single(aux);
            time_p2 = times.union(idx_p2);
        
            % Maximum ankle dorsiflexion
            aux = jointAngles.ankleAngleL+jointAngles.ankleAngleR;
            aux = aux(idx_start:idx_end);
            [~,idx_p3] = min(aux); idx_p3 = idx_p3-1+idx_start;
            time_p3 = times.union(idx_p3);
        
            % First stop of hip joint extension (maximum hip joint angle)
            aux = jointAngles.hipFlexionL+jointAngles.hipFlexionR;
            aux = aux(idx_start:idx_end);
            [~,idx_p4] = max(aux); idx_p4 = idx_p4-1+idx_start;
            time_p4 = times.union(idx_p4);
            
            sts_segments.idx_start(i) = idx_start;
            sts_segments.idx_p1(i) = idx_p1;
            sts_segments.idx_p2(i) = idx_p2;
            sts_segments.idx_p3(i) = idx_p3;
            sts_segments.idx_p4(i) = idx_p4;
            sts_segments.idx_end(i) = idx_end;
            sts_segments.time_start(i) = time_start;
            sts_segments.time_p1(i) = time_p1;
            sts_segments.time_p2(i) = time_p2;
            sts_segments.time_p3(i) = time_p3;
            sts_segments.time_p4(i) = time_p4;
            sts_segments.time_end(i) = time_end;
        end
        
%         PartFigureSTSSegments;
        
        %% ======== BoS =======
        %% BOS
        
        pressurePlantar2DInter_smooth = smoothdata(pressurePlantar2DInter, 1, 'gaussian', 5);
        pressureHip2DInter_smooth = smoothdata(pressureHip2DInter, 1, 'gaussian', 5);
        
        bos = struct();
        bos.x = cell(length(times.union),1);
        bos.y = cell(length(times.union),1);
        bos.mask_bos = cell(length(times.union),1);
        
        for idxFrame = 1:length(times.union)
            imgPlantar = reshape(pressurePlantar2DInter_smooth(idxFrame,:),32,32);
            imgButtock = reshape(pressureHip2DInter_smooth(idxFrame,:),32,32);
            imgButtock = [zeros(5,32); imgButtock(1:32-5,:)]; % calibrate positions of the buttock bottom array
        
            % fix foot
%             imgPlantar = imgPlantarMean;
            imgPlantar = reshape(mean(pressurePlantar2DInter_smooth(max([1,idxFrame-50]):min([length(times.union),idxFrame+50]),:,:)),32,32);
            
            if ismember(idxFrame,idx_segment_single)
                img = [imgPlantar;zeros(32,32)];
            else
                img = [imgPlantar;imgButtock];
            end
            
            [bos_x, bos_y, mask_bos] = CalBOS(img,0);
            
            bos.x{idxFrame} = bos_x+transform_plantar2kinect(1);
            bos.y{idxFrame} = -bos_y+transform_plantar2kinect(2);
            bos.mask_bos{idxFrame} = mask_bos;
        end
        
        %% Plantar BoS
        
        bos_plantar = struct();
        bos_plantar.x = cell(length(times.union),1);
        bos_plantar.y = cell(length(times.union),1);
        bos_plantar.mask_bos = cell(length(times.union),1);
        
        [x,y] = meshgrid(1:32,1:32);
        x = x(:); y = y(:);
        
        for idxFrame = 1:length(times.union)
            imgPlantar = reshape(pressurePlantar2DInter_smooth(idxFrame,:),32,32);
        
%             imgPlantar = imgPlantarMean;
            imgPlantar = reshape(mean(pressurePlantar2DInter_smooth(max([1,idxFrame-50]):min([length(times.union),idxFrame+50]),:,:)),32,32);
        
            img = [imgPlantar;zeros(32,32)];
        
            [bos_x, bos_y, mask_bos] = CalBOS(img,0);
            
            bos_plantar.x{idxFrame} = bos_x+transform_plantar2kinect(1);
            bos_plantar.y{idxFrame} = -bos_y+transform_plantar2kinect(2);
            bos_plantar.mask_bos{idxFrame} = mask_bos;
        end

        %% Border of BoS

        bos_plantar_front = zeros(length(times.union),1);
        bos_plantar_back = zeros(length(times.union),1);
        bos_plantar_left = zeros(length(times.union),1);
        bos_plantar_right = zeros(length(times.union),1);
        
        bos_back = zeros(length(times.union),1);
        bos_left = zeros(length(times.union),1);
        bos_right = zeros(length(times.union),1);
        
        for i = 1:length(bos.x)
            bos_plantar_left(i) = min(bos_plantar.x{i});
            bos_plantar_right(i) = max(bos_plantar.x{i});
            bos_plantar_front(i) = max(bos_plantar.y{i});
            bos_plantar_back(i) = min(bos_plantar.y{i});
        
            bos_back(i) = min(bos.y{i});
            bos_left(i) = min(bos.x{i});
            bos_right(i) = max(bos.x{i});
        end
        
        %% CoP position to kinect coordinate
        
        copPlantar.x = copPlantar.x+transform_plantar2kinect(1);
        copPlantar.y = copPlantar.y+transform_plantar2kinect(2);
        
        copPlantarInter.x = copPlantarInter.x+transform_plantar2kinect(1);
        copPlantarInter.y = copPlantarInter.y+transform_plantar2kinect(2);
    
        %% CoM-BoS distance and P-XcoM-BoS distance
        
        dis_com_bos = CalDistanceCOM2BOS(com,bos);
        dis_xcom_bos = CalDistanceCOM2BOS(xcom,bos);
        dis_com_bos_plantar = CalDistanceCOM2BOS(com,bos_plantar);
        dis_xcom_bos_plantar = CalDistanceCOM2BOS(xcom,bos_plantar);
        
        %% save all sts segments
    
        for idx_seg = 1:length(sts_segments.idx_start)
            seg = struct();
    
            % basic info
            seg.info.idx_sub = data.idxSub;
            seg.info.idx_sts = data.idxSTS;
            seg.info.idx_test = data.idxSTSTest;
            seg.info.idx_seg = idx_seg;
            seg.info.weight = weight;
            seg.info.height = height;
    
            % segments
            seg.idx.idx_start = sts_segments.idx_start(idx_seg);
            seg.idx.idx_p1 = sts_segments.idx_p1(idx_seg);
            seg.idx.idx_p2 = sts_segments.idx_p2(idx_seg);
            seg.idx.idx_p3 = sts_segments.idx_p3(idx_seg);
            seg.idx.idx_p4 = sts_segments.idx_p4(idx_seg);
            seg.idx.idx_end = sts_segments.idx_end(idx_seg);
    
            range_union = seg.idx.idx_start:seg.idx.idx_end;
            range_vicon = GetIdxTime(times.vicon,[sts_segments.time_start(idx_seg),sts_segments.time_end(idx_seg)]); range_vicon = range_vicon(1):range_vicon(2);
            
            % times
            seg.time_origin = times.union(range_union);
            seg.time = seg.time_origin-seg.time_origin(1);
            seg.time_vicon = times.vicon(range_vicon);
            seg.time_vicon = seg.time_vicon-seg.time_vicon(1);
    
            % CoM, XcoM, BoS
            seg.com.x = com.x(range_union);
            seg.com.y = com.y(range_union);
            seg.com.z = com.z(range_union);
    
            seg.com.vx = vcom.x(range_union);
            seg.com.vy = vcom.y(range_union);
            seg.com.vz = vcom.z(range_union);
    
            seg.com.ax = acom.x(range_union);
            seg.com.ay = acom.y(range_union);
            seg.com.az = acom.z(range_union);

            seg.xcom_o.x = xcom_o.x(range_union);
            seg.xcom_o.y = xcom_o.y(range_union);
            
            seg.xcom.x = xcom.x(range_union);
            seg.xcom.y = xcom.y(range_union);
    
            seg.bos.x = bos.x(range_union);
            seg.bos.y = bos.y(range_union);

            seg.bos.plantar_front = bos_plantar_front(range_union);
            seg.bos.plantar_back = bos_plantar_back(range_union);
            seg.bos.plantar_left = bos_plantar_left(range_union);
            seg.bos.plantar_right = bos_plantar_right(range_union);
            seg.bos.back = bos_back(range_union);
            seg.bos.left = bos_left(range_union);
            seg.bos.right = bos_right(range_union);

            % inertia
            seg.inertia = inertia_rotary(range_union);

            % CoM -> BoS
            seg.dis.com_bos = GetFieldInRange(dis_com_bos,range_union);
            seg.dis.xcom_bos = GetFieldInRange(dis_xcom_bos,range_union);
            seg.dis.com_bos_plantar = GetFieldInRange(dis_com_bos_plantar,range_union);
            seg.dis.xcom_bos_plnatar = GetFieldInRange(dis_xcom_bos_plantar,range_union);
    
            % grf
            seg.grf.left_x = grfPlantarLeft.x(range_union);
            seg.grf.left_y = grfPlantarLeft.y(range_union);
            seg.grf.left_z = grfPlantarLeft.z(range_union);
            seg.grf.right_x = grfPlantarRight.x(range_union);
            seg.grf.right_y = grfPlantarRight.y(range_union);
            seg.grf.right_z = grfPlantarRight.z(range_union);
            seg.grf.hip_x = grfHip.x(range_union);
            seg.grf.hip_y = grfHip.y(range_union);
            seg.grf.hip_z = grfHip.z(range_union);

            % kinect
            seg.stream.pelvis.z = streamInter.PELVIS.z(range_union);
    
            % ja
            seg.ja.left_hip = jointAngles.hipFlexionL(range_union);
            seg.ja.right_hip = jointAngles.hipFlexionR(range_union);
            seg.ja.left_knee = jointAngles.kneeAngleL(range_union);
            seg.ja.right_knee = jointAngles.kneeAngleR(range_union);
            seg.ja.left_ankle = jointAngles.ankleAngleL(range_union);
            seg.ja.right_ankle = jointAngles.ankleAngleR(range_union);
            seg.ja.lumbar = jointAngles.lumbarFlexion(range_union);
    
            % jrf
            seg.jrf.left_hip_x = analysisGround.jrl_hip_l_on_femur_l_in_ground_fz(range_vicon);
            seg.jrf.left_hip_y = analysisGround.jrl_hip_l_on_femur_l_in_ground_fx(range_vicon);
            seg.jrf.left_hip_z = analysisGround.jrl_hip_l_on_femur_l_in_ground_fy(range_vicon);
            seg.jrf.left_knee_x = analysisGround.jrl_knee_l_on_tibia_l_in_ground_fz(range_vicon);
            seg.jrf.left_knee_y = analysisGround.jrl_knee_l_on_tibia_l_in_ground_fx(range_vicon);
            seg.jrf.left_knee_z = analysisGround.jrl_knee_l_on_tibia_l_in_ground_fy(range_vicon);
            seg.jrf.left_ankle_x = analysisGround.jrl_ankle_l_on_talus_l_in_ground_fz(range_vicon);
            seg.jrf.left_ankle_y = analysisGround.jrl_ankle_l_on_talus_l_in_ground_fx(range_vicon);
            seg.jrf.left_ankle_z = analysisGround.jrl_ankle_l_on_talus_l_in_ground_fy(range_vicon);
            seg.jrf.right_hip_x = analysisGround.jrl_hip_r_on_femur_r_in_ground_fz(range_vicon);
            seg.jrf.right_hip_y = analysisGround.jrl_hip_r_on_femur_r_in_ground_fx(range_vicon);
            seg.jrf.right_hip_z = analysisGround.jrl_hip_r_on_femur_r_in_ground_fy(range_vicon);
            seg.jrf.right_knee_x = analysisGround.jrl_knee_r_on_tibia_r_in_ground_fz(range_vicon);
            seg.jrf.right_knee_y = analysisGround.jrl_knee_r_on_tibia_r_in_ground_fx(range_vicon);
            seg.jrf.right_knee_z = analysisGround.jrl_knee_r_on_tibia_r_in_ground_fy(range_vicon);
            seg.jrf.right_ankle_x = analysisGround.jrl_ankle_r_on_talus_r_in_ground_fz(range_vicon);
            seg.jrf.right_ankle_y = analysisGround.jrl_ankle_r_on_talus_r_in_ground_fx(range_vicon);
            seg.jrf.right_ankle_z = analysisGround.jrl_ankle_r_on_talus_r_in_ground_fy(range_vicon);

            seg.jrf.left_hip = funcSumXYZ(seg.jrf.left_hip_x,seg.jrf.left_hip_y,seg.jrf.left_hip_z);
            seg.jrf.left_knee = funcSumXYZ(seg.jrf.left_knee_x,seg.jrf.left_knee_y,seg.jrf.left_knee_z);
            seg.jrf.left_ankle = funcSumXYZ(seg.jrf.left_ankle_x,seg.jrf.left_ankle_y,seg.jrf.left_ankle_z);
    
            seg.jrf.right_hip = funcSumXYZ(seg.jrf.right_hip_x,seg.jrf.right_hip_y,seg.jrf.right_hip_z);
            seg.jrf.right_knee = funcSumXYZ(seg.jrf.right_knee_x,seg.jrf.right_knee_y,seg.jrf.right_knee_z);
            seg.jrf.right_ankle = funcSumXYZ(seg.jrf.right_ankle_x,seg.jrf.right_ankle_y,seg.jrf.right_ankle_z);

            % jm
            seg.jm.left_hip_flexion = id.hip_flexion_l_moment(range_vicon);
            seg.jm.left_hip_adduction = id.hip_adduction_l_moment(range_vicon);
            seg.jm.left_hip_rotation = id.hip_rotation_l_moment(range_vicon);
            seg.jm.left_knee = id.knee_angle_l_moment(range_vicon);
            seg.jm.left_ankle = id.ankle_angle_l_moment(range_vicon);
            seg.jm.right_hip_flexion = id.hip_flexion_r_moment(range_vicon);
            seg.jm.right_hip_adduction = id.hip_adduction_r_moment(range_vicon);
            seg.jm.right_hip_rotation = id.hip_rotation_r_moment(range_vicon);
            seg.jm.right_knee = id.knee_angle_r_moment(range_vicon);
            seg.jm.right_ankle = id.ankle_angle_r_moment(range_vicon);
            seg.jm.lumbar_extension = id.lumbar_extension_moment(range_vicon);
            seg.jm.lumbar_bending = id.lumbar_bending_moment(range_vicon);
            seg.jm.lumbar_rotation = id.lumbar_rotation_moment(range_vicon);

            % jp
            seg.jp.left_hip_flexion = jointPower.hip_flexion_l(range_vicon);
            seg.jp.left_hip_adduction = jointPower.hip_adduction_l(range_vicon);
            seg.jp.left_hip_rotation = jointPower.hip_rotation_l(range_vicon);
            seg.jp.left_knee = jointPower.knee_angle_l(range_vicon);
            seg.jp.left_ankle = jointPower.ankle_angle_l(range_vicon);
            seg.jp.right_hip_flexion = jointPower.hip_flexion_r(range_vicon);
            seg.jp.right_hip_adduction = jointPower.hip_adduction_r(range_vicon);
            seg.jp.right_hip_rotation = jointPower.hip_rotation_r(range_vicon);
            seg.jp.right_knee = jointPower.knee_angle_r(range_vicon);
            seg.jp.right_ankle = jointPower.ankle_angle_r(range_vicon);
            seg.jp.lumbar_extension = jointPower.lumbar_extension(range_vicon);
            seg.jp.lumbar_bending = jointPower.lumbar_bending(range_vicon);
            seg.jp.lumbar_rotation = jointPower.lumbar_rotation(range_vicon);

            % CoM-origin angle
            seg.com_angle.theta = theta_deg(range_union);
            seg.com_angle.omega = omega_deg(range_union);
            seg.com_angle.alpha = alpha_deg(range_union);

            seg.pl1 = pendulum_length1(range_union);
            seg.pl1_d = pendulum_length1_d(range_union);
            seg.pl1_d2 = pendulum_length1_d2(range_union);

            seg.pl2 = pendulum_length2(range_union);
            seg.pl2_d = pendulum_length2_d(range_union);
            seg.pl2_d2 = pendulum_length2_d2(range_union);
            
            % 区间调整
            seg.idx.idx_p1 = seg.idx.idx_p1-seg.idx.idx_start+1;
            seg.idx.idx_p2 = seg.idx.idx_p2-seg.idx.idx_start+1;
            seg.idx.idx_p3 = seg.idx.idx_p3-seg.idx.idx_start+1;
            seg.idx.idx_p4 = seg.idx.idx_p4-seg.idx.idx_start+1;
            seg.idx.idx_end = seg.idx.idx_end-seg.idx.idx_start+1;

            cellSegs = [cellSegs;seg];
    
        end
    end
    save('./mat_data/xcom_analysis.mat','cellSegs');
else
    load('./mat_data/xcom_analysis.mat','cellSegs');
end

%% STS strategies

idxs_sts = cell(4,1);
idxs_sts{1} = 1:length(cellSegs); % all
idxs_sts{2} = find(cellfun(@(x) x.info.idx_sts == 1, cellSegs)); % MT
idxs_sts{3} = find(cellfun(@(x) x.info.idx_sts == 2, cellSegs)); % ETF
idxs_sts{4} = find(cellfun(@(x) x.info.idx_sts == 3, cellSegs)); % DVR

%% Segmenting based on P-XcoM

thStable = 0.01;
for idxSeg = 1:length(cellSegs)
    seg = cellSegs{idxSeg};
    % CoM and XcoM have reached the stable point position
    aux = seg.xcom.y;
    for i = seg.idx.idx_p4-5:-1:1+5
        if range(aux(i-5:i+5))>thStable
            break;
        end
    end
    seg.idx.idx_xcom_stable = i;

    aux = seg.com.y;
    for i = seg.idx.idx_p4-5:-1:1+5
        if range(aux(i-5:i+5))>thStable
            break;
        end
    end
    seg.idx.idx_com_stable = i;
    
    seg.idx.idx_p3 = seg.idx.idx_xcom_stable; % repalce p3

    cellSegs{idxSeg} = seg;
end

%% ======== Parameters for calculating the average trend ========

str_paras = {
    'seg.com.x'
    'seg.xcom.x'
    'seg.com.y'
    'seg.xcom.y'
    'seg.dis.com_bos.dis' % 5
    'seg.dis.xcom_bos.dis'
    'seg.dis.com_bos.x' % 7
    'seg.dis.xcom_bos.x'
    'seg.dis.com_bos.y' % 9
    'seg.dis.xcom_bos.y'
    'seg.dis.com_bos.dis_y' % 11
    'seg.dis.xcom_bos.dis_y'
    'seg.com.y-seg.bos.plantar_back'
    'seg.xcom.y-seg.bos.plantar_back'
    'seg.xcom.x-seg.com.x' % 15
    'seg.xcom.y-seg.com.y' 
    'seg.inertia'
    'seg.com.vx' % 18
    'seg.com.vy' 
    'seg.com.z' % 20
    'seg.com.az'
    '(seg.jrf.left_hip_x-seg.jrf.right_hip_x)./2./seg.info.weight./10*100' % 22
    '(seg.jrf.left_hip_y+seg.jrf.right_hip_y)./2./seg.info.weight./10*100'
    '(seg.jrf.left_hip_z+seg.jrf.right_hip_z)./2./seg.info.weight./10*100'
    '(seg.jrf.left_hip+seg.jrf.right_hip)./2./seg.info.weight./10*100'
    '(seg.jrf.left_knee_x-seg.jrf.right_knee_x)./2./seg.info.weight./10*100' % 26
    '(seg.jrf.left_knee_y+seg.jrf.right_knee_y)./2./seg.info.weight./10*100'
    '(seg.jrf.left_knee_z+seg.jrf.right_knee_z)./2./seg.info.weight./10*100'
    '(seg.jrf.left_knee+seg.jrf.right_knee)./2./seg.info.weight./10*100'
    '(seg.jrf.left_ankle_x-seg.jrf.right_ankle_x)./2./seg.info.weight./10*100' % 30
    '(seg.jrf.left_ankle_y+seg.jrf.right_ankle_y)./2./seg.info.weight./10*100'
    '(seg.jrf.left_ankle_z+seg.jrf.right_ankle_z)./2./seg.info.weight./10*100'
    '(seg.jrf.left_ankle+seg.jrf.right_ankle)./2./seg.info.weight./10*100'
    '(seg.jm.left_hip_flexion+seg.jm.right_hip_flexion)./2./seg.info.weight./seg.info.height./10*100' % 34
    '(seg.jm.left_hip_adduction-seg.jm.right_hip_adduction)./2./seg.info.weight./seg.info.height./10*100'
    '(seg.jm.left_hip_rotation-seg.jm.right_hip_rotation)./2./seg.info.weight./seg.info.height./10*100'
    '(seg.jm.left_knee+seg.jm.right_knee)./2./seg.info.weight./seg.info.height./10*100' % 37
    '(seg.jm.left_ankle+seg.jm.right_ankle)./2./seg.info.weight./seg.info.height./10*100'
    'seg.jm.lumbar_extension./seg.info.weight./seg.info.height./10*100' % 39
    'seg.jm.lumbar_bending./seg.info.weight./seg.info.height./10*100'
    'seg.jm.lumbar_rotation./seg.info.weight./seg.info.height./10*100'
    '(seg.ja.left_hip+seg.ja.right_hip)./2' % 42
    '(seg.ja.left_knee+seg.ja.right_knee)./2'
    '(seg.ja.left_ankle+seg.ja.right_ankle)./2'
    '(seg.info.weight.*(9.79-seg.com.az).*seg.com.z./seg.inertia).^0.5' % 45 omega
    'seg.inertia./seg.com.z./seg.info.weight' % 46 l'
    '9.79-seg.com.az' % 47 g-az
    'seg.com.ay'
    '(seg.jp.left_hip_flexion+seg.jp.right_hip_flexion)./2./seg.info.weight./10*100' % 49 Joint Power
    '(seg.jp.left_hip_adduction-seg.jp.right_hip_adduction)./2./seg.info.weight./10*100'
    '(seg.jp.left_hip_rotation-seg.jp.right_hip_rotation)./2./seg.info.weight./10*100'
    '(seg.jp.left_knee+seg.jp.right_knee)./2./seg.info.weight./10*100' % 52
    '(seg.jp.left_ankle+seg.jp.right_ankle)./2./seg.info.weight./10*100'
    'seg.jp.lumbar_extension./seg.info.weight./10*100' % 54
    'seg.jp.lumbar_bending./seg.info.weight./10*100'
    'seg.jp.lumbar_rotation./seg.info.weight./10*100'
    'cumtrapz(seg.time_vicon,(seg.jp.left_hip_flexion+seg.jp.right_hip_flexion)./2./seg.info.weight./10*100)' % 57 Joint Work
    'cumtrapz(seg.time_vicon,(seg.jp.left_hip_adduction-seg.jp.right_hip_adduction)./2./seg.info.weight./10*100)'
    'cumtrapz(seg.time_vicon,(seg.jp.left_hip_rotation-seg.jp.right_hip_rotation)./2./seg.info.weight./10*100)'
    'cumtrapz(seg.time_vicon,(seg.jp.left_knee+seg.jp.right_knee)./2./seg.info.weight./10*100)' % 60
    'cumtrapz(seg.time_vicon,(seg.jp.left_ankle+seg.jp.right_ankle)./2./seg.info.weight./10*100)'
    'cumtrapz(seg.time_vicon,seg.jp.lumbar_extension./seg.info.weight./10*100)' % 62
    'cumtrapz(seg.time_vicon,seg.jp.lumbar_bending./seg.info.weight./10*100)'
    'cumtrapz(seg.time_vicon,seg.jp.lumbar_rotation./seg.info.weight./10*100)'
    'seg.com.vy.^2' % 65
    'seg.com.vz.^2'
    'seg.pl1.*seg.com_angle.omega.*seg.com_angle.omega' % 67 4项
    'seg.pl1.*seg.com_angle.alpha'
    '2*seg.pl1_d.*seg.com_angle.omega'
    'seg.pl1_d2'
    'seg.pl1_d2./seg.pl1' % 71 k=l''/l
    'seg.xcom_o.x' % 72
    'seg.xcom_o.y'
    'seg.pl1.*seg.com_angle.omega.*seg.com_angle.omega./(seg.pl1.*seg.com_angle.alpha)' % 74
    '2*seg.pl1_d.*seg.com_angle.omega./(seg.pl1.*seg.com_angle.alpha)'
    'seg.info.weight.*(9.79-seg.com.az).*seg.com.z./seg.inertia' % 76 omega_0^2
    'seg.pl1' % 77 l
    'seg.com.vy./(seg.xcom.y-seg.com.y)' % 78 lambda
    '(seg.pl1_d2./seg.pl1).^0.5' % 79 sqrt k
    ['abs(cumtrapz(seg.time_vicon,(seg.jp.left_hip_flexion+seg.jp.right_hip_flexion)./2./seg.info.weight./10*100))+' ...
    'abs(cumtrapz(seg.time_vicon,(seg.jp.left_hip_adduction-seg.jp.right_hip_adduction)./2./seg.info.weight./10*100))+' ...
    'abs(cumtrapz(seg.time_vicon,(seg.jp.left_hip_rotation-seg.jp.right_hip_rotation)./2./seg.info.weight./10*100))+' ...
    'abs(cumtrapz(seg.time_vicon,(seg.jp.left_knee+seg.jp.right_knee)./2./seg.info.weight./10*100))+' ...
    'abs(cumtrapz(seg.time_vicon,(seg.jp.left_ankle+seg.jp.right_ankle)./2./seg.info.weight./10*100))+' ...
    'abs(cumtrapz(seg.time_vicon,seg.jp.lumbar_extension./seg.info.weight./10*100))+' ...
    'abs(cumtrapz(seg.time_vicon,seg.jp.lumbar_bending./seg.info.weight./10*100))+' ...
    'abs(cumtrapz(seg.time_vicon,seg.jp.lumbar_rotation./seg.info.weight./10*100))'] % 80
    };

str_para_names = {
    'com_x'
    'xcom_x'
    'com_y'
    'xcom_y'
    'com_dis' % 5
    'xcom_dis'
    'com_dis_x' % 7
    'xcom_dis_x'
    'com_dis_y' % 9
    'xcom_dis_y'
    'com_dis_y_border' % 11
    'xcom_dis_y_border'
    'com_y_back'
    'xcom_y_back'
    'xcom_com_x' % 15
    'xcom_com_y' 
    'inertia'
    'vx' % 18
    'vy' 
    'com_z' % 20
    'az'
    'jrf_hip_x' % 22
    'jrf_hip_y'
    'jrf_hip_z'
    'jrf_hip'
    'jrf_knee_x' % 26
    'jrf_knee_y'
    'jrf_knee_z'
    'jrf_knee'
    'jrf_ankle_x' % 30
    'jrf_ankle_y'
    'jrf_ankle_z'
    'jrf_ankle'
    'jm_hip_flexion' % 34
    'jm_hip_adduction'
    'jm_hip_rotation'
    'jm_knee' % 37
    'jm_ankle'
    'jm_lumbar_extension' % 39
    'jm_lumbar_bending'
    'jm_lumbar_rotation'
    'ja_hip' % 42
    'ja_knee'
    'ja_ankle'
    'omega' % 45 omega
    'l''' % 46 l'
    'g_az' % 47 g-az
    'ay' % 48
    'jp_hip_flexion' % 49
    'jp_hip_adduction'
    'jp_hip_rotation'
    'jp_knee' % 52
    'jp_ankle'
    'jp_lumbar_extension' % 54
    'jp_lumbar_bending'
    'jp_lumbar_rotation'
    'jw_hip_flexion' % 57
    'jw_hip_adduction'
    'jw_hip_rotation'
    'jw_knee' % 60
    'jw_ankle'
    'jw_lumbar_extension' % 62
    'jw_lumbar_bending'
    'jw_lumbar_rotation'
    'vy2' % 65
    'vz2'
    'lw2' % 67
    'la'
    '2dlw'
    'ddl'
    'k' % 71
    'xcom_o_x'
    'xcom_o_y'
    'lw2/la' % 74
    '2dlw/la'
    'omega2' % 76
    'l'
    'lambda'
    'sqrt k' % 79
    'jw sum' % 80
    };

mean_curves = cell(length(str_paras),1); 
std_curves = cell(length(str_paras),1); 
time_curves = cell(length(str_paras),1); 
time_stages = cell(length(str_paras),1);
for i = 1:length(str_paras)
    str_para = str_paras{i};
    [mean_curves{i}, std_curves{i}, time_curves{i}, time_stages{i}] = GetAverageCurves(cellSegs, idxs_sts, str_para);
end

%% ======== correlation analysis ========

tableCorrs = struct();
for idxStage = 1:7
    for idxSTS = 1:4
        tableCorr = struct();
        tableCorr.mean = zeros(length(str_paras));
        tableCorr.std = zeros(length(str_paras));
        tableCorr.cellCorr = cell(length(cellSegs(idxs_sts{idxSTS})),1);
        
        for idxSeg = 1:length(idxs_sts{idxSTS})
            seg = cellSegs{idxs_sts{idxSTS}(idxSeg)};
    
            if idxStage == 1 
                idxP = 1:length(seg.time);
            elseif idxStage == 2
                idxP = 1:seg.idx.idx_p2;
            elseif idxStage == 3
                idxP = seg.idx.idx_p2:seg.idx.idx_p3;
            elseif idxStage == 4
                idxP = seg.idx.idx_p3:seg.idx.idx_p4;
            elseif idxStage == 5
                idxP = seg.idx.idx_p4:seg.idx.idx_end;
            elseif idxStage == 6 % Near the maximum speed
                [~,aux] = max(seg.com.vy);
                idxP = max(1,aux-5):min(seg.idx.idx_end,aux+10);
            else % ascent stage
                for idxLeft = seg.idx.idx_p2:-1:1
                    if seg.com.vz(idxLeft)<0
                        break;
                    end
                end
                for idxRight = seg.idx.idx_p2:seg.idx.idx_end
                    if seg.com.vz(idxRight)<0
                        break;
                    end
                end
                idxP = (idxLeft+1):(idxRight-1);
            end
        
            if length(idxP)>5
                dataSeg = zeros(length(str_paras),length(idxP));
                for idxPara = 1:length(str_paras)
                    str_para = str_paras{idxPara};
                    eval(['data = ',str_para,';']);
                    if contains(str_para,'jrf') || contains(str_para,'jm') || contains(str_para,'jp')
                        data = interp1(seg.time_vicon,data,seg.time);
                    end
        
                    dataSeg(idxPara,:) = data(idxP);
                end
                
                dataSeg(:,sum(isnan(dataSeg),1)>0) = [];
            
                aux = real(corrcoef(dataSeg'));
            else
                aux = nan*ones(length(str_paras));
            end
            
            tableCorr.cellCorr{idxSeg} = aux;
        end
        
        for i = 1:length(str_paras)
            for j = 1:length(str_paras)
                aux = zeros(length(idxs_sts{idxSTS}),1);
                for idxSeg = 1:length(idxs_sts{idxSTS})
                    aux(idxSeg) = tableCorr.cellCorr{idxSeg}(i,j);
                end
                aux(isnan(aux)) = [];
                tableCorr.mean(i,j) = mean(aux);
                tableCorr.std(i,j) = std(aux);
            end
        end
        
        tableCorr.mean_significant = tableCorr.mean;
        tableCorr.mean_significant(abs(tableCorr.mean_significant)<0.8) = 0;
        tableCorr.mean = array2table(tableCorr.mean,'RowNames',str_para_names,'VariableNames',str_para_names);
        tableCorr.mean_significant = array2table(tableCorr.mean_significant,'RowNames',str_para_names,'VariableNames',str_para_names);
        tableCorr.std = array2table(tableCorr.std,'RowNames',str_para_names,'VariableNames',str_para_names);
    
        names_seg = {'all','s1','s2','s3','s4','vmax','zLift'};
        names_sts = {'all','MT','ETF','DVR'};
        tableCorrs.(names_seg{idxStage}).(names_sts{idxSTS}) = tableCorr;
    end
    
end

%% ======== Trend characteristics ========

%% Trend characteristics

tableTrendParas = cell(5,1);
for i = 1:5 % all,phase 1, phase 2, phase 3, phase 4
    tableTrendParas{i,1} = struct();
    tableTrendParas{i,1}.cv.data = zeros(length(cellSegs),length(str_paras)); % coefficient of variation
    tableTrendParas{i,1}.diff_mean.data = zeros(length(cellSegs),length(str_paras)); % First order differential mean
    tableTrendParas{i,1}.diff_std.data = zeros(length(cellSegs),length(str_paras)); % First order differential std
    tableTrendParas{i,1}.diff_skewness.data = zeros(length(cellSegs),length(str_paras)); % First order differential skewness
    tableTrendParas{i,1}.mcr.data = zeros(length(cellSegs),length(str_paras)); % mcr
    tableTrendParas{i,1}.en.data = zeros(length(cellSegs),length(str_paras));% approximate entropy
    tableTrendParas{i,1}.maxV.data = zeros(length(cellSegs),length(str_paras));% peak value
    tableTrendParas{i,1}.maxT.data = zeros(length(cellSegs),length(str_paras));% peak time
    tableTrendParas{i,1}.mean.data = zeros(length(cellSegs),length(str_paras));% mean
    tableTrendParas{i,1}.rms.data = zeros(length(cellSegs),length(str_paras));% rms
end

for i = 1:5
    for idxSeg = 1:length(cellSegs)
        seg = cellSegs{idxSeg};
        for idxPara = 1:length(str_paras)
            str_para = str_paras{idxPara};
            eval(['data = ',str_para,';']);

            if i == 1
                idxP = 1:seg.idx.idx_end;
            elseif i == 2
                idxP = 1:seg.idx.idx_p2;
            elseif i == 3
                idxP = seg.idx.idx_p2:seg.idx.idx_p3;
            elseif i == 4
                idxP = seg.idx.idx_p3:seg.idx.idx_p4;
            else
                idxP = seg.idx.idx_p4:seg.idx.idx_end;
            end
    
            if contains(str_para,'jrf') || contains(str_para,'jm') || contains(str_para,'jp')
                data = interp1(seg.time_vicon,data,seg.time);
            end
        
            t = seg.time(idxP);
            data = data(idxP);

            data = data(:);
            n = length(data);
            mean_val = mean(data);
            
            % 1. cv
            std_dev = std(data);
            CV = std_dev / abs(mean_val); 
            tableTrendParas{i,1}.cv.data(idxSeg,idxPara) = CV;
            
            % 2. first order differential
            diff_data = diff(data);
            diff_mean = mean(diff_data);
            diff_std = std(diff_data);
            diff_skewness = skewness(diff_data); 
            
            tableTrendParas{i,1}.diff_mean.data(idxSeg,idxPara) = diff_mean;
            tableTrendParas{i,1}.diff_std.data(idxSeg,idxPara) = diff_std;
            tableTrendParas{i,1}.diff_skewness.data(idxSeg,idxPara) = diff_skewness;
            
            % 3. mcr
            zero_crossings = sum(diff(sign(data - mean_val)) ~= 0);
            MCR = zero_crossings / (n-1);
            tableTrendParas{i,1}.mcr.data(idxSeg,idxPara) = MCR;
            
            % 4. apen
            apen = ApEn(2, 0.2*std_dev, data, 1);
%             sampen = SampEn(2, 0.2*std_dev, data, 1);
%             pen = permutationEntropy(data, 3, 10);
            tableTrendParas{i,1}.en.data(idxSeg,idxPara) = apen;

            % 5. peak values
            [~,aux] = max(abs(data));
            tableTrendParas{i,1}.maxV.data(idxSeg,idxPara) = data(aux);
            tableTrendParas{i,1}.maxT.data(idxSeg,idxPara) = t(aux);

            % 6. mean % rms
            tableTrendParas{i,1}.mean.data(idxSeg,idxPara) = mean(data);
            tableTrendParas{i,1}.rms.data(idxSeg,idxPara) = rms(data);

        end
    end
end

%% 趋势特征统计分析

for i = 1:5 % 5个阶段
    names_trend_paras = fieldnames(tableTrendParas{1,1});
    for k = 1:length(names_trend_paras)
        tableTrendParas{i,1}.(names_trend_paras{k}).mean_std = zeros(14,length(str_paras));
    end
    
    for j = 1:length(names_trend_paras)
        name = names_trend_paras{j};
        for idxSTS = 1:4
            data = tableTrendParas{i,1}.(name).data(idxs_sts{idxSTS},:);

            tableTrendParas{i,1}.(name).mean_std(idxSTS*2-1,:) = mean(data(~isnan(sum(data,2)*0),:));
            tableTrendParas{i,1}.(name).mean_std(idxSTS*2,:) = std(data(~isnan(sum(data,2)*0),:));
        end

        for idxPara = 1:length(str_paras)
            dataMT = tableTrendParas{i,1}.(name).data(idxs_sts{2},idxPara);
            dataETF = tableTrendParas{i,1}.(name).data(idxs_sts{3},idxPara);
            dataDVR = tableTrendParas{i,1}.(name).data(idxs_sts{4},idxPara);
    
            [p, h] = ranksum(dataMT,dataETF);
            tableTrendParas{i,1}.(name).mean_std(9,idxPara) = h;
            tableTrendParas{i,1}.(name).mean_std(10,idxPara) = p;
            [p, h] = ranksum(dataMT,dataDVR);
            tableTrendParas{i,1}.(name).mean_std(11,idxPara) = h;
            tableTrendParas{i,1}.(name).mean_std(12,idxPara) = p;
            [p, h] = ranksum(dataETF,dataDVR);
            tableTrendParas{i,1}.(name).mean_std(13,idxPara) = h;
            tableTrendParas{i,1}.(name).mean_std(14,idxPara) = p;
        end

    end
    
    for j = 1:length(names_trend_paras)
        tableTrendParas{i,1}.(names_trend_paras{j}).mean_std = array2table(tableTrendParas{i,1}.(names_trend_paras{j}).mean_std,...
            'RowNames', ...
            {'All mean','All std','MT mean','MT std','ETF mean','ETF std','DVR mean','DVR std', ...
            'MT-ETF h','MT-ETF p','MT_DVR h','MT_DVR p','ETF-DVR h','ETF-DVR p'},...
            'VariableNames',str_para_names);
    end

end

%% ======== Results ========

disp('======== Results ========')

%% 1.Average trend of XcoM and CoM

idxParas = [1,2];
fig_options.figure_name = 'The Average Trends of CoM and P-XcoM in Mediolateral Axis';
fig_options.legend_names = {'CoM','P-XcoM'};
fig_options.y_name = 'Position / m';
% FigureMeanAndStd(time_curves,mean_curves,std_curves,time_stages,str_para_names,idxParas,colors,fig_options);

idxParas = [3,4];
fig_options.figure_name = 'The Average Trends of CoM and P-XcoM in Anteroposterior Axis';
fig_options.legend_names = {'CoM','P-XcoM'};
fig_options.y_name = 'Position / m';
% FigureMeanAndStd(time_curves,mean_curves,std_curves,time_stages,str_para_names,idxParas,colors,fig_options);


idxParas = [1,2,3,4];
fig_options.figure_name = 'The Average Trends of CoM and P-XcoM';
fig_options.legend_names = {'ML CoM','ML P-XcoM','AP CoM','AP P-XcoM'};
fig_options.y_name = 'Position / m';
FigureMeanAndStd(time_curves,mean_curves,std_curves,time_stages,str_para_names,idxParas,colors,fig_options);


%% 2. frequency of BoS boundary exceedance for CoM and P-XcoM

tableRatiosBeyondBoS = zeros(2,4);
for i = 1:4
    cellAux = cellSegs(idxs_sts{i});
    isBeyond = zeros(length(cellAux),2);
    for j = 1:length(cellAux)
        seg = cellAux{j};
        
        aux = find(seg.dis.com_bos.dis>0,1):seg.idx.idx_end;
        
        isBeyond(j,1) = min(seg.dis.com_bos.dis(aux))<0;
        isBeyond(j,2) = min(seg.dis.xcom_bos.dis(aux))<0;
    
    end
    
    tableRatiosBeyondBoS(1,i) = sum(isBeyond(:,1))./length(isBeyond(:,1));
    tableRatiosBeyondBoS(2,i) = sum(isBeyond(:,2))./length(isBeyond(:,2));
end

tableRatiosBeyondBoS = array2table(tableRatiosBeyondBoS,'VariableNames',{'ALL','MT','ETF','DVR'},'RowNames',{'CoM','XcoM'});

%% Typical P-XcoM and CoM

seg = cellSegs{3};
PartFigureCoMXcoMBoS;

%% 3. CoM-BoS distance

idxParas = [5,6];
fig_options.figure_name = 'The Average Trends of Distance to BoS border';
fig_options.legend_names = {'CoM','P-XcoM'};
fig_options.y_name = 'Distance / m';
FigureMeanAndStd(time_curves,mean_curves,std_curves,time_stages,str_para_names,idxParas,colors,fig_options);

idxParas = [7,8,9,10];
fig_options.figure_name = 'The Average Trends of Distance to BoS Border in Axes';
fig_options.legend_names = {'CoM ML','P-XcoM ML','CoM AP','P-XcoM AP'};
fig_options.y_name = 'Distance / m';
% FigureMeanAndStd(time_curves,mean_curves,std_curves,time_stages,str_para_names,idxParas,colors,fig_options);

idxParas = [9,10];
fig_options.figure_name = 'The Average Trends of Distance to BoS Border in Y Axis';
fig_options.legend_names = {'CoM','P-XcoM'};
fig_options.y_name = 'Distance / m';
% FigureMeanAndStd(time_curves,mean_curves,std_curves,time_stages,str_para_names,idxParas,colors,fig_options);

idxParas = [13,14];
fig_options.figure_name = 'The Average Trends of Distance to Plantar BoS Back Border';
fig_options.legend_names = {'CoM','P-XcoM'};
fig_options.y_name = 'Distance / m';
% FigureMeanAndStd(time_curves,mean_curves,std_curves,time_stages,str_para_names,idxParas,colors,fig_options);

%% 4. XcoM-CoM

idxParas = [15];
fig_options.figure_name = 'The Average Trends of (P-XcoM - CoM) X';
fig_options.legend_names = {'P-XcoM - CoM'};
fig_options.y_name = 'Position / m';
% FigureMeanAndStd(time_curves,mean_curves,std_curves,time_stages,str_para_names,idxParas,colors,fig_options);

idxParas = [16];
fig_options.figure_name = 'The Average Trends of (P-XcoM - CoM) Y';
fig_options.legend_names = {'P-XcoM - CoM'};
fig_options.y_name = 'Position / m';
% FigureMeanAndStd(time_curves,mean_curves,std_curves,time_stages,str_para_names,idxParas,colors,fig_options);

%% 5. v

idxParas = [18];
fig_options.figure_name = 'The Average Trends of V x';
fig_options.legend_names = {'V_x'};
fig_options.y_name = 'Velocity / m/s';
% FigureMeanAndStd(time_curves,mean_curves,std_curves,time_stages,str_para_names,idxParas,colors,fig_options);

idxParas = [19];
fig_options.figure_name = 'The Average Trends of V y';
fig_options.legend_names = {'V_y'};
fig_options.y_name = 'Velocity / m/s';
% FigureMeanAndStd(time_curves,mean_curves,std_curves,time_stages,str_para_names,idxParas,colors,fig_options);


%% 6. z

idxParas = [20];
fig_options.figure_name = 'The Average Trends of CoM z';
fig_options.legend_names = {'CoM z'};
fig_options.y_name = 'Position / m';
% FigureMeanAndStd(time_curves,mean_curves,std_curves,time_stages,str_para_names,idxParas,colors,fig_options);

%% 7. omega

idxParas = [45];
fig_options.figure_name = 'The Average Trends of omega';
fig_options.legend_names = {'\omega_0'};
fig_options.y_name = '\omega_0 / s^-1';
% FigureMeanAndStd(time_curves,mean_curves,std_curves,time_stages,str_para_names,idxParas,colors,fig_options);

idxParas = [46];
fig_options.figure_name = 'The Average Trends of l';
fig_options.legend_names = {'l_0'};
fig_options.y_name = 'l_0 / m';
% FigureMeanAndStd(time_curves,mean_curves,std_curves,time_stages,str_para_names,idxParas,colors,fig_options);

idxParas = [47];
fig_options.figure_name = 'The Average Trends of (g-az)';
fig_options.legend_names = {'g-az'};
fig_options.y_name = 'g-az / m/s^2';
% FigureMeanAndStd(time_curves,mean_curves,std_curves,time_stages,str_para_names,idxParas,colors,fig_options);

%% 8. JRF

idxParas = [22,23,24];
fig_options.figure_name = 'The Average Trends of JRFs - Hip';
fig_options.legend_names = {'Hip x','Hip y','Hip z'};
fig_options.y_name = 'Force (% BW)';
% FigureMeanAndStd(time_curves,mean_curves,std_curves,time_stages,str_para_names,idxParas,colors,fig_options);

idxParas = [26,27,28];
fig_options.figure_name = 'The Average Trends of JRFs - Knee';
fig_options.legend_names = {'Knee x','Knee y','Knee z'};
fig_options.y_name = 'Force (% BW)';
% FigureMeanAndStd(time_curves,mean_curves,std_curves,time_stages,str_para_names,idxParas,colors,fig_options);

idxParas = [30,31,32];
fig_options.figure_name = 'The Average Trends of JRFs - Ankle';
fig_options.legend_names = {'Ankle x','Ankle y','Ankle z'};
fig_options.y_name = 'Force (% BW)';
% FigureMeanAndStd(time_curves,mean_curves,std_curves,time_stages,str_para_names,idxParas,colors,fig_options);

%% 9. JM

idxParas = [34,37,38,39];
fig_options.figure_name = 'The Average Trends of JMs';
fig_options.legend_names = {'Hip','Knee','Ankle','Lumbar'};
fig_options.y_name = 'Moment (% BW × BH)';
% FigureMeanAndStd(time_curves,mean_curves,std_curves,time_stages,str_para_names,idxParas,colors,fig_options);

%% 10. JP

idxParas = [49,52:54];
fig_options.figure_name = 'The Average Trends of JPs';
fig_options.legend_names = {'Hip','Knee','Ankle','Lumbar'};
fig_options.y_name = 'Power (% BW)';
FigureMeanAndStd(time_curves,mean_curves,std_curves,time_stages,str_para_names,idxParas,colors,fig_options);

%% 11. JW

idxParas = [57,60:62];
fig_options.figure_name = 'The Average Trends of JWs';
fig_options.legend_names = {'Hip','Knee','Ankle','Lumbar'};
fig_options.y_name = 'Work (% BW)';
FigureMeanAndStd(time_curves,mean_curves,std_curves,time_stages,str_para_names,idxParas,colors,fig_options);

idxParas = [80];
fig_options.figure_name = 'The Average Trends of JWs';
fig_options.legend_names = {'Sum'};
fig_options.y_name = 'Work (% BW)';
% FigureMeanAndStd(time_curves,mean_curves,std_curves,time_stages,str_para_names,idxParas,colors,fig_options);

% PartFigureJointPowersAndWorks;

%% Table: Correlations of P-XcoM components with dynamic parameters

tableTopValues = struct();
tableTopValues.v_y = FindCorrDynamics(tableCorrs,19);
tableTopValues.com_z = FindCorrDynamics(tableCorrs,20);
tableTopValues.v_y2 = FindCorrDynamics(tableCorrs,65);
tableTopValues.v_z2 = FindCorrDynamics(tableCorrs,66);
tableTopValues.k = FindCorrDynamics(tableCorrs,71);
tableTopValues.lambda = FindCorrDynamics(tableCorrs,78);
tableTopValues.sqrtk = FindCorrDynamics(tableCorrs,79);

%% Table: Correlations of P-XcoM components

idxs_r = [4,3,16,78];
idxs_v = [3,16,19,78,45,79];

tableComponents = zeros(length(idxs_r),length(idxs_v));
for i = 1:length(idxs_r)
    idx_r = idxs_r(i);
    for j = 1:length(idxs_v)
        idx_v = idxs_v(j);
        tableComponents(i,j) = tableCorrs.all.all.mean{idx_r,idx_v};
    end
end

tableComponents = array2table(tableComponents,'RowNames',str_para_names(idxs_r),'VariableNames',str_para_names(idxs_v));

% PartFigureComponents;

%% Assumption 1

% lw2,la,2l'w,l''

idxParas = [68,67,69,70];
fig_options.figure_name = 'The Average Trends of Angular Velocity Term and Angular Acceleration Term';
fig_options.legend_names = {'$l\alpha$','$l\omega^2$','$2\dot{l}\omega$','$\ddot{l}$'};
fig_options.y_name = '';
FigureMeanAndStd(time_curves,mean_curves,std_curves,time_stages,str_para_names,idxParas,colors,fig_options);

%% Assumption 2

idxParas = [76,71];
fig_options.figure_name = 'The Average Trends of $\omega_0^{\prime 2}$ and k';
fig_options.legend_names = {'$\omega_0^{\prime 2}$','$\ddot{l}/l$'};
fig_options.y_name = '';
FigureMeanAndStd(time_curves,mean_curves,std_curves,time_stages,str_para_names,idxParas,colors,fig_options);

%% Table: Peak values

idxParas = [4,3,16,19,78,45,79,49,52,53,54,57,60,61,62,80];
tableMaximum = tableTrendParas{1,1}.maxV.mean_std(:,idxParas);

tableStrMaximum = strings(3, length(idxParas));
for i = 1:3
    for j = 1:length(idxParas)
        str = num2str(tableMaximum{2*i+1,j},'%.2f');
        str = [str,' ± ',num2str(tableMaximum{2*i+2,j},'%.2f')];
        if i == 1
            if tableMaximum{9,j} == 1
                str = [str,' *'];
            end
            if tableMaximum{11,j} == 1
                str = [str,' #'];
            end
        elseif i == 2
            if tableMaximum{13,j} == 1
                str = [str,' ^'];
            end
        end
    tableStrMaximum(i,j) = str;
    end
end

tableStrMaximum = array2table(tableStrMaximum,'VariableNames',str_para_names(idxParas));
