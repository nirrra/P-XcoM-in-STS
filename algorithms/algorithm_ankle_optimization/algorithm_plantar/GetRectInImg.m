function [hasPlantar,rect,M1,M5,C] = GetRectInImg(img,imgTemplates,lr)
numPtsMax = numel(find(imgTemplates.imgTemplate>0));
hasPlantar = true;
angles = -45:5:45; % 负的为顺时针，正的为逆时针

if lr == 'l'
    img(:,17:32) = 0;
else
    img(:,1:16) = 0;
end

% 判断图中是否有脚印，是否只有足前掌
numPts = numel(find(img>0));

if numPts < 10
    rect = zeros(4,2);
    hasPlantar = false;
    return;
elseif numPts < numPtsMax*0.6
    imgTemplate = imgTemplates.imgTemplateM;
    imgTemplateShape = imgTemplates.imgTemplateShapeM;
else
    imgTemplate = imgTemplates.imgTemplate;
    imgTemplateShape = imgTemplates.imgTemplateShape;
end
%% 寻找匹配最好的旋转方向
bestMatch = 0;
for i = 1:length(angles)
    aux = imrotate(img,angles(i),'bicubic','crop');
    aux = aux./max(aux(:));

    aux = conv2(aux,rot90(imgTemplate,2),'full');
    if max(aux(:))>bestMatch
        bestMatch = max(aux(:));
        rotAngle = angles(i);
    end
end

aux = conv2(imrotate(img,rotAngle,'bicubic','crop'),rot90(imgTemplate,2),'full');
[x,y] = find(aux==max(aux(:)));
x = x-32+1; y = y-32+1;
rect_r = imgTemplates.rectTemplate+[x,y]-[1,1];

%% 判断是否需要imgTemplateShape（只有形状，无压力值）
sumOut = 0;
for i = 1:32
    for j = 1:32
        if i < min(rect_r(:,1)) || i > max(rect_r(:,1)) || j < min(rect_r(:,2)) || j > max(rect_r(:,2))
            sumOut = sumOut+img(i,j);
        end
    end
end
if sumOut>1000
    bestMatch = 0;
    for i = 1:length(angles)
        aux = imrotate(img,angles(i),'bicubic','crop');
        aux = aux./max(aux(:));
    
        aux = conv2(aux,rot90(imgTemplateShape,2),'full');
        if max(aux(:))>bestMatch
            bestMatch = max(aux(:));
            rotAngle = angles(i);
        end
    end
    
    aux = conv2(imrotate(img,rotAngle,'bicubic','crop'),rot90(imgTemplateShape,2),'full');
    [x,y] = find(aux==max(aux(:)));
    x = x-32+1; y = y-32+1;
    rect_r = imgTemplates.rectTemplate+[x,y]-[1,1];
end

% figure; hold on;
% imshow(mat2gray(imrotate(img,rotAngle,'bicubic','crop')),'InitialMagnification','fit');
% plot(rect_r(:,2),rect_r(:,1),'r*');
% hold off; title('旋转后外切矩形');

%% 旋转回原图
rect = RotateRect(rect_r,[16.5,16.5],rotAngle);
%% 跖骨点
M1_r = imgTemplates.M1+[x,y]-[1,1];
M5_r = imgTemplates.M5+[x,y]-[1,1];
C_r = imgTemplates.C+[x,y]-[1,1];
M1 = RotatePt(M1_r,[16.5,16.5],rotAngle);
M5 = RotatePt(M5_r,[16.5,16.5],rotAngle);
C = RotatePt(C_r,[16.5,16.5],rotAngle);
%% 处理右脚
if lr == 'r'
    rect = rect(4:-1:1,:);
end

% figure; hold on;
% imshow(mat2gray(imgTest),'InitialMagnification','fit');
% plot(rect(:,2),rect(:,1),'r*');
% hold off; title('原图外切矩形')
end

function [new_pt] = RotatePt(pt,origin,degree)
    % 创建旋转矩阵  
    R = [cosd(degree), sind(degree); -sind(degree), cosd(degree)];  
    % 计算相对于原点的偏移量  
    offset = pt - origin;
    % 应用旋转矩阵  
    rotated_offset = R * offset';  
    % 将旋转后的偏移量加回原点，得到新坐标  
    new_pt = rotated_offset' + origin;  
end