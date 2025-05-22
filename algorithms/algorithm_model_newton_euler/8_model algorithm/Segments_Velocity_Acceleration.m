%% ���ؽ��˲���ֵ��֡�ʱ��100HZ������֤
function [segments_com_position,segments_com_velocity,segments_com_acceleration] = Segments_Velocity_Acceleration(kinectstream,sex,freq,copLeft,copRight)
% ���������ҽŵ�COP�����㲿���ĸ���COP
if sex == 'M'
    Lcs.HeadNeck = 1;
    Lcs.Trunk = 0.4486;
    Lcs.Upperarm = 0.5772;
    Lcs.Forearm = 0.4574;
    Lcs.Hand = 0.79;
    Lcs.Thigh = 0.4095;
    Lcs.Shank = 0.4459;
    Lcs.Foot = 0.4415;
    
    M.HeadNeck = 0.0694;
    M.Trunk = 0.4346;
    M.Upperarm = 0.0271;
    M.Forearm = 0.0162;
    M.Hand = 0.0061;
    M.Thigh = 0.1416;
    M.Shank = 0.0433;
    M.Foot = 0.0137;
elseif sex == 'F'
    Lcs.HeadNeck = 1;
    Lcs.Trunk = 0.4151;
    Lcs.Upperarm = 0.5754;
    Lcs.Forearm = 0.4559;
    Lcs.Hand = 0.7474;
    Lcs.Thigh = 0.3612;
    Lcs.Shank = 0.4416;
    Lcs.Foot = 0.4014;
    
    M.HeadNeck = 0.0669;%Ϊ�˽����شյ�100%
    M.Trunk = 0.4257;
    M.Upperarm = 0.0255;
    M.Forearm = 0.0138;
    M.Hand = 0.0056;
    M.Thigh = 0.1478;
    M.Shank = 0.0481;
    M.Foot = 0.0129;
end

%     % Evaluation of the Microsoft Kinect as a clinical assessment tool of body sway
%     Lcs.HeadNeck = 1;
%     Lcs.Trunk = 0.5;
%     Lcs.Upperarm = 0.436;
%     Lcs.Forearm = 0.430;
%     Lcs.Hand = 0.506;
%     Lcs.Thigh = 0.433;
%     Lcs.Shank = 0.433;
%     Lcs.Foot = 0.500;
%     
%     M.HeadNeck = 0.081;
%     M.Trunk = 0.355;
%     M.Upperarm = 0.028;
%     M.Forearm = 0.016;
%     M.Hand = 0.006;
%     M.Thigh = 0.142;
%     M.Shank = 0.0465;
%     M.Foot = 0.0145;

%% ���������λ��
%ͷ����

xcom_HeadNeck = (Lcs.HeadNeck * (kinectstream.HEAD.x - kinectstream.NECK.x) + kinectstream.NECK.x);
ycom_HeadNeck = (Lcs.HeadNeck * (kinectstream.HEAD.y - kinectstream.NECK.y) + kinectstream.NECK.y);
zcom_HeadNeck = (Lcs.HeadNeck * (kinectstream.HEAD.z - kinectstream.NECK.z) + kinectstream.NECK.z);

%����
xcom_Trunk = (Lcs.Trunk * ((kinectstream.HIP_LEFT.x + kinectstream.HIP_RIGHT.x)/2 - (kinectstream.SHOULDER_LEFT.x...
    +kinectstream.SHOULDER_RIGHT.x)/2)+ (kinectstream.SHOULDER_LEFT.x + kinectstream.SHOULDER_RIGHT.x)/2);
ycom_Trunk = (Lcs.Trunk * ((kinectstream.HIP_LEFT.y + kinectstream.HIP_RIGHT.y)/2 - (kinectstream.SHOULDER_LEFT.y...
    +kinectstream.SHOULDER_RIGHT.y)/2)+ (kinectstream.SHOULDER_LEFT.y + kinectstream.SHOULDER_RIGHT.y)/2);
