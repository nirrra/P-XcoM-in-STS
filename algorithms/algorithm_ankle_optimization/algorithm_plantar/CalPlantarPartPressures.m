function [pressures] = CalPlantarPartPressures(img,partitionTemplate)

aux = partitionTemplate.sumD.*img; pressures.sumD = sum(aux(:));
aux = partitionTemplate.sumM12.*img; pressures.sumM12 = sum(aux(:));
aux = partitionTemplate.sumM35.*img; pressures.sumM35 = sum(aux(:));
aux = partitionTemplate.sumL.*img; pressures.sumL = sum(aux(:));
aux = partitionTemplate.sumC.*img; pressures.sumC = sum(aux(:));
