function [new_rect] = RotateRect(rect,origin,degree)
    % 创建旋转矩阵  
    R = [cosd(degree), sind(degree); -sind(degree), cosd(degree)];  
      
    % 初始化旋转后的点集  
    new_rect = zeros(size(rect));  
      
    % 遍历点集中的每个点  
    for i = 1:size(rect, 1)  
        % 计算相对于原点的偏移量  
        offset = rect(i,:) - origin;  
          
        % 应用旋转矩阵  
        rotated_offset = R * offset';  
          
        % 将旋转后的偏移量加回原点，得到新坐标  
        new_rect(i,:) = rotated_offset' + origin;  
    end  
end