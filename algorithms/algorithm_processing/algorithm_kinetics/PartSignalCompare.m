% 画图逐步分析动力学的计算过程
%% 关节矩
% figure; hold on;
% plot(streamInter.wtime,jointMomentLocal.Thigh_Left_proximal.x);
% plot(streamInter.wtime,jointMomentLocal.Shank_Left_proximal.x);
% plot(streamInter.wtime,-jointMomentLocal.Shank_Left_distal.x);
% hold off; xlim([tSTSStart,tSTSEnd]); title('关节矩'); legend('髋','膝','踝');
% %% 关节矩计算过程
% figure;
% subplot(3,1,1); hold on;
% plot(streamInter.wtime,jointMomentCoupleGlobal.Foot_Left.x);
% plot(streamInter.wtime,jointMomentRF.Foot_Left.x);
% plot(streamInter.wtime,jointMomentGlobal.Foot_Left_distal.x);
% plot(streamInter.wtime,jointMomentGlobal.Foot_Left_proximal.x)
% legend('总力矩','作用力矩','远端','近端'); title('足部'); hold off;
% subplot(3,1,2); hold on;
% plot(streamInter.wtime,jointMomentCoupleGlobal.Shank_Left.x);
% plot(streamInter.wtime,jointMomentRF.Shank_Left.x);
% plot(streamInter.wtime,jointMomentGlobal.Shank_Left_distal.x);
% plot(streamInter.wtime,jointMomentGlobal.Shank_Left_proximal.x)
% legend('总力矩','作用力矩','远端','近端'); title('小腿'); hold off;
% subplot(3,1,3); hold on;
% plot(streamInter.wtime,jointMomentCoupleGlobal.Thigh_Left.x);
% plot(streamInter.wtime,jointMomentRF.Thigh_Left.x);
% plot(streamInter.wtime,jointMomentGlobal.Thigh_Left_distal.x);
% plot(streamInter.wtime,jointMomentGlobal.Thigh_Left_proximal.x)
% legend('总力矩','作用力矩','远端','近端'); title('大腿'); hold off;
% sgtitle('关节矩计算过程');
% %% GRM
% figure; hold on;
% plot(streamInter.wtime,grmLeft_k.x);
% plot(streamInter.wtime,grmLeft_k.y);
% plot(streamInter.wtime,grmLeft_k.z);
% hold off; xlim([tSTSStart,tSTSEnd]); legend('x','y','z'); hold off; title('GRM');
% %% GRM计算过程
% figure;
% subplot(3,1,1); plot(streamInter.wtime,grmRotate.human.x); xlim([tSTSStart,tSTSEnd]); title('旋转力矩');
% subplot(3,1,2); plot(streamInter.wtime,grmCom.human.x); xlim([tSTSStart,tSTSEnd]); title('平移力矩');
% subplot(3,1,3); plot(streamInter.wtime,grmGravity.x); xlim([tSTSStart,tSTSEnd]); title('重力矩');
% sgtitle('GRM计算过程');
% %% COM
% figure; 
% subplot(3,1,1); plot(streamInter.wtime,posCOMSegments.human.x); xlim([tSTSStart,tSTSEnd]); title('x');
% subplot(3,1,2); plot(streamInter.wtime,posCOMSegments.human.y); xlim([tSTSStart,tSTSEnd]); title('y');
% subplot(3,1,3); plot(streamInter.wtime,posCOMSegments.human.z); xlim([tSTSStart,tSTSEnd]); title('z');
% sgtitle('质心位置');
% %% ACC
% figure; 
% subplot(3,1,1); plot(streamInter.wtime,accCOMSegments.human.x); xlim([tSTSStart,tSTSEnd]); title('x');
% subplot(3,1,2); plot(streamInter.wtime,accCOMSegments.human.y); xlim([tSTSStart,tSTSEnd]); title('y');
% subplot(3,1,3); plot(streamInter.wtime,accCOMSegments.human.z); xlim([tSTSStart,tSTSEnd]); title('z');
% sgtitle('质心加速度');