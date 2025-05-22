%% 显示T-pose下的所有标记点
function [] = DrawKinectMarkers(stream,frame)
figure_name = 'Kinect markers.png';
angle = -180;
names = fieldnames(stream); 
if length(names)==35
    names = names(4:35);
    idxMarkers = [1:6,12,13,19:28];
    idxMarkers2 = [];
    idxMarkers3 = [];
    figure_name = 'All markers.png';
    angle = 0;
elseif length(names)==33
    names = names([2:4,8,12,14:16,18:33]);
%     names = names([2:4,8,12,14:16,18:24,32,33]); % 不包括足底点
    idxMarkers = 1:length(names);
%     idxMarkers2 = [6,7,9,10,23,24]; % 区分不同颜色
%     idxMarkers3 = [17:22];
    idxMarkers2 = []; %所有点
    idxMarkers3 = [];
    figure_name = 'Optimized markers.png';
elseif length(names)==25
    names = names([2:4,8,12:25]);
    idxMarkers = 1:length(names);
    idxMarkers2 = [];
    idxMarkers3 = [];
    figure_name = 'Markerset markers.png';
end
f = figure(1); 
scatter3(stream.(names{1}).x(frame),stream.(names{1}).y(frame),stream.(names{1}).z(frame),60,'MarkerEdgeColor','k','MarkerFaceColor',[190,46,56]./255); hold on;
for i = 2:size(names,1)
    if ismember(i,idxMarkers2) % 替代点
        scatter3(stream.(names{i}).x(frame),stream.(names{i}).y(frame),stream.(names{i}).z(frame),60,'MarkerEdgeColor','k','MarkerFaceColor',[46,117,182]./255); 
    elseif ismember(i,idxMarkers3) % 足底点
        scatter3(stream.(names{i}).x(frame),stream.(names{i}).y(frame),stream.(names{i}).z(frame),60,'MarkerEdgeColor','k','MarkerFaceColor',[84,130,53]./255); 
    elseif ismember(i,idxMarkers) % 原本点
        scatter3(stream.(names{i}).x(frame),stream.(names{i}).y(frame),stream.(names{i}).z(frame),60,'MarkerEdgeColor','k','MarkerFaceColor',[190,46,56]./255); 
    else % 其他点
        scatter3(stream.(names{i}).x(frame),stream.(names{i}).y(frame),stream.(names{i}).z(frame),60,'MarkerEdgeColor','k','MarkerFaceColor',[0,200,200]./255); 
    end
end
hold on;

hold off;
axis equal;
xlim([stream.PELVIS.x(frame)-0.9,stream.PELVIS.x(frame)+0.9]);
axis off;
grid off;
view(angle,10);
exportgraphics(f,figure_name,'Resolution',600);