% 计算点到线的距离
function distance = PointToLineDistance(pt, pt1, pt2)
    x = pt(1); y = pt(2);
    a = pt1(1); b = pt1(2);
    c = pt2(1); d = pt2(2);

    % 计算斜率  
    if c ~= a  
        m = (d - b) / (c - a);  
        A = -m;  
        B = 1;  
        C = m*a - b;  
    else  
        % 直线垂直于x轴，特殊处理  
        A = 1;  
        B = 0;  
        C = -a;  
    end  
      
    % 使用点到直线距离公式计算距离  
    numerator = abs(A*x + B*y + C);  
    denominator = sqrt(A^2 + B^2);  
    distance = numerator / denominator;  
end