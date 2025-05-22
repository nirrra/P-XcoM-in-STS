function [partitionTemplate,labelsTemplate] = GetPartitionTemplate(rect,l,w,img)
    ptsPlantar(1,:) = (rect(1,:)-rect(2,:))./(4+4+l+6)*(6+l+6)+rect(2,:);
    ptsPlantar(3,:) = (rect(4,:)-rect(3,:))./(4+4+l+6)*(6+l+6)+rect(3,:);
    ptsPlantar(2,:) = (ptsPlantar(1,:)-ptsPlantar(3,:))/2+ptsPlantar(3,:);
    ptsPlantar(4,:) = (rect(1,:)-rect(2,:))./(4+4+l+6)*(l+6-1)+rect(2,:);
    ptsPlantar(6,:) = (rect(4,:)-rect(3,:))./(4+4+l+6)*(l+6-1)+rect(3,:);
    ptsPlantar(5,:) = (ptsPlantar(4,:)-ptsPlantar(6,:))/2+ptsPlantar(6,:);
    ptsPlantar(7,:) = (rect(1,:)-rect(2,:))./(4+4+l+6)*(6+1)+rect(2,:);
    ptsPlantar(8,:) = (rect(4,:)-rect(3,:))./(4+4+l+6)*(6+1)+rect(3,:);

    % 脚趾
    partitionTemplate.sumD = GetRectTemplate([rect(1,:);ptsPlantar(1,:);ptsPlantar(3,:);rect(4,:)]);
    % 第3-5跖骨
    partitionTemplate.sumM35 = GetRectTemplate([ptsPlantar(1,:);ptsPlantar(4,:);ptsPlantar(5,:);ptsPlantar(2,:)]);
    % 第1-2跖骨
    partitionTemplate.sumM12 = GetRectTemplate([ptsPlantar(2,:);ptsPlantar(5,:);ptsPlantar(6,:);ptsPlantar(3,:)]);
    % 足弓
    partitionTemplate.sumL = GetRectTemplate([ptsPlantar(4,:);ptsPlantar(7,:);ptsPlantar(8,:);ptsPlantar(6,:)]);
    % 足跟
    partitionTemplate.sumC = GetRectTemplate([ptsPlantar(7,:);rect(2,:);rect(3,:);ptsPlantar(8,:)]);
    

    labelsTemplate = zeros(32,32);
    labelsTemplate(partitionTemplate.sumD>=0.5) = 1;
    labelsTemplate(partitionTemplate.sumM12>=0.5) = 2;
    labelsTemplate(partitionTemplate.sumM35>=0.5) = 3;
    labelsTemplate(partitionTemplate.sumL>=0.5) = 4;
    labelsTemplate(partitionTemplate.sumC>=0.5) = 5;

    if nargin>3
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