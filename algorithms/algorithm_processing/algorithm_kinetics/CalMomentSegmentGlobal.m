function [moment_couple_global_new] = CalMomentSegmentGlobal(M,weight,gender,kinectstream,segments_RM,segments_W_L,segments_Alpha_L)
SegmentNames = {'HeadNeck','Trunk','Upperarm','Forearm','Hand','Thigh','Shank','Foot'};
SegmentLRNames = {'HeadNeck','Trunk','Upperarm_Left','Forearm_Left','Hand_Left','Thigh_Left','Shank_Left','Foot_Left',...
    'Upperarm_Right','Forearm_Right','Hand_Right','Thigh_Right','Shank_Right','Foot_Right'};
lengthStream = length(kinectstream.wtime);
%% 计算各体段长度
% 转动惯量，分为3个方向，绕着Sagittal，Transverse，Longitudinal（长轴方向），一般分别指绕着Y，X，Z，
% 脚（Foot）除外，脚的Sagittal，Transverse，Longitudinal 指， Z，X，Y
for i = 1:length(SegmentNames)
    Moment_of_Inertia.(SegmentNames{i}) = zeros(3,3);
end

Segments_Length = Get_Segments_Length_Struct(kinectstream);
if gender == 'M'
    % 绕x轴
    Moment_of_Inertia.HeadNeck(1,1) = (Segments_Length.HeadNeck)^2 * 0.376*0.376;
    Moment_of_Inertia.Trunk(1,1) = (Segments_Length.Trunk)^2 * 0.347*0.347;
    Moment_of_Inertia.Upperarm(1,1) = (Segments_Length.Upperarm)^2 * 0.269*0.269;
    Moment_of_Inertia.Forearm(1,1) = (Segments_Length.Forearm)^2 * 0.265*0.265;
    Moment_of_Inertia.Hand(1,1) = (Segments_Length.Hand)^2 * 0.513*0.513;
    Moment_of_Inertia.Thigh(1,1) = (Segments_Length.Thigh)^2 * 0.329*0.329;
    Moment_of_Inertia.Shank(1,1) = (Segments_Length.Shank)^2 * 0.249*0.249;
    Moment_of_Inertia.Foot(1,1) = (Segments_Length.Foot)^2 * 0.245*0.245;  %Transverse
    %绕y轴
    Moment_of_Inertia.HeadNeck(2,2) = (Segments_Length.HeadNeck)^2 * 0.362*0.362;
    Moment_of_Inertia.Trunk(2,2) = (Segments_Length.Trunk)^2 * 0.372*0.372;
    Moment_of_Inertia.Upperarm(2,2) = (Segments_Length.Upperarm)^2 * 0.285*0.285;
    Moment_of_Inertia.Forearm(2,2) = (Segments_Length.Forearm)^2 * 0.276*0.276;
    Moment_of_Inertia.Hand(2,2) = (Segments_Length.Hand)^2 * 0.628*0.628;
    Moment_of_Inertia.Thigh(2,2) = (Segments_Length.Thigh)^2 * 0.329*0.329;
    Moment_of_Inertia.Shank(2,2) = (Segments_Length.Shank)^2 * 0.255*0.255;
    %Moment_of_Inertia.Foot(2,2) = (Segments_Length.Foot)^2 * 0.124*0.124;  %Longitudinal
    %绕z轴
    %     Moment_of_Inertia.HeadNeck(3,3) = (Segments_Length.HeadNeck)^2 * 0.312*0.312;
         Moment_of_Inertia.Trunk(3,3) = (Segments_Length.Trunk)^2 * 0.191*0.191;
    %     Moment_of_Inertia.Upperarm(3,3) = (Segments_Length.Upperarm)^2 * 0.158*0.158;
    %     Moment_of_Inertia.Forearm(3,3) = (Segments_Length.Forearm)^2 * 0.121*0.121;
    %     Moment_of_Inertia.Hand(3,3) = (Segments_Length.Hand)^2 * 0.401*0.401;
    %     Moment_of_Inertia.Thigh(3,3) = (Segments_Length.Thigh)^2 * 0.149*0.149;
    %     Moment_of_Inertia.Shank(3,3) = (Segments_Length.Shank)^2 * 0.103*0.103;
    Moment_of_Inertia.Foot(3,3) = (Segments_Length.Foot)^2 * 0.257*0.257;  %Sagittal