zcom_Trunk = (Lcs.Trunk * ((kinectstream.HIP_LEFT.z + kinectstream.HIP_RIGHT.z)/2 - (kinectstream.SHOULDER_LEFT.z...
    +kinectstream.SHOULDER_RIGHT.z)/2)+ (kinectstream.SHOULDER_LEFT.z + kinectstream.SHOULDER_RIGHT.z)/2);

%�ϱ�
 %���ϱ�
xcom_Upperarm_Left = (Lcs.Upperarm * (kinectstream.ELBOW_LEFT.x - kinectstream.SHOULDER_LEFT.x) + kinectstream.SHOULDER_LEFT.x);
ycom_Upperarm_Left = (Lcs.Upperarm * (kinectstream.ELBOW_LEFT.y - kinectstream.SHOULDER_LEFT.y) + kinectstream.SHOULDER_LEFT.y);
zcom_Upperarm_Left = (Lcs.Upperarm * (kinectstream.ELBOW_LEFT.z - kinectstream.SHOULDER_LEFT.z) + kinectstream.SHOULDER_LEFT.z);
 %���ϱ�
xcom_Upperarm_Right = (Lcs.Upperarm * (kinectstream.ELBOW_RIGHT.x - kinectstream.SHOULDER_RIGHT.x) + kinectstream.SHOULDER_RIGHT.x);
ycom_Upperarm_Right = (Lcs.Upperarm * (kinectstream.ELBOW_RIGHT.y - kinectstream.SHOULDER_RIGHT.y) + kinectstream.SHOULDER_RIGHT.y);
zcom_Upperarm_Right = (Lcs.Upperarm * (kinectstream.ELBOW_RIGHT.z - kinectstream.SHOULDER_RIGHT.z) + kinectstream.SHOULDER_RIGHT.z);

%ǰ��
 %��ǰ��
xcom_Forearm_Left = (Lcs.Forearm * (kinectstream.WRIST_LEFT.x - kinectstream.ELBOW_LEFT.x) + kinectstream.ELBOW_LEFT.x);
ycom_Forearm_Left = (Lcs.Forearm * (kinectstream.WRIST_LEFT.y - kinectstream.ELBOW_LEFT.y) + kinectstream.ELBOW_LEFT.y);
zcom_Forearm_Left = (Lcs.Forearm * (kinectstream.WRIST_LEFT.z - kinectstream.ELBOW_LEFT.z) + kinectstream.ELBOW_LEFT.z);
 %��ǰ��
xcom_Forearm_Right = (Lcs.Forearm * (kinectstream.WRIST_RIGHT.x - kinectstream.ELBOW_RIGHT.x) + kinectstream.ELBOW_RIGHT.x);
ycom_Forearm_Right = (Lcs.Forearm * (kinectstream.WRIST_RIGHT.y - kinectstream.ELBOW_RIGHT.y) + kinectstream.ELBOW_RIGHT.y);
zcom_Forearm_Right = (Lcs.Forearm * (kinectstream.WRIST_RIGHT.z - kinectstream.ELBOW_RIGHT.z) + kinectstream.ELBOW_RIGHT.z);

%����
%������
xcom_Hand_Left = (Lcs.Hand * (kinectstream.HAND_LEFT.x - kinectstream.WRIST_LEFT.x) + kinectstream.WRIST_LEFT.x);
ycom_Hand_Left = (Lcs.Hand * (kinectstream.HAND_LEFT.y - kinectstream.WRIST_LEFT.y) + kinectstream.WRIST_LEFT.y);
zcom_Hand_Left = (Lcs.Hand * (kinectstream.HAND_LEFT.z - kinectstream.WRIST_LEFT.z) + kinectstream.WRIST_LEFT.z);
%������
xcom_Hand_Right = (Lcs.Hand * (kinectstream.HAND_RIGHT.x - kinectstream.WRIST_RIGHT.x) + kinectstream.WRIST_RIGHT.x);
ycom_Hand_Right = (Lcs.Hand * (kinectstream.HAND_RIGHT.y - kinectstream.WRIST_RIGHT.y) + kinectstream.WRIST_RIGHT.y);
zcom_Hand_Right = (Lcs.Hand * (kinectstream.HAND_RIGHT.z - kinectstream.WRIST_RIGHT.z) + kinectstream.WRIST_RIGHT.z);

