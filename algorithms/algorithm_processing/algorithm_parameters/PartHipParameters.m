% 臀底峰值
data = sum(pressureHip,2);
[vPeakH,pPeakH] = max(data(pHS2:pHE2)); pPeakH = pPeakH-1+pHS2;
tPeakH = times.hip(pPeakH);
p_listV.vPeakH = (vPeakH-data(pHS2))*weightR;