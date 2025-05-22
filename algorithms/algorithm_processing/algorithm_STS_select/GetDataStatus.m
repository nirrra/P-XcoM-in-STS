function [dataStatus] = GetDataStatus(time,posSTS)
dataStatus = zeros(size(time));
fs = round(length(time)/range(time));

% figure; hold on;
% plot(grfPlantar.z);
% plot(posSTS.seatOn,grfPlantar.z(posSTS.seatOn),'ro');
% plot(posSTS.seatEnd,grfPlantar.z(posSTS.seatEnd),'r*');
% plot(posSTS.standOn,grfPlantar.z(posSTS.standOn),'go');
% plot(posSTS.standEnd,grfPlantar.z(posSTS.standEnd),'g*');
% hold off;

% 站起段
for i = 1:length(posSTS.seatOn)
    if posSTS.seatEnd(i)-posSTS.seatOn(i) < 4*fs
        dataStatus(posSTS.seatOn(i):posSTS.seatEnd(i)) = 1;
    end
end
% 坐下段
for i = 1:length(posSTS.standOn)
    if posSTS.standEnd(i)-posSTS.standOn(i) < 4*fs
        dataStatus(posSTS.standOn(i):posSTS.standEnd(i)) = 3;
    end
end
% 静站段
for i = 1:length(posSTS.seatEnd)
    posSeatEnd = posSTS.seatEnd(i);
    aux = find(posSTS.standOn>posSeatEnd);
    if ~isempty(aux) && posSTS.standOn(aux(1))-posSeatEnd < 4*fs
        posStandOn = posSTS.standOn(aux(1));
        dataStatus(posSeatEnd:posStandOn) = 2;
    end
end
% 静坐段
for i = 1:length(posSTS.standEnd)
    posStandEnd = posSTS.standEnd(i);
    aux = find(posSTS.seatOn>posStandEnd);
    if ~isempty(aux) && posSTS.seatOn(aux(1))-posStandEnd < 4*fs
        posSeatOn = posSTS.seatOn(aux(1));
        dataStatus(posStandEnd:posSeatOn) = 4;
    end
end