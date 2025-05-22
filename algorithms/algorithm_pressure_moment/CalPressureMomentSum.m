% 计算阵列各单元地面反作用力相对于posAxis的力矩和
function [sumMomentsXYZ] = CalPressureMomentSum(posAxis,pts,ptsReal,pressure2D,grf_F)
    if size(posAxis,1)==1
        posAxis = repmat(posAxis,size(pressure2D,1),1);
    end
    sumMoments = zeros(size(pressure2D,1),3);
    for i = 1:size(pressure2D,1)
        img = reshape(pressure2D(i,:),32,32);
        sumMoment = zeros(1,3);
        for j = 1:length(pts)
            pt = pts(j,:);
            ptReal = ptsReal(j,:);
            F = [0,0,img(33-pt(2),pt(1))];
            moment = cross(ptReal-posAxis(i,:),F);
            sumMoment = sumMoment+moment;
        end
        sumMoments(i,:) = sumMoment;
    end
    
    % 转化为xyz
    sumMomentsXYZ.x = sumMoments(:,1);
    sumMomentsXYZ.y = sumMoments(:,2);
    sumMomentsXYZ.z = sumMoments(:,3);

    if nargin>4
        % 考虑切向力（默认切向力作用在posAxis投影）
        sumMomentsXYZ.x = sumMomentsXYZ.x+grf_F.y.*posAxis(:,3);
        sumMomentsXYZ.y = sumMomentsXYZ.y-grf_F.x.*posAxis(:,3);
    end
end