function cost = AnkleHeightOptimization(params,lenFoot,lenShank,posFoot,posAnkle,posKnee)
    h = params;
    posAnkle = [posAnkle(1:2),h];

    cost1 = (lenFoot-(norm(posFoot-posAnkle)))^2;
    cost2 = (lenShank-(norm(posKnee-posAnkle)))^2;

    cost = cost1+cost2;