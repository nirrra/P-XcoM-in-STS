function [tableAnova,tableAnovaSign,h] = CalAnova(tableParas)
% 0表示具有显著差异性、正态性、齐次性
idxG1 = find(floor(tableParas.idx/1000)==1);
idxG2 = find(floor(tableParas.idx/1000)==2);
idxG3 = find(floor(tableParas.idx/1000)==3);
arrayParas = table2array(tableParas); p_nameParas = tableParas.Properties.VariableNames(1:end-1);
h = zeros(size(tableParas,2)-1,15);
for pItem = 1:size(tableParas,2)-1
    g1 = arrayParas(idxG1,pItem); g2 = arrayParas(idxG2,pItem); g3 = arrayParas(idxG3,pItem);
    g1 = g1(~isnan(g1)); g2 = g2(~isnan(g2)); g3 = g3(~isnan(g3));
    aux = [g1;g2;g3];
    aux = anova1(aux,[ones(1,size(g1,1)),2*ones(1,size(g2,1)),3*ones(1,size(g3,1))],'off');
    h(pItem,1) = ~(aux<0.05); h(pItem,2) = aux;
    h(pItem,3) = mean(g1); h(pItem,4) = std(g1);
    h(pItem,5) = mean(g2); h(pItem,6) = std(g2);
    h(pItem,7) = mean(g3); h(pItem,8) = std(g3);
    if sum(isnan(g1))~=0 || sum(isnan(g2))~=0 || sum(isnan(g3))~=0
        h(pItem,9) = 1; h(pItem,10) = 1; h(pItem,11) = 1; h(pItem,12) = 1;
    else
        if length(g1)<4
            h(pItem,9) = 1; 
        else
            h(pItem,9) = lillietest(g1,0.05); % 正态性检验，0表示正态性
        end
        if length(g2)<4
            h(pItem,10) = 1; 
        else
            h(pItem,10) = lillietest(g2,0.05);
        end
        if length(g3)<4
            h(pItem,11) = 1; 
        else
            h(pItem,11) = lillietest(g3,0.05);
        end
        [aux,~] = vartestn([g1;g2;g3],[ones(1,size(g1,1)),2*ones(1,size(g2,1)),3*ones(1,size(g3,1))],'off');
        h(pItem,12) = ~(aux<0.05);
    end
    h(pItem,13) = length(g1); h(pItem,14) = length(g2); h(pItem,15) = length(g3);
end
tableAnova = array2table(h,'RowNames',p_nameParas,'VariableNames',{'显著差异性','P值','I 平均值','I 标准差','II 平均值','II 标准差','III 平均值','III 标准差','I 正态性','II 正态性','III 正态性','齐次性','I 数目','II 数目','III 数目'});
tableAnovaSign = tableAnova((h(:,1)==0),:); % 只考虑差异显著性
tableAnovaSign = tableAnova(intersect(find(h(:,1)==0),find(sum(h(:,9:12),2)==0)),:); % 考虑齐次性
disp(['ANOVA 所有参数平均： 正态性，',num2str(sum(sum(h(:,9:11)))/3/size(h,1)),'；齐次性，',num2str(sum(h(:,12))/size(h,1))]);