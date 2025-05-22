% 查看平移效果

figure; 
set(gcf, 'color', 'w');
subplot(1,2,1);
imshow(mat2gray([reshape(mean(pressurePlantar2DInter(idx_segment_both,:,:),1),32,32);reshape(mean(pressureButtock2DInter(idx_segment_both,:,:),1),32,32)]),...
    'InitialMagnification','fit'); colormap default;
subplot(1,2,2);
imshow(mat2gray([reshape(mean(pressurePlantar2DInter(idx_segment_both,:,:),1),32,32);reshape(mean(pressureButtock2DInter_shifted(idx_segment_both,:,:),1),32,32)]),...
    'InitialMagnification','fit'); colormap default;
sgtitle(['图.5 臀底压力水平位移：',num2str(dj_buttock),'像素 （正为向右平移）'],'FontWeight', 'normal', 'FontSize', 11, 'Color', [.2 .2 .2]);