%���� 
 %�����
xcom_Thigh_Left = (Lcs.Thigh * (kinectstream.KNEE_LEFT.x - kinectstream.HIP_LEFT.x) + kinectstream.HIP_LEFT.x);
ycom_Thigh_Left = (Lcs.Thigh * (kinectstream.KNEE_LEFT.y - kinectstream.HIP_LEFT.y) + kinectstream.HIP_LEFT.y);
zcom_Thigh_Left = (Lcs.Thigh * (kinectstream.KNEE_LEFT.z - kinectstream.HIP_LEFT.z) + kinectstream.HIP_LEFT.z);
 %�Ҵ���
xcom_Thigh_Right = (Lcs.Thigh * (kinectstream.KNEE_RIGHT.x - kinectstream.HIP_RIGHT.x) + kinectstream.HIP_RIGHT.x);
ycom_Thigh_Right = (Lcs.Thigh * (kinectstream.KNEE_RIGHT.y - kinectstream.HIP_RIGHT.y) + kinectstream.HIP_RIGHT.y);
zcom_Thigh_Right = (Lcs.Thigh * (kinectstream.KNEE_RIGHT.z - kinectstream.HIP_RIGHT.z) + kinectstream.HIP_RIGHT.z);

%С��
 %��С��
xcom_Shank_Left = (Lcs.Shank * (kinectstream.ANKLE_LEFT.x - kinectstream.KNEE_LEFT.x) + kinectstream.KNEE_LEFT.x);
ycom_Shank_Left = (Lcs.Shank * (kinectstream.ANKLE_LEFT.y - kinectstream.KNEE_LEFT.y) + kinectstream.KNEE_LEFT.y);
zcom_Shank_Left = (Lcs.Shank * (kinectstream.ANKLE_LEFT.z - kinectstream.KNEE_LEFT.z) + kinectstream.KNEE_LEFT.z);
 %��С��
xcom_Shank_Right = (Lcs.Shank * (kinectstream.ANKLE_RIGHT.x - kinectstream.KNEE_RIGHT.x) + kinectstream.KNEE_RIGHT.x);
ycom_Shank_Right = (Lcs.Shank * (kinectstream.ANKLE_RIGHT.y - kinectstream.KNEE_RIGHT.y) + kinectstream.KNEE_RIGHT.y);
zcom_Shank_Right = (Lcs.Shank * (kinectstream.ANKLE_RIGHT.z - kinectstream.KNEE_RIGHT.z) + kinectstream.KNEE_RIGHT.z);


%��
 %����
xcom_Foot_Left = (Lcs.Foot * (kinectstream.FOOT_LEFT.x - kinectstream.ANKLE_LEFT.x) +  kinectstream.ANKLE_LEFT.x);
ycom_Foot_Left = (Lcs.Foot * (kinectstream.FOOT_LEFT.y - kinectstream.ANKLE_LEFT.y) +  kinectstream.ANKLE_LEFT.y);
zcom_Foot_Left = (Lcs.Foot * (kinectstream.FOOT_LEFT.z - kinectstream.ANKLE_LEFT.z) +  kinectstream.ANKLE_LEFT.z);
 %����
xcom_Foot_Right = (Lcs.Foot * (kinectstream.FOOT_RIGHT.x - kinectstream.ANKLE_RIGHT.x) +  kinectstream.ANKLE_RIGHT.x);
ycom_Foot_Right = (Lcs.Foot * (kinectstream.FOOT_RIGHT.y - kinectstream.ANKLE_RIGHT.y) +  kinectstream.ANKLE_RIGHT.y);
zcom_Foot_Right = (Lcs.Foot * (kinectstream.FOOT_RIGHT.z - kinectstream.ANKLE_RIGHT.z) +  kinectstream.ANKLE_RIGHT.z);

