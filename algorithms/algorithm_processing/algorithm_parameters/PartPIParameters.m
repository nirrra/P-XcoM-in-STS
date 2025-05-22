data = PI;
for pPIMin = pKIS2+10:pStableKI-10
    if data(pPIMin) == min(data(pPIMin-10:pPIMin+10)) && data(pPIMin)-min(data(pKIS2:pStableKI))<0.2
        tPIMin = streamInter.wtime(pPIMin);
        vPIMin = data(pPIMin);
        break;
    end
end
if pPIMin == pStableKI-10
    [~,pPIMin] = min(data(pKIS2:pStableKI)); pPIMin = pPIMin-1+pKIS2;
    tPIMin = streamInter.wtime(pPIMin); vPIMin = data(pPIMin);
end

for pPIMax = pPIMin:min(pPIMin+ceil(fsInter*1),pStableKI)
    if data(pPIMax) == max(data(pPIMax-10:pPIMax+10))
        tPIMax = streamInter.wtime(pPIMax);
        vPIMax = data(pPIMax);
        break;
    end
end
if pPIMax == min(pPIMin+ceil(fsInter*1),pStableKI)
    tPIMax = NaN; 
    vPIMax = NaN;
end

vPIStart = data(pKIS2); vPISEnd = data(pStableKI);

p_listV.vPIMin = vPIMin;
p_listV.vPIMax = vPIMax;
p_listV.vPIStart = vPIStart;
p_listV.vPISEnd = vPISEnd;