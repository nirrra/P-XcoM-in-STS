% 足底峰值
data = sum(pressurePlantar,2);
aux = GetIdxTime(times.plantar,tHipMomentMin);
[vPeakP,pPeakP] = max(data(aux-5:aux+5)); pPeakP = pPeakP-1+aux-5; 
tPeakP = times.plantar(pPeakP); 

% 峰值前Counter
[~,pCounterP] = min(data(pPS2:pPeakP)); pCounterP = pCounterP-1+pPS2;
if data(pCounterP) == min(data(pCounterP-5:pCounterP+5))
    tCounterP = times.plantar(pCounterP);
    vCounterP = data(pCounterP);
else
    pCounterP = 1; tCounterP = NaN; vCounterP = NaN;
end
% 峰值后Rebound
aux = GetIdxTime(times.plantar,tPeakP+2);
[~,pReboundP] = min(data(pPeakP:aux)); pReboundP = pReboundP-1+pPeakP;
if data(pReboundP) == min(data(pReboundP-5:pReboundP+5))
    tReboundP = times.plantar(pReboundP);
    vReboundP = data(pReboundP);
else
    pReboundP = 1; tReboundP = NaN; vReboundP = NaN;
end

p_listV.vPeakP = (vPeakP-data(pStableP))*weightR;
p_listV.vPCounterP = (vCounterP-data(pPS2))*weightR;
p_listV.vReboundP = (vReboundP-data(pStableP))*weightR;