if nargin>3
    xcom_Foot_Left = ones(size(xcom_Foot_Left)).*copLeft(1);
    ycom_Foot_Left = ones(size(xcom_Foot_Left)).*copLeft(2);
    zcom_Foot_Left = ones(size(xcom_Foot_Left)).*zcom_Foot_Left;

    xcom_Foot_Right = ones(size(xcom_Foot_Right)).*copRight(1);
    ycom_Foot_Right = ones(size(xcom_Foot_Right)).*copRight(2);
    zcom_Foot_Right = ones(size(xcom_Foot_Right)).*zcom_Foot_Right;
end

%% ������������ٶ� ���ٶ�
[segments_com_HeadNeck_velocity.x,segments_com_HeadNeck_acceleration.x] = Get_Com_Velocity_Acceleration(xcom_HeadNeck,freq);
[segments_com_HeadNeck_velocity.y,segments_com_HeadNeck_acceleration.y] = Get_Com_Velocity_Acceleration(ycom_HeadNeck,freq);
[segments_com_HeadNeck_velocity.z,segments_com_HeadNeck_acceleration.z] = Get_Com_Velocity_Acceleration(zcom_HeadNeck,freq);


[segments_com_Trunk_velocity.x,segments_com_Trunk_acceleration.x] = Get_Com_Velocity_Acceleration(xcom_Trunk,freq);
[segments_com_Trunk_velocity.y,segments_com_Trunk_acceleration.y] = Get_Com_Velocity_Acceleration(ycom_Trunk,freq);
[segments_com_Trunk_velocity.z,segments_com_Trunk_acceleration.z] = Get_Com_Velocity_Acceleration(zcom_Trunk,freq);


[segments_com_Upperarm_Left_velocity.x,segments_com_Upperarm_Left_acceleration.x] = Get_Com_Velocity_Acceleration(xcom_Upperarm_Left,freq);
[segments_com_Upperarm_Left_velocity.y,segments_com_Upperarm_Left_acceleration.y] = Get_Com_Velocity_Acceleration(ycom_Upperarm_Left,freq);
[segments_com_Upperarm_Left_velocity.z,segments_com_Upperarm_Left_acceleration.z] = Get_Com_Velocity_Acceleration(zcom_Upperarm_Left,freq);


[segments_com_Upperarm_Right_velocity.x,segments_com_Upperarm_Right_acceleration.x] = Get_Com_Velocity_Acceleration(xcom_Upperarm_Right,freq);
[segments_com_Upperarm_Right_velocity.y,segments_com_Upperarm_Right_acceleration.y] = Get_Com_Velocity_Acceleration(ycom_Upperarm_Right,freq);
[segments_com_Upperarm_Right_velocity.z,segments_com_Upperarm_Right_acceleration.z] = Get_Com_Velocity_Acceleration(zcom_Upperarm_Right,freq);



[segments_com_Forearm_Left_velocity.x,segments_com_Forearm_Left_acceleration.x] = Get_Com_Velocity_Acceleration(xcom_Forearm_Left,freq);
[segments_com_Forearm_Left_velocity.y,segments_com_Forearm_Left_acceleration.y] = Get_Com_Velocity_Acceleration(ycom_Forearm_Left,freq);
[segments_com_Forearm_Left_velocity.z,segments_com_Forearm_Left_acceleration.z] = Get_Com_Velocity_Acceleration(zcom_Forearm_Left,freq);




[segments_com_Forearm_Right_velocity.x,segments_com_Forearm_Right_acceleration.x] = Get_Com_Velocity_Acceleration(xcom_Forearm_Right,freq);
[segments_com_Forearm_Right_velocity.y,segments_com_Forearm_Right_acceleration.y] = Get_Com_Velocity_Acceleration(ycom_Forearm_Right,freq);
[segments_com_Forearm_Right_velocity.z,segments_com_Forearm_Right_acceleration.z] = Get_Com_Velocity_Acceleration(zcom_Forearm_Right,freq);



