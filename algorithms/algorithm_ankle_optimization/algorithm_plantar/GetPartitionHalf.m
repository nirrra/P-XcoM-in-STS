function [partitionTemplate,labelsTemplate] = GetPartitionHalf(rect,img)
    ptsPlantar(1,:) = (rect(1,:)-rect(2,:))./2+rect(2,:);
    ptsPlantar(2,:) = (rect(4,:)-rect(3,:))./2+rect(3,:);
    
    % 足前掌
    partitionTemplate.sumM = GetRectTemplate([rect(1,:);ptsPlantar(1,:);ptsPlantar(2,:);rect(4,:)]);
    % 足跟
    partitionTemplate.sumC = GetRectTemplate([ptsPlantar(1,:);rect(2,:);rect(3,:);ptsPlantar(2,:)]);
    

    labelsTemplate = zeros(32,32);
    labelsTemplate(partitionTemplate.sumM>=0.5) = 1;
    labelsTemplate(partitionTemplate.sumC>=0.5) = 2;

    if nargin>1
        figure; hold on;
        imshow(mat2gray(img),'InitialMagnification','fit');
        plot(rect(:,2),rect(:,1),'r*');
        plot(ptsPlantar(:,2),ptsPlantar(:,1),'b*');
        hold off; title('足底分区');
    end
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