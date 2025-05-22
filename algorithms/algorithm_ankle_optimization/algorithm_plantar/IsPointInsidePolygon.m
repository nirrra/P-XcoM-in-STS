% 检查点是否在四边形内部  
function inside = IsPointInsidePolygon(x, y, rect)  
    % 计算从点(x, y)到四边形每条边的有向交叉积  
    crossProducts = zeros(1, 4);  
    for i = 1:4  
        i1 = mod(i, 4) + 1; % 下一个顶点的索引，考虑循环  
        x1 = rect(i, 1);  
        y1 = rect(i, 2);  
        x2 = rect(i1, 1);  
        y2 = rect(i1, 2);  
        crossProducts(i) = (x2 - x1) * (y - y1) - (y2 - y1) * (x - x1);  
    end  
      
    % 如果所有交叉积的符号都相同，则点在四边形内部或边界上  
    inside = all(crossProducts .* crossProducts(1) > 0);  
end