[segments_com_Hand_Left_velocity.x,segments_com_Hand_Left_acceleration.x] = Get_Com_Velocity_Acceleration(xcom_Hand_Left,freq);
[segments_com_Hand_Left_velocity.y,segments_com_Hand_Left_acceleration.y] = Get_Com_Velocity_Acceleration(ycom_Hand_Left,freq);
[segments_com_Hand_Left_velocity.z,segments_com_Hand_Left_acceleration.z] = Get_Com_Velocity_Acceleration(zcom_Hand_Left,freq);



[segments_com_Hand_Right_velocity.x,segments_com_Hand_Right_acceleration.x] = Get_Com_Velocity_Acceleration(xcom_Hand_Right,freq);
[segments_com_Hand_Right_velocity.y,segments_com_Hand_Right_acceleration.y] = Get_Com_Velocity_Acceleration(ycom_Hand_Right,freq);
[segments_com_Hand_Right_velocity.z,segments_com_Hand_Right_acceleration.z] = Get_Com_Velocity_Acceleration(zcom_Hand_Right,freq);



[segments_com_Thigh_Left_velocity.x,segments_com_Thigh_Left_acceleration.x] = Get_Com_Velocity_Acceleration(xcom_Thigh_Left,freq);
[segments_com_Thigh_Left_velocity.y,segments_com_Thigh_Left_acceleration.y] = Get_Com_Velocity_Acceleration(ycom_Thigh_Left,freq);
[segments_com_Thigh_Left_velocity.z,segments_com_Thigh_Left_acceleration.z] = Get_Com_Velocity_Acceleration(zcom_Thigh_Left,freq);


[segments_com_Thigh_Right_velocity.x,segments_com_Thigh_Right_acceleration.x] = Get_Com_Velocity_Acceleration(xcom_Thigh_Right,freq);
[segments_com_Thigh_Right_velocity.y,segments_com_Thigh_Right_acceleration.y] = Get_Com_Velocity_Acceleration(ycom_Thigh_Right,freq);
[segments_com_Thigh_Right_velocity.z,segments_com_Thigh_Right_acceleration.z] = Get_Com_Velocity_Acceleration(zcom_Thigh_Right,freq);



[segments_com_Shank_Left_velocity.x,segments_com_Shank_Left_acceleration.x] = Get_Com_Velocity_Acceleration(xcom_Shank_Left,freq);
[segments_com_Shank_Left_velocity.y,segments_com_Shank_Left_acceleration.y] = Get_Com_Velocity_Acceleration(ycom_Shank_Left,freq);
[segments_com_Shank_Left_velocity.z,segments_com_Shank_Left_acceleration.z] = Get_Com_Velocity_Acceleration(zcom_Shank_Left,freq);


[segments_com_Shank_Right_velocity.x,segments_com_Shank_Right_acceleration.x] = Get_Com_Velocity_Acceleration(xcom_Shank_Right,freq);
[segments_com_Shank_Right_velocity.y,segments_com_Shank_Right_acceleration.y] = Get_Com_Velocity_Acceleration(ycom_Shank_Right,freq);
[segments_com_Shank_Right_velocity.z,segments_com_Shank_Right_acceleration.z] = Get_Com_Velocity_Acceleration(zcom_Shank_Right,freq);


[segments_com_Foot_Left_velocity.x,segments_com_Foot_Left_acceleration.x] = Get_Com_Velocity_Acceleration(xcom_Foot_Left,freq);
[segments_com_Foot_Left_velocity.y,segments_com_Foot_Left_acceleration.y] = Get_Com_Velocity_Acceleration(ycom_Foot_Left,freq);
[segments_com_Foot_Left_velocity.z,segments_com_Foot_Left_acceleration.z] = Get_Com_Velocity_Acceleration(zcom_Foot_Left,freq);


