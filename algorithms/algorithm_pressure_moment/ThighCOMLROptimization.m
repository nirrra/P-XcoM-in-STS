%% 大腿质心位置优化函数
function cost = ThighCOMLROptimization(params,ptsLeft,ptsRealLeft,ptsRight,ptsRealRight,pressureHip2DInter,...
    momentsShank2ThighLeft,momentsShank2ThighRight,vecLeft2Right,idxSitStable,mid)
    comThighLeftX = params(1);
    comThighLeftY = params(2);
    comThighLeftZ = params(3);

    comThighLeft = [comThighLeftX,comThighLeftY,comThighLeftZ];
    comThighRight = comThighLeft+vecLeft2Right;

    cost = 0;
    for i = 1:length(idxSitStable)
        t = idxSitStable(i);
        img = reshape(pressureHip2DInter(t,:),32,32);
        sumMomentGRF = zeros(1,3);
        for j = 1:length(ptsLeft)
            pt = ptsLeft(j,:);
            F = [0,0,img(33-pt(2),pt(1))];
            if pt(1) == mid
                F = F./2;
            end
            pt = ptsRealLeft(j,:);
            moment = cross([pt(1),pt(2),0]-comThighLeft,F);
            sumMomentGRF = sumMomentGRF+moment;
        end
        sumMoment = sumMomentGRF+momentsShank2ThighLeft(t,:);
        cost = cost+norm(sumMoment);

        sumMomentGRF = zeros(1,3);
        for j = 1:length(ptsRight)
            pt = ptsRight(j,:);
            F = [0,0,img(33-pt(2),pt(1))];
            if pt(1) == mid
                F = F./2;
            end
            pt = ptsRealRight(j,:);
            moment = cross([pt(1),pt(2),0]-comThighRight,F);
            sumMomentGRF = sumMomentGRF+moment;
        end
        sumMoment = sumMomentGRF+momentsShank2ThighRight(t,:);
        cost = cost+norm(sumMoment);
    end