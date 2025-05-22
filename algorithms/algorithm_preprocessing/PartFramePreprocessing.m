%% Kinect转换到人体坐标系（X右，Y前，Z上），根据COM
tmKinect2Opensim = GetKinect2OpensimT(stream,dataVicon,times);
stream = Transform_Azure(tmKinect2Opensim,stream);

%% 坐标系原点统一至两脚中间
% figure; plot(stream.wtime,stream.FOOT_LEFT.y)
posOrigin = [stream.FOOT_LEFT.x+stream.FOOT_RIGHT.x,stream.FOOT_LEFT.y+stream.FOOT_RIGHT.y,stream.FOOT_LEFT.z+stream.FOOT_RIGHT.z]./2;
posOrigin = mean(posOrigin(301:end-300,:));
tmFootOrigin = [1,0,0,-posOrigin(1);0,1,0,-posOrigin(2);0,0,1,-posOrigin(3);0,0,0,1];
stream = Transform_Azure(tmFootOrigin,stream);

%% 绕Y/Z轴旋转关节点，使得人体竖直轴与z轴同向
% [comX,comY,comZ] = GravityKinectAzure(stream,gender); figure; subplot(1,2,1); plot(comX,comY); axis equal;
stream = RotateStreamYZ(stream,1);
% [comX,comY,comZ] = GravityKinectAzure(stream,gender); subplot(1,2,2); plot(comX,comY); axis equal;

% DrawKinectFrame(stream,50); % 查看单帧
modelHeight = max(stream.HEAD.z-mean([stream.FOOT_LEFT.z,stream.FOOT_RIGHT.z],2));
disp(['模型身高比：',num2str(100*modelHeight./heights(idxSub))]);