[segments_com_Foot_Right_velocity.x,segments_com_Foot_Right_acceleration.x] = Get_Com_Velocity_Acceleration(xcom_Foot_Right,freq);
[segments_com_Foot_Right_velocity.y,segments_com_Foot_Right_acceleration.y] = Get_Com_Velocity_Acceleration(ycom_Foot_Right,freq);
[segments_com_Foot_Right_velocity.z,segments_com_Foot_Right_acceleration.z] = Get_Com_Velocity_Acceleration(zcom_Foot_Right,freq);
%% �����������λ��
xcom_human = xcom_HeadNeck*M.HeadNeck + xcom_Trunk*M.Trunk + xcom_Upperarm_Left*M.Upperarm + xcom_Upperarm_Right*M.Upperarm + xcom_Forearm_Left*M.Forearm + xcom_Forearm_Right*M.Forearm...
    + xcom_Hand_Left*M.Hand + xcom_Hand_Right*M.Hand + xcom_Thigh_Left*M.Thigh + xcom_Thigh_Right*M.Thigh + xcom_Shank_Left*M.Shank + xcom_Shank_Right*M.Shank...
    + xcom_Foot_Left*M.Foot + xcom_Foot_Right*M.Foot;

ycom_human = ycom_HeadNeck*M.HeadNeck + ycom_Trunk*M.Trunk + ycom_Upperarm_Left*M.Upperarm + ycom_Upperarm_Right*M.Upperarm + ycom_Forearm_Left*M.Forearm + ycom_Forearm_Right*M.Forearm...
    + ycom_Hand_Left*M.Hand + ycom_Hand_Right*M.Hand + ycom_Thigh_Left*M.Thigh + ycom_Thigh_Right*M.Thigh + ycom_Shank_Left*M.Shank + ycom_Shank_Right*M.Shank...
    + ycom_Foot_Left*M.Foot + ycom_Foot_Right*M.Foot;

zcom_human = zcom_HeadNeck*M.HeadNeck + zcom_Trunk*M.Trunk + zcom_Upperarm_Left*M.Upperarm + zcom_Upperarm_Right*M.Upperarm + zcom_Forearm_Left*M.Forearm + zcom_Forearm_Right*M.Forearm...
    + zcom_Hand_Left*M.Hand + zcom_Hand_Right*M.Hand + zcom_Thigh_Left*M.Thigh + zcom_Thigh_Right*M.Thigh + zcom_Shank_Left*M.Shank + zcom_Shank_Right*M.Shank...
    + zcom_Foot_Left*M.Foot + zcom_Foot_Right*M.Foot;

%% ���������ٶ�,���ٶ�
[segments_com_human_velocity.x,segments_com_human_acceleration.x] = Get_Com_Velocity_Acceleration(xcom_human,freq);
[segments_com_human_velocity.y,segments_com_human_acceleration.y] = Get_Com_Velocity_Acceleration(ycom_human,freq);
[segments_com_human_velocity.z,segments_com_human_acceleration.z] = Get_Com_Velocity_Acceleration(zcom_human,freq);


%% ���Ͻ��
%����λ��
segments_com_position.HeadNeck.x = xcom_HeadNeck;
segments_com_position.HeadNeck.y = ycom_HeadNeck;
segments_com_position.HeadNeck.z = zcom_HeadNeck;

segments_com_position.Trunk.x = xcom_Trunk;
segments_com_position.Trunk.y = ycom_Trunk;
segments_com_position.Trunk.z = zcom_Trunk;

segments_com_position.Upperarm_Left.x = xcom_Upperarm_Left;
segments_com_position.Upperarm_Left.y = ycom_Upperarm_Left;
segments_com_position.Upperarm_Left.z = zcom_Upperarm_Left;

segments_com_position.Upperarm_Right.x = xcom_Upperarm_Right;
segments_com_position.Upperarm_Right.y = ycom_Upperarm_Right;
segments_com_position.Upperarm_Right.z = zcom_Upperarm_Right;

