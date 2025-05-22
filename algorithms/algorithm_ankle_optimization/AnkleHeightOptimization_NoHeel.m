function cost = AnkleHeightOptimization_NoHeel(params,lenFoot,lenShank,posFoot,posKnee)
    x = params(1);
    y = params(2);
    z = params(3);
    posAnkle = [x,y,z];

    cost1 = (lenFoot-(norm(posFoot-posAnkle)))^2;
    cost2 = (lenShank-(norm(posKnee-posAnkle)))^2;
    cost3 = ((y-posFoot(2))/(x-posFoot(1))-(posKnee(2)-posFoot(2))/(posKnee(1)-posFoot(1)))^2;

    cost = cost1+cost2+cost3;