else
    % 绕x轴
    Moment_of_Inertia.HeadNeck(1,1) = (Segments_Length.HeadNeck)^2 * 0.359*0.359;
    Moment_of_Inertia.Trunk(1,1) = (Segments_Length.Trunk)^2 * 0.339*0.339;
    Moment_of_Inertia.Upperarm(1,1) = (Segments_Length.Upperarm)^2 * 0.260*0.260;
    Moment_of_Inertia.Forearm(1,1) = (Segments_Length.Forearm)^2 * 0.257*0.257;
    Moment_of_Inertia.Hand(1,1) = (Segments_Length.Hand)^2 * 0.454*0.454;
    Moment_of_Inertia.Thigh(1,1) = (Segments_Length.Thigh)^2 * 0.364*0.364;
    Moment_of_Inertia.Shank(1,1) = (Segments_Length.Shank)^2 * 0.267*0.267;
    Moment_of_Inertia.Foot(1,1) = (Segments_Length.Foot)^2 * 0.279*0.279;  %Transverse
    %绕y轴
    Moment_of_Inertia.HeadNeck(2,2) = (Segments_Length.HeadNeck)^2 * 0.330*0.330;
    Moment_of_Inertia.Trunk(2,2) = (Segments_Length.Trunk)^2 * 0.357*0.357;
    Moment_of_Inertia.Upperarm(2,2) = (Segments_Length.Upperarm)^2 * 0.278*0.278;
    Moment_of_Inertia.Forearm(2,2) = (Segments_Length.Forearm)^2 * 0.261*0.261;
    Moment_of_Inertia.Hand(2,2) = (Segments_Length.Hand)^2 * 0.531*0.531;
    Moment_of_Inertia.Thigh(2,2) = (Segments_Length.Thigh)^2 * 0.369*0.369;
    Moment_of_Inertia.Shank(2,2) = (Segments_Length.Shank)^2 * 0.271*0.271;
    %Moment_of_Inertia.Foot(2,2) = (Segments_Length.Foot)^2 * 0.139*0.139;  %Longitudinal
    %绕z轴
    %     Moment_of_Inertia.HeadNeck(3,3) = (Segments_Length.HeadNeck)^2 * 0.318*0.318;
         Moment_of_Inertia.Trunk(3,3) = (Segments_Length.Trunk)^2 * 0.171*0.171;
    %     Moment_of_Inertia.Upperarm(3,3) = (Segments_Length.Upperarm)^2 * 0.148*0.148;
    %     Moment_of_Inertia.Forearm(3,3) = (Segments_Length.Forearm)^2 * 0.094*0.094;
    %     Moment_of_Inertia.Hand(3,3) = (Segments_Length.Hand)^2 * 0.335*0.335;
    %     Moment_of_Inertia.Thigh(3,3) = (Segments_Length.Thigh)^2 * 0.162*0.162;
    %     Moment_of_Inertia.Shank(3,3) = (Segments_Length.Shank)^2 * 0.093*0.093;
    Moment_of_Inertia.Foot(3,3) = (Segments_Length.Foot)^2 * 0.299*0.299;   %Sagittal
end

%% 各体段绕质心旋转所需的力偶矩，格式3*1
for i=1:lengthStream
    for j = 1:length(SegmentLRNames)
        nameLR = SegmentLRNames{j};
        if contains(nameLR,'_')
            name = nameLR(1:strfind(nameLR,'_')-1);
        else
            name = nameLR;
        end
        % 局部坐标系
        moment_couple_local.(nameLR){i} = (weight * M.(name) * Moment_of_Inertia.(name)) * ...
            [segments_Alpha_L.(nameLR){i}(3,2);segments_Alpha_L.(nameLR){i}(1,3);segments_Alpha_L.(nameLR){i}(2,1)]...
            + segments_W_L.(nameLR){i} * (weight * M.(name) * Moment_of_Inertia.(name)) * ...
            [segments_W_L.(nameLR){i}(3,2);segments_W_L.(nameLR){i}(1,3);segments_W_L.(nameLR){i}(2,1)];
        % 全局坐标系
        moment_couple_global.(nameLR){i} = segments_RM.(nameLR){i} * moment_couple_local.(nameLR){i};
    end
end

%% 转化为xyz
names = fieldnames(moment_couple_global);
for i = 1:length(names)
    name = names{i};
    for j = 1:lengthStream
        moment_couple_global_new.(name).x(j,1) = moment_couple_global.(name){1,j}(1);
        moment_couple_global_new.(name).y(j,1) = moment_couple_global.(name){1,j}(2);
        moment_couple_global_new.(name).z(j,1) = moment_couple_global.(name){1,j}(3);
    end
end