segments_com_position.Forearm_Left.x = xcom_Forearm_Left;
segments_com_position.Forearm_Left.y = ycom_Forearm_Left;
segments_com_position.Forearm_Left.z = zcom_Forearm_Left;

segments_com_position.Forearm_Right.x = xcom_Forearm_Right;
segments_com_position.Forearm_Right.y = ycom_Forearm_Right;
segments_com_position.Forearm_Right.z = zcom_Forearm_Right;


segments_com_position.Hand_Left.x = xcom_Hand_Left;
segments_com_position.Hand_Left.y = ycom_Hand_Left;
segments_com_position.Hand_Left.z = zcom_Hand_Left;

segments_com_position.Hand_Right.x = xcom_Hand_Right;
segments_com_position.Hand_Right.y = ycom_Hand_Right;
segments_com_position.Hand_Right.z = zcom_Hand_Right;

segments_com_position.Thigh_Left.x = xcom_Thigh_Left;
segments_com_position.Thigh_Left.y = ycom_Thigh_Left;
segments_com_position.Thigh_Left.z = zcom_Thigh_Left;

segments_com_position.Thigh_Right.x = xcom_Thigh_Right;
segments_com_position.Thigh_Right.y = ycom_Thigh_Right;
segments_com_position.Thigh_Right.z = zcom_Thigh_Right;

segments_com_position.Shank_Left.x = xcom_Shank_Left;
segments_com_position.Shank_Left.y = ycom_Shank_Left;
segments_com_position.Shank_Left.z = zcom_Shank_Left;

segments_com_position.Shank_Right.x = xcom_Shank_Right;
segments_com_position.Shank_Right.y = ycom_Shank_Right;
segments_com_position.Shank_Right.z = zcom_Shank_Right;

segments_com_position.Foot_Left.x = xcom_Foot_Left;
segments_com_position.Foot_Left.y = ycom_Foot_Left;
segments_com_position.Foot_Left.z = zcom_Foot_Left;

segments_com_position.Foot_Right.x = xcom_Foot_Right;
segments_com_position.Foot_Right.y = ycom_Foot_Right;
segments_com_position.Foot_Right.z = zcom_Foot_Right;

segments_com_position.human.x = xcom_human;
segments_com_position.human.y = ycom_human;
segments_com_position.human.z = zcom_human;

%�ٶ�
segments_com_velocity.HeadNeck = segments_com_HeadNeck_velocity;
segments_com_velocity.Trunk = segments_com_Trunk_velocity;
segments_com_velocity.Upperarm_Left = segments_com_Upperarm_Left_velocity;
segments_com_velocity.Upperarm_Right = segments_com_Upperarm_Right_velocity;
segments_com_velocity.Forearm_Left = segments_com_Forearm_Left_velocity;
segments_com_velocity.Forearm_Right = segments_com_Forearm_Right_velocity;
segments_com_velocity.Hand_Left = segments_com_Hand_Left_velocity;
segments_com_velocity.Hand_Right = segments_com_Hand_Right_velocity;
segments_com_velocity.Thigh_Left = segments_com_Thigh_Left_velocity;
segments_com_velocity.Thigh_Right = segments_com_Thigh_Right_velocity;
segments_com_velocity.Shank_Left = segments_com_Shank_Left_velocity;
segments_com_velocity.Shank_Right = segments_com_Shank_Right_velocity;
segments_com_velocity.Foot_Left = segments_com_Foot_Left_velocity;
segments_com_velocity.Foot_Right = segments_com_Foot_Right_velocity;
segments_com_velocity.human = segments_com_human_velocity;
%���ٶ�
segments_com_acceleration.HeadNeck = segments_com_HeadNeck_acceleration;
segments_com_acceleration.Trunk = segments_com_Trunk_acceleration;
segments_com_acceleration.Upperarm_Left = segments_com_Upperarm_Left_acceleration;
segments_com_acceleration.Upperarm_Right = segments_com_Upperarm_Right_acceleration;
segments_com_acceleration.Forearm_Left = segments_com_Forearm_Left_acceleration;
segments_com_acceleration.Forearm_Right = segments_com_Forearm_Right_acceleration;
segments_com_acceleration.Hand_Left = segments_com_Hand_Left_acceleration;
segments_com_acceleration.Hand_Right = segments_com_Hand_Right_acceleration;
segments_com_acceleration.Thigh_Left = segments_com_Thigh_Left_acceleration;
segments_com_acceleration.Thigh_Right = segments_com_Thigh_Right_acceleration;
segments_com_acceleration.Shank_Left = segments_com_Shank_Left_acceleration;
segments_com_acceleration.Shank_Right = segments_com_Shank_Right_acceleration;
segments_com_acceleration.Foot_Left = segments_com_Foot_Left_acceleration;
segments_com_acceleration.Foot_Right = segments_com_Foot_Right_acceleration;
segments_com_acceleration.human = segments_com_human_acceleration;


