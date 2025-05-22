function [labelsUpper,labelsLower] = GetHalfRectTemplate(rect)
    ptsPlantar(1,:) = (rect(1,:)-rect(2,:))./2+rect(2,:);
    ptsPlantar(2,:) = (rect(4,:)-rect(3,:))./2+rect(3,:);
    partitionTemplate.Upper = GetRectTemplate([rect(1,:);ptsPlantar(1,:);ptsPlantar(2,:);rect(4,:)]);
    partitionTemplate.Lower = GetRectTemplate([ptsPlantar(1,:);rect(2,:);rect(3,:);ptsPlantar(2,:)]);


    labelsUpper = zeros(32,32);
    labelsUpper(partitionTemplate.Upper>=0.5) = 1;

    labelsLower = zeros(32,32);
    labelsLower(partitionTemplate.Lower>=0.5) = 1;

end

function [template] = GetRectTemplate(rect)
    template = zeros(32,32);
    for i = 1:32
        for j = 1:32
            rect_i = [i-0.5,j-0.5;i+0.5,j-0.5;i+0.5,j+0.5;i-0.5,j+0.5];
            % 判断4个顶点是否都在rect里
            flagInRect = true;
            for k = 1:4
                pt = rect_i(k,:);
                flagInRect = flagInRect & IsPointInsidePolygon(pt(1),pt(2),rect);
            end
            
            if flagInRect
                % 单元格在矩形内
                template(i,j) = 1;
            else
                % 单元格不在矩形内，计算单元格和矩形的相交面积
                area = CalIntersectionArea(rect_i,rect);
                template(i,j) = area;
            end
        end
    end
end