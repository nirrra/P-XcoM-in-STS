% 根据足底阵列到Kinect的位移计算臀底阵列到Kinect的位移，另外根据中线位置修正X轴位移
function [vectorHip2Kinect,ptsLeft,ptsRight,ptsRealLeft,ptsRealRight] = GetHipPos2Kinect_PlantarReference(streamInter,posCOMSegments,vectorPlantar2Kinect,...
    pressureHip2DInter,grfPlantar_F,height)

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

midH = matrixRealX(mid);
midK = (thighCOMLeftKinect+thighCOMRightKinect)./2; midK = midK(1);

vectorHip2Kinect = vectorPlantar2Kinect;
vectorHip2Kinect(1) = midK-midH;
vectorHip2Kinect(2) = vectorHip2Kinect(2)-0.4;
vectorHip2Kinect(3) = vectorHip2Kinect(3)+0.53;