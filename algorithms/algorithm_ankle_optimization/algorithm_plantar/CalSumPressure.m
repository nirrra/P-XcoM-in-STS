% 计算矩形内部的压力
function [sumPressure] = CalSumPressure(img,rect)
    sumPressure = 0;
%     imgArea = zeros(32,32);
    for i = 1:32
        for j = 1:32
            % 第(i,j)单元的4个顶点
            rect_i = [i-0.5,j-0.5;i+0.5,j-0.5;i+0.5,j+0.5;i-0.5,j+0.5];
            % 判断4个顶点是否都在rect里
            flagInRect = true;
            for k = 1:4
                pt = rect_i(k,:);
                flagInRect = flagInRect & IsPointInsidePolygon(pt(1),pt(2),rect);
            end
            
            if flagInRect
                % 单元格在矩形内
                sumPressure = sumPressure+img(i,j);
%                 area = CalIntersectionArea(rect_i,rect);
            else
                % 单元格不在矩形内，计算单元格和矩形的相交面积
                area = CalIntersectionArea(rect_i,rect);
                sumPressure = sumPressure+img(i,j)*area;
            end
%             imgArea(i,j) = area;
        end
    end
%     figure; imshow(mat2gray(imgArea),'InitialMagnification','fit');
end


