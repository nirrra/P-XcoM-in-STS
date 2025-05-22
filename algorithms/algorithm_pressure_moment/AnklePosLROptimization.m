%% 踝关节位置优化函数，同时优化左右踝关节
function cost = AnklePosLROptimization(params,ptsLeft,ptsRealLeft,ptsRight,ptsRealRight,pressurePlantar2DInter,...
    vecLeft2Right,vecAnkle2FootLeft,vecAnkle2FootRight,forceShank2FootLeft,forceShank2FootRight,idxStandStable,Lcs)
    posAnkleLeftX = params(1);
    posAnkleLeftY = params(2);
    posAnkleLeftZ = params(3);

    posAnkleLeft = [posAnkleLeftX,posAnkleLeftY,posAnkleLeftZ];
    posAnkleRight = posAnkleLeft+vecLeft2Right;
    posFootLeft = posAnkleLeft+vecAnkle2FootLeft;
    posFootRight = posAnkleRight+vecAnkle2FootRight;
    comFootLeft = Lcs*(posFootLeft-posAnkleLeft)+posAnkleLeft;
    comFootRight = Lcs*(posFootRight-posAnkleRight)+posAnkleRight;

    cost = 0;

    for i = 1:length(idxStandStable)
        t = idxStandStable(i);
        img = reshape(pressurePlantar2DInter(t,:),32,32);
        sumMomentGRF = zeros(1,3);
        for j = 1:length(ptsLeft)
            pt = ptsLeft(j,:);
            F = [0,0,img(33-pt(2),pt(1))];
            pt = ptsRealLeft(j,:);
            moment = cross([pt(1),pt(2),0]-comFootLeft,F);
            sumMomentGRF = sumMomentGRF+moment;
        end
        sumMoment = sumMomentGRF+cross(posAnkleLeft-comFootLeft,forceShank2FootLeft(t,:));
        cost = cost+norm(sumMoment);

        sumMomentGRF = zeros(1,3);
        for j = 1:length(ptsRight)
            pt = ptsRight(j,:);
            F = [0,0,img(33-pt(2),pt(1))];
            pt = ptsRealRight(j,:);
            moment = cross([pt(1),pt(2),0]-comFootRight,F);
            sumMomentGRF = sumMomentGRF+moment;
        end
        sumMoment = sumMomentGRF+cross(posAnkleRight-comFootRight,forceShank2FootRight(t,:));
        cost = cost+norm(sumMoment);
    end
