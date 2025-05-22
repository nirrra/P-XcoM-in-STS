%% 显示STS段
function [] = ShowSTS(posStart,posEnd,data,streamInter,color)
    data = data(101:end-100);
    if nargin<5, color = 'k'; end
    if nargin<4
        for i = 1:length(posStart)
            plot([posStart(i),posStart(i)],[min(data),max(data)],'k');
            plot([posEnd(i),posEnd(i)],[min(data),max(data)],'k');
            plot([posStart(i),posEnd(i)],[mean(data),mean(data)],[color,'-']);
        end
    else
        for i = 1:length(posStart)
            plot(streamInter.wtime([posStart(i),posStart(i)]),[min(data),max(data)],'k');
            plot(streamInter.wtime([posEnd(i),posEnd(i)]),[min(data),max(data)],'k');
            plot(streamInter.wtime([posStart(i),posEnd(i)]),[mean(data),mean(data)],[color,'-']);
        end
    end
end