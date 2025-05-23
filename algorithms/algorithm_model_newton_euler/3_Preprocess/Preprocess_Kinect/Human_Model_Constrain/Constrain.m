% c为非线性不等式，ceq为非线性等式
function  [c,ceq]  = Constrain(joints_position_model,segments_length)
% 1PELVIS 2HEAD 3SHOULDER 4ELBOWL 5WRISTL 6HANDL 7SHOULDERR 8ELBOWR 9WRISTR
% 10HANDR 11HIPL 12KNEEL 13ANKLEL 14FOOTL 15HIPR 16KNEER 17ANKLER 18FOOTR 19CLAVICLE
% 体段长度限制
% ceq = [];
% 包括手的
% ceq = (norm(joints_position_model(2,:) - joints_position_model(19,:)) - segments_length.HeadNeck)^2 + ...
%     (norm((joints_position_model(11,:) + joints_position_model(15,:)) / 2 - ...
%     (joints_position_model(3,:) + joints_position_model(7,:)) / 2) - segments_length.Trunk)^2 + ...
%     (norm(joints_position_model(3,:) - joints_position_model(4,:)) - segments_length.Upperarm)^2 + ...
%     (norm(joints_position_model(7,:) - joints_position_model(8,:)) - segments_length.Upperarm)^2 + ...
%     (norm(joints_position_model(4,:) - joints_position_model(5,:)) - segments_length.Forearm)^2 + ...
%     (norm(joints_position_model(8,:) - joints_position_model(9,:)) - segments_length.Forearm)^2 + ...
%     (norm(joints_position_model(11,:) - joints_position_model(12,:)) - segments_length.Thigh)^2 + ...
%     (norm(joints_position_model(15,:) - joints_position_model(16,:)) - segments_length.Thigh)^2 + ...
%     (norm(joints_position_model(12,:) - joints_position_model(13,:)) - segments_length.Shank)^2 + ...
%     (norm(joints_position_model(16,:) - joints_position_model(17,:)) - segments_length.Shank)^2 + ...
%     (norm(joints_position_model(5,:) - joints_position_model(6,:)) - segments_length.Hand)^2 + ...
%     (norm(joints_position_model(9,:) - joints_position_model(10,:)) - segments_length.Hand)^2 + ...
%     (norm(joints_position_model(13,:) - joints_position_model(14,:)) - segments_length.Foot)^2 +...
%     (norm(joints_position_model(17,:) - joints_position_model(18,:)) - segments_length.Foot)^2;

ceq = (norm(joints_position_model(2,:) - joints_position_model(19,:)) - segments_length.HeadNeck)^2 + ...
    (norm((joints_position_model(11,:) + joints_position_model(15,:)) / 2 - ...
    (joints_position_model(3,:) + joints_position_model(7,:)) / 2) - segments_length.Trunk)^2 + ...
    (norm(joints_position_model(3,:) - joints_position_model(4,:)) - segments_length.Upperarm)^2 + ...
    (norm(joints_position_model(7,:) - joints_position_model(8,:)) - segments_length.Upperarm)^2 + ...
    (norm(joints_position_model(4,:) - joints_position_model(5,:)) - segments_length.Forearm)^2 + ...
    (norm(joints_position_model(8,:) - joints_position_model(9,:)) - segments_length.Forearm)^2 + ...
    (norm(joints_position_model(11,:) - joints_position_model(12,:)) - segments_length.Thigh)^2 + ...
    (norm(joints_position_model(15,:) - joints_position_model(16,:)) - segments_length.Thigh)^2 + ...
    (norm(joints_position_model(12,:) - joints_position_model(13,:)) - segments_length.Shank)^2 + ...
    (norm(joints_position_model(16,:) - joints_position_model(17,:)) - segments_length.Shank)^2 + ...
    (norm(joints_position_model(13,:) - joints_position_model(14,:)) - segments_length.Foot)^2 +...
    (norm(joints_position_model(17,:) - joints_position_model(18,:)) - segments_length.Foot)^2;

%% 膝关节
shankL = joints_position_model(13,:) - joints_position_model(12,:);
thighL = joints_position_model(12,:) - joints_position_model(11,:);
shankR = joints_position_model(17,:) - joints_position_model(16,:);
thighR = joints_position_model(16,:) - joints_position_model(15,:);

orientationKneeL = cross(thighL,shankL);
orientationKneeR = cross(thighR,shankR);
    
c(1) = orientationKneeL(1); % X轴应小于0
c(2) = orientationKneeR(1);
%% 踝关节
footL = joints_position_model(14,:) - joints_position_model(13,:);
footR = joints_position_model(18,:) - joints_position_model(17,:);

orientationAnkleL = cross(footL,shankL);
orientationAnkleR = cross(footR,shankR);
% 矢状面方向
c(3) = orientationAnkleL(1);
c(4) = orientationAnkleR(1);

% 左右转角
A = [0 1 0];
B = [footL(1),footL(2),0];
angleAnkleL = acosd(dot(A, B) / (norm(A) * norm(B)));

A = [0 1 0];
B = [footR(1),footR(2),0];
angleAnkleR = acosd(dot(A, B) / (norm(A) * norm(B)));

c(5) = angleAnkleL - 30;
c(6) = angleAnkleR - 30;

% 背屈角度
angleAnkleL = rad2deg(acos(dot(footL, shankL) / (norm(footL) * norm(shankL))));
% c(7) = 60 - angleAnkleL;
c(8) = angleAnkleL - 120;

angleAnkleR = rad2deg(acos(dot(footR, shankR) / (norm(footR) * norm(shankR))));
% c(9) = 60 - angleAnkleR;
c(10) = angleAnkleR - 120;

end