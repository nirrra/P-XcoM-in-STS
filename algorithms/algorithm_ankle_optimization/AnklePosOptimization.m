function cost = AnklePosOptimization(params,lenFoot,lenShank,posFoot,h,posKnee)
    x = params(1);
    y = params(2);
    posAnkle = [x,y,h];
    
    cost1 = (lenFoot-(norm(posFoot-posAnkle)))^2; % 足部长度
    cost2 = (lenShank-(norm(posKnee-posAnkle)))^2; % 小腿长度
    cost3 = ((posAnkle(2)-posFoot(2))*(posKnee(1)-posFoot(1))-(posAnkle(1)-posFoot(1))*(posKnee(2)-posFoot(2)))^2; % 踝在膝-足直线上
    
    % 踝关节角
    vAB = posAnkle-posFoot;
    vCB = posAnkle-posKnee;
    ankleAngle = acosd(dot(vAB,vCB)/(norm(vAB)*norm(vCB)));
    
    cost_penalty1 = (ankleAngle<30)+(ankleAngle>150);

    % 足和y方向夹角
    vAB = posFoot-posAnkle; vAB = vAB(1:2);
    vY = [0,1];
    footAngle = acosd(dot(vAB,vY)/(norm(vAB)*norm(vY)));
    cost_penalty2 = footAngle<45;

    cost = cost1+cost2+0*cost3+1000*cost_penalty1+1000*cost_penalty2;