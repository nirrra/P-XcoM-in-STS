% 蒙特卡洛计算相交面积
function intersectionArea = CalIntersectionArea(rect1, rect2)  
    % rect1 和 rect2 都是 4x2 的矩阵，每一行代表一个顶点的 (x,y) 坐标  
    % 首先确定矩形的边界框  
    [x1_min, x1_max, y1_min, y1_max] = GetBoundingBox(rect1);  
    [x2_min, x2_max, y2_min, y2_max] = GetBoundingBox(rect2);  
      
    % 检查边界框是否相交  
    if x1_max < x2_min || x2_max < x1_min || y1_max < y2_min || y2_max < y1_min  
        intersectionArea = 0; % 边界框不相交，则交集面积为0  
    else  
        % 计算交集的边界框  
        intersectionXMin = max(x1_min, x2_min);  
        intersectionXMax = min(x1_max, x2_max);  
        intersectionYMin = max(y1_min, y2_min);  
        intersectionYMax = min(y1_max, y2_max);  
          
        % 如果有交集，进一步计算实际交集的面积  
        if intersectionXMin < intersectionXMax && intersectionYMin < intersectionYMax  
            % 使用蒙特卡洛方法估计交集的面积（适用于不规则形状）  
            % 你可以替换为更精确的几何方法，如果矩形是规则的  
            numPoints = 10000; % 用于蒙特卡洛方法的点数  
            % 生成intersection中的numPoints个随机点
            points = rand(numPoints, 2);  
            points(:,1) = points(:,1) * (intersectionXMax - intersectionXMin) + intersectionXMin;  
            points(:,2) = points(:,2) * (intersectionYMax - intersectionYMin) + intersectionYMin;  
            pointsInRect1 = CountPointsInRect(points,rect1);  
            pointsInRect2 = CountPointsInRect(points,rect2);  
              
            % 检查哪些点在两个矩形中都存在  
            pointsInIntersection = pointsInRect1 & pointsInRect2;  
              
            % 估计交集面积  
            intersectionArea = sum(pointsInIntersection) / numPoints * (intersectionXMax - intersectionXMin) * (intersectionYMax - intersectionYMin);  
        else  
            intersectionArea = 0; % 交集边界框为空，则交集面积为0  
        end  
    end  
end  
  
function [x_min, x_max, y_min, y_max] = GetBoundingBox(rect)  
    % 从矩形的顶点坐标中计算边界框  
    x = rect(:,1);  
    y = rect(:,2);  
    x_min = min(x);  
    x_max = max(x);  
    y_min = min(y);  
    y_max = max(y);  
end  
  
function pointsInRect = CountPointsInRect(points,rect)
    pointsInRect = false(size(points,1),1);
    for i = 1:length(pointsInRect)
        pointsInRect(i) = IsPointInsidePolygon(points(i,1),points(i,2),rect);
    end
end