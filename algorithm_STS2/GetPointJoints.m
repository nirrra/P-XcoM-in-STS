function pointJoints = GetPointJoints(data,posStart,posEnd,timeV,streamInter,pVS1,pVE1)
    timeStart = streamInter.wtime(posStart);
    timeEnd = streamInter.wtime(posEnd);
    % 处理opensim结果
    aux = GetIdxTime(timeV,[timeStart,timeEnd]);
    timeAux = timeV(aux(1):aux(2));
    % 踝关节
    dataAnkle = data.ankle_angle_l_moment(pVS1:pVE1);
    dataAnkle = dataAnkle(aux(1):aux(2));
    % 最小点
    [~,posAnkleMin] = min(dataAnkle);
    % 最小点前的最大点
    [~,posAnkleMax] = max(dataAnkle(1:posAnkleMin));
    
    % 膝关节
    dataKnee = data.knee_angle_l_moment(pVS1:pVE1);
    dataKnee = dataKnee(aux(1):aux(2));
    % 最大点
    [~,posKneeMax] = max(dataKnee);
    
    % 髋关节
    dataHip = data.hip_flexion_l_moment(pVS1:pVE1);
    dataHip = dataHip(aux(1):aux(2));
    % 最小点
    [~,posHipMin] = min(dataHip);
    
    figure; 
    subplot(3,1,1); hold on;
    plot(timeAux,dataAnkle);
    plot(timeAux(posAnkleMin),dataAnkle(posAnkleMin),'go');
    plot(timeAux(posAnkleMax),dataAnkle(posAnkleMax),'ro');
    hold off; title('踝关节');
    subplot(3,1,2); hold on;
    plot(timeAux,dataKnee);
    plot(timeAux(posKneeMax),dataKnee(posKneeMax),'ro');
    hold off; title('膝关节');
    subplot(3,1,3); hold on;
    plot(timeAux,dataHip);
    plot(timeAux(posHipMin),dataHip(posHipMin),'ro');
    hold off; title('髋关节');
    
    pointJoints.timeAnkleMin = timeAux(posAnkleMin);
    pointJoints.timeAnkleMax = timeAux(posAnkleMax);
    pointJoints.timeKneeMax = timeAux(posKneeMax);
    pointJoints.timeHipMin = timeAux(posHipMin);