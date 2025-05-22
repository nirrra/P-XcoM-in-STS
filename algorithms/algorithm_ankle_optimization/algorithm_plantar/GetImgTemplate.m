function [imgTemplates] = GetImgTemplate(img,lr)
angles = -45:5:45; % 负的为顺时针，正的为逆时针
cellImgs = cell(length(angles),2);
for i = 1:length(angles)
    aux = imrotate(img,angles(i),'bicubic','crop');
    cellImgs{i,1} = aux./max(aux(:));
end

%% 寻找最匹配的模板参数和模板图
bestMatch = 0;
for l = 1:17
    plantarTemplate = CreatePlantarTemplate(l,lr);
    for i = 1:length(cellImgs)
        aux = conv2(cellImgs{i},rot90(plantarTemplate.template,2),'full');
        if max(aux(:))>bestMatch
            bestMatch = max(aux(:));
            bestParas = [i,l];
        end
    end
end

imgTemplate = cellImgs{bestParas(1)};
l = bestParas(2);

plantarTemplate = CreatePlantarTemplate(l,lr);


%% 获取模板的外切矩形
aux = conv2(imgTemplate,rot90(plantarTemplate.template,2),'full');
[x,y] = find(aux==max(aux(:)));
x = x-32+1; y = y-32+1;
rectTemplate = plantarTemplate.rect+[x,y]-[1,1];
for i = 1:size(rectTemplate,1)*size(rectTemplate,2)
    if rectTemplate(i)>32, rectTemplate(i)=32; end
    if rectTemplate(i)<1, rectTemplate(i)=1; end
end

%% 根据前脚掌调整矩形宽度
th = 0.01*max(imgTemplate(:));
 
% 调整宽度
aux = find(max(imgTemplate(max(1,rectTemplate(2,1)-6-l-4):rectTemplate(2,1),:))>th);
xgroup = [aux(1)]; maxLength = 1; maxgroup = [];
for i = 2:length(aux)
    if xgroup(end)+1 == aux(i)
        xgroup = [xgroup,aux(i)];
    else
        xgroup = [aux(i)];
    end
    if length(xgroup)>maxLength
        maxLength = length(xgroup);
        maxgroup = xgroup;
    end
end
w = range(maxgroup)+2;
if lr == 'l'
    rectTemplate(1:2,2) = max(1,maxgroup(1)-1);
    rectTemplate(3:4,2) = rectTemplate(1,2)+w;
else
    rectTemplate(1:2,2) = max(1,maxgroup(end)+1);
    rectTemplate(3:4,2) = rectTemplate(1,2)-w;
end
% disp(['模板 足弓长度l：',num2str(l),'；足部宽度w：',num2str(w)]);


% figure; hold on;
% imshow(mat2gray(imgTemplate),'InitialMagnification','fit'); title('最匹配图'); colormap jet;
% plot(rectTemplate(:,2),rectTemplate(:,1),'r*'); hold off;
% figure; imshow(mat2gray(plantarTemplate.template),'InitialMagnification','fit'); title('模板'); colormap jet;

%% 只考虑形状的模板
imgTemplateShape = imgTemplate;
imgTemplateShape(imgTemplateShape<=0) = 0;
imgTemplateShape(imgTemplateShape>0) = 1;

%% 部分足底的模板
imgTemplateM = zeros(32,32);
for i = min(rectTemplate(:,1)):min(rectTemplate(:,1))+6
    for j = max([1,min(rectTemplate(:,2))]):min([32,max(rectTemplate(:,2))])
        imgTemplateM(i,j) = 1;
    end
end
imgTemplateShapeM = imgTemplateM.*imgTemplateShape;
imgTemplateM = imgTemplateM.*imgTemplate;

imgTemplateC = zeros(32,32);
for i = floor(mean(rectTemplate(:,1))):max(rectTemplate(:,1))
    for j = max([1,min(rectTemplate(:,2))]):min([32,max(rectTemplate(:,2))])
        imgTemplateC(i,j) = 1;
    end
end
imgTemplateShapeC = imgTemplateC.*imgTemplateShape;
imgTemplateC = imgTemplateC.*imgTemplate;

imgTemplateL = zeros(32,32);
for i = min(rectTemplate(:,1))+6:floor(mean(rectTemplate(:,1)))
    for j = max([1,min(rectTemplate(:,2))]):min([32,max(rectTemplate(:,2))])
        imgTemplateL(i,j) = 1;
    end
end
imgTemplateShapeL = imgTemplateL.*imgTemplateShape;
imgTemplateL = imgTemplateL.*imgTemplate;

%% M1/M5位置
imgTemplateML = zeros(32,32);
for i = min(rectTemplate(:,1)):floor(mean(rectTemplate(:,1)))
    for j = max([1,min(rectTemplate(:,2))]):min([32,max(rectTemplate(:,2))])
        imgTemplateML(i,j) = 1;
    end
end
imgTemplateML = imgTemplateML.*imgTemplate;

[~,lineM] = max(sum(imgTemplateML,2));
for i = 1:32
    if imgTemplateML(lineM,i) > 0.1*max(imgTemplate(:)), break; end
end
M5 = [lineM,i];

for i = 32:-1:1
    if imgTemplateML(lineM,i) > 0.1*max(imgTemplate(:)), break; end
end
M1 = [lineM,i];

if lr == 'r'
    aux = M1; M1 = M5; M5 = aux;
end
%% C位置
% [~,lineC] = max(sum(imgTemplateC,2));
% [~,aux] = max(imgTemplateC(lineC,:));
% C = [lineC,aux];
[i,j] = find(imgTemplateC==max(imgTemplateC(:)));
C = [i,j];

imgTemplates.l = l;
imgTemplates.w = w;
imgTemplates.imgTemplate = imgTemplate;
imgTemplates.imgTemplateM = imgTemplateM;
imgTemplates.imgTemplateC = imgTemplateC;
imgTemplates.imgTemplateL = imgTemplateL;
imgTemplates.rectTemplate = rectTemplate;
imgTemplates.imgTemplateShape = imgTemplateShape;
imgTemplates.imgTemplateShapeM = imgTemplateShapeM;
imgTemplates.imgTemplateShapeC = imgTemplateShapeC;
imgTemplates.imgTemplateShapeL = imgTemplateShapeL;
imgTemplates.M1 = M1;
imgTemplates.M5 = M5;
imgTemplates.C = C;