%% ��֤
x_zero = segments_com_acceleration.human.x - (segments_com_acceleration.HeadNeck.x*M.HeadNeck + segments_com_acceleration.Trunk.x*M.Trunk + segments_com_acceleration.Upperarm_Left.x*M.Upperarm + segments_com_acceleration.Upperarm_Right.x*M.Upperarm + segments_com_acceleration.Forearm_Left.x*M.Forearm + segments_com_acceleration.Forearm_Right.x*M.Forearm...
    + segments_com_acceleration.Hand_Left.x*M.Hand + segments_com_acceleration.Hand_Right.x*M.Hand + segments_com_acceleration.Thigh_Left.x*M.Thigh + segments_com_acceleration.Thigh_Right.x*M.Thigh + segments_com_acceleration.Shank_Left.x*M.Shank + segments_com_acceleration.Shank_Right.x*M.Shank...
    + segments_com_acceleration.Foot_Left.x*M.Foot + segments_com_acceleration.Foot_Right.x*M.Foot);

y_zero = segments_com_acceleration.human.y - (segments_com_acceleration.HeadNeck.y*M.HeadNeck + segments_com_acceleration.Trunk.y*M.Trunk + segments_com_acceleration.Upperarm_Left.y*M.Upperarm + segments_com_acceleration.Upperarm_Right.y*M.Upperarm + segments_com_acceleration.Forearm_Left.y*M.Forearm + segments_com_acceleration.Forearm_Right.y*M.Forearm...
    + segments_com_acceleration.Hand_Left.y*M.Hand + segments_com_acceleration.Hand_Right.y*M.Hand + segments_com_acceleration.Thigh_Left.y*M.Thigh + segments_com_acceleration.Thigh_Right.y*M.Thigh + segments_com_acceleration.Shank_Left.y*M.Shank + segments_com_acceleration.Shank_Right.y*M.Shank...
    + segments_com_acceleration.Foot_Left.y*M.Foot + segments_com_acceleration.Foot_Right.y*M.Foot);

z_zero = segments_com_acceleration.human.z - (segments_com_acceleration.HeadNeck.z*M.HeadNeck + segments_com_acceleration.Trunk.z*M.Trunk + segments_com_acceleration.Upperarm_Left.z*M.Upperarm + segments_com_acceleration.Upperarm_Right.z*M.Upperarm + segments_com_acceleration.Forearm_Left.z*M.Forearm + segments_com_acceleration.Forearm_Right.z*M.Forearm...
    + segments_com_acceleration.Hand_Left.z*M.Hand + segments_com_acceleration.Hand_Right.z*M.Hand + segments_com_acceleration.Thigh_Left.z*M.Thigh + segments_com_acceleration.Thigh_Right.z*M.Thigh + segments_com_acceleration.Shank_Left.z*M.Shank + segments_com_acceleration.Shank_Right.z*M.Shank...
    + segments_com_acceleration.Foot_Left.z*M.Foot + segments_com_acceleration.Foot_Right.z*M.Foot);

