%% 阵列校准到单位N
[ratioV2P_P,ratioV2P_H] = Voltage2Pressure(times,pressurePlantar,pressureHip,weight);
pressurePlantar = ratioV2P_P.*pressurePlantar; pressurePlantar2D = ratioV2P_P.*pressurePlantar2D;
pressureHip = ratioV2P_H.*pressureHip; pressureHip2D = ratioV2P_H.*pressureHip2D;
[p_listPlantar,ptsPartsAnotomy] = CalPlantarPressures(pressurePlantar2D);