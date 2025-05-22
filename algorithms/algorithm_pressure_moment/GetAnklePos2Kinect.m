function [ankleLeftPlantar,ankleRightPlantar,vectorPlantar2Kinect,matrixPlantar] = GetAnklePos2Kinect(streamInter,...
    pressurePlantar2DInter,p_listPlantarInter,ptsPlantarLeft,ptsPlantarRight,idxStandStable,weight,gender,flagZ)
%% 初始化
flagOptimization = 2; % 算法2：双脚同时优化，保持左右踝关节间距离稳定
if nargin<11, flagZ = true; end
if gender == 'M'
    Lcs.Foot = 0.4415;
    M.Foot = 0.0137;
else
    Lcs.Foot = 0.4014;
    M.Foot = 0.0129;
end

%% Kinect系下踝关节位置
ankleLeftKinect = mean([streamInter.ANKLE_LEFT.x(idxStandStable),streamInter.ANKLE_LEFT.y(idxStandStable),streamInter.ANKLE_LEFT.z(idxStandStable)]);
ankleRightKinect = mean([streamInter.ANKLE_RIGHT.x(idxStandStable),streamInter.ANKLE_RIGHT.y(idxStandStable),streamInter.ANKLE_RIGHT.z(idxStandStable)]);

% 阵列每个单元格中心的实际位置，以左后单元左后顶点为坐标系原点，x向右，y向前
matrixRealX = ((1:32)'-0.5).*11.5/1000; matrixRealY = matrixRealX; % 单位m

ptsPlantarRealLeft = [matrixRealX(ptsPlantarLeft(:,1)),matrixRealY(ptsPlantarLeft(:,2))];
ptsPlantarRealRight = [matrixRealX(ptsPlantarRight(:,1)),matrixRealY(ptsPlantarRight(:,2))];

vecAnkle2FootLeft = median([streamInter.FOOT_LEFT.x,streamInter.FOOT_LEFT.y,streamInter.FOOT_LEFT.z]-...
    [streamInter.ANKLE_LEFT.x,streamInter.ANKLE_LEFT.y,streamInter.ANKLE_LEFT.z]);
vecAnkle2FootRight = median([streamInter.FOOT_RIGHT.x,streamInter.FOOT_RIGHT.y,streamInter.FOOT_RIGHT.z]-...
    [streamInter.ANKLE_RIGHT.x,streamInter.ANKLE_RIGHT.y,streamInter.ANKLE_RIGHT.z]);
height = (vecAnkle2FootLeft(3)+vecAnkle2FootRight(3))./2;
vecAnkle2FootLeft(3) = height; vecAnkle2FootRight(3) = height;

%% 最优化
options = optimoptions('fminunc', 'Algorithm', 'quasi-newton','Display','notify'); % 优化参数
gravity = [0,0,-M.Foot*weight*9.8];
grfLeft = [zeros(size(streamInter.wtime)),zeros(size(streamInter.wtime)),p_listPlantarInter.pPlantarLeft];
forceShank2FootRight = zeros(1,3)-grfLeft-gravity;
grfRight = [zeros(size(streamInter.wtime)),zeros(size(streamInter.wtime)),p_listPlantarInter.pPlantarRight];
forceShank2FootLeft = zeros(1,3)-grfRight-gravity;
if flagOptimization == 1
    %% 算法1：双脚分开优化
    % 左脚
    initialGuessLeft = [median(ptsPlantarRealLeft(:,1)),min(ptsPlantarRealLeft(:,2))+0.03,-vecAnkle2FootLeft(3)]; % 猜测位置靠近足跟
    ankleLeftOptimized = fminunc(@(params) AnklePosOptimization(params,ptsPlantarLeft,ptsPlantarRealLeft,...
        pressurePlantar2DInter,forceShank2FootLeft,vecAnkle2FootLeft,idxStandStable,Lcs.Foot,flagZ),initialGuessLeft,options);
    % 右脚
    initialGuessRight = [median(ptsPlantarRealRight(:,1)),min(ptsPlantarRealRight(:,2))+0.03,-vecAnkle2FootRight(3)]; % 猜测位置靠近足跟
    ankleRightOptimized = fminunc(@(params) AnklePosOptimization(params,ptsPlantarRight,ptsPlantarRealRight,...
        pressurePlantar2DInter,forceShank2FootRight,vecAnkle2FootRight,idxStandStable,Lcs.Foot,flagZ),initialGuessRight,options);
else
    %% 算法2：双脚同时优化，保持左右踝关节间距离稳定
    vecLeft2Right = ankleRightKinect-ankleLeftKinect;
    
    initialGuessLeft = [median(ptsPlantarRealLeft(:,1)),min(ptsPlantarRealLeft(:,2))+0.03,-vecAnkle2FootLeft(3)]; % 猜测位置靠近足跟
    initialGuessRight = initialGuessLeft+vecLeft2Right;
    ankleLeftOptimized = fminunc(@(params) AnklePosLROptimization(params,ptsPlantarLeft,ptsPlantarRealLeft,ptsPlantarRight,ptsPlantarRealRight,...
        pressurePlantar2DInter,vecLeft2Right,vecAnkle2FootLeft,vecAnkle2FootRight,forceShank2FootLeft,forceShank2FootRight,...
        idxStandStable,Lcs.Foot),initialGuessLeft,options);
    ankleRightOptimized = ankleLeftOptimized+vecLeft2Right;
end
%% 对齐Kinect和阵列的踝关节位置
% 阵列系下踝关节位置
if flagZ
    ankleLeftPlantar = ankleLeftOptimized;
    ankleRightPlantar = ankleRightOptimized;
else
    ankleLeftPlantar = [ankleLeftOptimized(1:2),-vecAnkle2FootLeft(3)];
    ankleRightPlantar = [ankleRightOptimized(1:2),-vecAnkle2FootRight(3)];
end

% 阵列系到Kinect系平移向量
vectorPlantar2Kinect = ((ankleLeftKinect+ankleRightKinect)-(ankleLeftPlantar+ankleRightPlantar))./2;
% 阵列系下阵列位置
matrixPlantar.x = repmat(((1:32)-0.5).*11.5/1000,32,1);
matrixPlantar.y = repmat(((32:-1:1)-0.5)'.*11.5/1000,1,32);
matrixPlantar.z = zeros(32);
% Kinect系下阵列位置
matrixPlantar2Kinect.x = repmat(((1:32)-0.5).*11.5/1000,32,1)+vectorPlantar2Kinect(1);
matrixPlantar2Kinect.y = repmat(((32:-1:1)-0.5)'.*11.5/1000,1,32)+vectorPlantar2Kinect(2);
matrixPlantar2Kinect.z = zeros(32)+vectorPlantar2Kinect(3);

% figure; 
% scatter3(ptsPlantarRealLeft(:,1),ptsPlantarRealLeft(:,2),zeros(size(ptsPlantarRealLeft(:,1)))); hold on;
% scatter3(ptsPlantarRealRight(:,1),ptsPlantarRealRight(:,2),zeros(size(ptsPlantarRealRight(:,1))));
% plot3(ankleLeftPlantar(1),ankleLeftPlantar(2),ankleLeftPlantar(3),'ro');
% plot3(ankleRightPlantar(1),ankleRightPlantar(2),ankleRightPlantar(3),'ro');
% plot3(initialGuessLeft(1),initialGuessLeft(2),initialGuessLeft(3),'g*');
% plot3(initialGuessRight(1),initialGuessRight(2),initialGuessRight(3),'g*');
% plot3(ankleLeftKinect(1)-vectorPlantar2Kinect(1),ankleLeftKinect(2)-vectorPlantar2Kinect(2),ankleLeftKinect(3)-vectorPlantar2Kinect(3),'bo');
% plot3(ankleRightKinect(1)-vectorPlantar2Kinect(1),ankleRightKinect(2)-vectorPlantar2Kinect(2),ankleRightKinect(3)-vectorPlantar2Kinect(3),'bo');
% plot3([ankleLeftPlantar(1),ankleLeftPlantar(1)+vecAnkle2FootLeft(1)],[ankleLeftPlantar(2),ankleLeftPlantar(2)+vecAnkle2FootLeft(2)],[ankleLeftPlantar(3),ankleLeftPlantar(3)+vecAnkle2FootLeft(3)],'k');
% plot3([ankleRightPlantar(1),ankleRightPlantar(1)+vecAnkle2FootRight(1)],[ankleRightPlantar(2),ankleRightPlantar(2)+vecAnkle2FootRight(2)],[ankleRightPlantar(3),ankleRightPlantar(3)+vecAnkle2FootRight(3)],'k');
% hold off; xlim([min(matrixRealX),max(matrixRealX)]); ylim([min(matrixRealY),max(matrixRealY)]);
% axis equal;
% title('阵列系下踝关节位置'); legend('左脚作用点','右脚作用点','左 阵列','右 阵列','左 猜测','右 猜测','左 Kinect','右 Kinect','左 足踝','右 足踝');