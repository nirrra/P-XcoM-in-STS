% OpenSim坐标系（前上右）转移到kinect坐标系（右前上）
% 注意：实际将人体对地面的作用力转移至（左后下）的坐标系，转换为地面对人体的作用力后，为kinect坐标系
grfHip.x = dataVicon.grf(:,4); grfHip.y = dataVicon.grf(:,2); grfHip.z = dataVicon.grf(:,3);
grmHip.x = dataVicon.grf(:,10); grmHip.y = dataVicon.grf(:,8); grmHip.z = dataVicon.grf(:,9);
grfPlantar.x = dataVicon.grf(:,13); grfPlantar.y = dataVicon.grf(:,11); grfPlantar.z = dataVicon.grf(:,12);
grfPlantarLeft.x = dataVicon.grf(:,22); grfPlantarLeft.y = dataVicon.grf(:,20); grfPlantarLeft.z = dataVicon.grf(:,21);
grfPlantarRight.x = dataVicon.grf(:,31); grfPlantarRight.y = dataVicon.grf(:,29); grfPlantarRight.z = dataVicon.grf(:,30);
grmPlantar.x = dataVicon.grf(:,19); grmPlantar.y = dataVicon.grf(:,17); grmPlantar.z = dataVicon.grf(:,18);
grmPlantarLeft.x = dataVicon.grf(:,28); grmPlantarLeft.y = dataVicon.grf(:,26); grmPlantarLeft.z = dataVicon.grf(:,27);
grmPlantarRight.x = dataVicon.grf(:,37); grmPlantarRight.y = dataVicon.grf(:,35); grmPlantarRight.z = dataVicon.grf(:,36);
grfCOP.x = dataVicon.grf(:,16); grfCOP.y = dataVicon.grf(:,14); grfCOP.z = dataVicon.grf(:,15);

% 将grf信号插值到kinect时间
% 测力台
grfHip = FilterXYZAndInter(grfHip,timeG,pGS1,pGE1,streamInter);
grmHip = FilterXYZAndInter(grmHip,timeG,pGS1,pGE1,streamInter);
% 臀底测力台去噪
grfHip.x = grfHip.x-mean(grfHip.x(idxStandStable));
grfHip.y = grfHip.y-mean(grfHip.y(idxStandStable));
grfHip.z = grfHip.z-mean(grfHip.z(idxStandStable));

grfHipLeft.x = grfHip.x./2; grfHipLeft.y = grfHip.y./2; grfHipLeft.z = grfHip.z./2;
grfHipRight.x = grfHip.x./2; grfHipRight.y = grfHip.y./2; grfHipRight.z = grfHip.z./2;
grmHipLeft.x = grmHip.x./2; grmHipLeft.y = grmHip.y./2; grmHipLeft.z = grmHip.z./2;
grmHipRight.x = grmHip.x./2; grmHipRight.y = grmHip.y./2; grmHipRight.z = grmHip.z./2;

grfPlantar = FilterXYZAndInter(grfPlantar,timeG,pGS1,pGE1,streamInter);
grfPlantarLeft = FilterXYZAndInter(grfPlantarLeft,timeG,pGS1,pGE1,streamInter);
grfPlantarRight = FilterXYZAndInter(grfPlantarRight,timeG,pGS1,pGE1,streamInter);
grmPlantarLeft = FilterXYZAndInter(grmPlantarLeft,timeG,pGS1,pGE1,streamInter);
grmPlantarRight = FilterXYZAndInter(grmPlantarRight,timeG,pGS1,pGE1,streamInter);
grmPlantar = FilterXYZAndInter(grmPlantar,timeG,pGS1,pGE1,streamInter);
grfCOP = FilterXYZAndInter(grfCOP,timeG,pGS1,pGE1,streamInter);