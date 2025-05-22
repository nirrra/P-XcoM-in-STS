%% 大腿质心位置优化函数
function cost = ThighCOMOptimization(params,pts,ptsReal,pressureHip2DInter,momentsShank2Thigh,idxSitStable,mid)
    comThighX = params(1);
    comThighY = params(2);
    comThighZ = params(3);

    comThigh = [comThighX,comThighY,comThighZ];

    cost = 0;
    for i = 1:length(idxSitStable)
        t = idxSitStable(i);
        img = reshape(pressureHip2DInter(t,:),32,32);
        sumMomentGRF = zeros(1,3);
        for j = 1:length(pts)
            pt = pts(j,:);
            F = [0,0,img(33-pt(2),pt(1))];
            if pt(1) == mid
                F = F./2;
            end
            pt = ptsReal(j,:);
            moment = cross([pt(1),pt(2),0]-comThigh,F);
            sumMomentGRF = sumMomentGRF+moment;
        end
        sumMoment = sumMomentGRF+momentsShank2Thigh(t,:);
        cost = cost+norm(sumMoment);
    end