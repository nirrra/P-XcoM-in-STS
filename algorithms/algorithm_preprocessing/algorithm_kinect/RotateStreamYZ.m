function [stream] = RotateStreamYZ(stream,numRotate,gender)
if nargin<3, gender = 'M'; end
if nargin<2, numRotate = 2; end

if numRotate == 0, return; end
%% 绕Y轴
data = stream.HEAD.z;
idxStream = [];
for i = 1+5:length(data)-5
    if range(data(i-5:i+5))<0.01 && data(i)>max(data)-0.01
        idxStream = [idxStream,i];
    end
end
% figure; hold on;
% plot(stream.wtime,data);
% plot(stream.wtime(idxStream),data(idxStream),'ro');
% hold off; title('站立稳定点');

% DrawKinectFrame(stream,idxStream(1)); % 查看单帧，坐姿
options = optimoptions('fminunc', 'Algorithm', 'quasi-newton','Display','notify'); % 优化参数
initialGuess = 0; % 猜测旋转角度为0度
rotAngleYOptimized = fminunc(@(params) StreamAxisYOptimization(params,stream,idxStream),initialGuess,options);
tmRotateY = [cosd(rotAngleYOptimized),0,sind(rotAngleYOptimized),0;...
                0,1,0,0;...
                -sind(rotAngleYOptimized),0,cosd(rotAngleYOptimized),0;...
                0,0,0,1];
stream = Transform_Azure(tmRotateY,stream);
disp(['绕Y轴旋转角度：',num2str(rotAngleYOptimized)]);

if numRotate == 1
    return;
end
%% 绕Z轴
% 根据肩关节、髋关节连线
rotAngleZOptimized = fminunc(@(params) StreamAxisZOptimization(params,stream,idxStream),initialGuess,options);

tmRotateZ = [cosd(rotAngleZOptimized),-sind(rotAngleZOptimized),0,0;...
                sind(rotAngleZOptimized),cosd(rotAngleZOptimized),0,0;...
                0,0,1,0;...
                0,0,0,1];

stream = Transform_Azure(tmRotateZ,stream);
disp(['绕Z轴旋转角度：',num2str(rotAngleZOptimized)]);
% DrawKinectFrame(stream,idxStream(1)); % 查看单帧，坐姿