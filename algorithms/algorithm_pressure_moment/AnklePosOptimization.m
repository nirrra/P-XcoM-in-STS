%% 踝关节位置优化函数
function cost = AnklePosOptimization(params,pts,ptsReal,pressurePlantar2DInter,forceShank2Foot,vecAnkle2Foot,idxStandStable,Lcs,flagZ)
    if nargin<9, flagZ = true; end
    posAnkleX = params(1);
    posAnkleY = params(2);
    posAnkleZ = params(3);
    if ~flagZ
        posAnkleZ = -vecAnkle2Foot(3);
    end
    posAnkle = [posAnkleX,posAnkleY,posAnkleZ];
    
    posFoot = posAnkle+vecAnkle2Foot;
    comFoot = Lcs*(posFoot-posAnkle)+posAnkle;
    cost = 0;
    
    for i = 1:length(idxStandStable)
        t = idxStandStable(i);
        img = reshape(pressurePlantar2DInter(t,:),32,32);
        sumMomentGRF = zeros(1,3);
        for j = 1:length(pts)
            pt = pts(j,:);
            F = [0,0,img(33-pt(2),pt(1))];
            pt = ptsReal(j,:);
            moment = cross([pt(1),pt(2),0]-comFoot,F);
            sumMomentGRF = sumMomentGRF+moment;
        end
        sumMoment = sumMomentGRF+cross(posAnkle-comFoot,forceShank2Foot(t,:));
        cost = cost+norm(sumMoment);
    end

end