function [hipLeftOptimized,hipRightOptimized,vectorHip2Kinect,ptsLeft,ptsRight,ptsRealLeftRot,ptsRealRightRot] = GetHipPos2Kinect(streamInter,posCOMSegments,...
    pressureHip2DInter,grfPlantar_F,jointForces,height)
flagOptimization = 2; % 1，左右分别最优化；2，左右同时最优化

[mid,ischialLeft,ischialRight,idxSitStable,ptsLeft,ptsRight] = GetHipMidAndPressureLR(pressureHip2DInter,streamInter,grfPlantar_F,height);
% 阵列每个单元格中心的实际位置，以左后单元左后顶点为坐标系原点，x向右，y向前
matrixRealX = ((1:32)'-0.5).*11.5/1000; matrixRealY = matrixRealX; % 单位m
ptsRealLeft = [matrixRealX(ptsLeft(:,1)),matrixRealY(ptsLeft(:,2))];
ptsRealRight = [matrixRealX(ptsRight(:,1)),matrixRealY(ptsRight(:,2))];

%% Kinect系下髋关节位置
hipLeftKinect = mean([streamInter.HIP_LEFT.x(idxSitStable),streamInter.HIP_LEFT.y(idxSitStable),streamInter.HIP_LEFT.z(idxSitStable)]);
hipRightKinect = mean([streamInter.HIP_RIGHT.x(idxSitStable),streamInter.HIP_RIGHT.y(idxSitStable),streamInter.HIP_RIGHT.z(idxSitStable)]);
thighCOMLeftKinect = mean([posCOMSegments.Thigh_Left.x(idxSitStable),posCOMSegments.Thigh_Left.y(idxSitStable),posCOMSegments.Thigh_Left.z(idxSitStable)]);
thighCOMRightKinect = mean([posCOMSegments.Thigh_Right.x(idxSitStable),posCOMSegments.Thigh_Right.y(idxSitStable),posCOMSegments.Thigh_Right.z(idxSitStable)]);

%% 最优化：总力矩最小
options = optimoptions('fminunc', 'Algorithm', 'quasi-newton','Display','notify'); % 优化参数
% 计算Thigh远端力矩
momentsShank2ThighLeft = zeros(length(streamInter.wtime),3);
momentsShank2ThighRight = zeros(length(streamInter.wtime),3);
for i = 1:length(streamInter.wtime)
    momentsShank2ThighLeft(i,:) = cross([streamInter.KNEE_LEFT.x(i),streamInter.KNEE_LEFT.y(i),streamInter.KNEE_LEFT.z(i)]-...
        [posCOMSegments.Thigh_Left.x(i),posCOMSegments.Thigh_Left.y(i),posCOMSegments.Thigh_Left.z(i)],...
        [jointForces.reaction_force_Thigh_Left_distal.x(i),jointForces.reaction_force_Thigh_Left_distal.y(i),jointForces.reaction_force_Thigh_Left_distal.z(i)]);

    momentsShank2ThighRight(i,:) = cross([streamInter.KNEE_RIGHT.x(i),streamInter.KNEE_RIGHT.y(i),streamInter.KNEE_RIGHT.z(i)]-...
        [posCOMSegments.Thigh_Right.x(i),posCOMSegments.Thigh_Right.y(i),posCOMSegments.Thigh_Right.z(i)],...
        [jointForces.reaction_force_Thigh_Right_distal.x(i),jointForces.reaction_force_Thigh_Right_distal.y(i),jointForces.reaction_force_Thigh_Right_distal.z(i)]);
end
if flagOptimization == 1
    % 左髋
    initialGuessLeft = [matrixRealX(ischialLeft(1,2)),matrixRealY(33-ischialLeft(1,1)),mean(streamInter.HIP_LEFT.z(idxSitStable))-0.53];
    thighCOMLeftOptimized = fminunc(@(params) ThighCOMOptimization(params,ptsLeft,ptsRealLeft,pressureHip2DInter,...
        momentsShank2ThighLeft,idxSitStable,mid),initialGuessLeft,options);
    hipLeftOptimized = thighCOMLeftOptimized-thighCOMLeftKinect+hipLeftKinect;
    
    % 右髋
    initialGuessRight = [matrixRealX(ischialRight(1,2)),matrixRealY(33-ischialRight(1,1)),mean(streamInter.HIP_RIGHT.z(idxSitStable))-0.53];
    thighCOMRightOptimized = fminunc(@(params) ThighCOMOptimization(params,ptsRight,ptsRealRight,pressureHip2DInter,...
        momentsShank2ThighRight,idxSitStable,mid),initialGuessRight,options);
    hipRightOptimized = thighCOMRightOptimized-thighCOMRightKinect+hipRightKinect;
else
    vecLeft2Right = thighCOMRightKinect-thighCOMLeftKinect;
    vecLeft2RightRot = [norm(vecLeft2Right(1:2)),0,vecLeft2Right(3)];
    rotAngle = asind(cross(vecLeft2RightRot,vecLeft2Right)./(norm(vecLeft2Right)*norm(vecLeft2RightRot))); 
    rotAngle = rotAngle(3);% 绕z轴旋转的角度

    % 将阵列点在Kinect下坐标，旋转到左右坐骨结节和左右大腿质心平行
    ptsRealLeftRot(:,1) = ptsRealLeft(:,1)*cosd(rotAngle)-ptsRealLeft(:,2)*sind(rotAngle);
    ptsRealLeftRot(:,2) = ptsRealLeft(:,1)*sind(rotAngle)+ptsRealLeft(:,2)*cosd(rotAngle);
    ptsRealRightRot(:,1) = ptsRealRight(:,1)*cosd(rotAngle)-ptsRealRight(:,2)*sind(rotAngle);
    ptsRealRightRot(:,2) = ptsRealRight(:,1)*sind(rotAngle)+ptsRealRight(:,2)*cosd(rotAngle);

%     figure; 
%     subplot(2,1,1); hold on;
%     scatter(ptsRealLeft(:,1),ptsRealLeft(:,2));
%     scatter(ptsRealRight(:,1),ptsRealRight(:,2)); title('旋转前');
%     subplot(2,1,2); hold on;
%     scatter(ptsRealLeftRot(:,1),ptsRealLeftRot(:,2));
%     scatter(ptsRealRightRot(:,1),ptsRealRightRot(:,2)); title('旋转后');

    initialGuessLeft = [matrixRealX(ischialLeft(1,2)),matrixRealY(33-ischialLeft(1,1)),mean(streamInter.HIP_LEFT.z(idxSitStable))-0.53];
    initialGuessRight = initialGuessLeft+vecLeft2Right;
    thighCOMLeftOptimized = fminunc(@(params) ThighCOMLROptimization(params,ptsLeft,ptsRealLeftRot,ptsRight,ptsRealRightRot,pressureHip2DInter,...
    momentsShank2ThighLeft,momentsShank2ThighRight,vecLeft2Right,idxSitStable,mid),initialGuessLeft,options);
    thighCOMRightOptimized = thighCOMLeftOptimized+vecLeft2Right;
    hipLeftOptimized = thighCOMLeftOptimized-thighCOMLeftKinect+hipLeftKinect;
    hipRightOptimized = thighCOMRightOptimized-thighCOMRightKinect+hipRightKinect;
end

%% 阵列系到Kinect系平移向量
vectorHip2Kinect = ((hipLeftKinect+hipRightKinect)-(hipLeftOptimized+hipRightOptimized))./2;

figure; 
scatter3(ptsRealLeftRot(:,1),ptsRealLeftRot(:,2),zeros(size(ptsRealLeftRot(:,1)))); hold on;
scatter3(ptsRealRightRot(:,1),ptsRealRightRot(:,2),zeros(size(ptsRealRightRot(:,1))));
plot3(hipLeftOptimized(1),hipLeftOptimized(2),hipLeftOptimized(3),'ro');
plot3(hipRightOptimized(1),hipRightOptimized(2),hipRightOptimized(3),'ro');
plot3(thighCOMLeftOptimized(1),thighCOMLeftOptimized(2),thighCOMLeftOptimized(3),'g*');
plot3(thighCOMRightOptimized(1),thighCOMRightOptimized(2),thighCOMRightOptimized(3),'g*');
plot3(hipLeftKinect(1)-vectorHip2Kinect(1),hipLeftKinect(2)-vectorHip2Kinect(2),hipLeftKinect(3)-vectorHip2Kinect(3),'bo');
plot3(hipRightKinect(1)-vectorHip2Kinect(1),hipRightKinect(2)-vectorHip2Kinect(2),hipRightKinect(3)-vectorHip2Kinect(3),'bo');
hold off; xlim([min(matrixRealX),max(matrixRealX)]); ylim([min(matrixRealY),max(matrixRealY)]);
axis equal;
title('阵列系下髋关节位置'); legend('左臀作用点','右臀作用点','左 阵列','右 阵列','左 大腿质心','右 大腿质心','左 Kinect','右 Kinect');

% ptsRealLeftRot = ptsRealLeft; ptsRealRightRot = ptsRealRight;