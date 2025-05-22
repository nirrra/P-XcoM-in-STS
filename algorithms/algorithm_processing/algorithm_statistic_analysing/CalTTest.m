function [tableTTest,tableTTestSign,h] = CalTTest(tableParas,idxG1,idxG2,flagSignrank)
% 0表示具有显著差异性、正态性、齐次性
if nargin<4
    flagSignrank = false; % 使用Wilcoxon signed rank test或t检验
end
idxG1 = find(floor(tableParas.idx/1000)==idxG1);
idxG2 = find(floor(tableParas.idx/1000)==idxG2);
arrayParas = table2array(tableParas); p_nameParas = tableParas.Properties.VariableNames(1:end-1);
h = zeros(size(tableParas,2)-1,11);
for pItem = 1:size(tableParas,2)-1
    g1 = arrayParas(idxG1,pItem); g2 = arrayParas(idxG2,pItem); 
    g1 = g1(~isnan(g1)); g2 = g2(~isnan(g2));
    [~,aux] = ttest2(g1,g2);
    if flagSignrank && sum(isnan(g1))==0 && sum(isnan(g2))==0
        [aux,~] = signrank(g1,g2);
    end
    if isnan(aux)
        aux = 1;
    end
    % 筛选<0.05，差异极其显著
    h(pItem,1) = ~(aux<0.05); h(pItem,2) = aux; 
    % 平均值及标准差
    h(pItem,3) = mean(g1); h(pItem,4) = std(g1);
    h(pItem,5) = mean(g2); h(pItem,6) = std(g2);
    if sum(isnan(g1))~=0 || sum(isnan(g2))~=0
        h(pItem,7) = 1; h(pItem,8) = 1; h(pItem,9) = 1;
    else
        if length(g1)<4
            h(pItem,7) = 1; 
        else
            h(pItem,7) = lillietest(g1,0.05); % 正态性检验，0表示正态性
        end
        if length(g2)<4
            h(pItem,8) = 1; 
        else
            h(pItem,8) = lillietest(g2,0.05);
        end
        if length(g1) == 1 || length(g2) == 1
            aux = 1;
        else
            [aux,~] = vartest2(g1,g2); % 齐次性检验，0表示齐次性
            if isnan(aux)
               aux = 1; 
            end
        end
        h(pItem,9) = aux;
    end
    h(pItem,10) = length(g1); h(pItem,11) = length(g2);
end
tableTTest = array2table(h,'RowNames',p_nameParas,...
    'VariableNames',{'差异性','P值','组1平均值','组1标准差','组2平均值','组2标准差','组1正态','组2正态','齐性检验','组1 数目','组2 数目'});
tableTTestSign = tableTTest(h(:,1)==0,:); % 只考虑差异显著性
tableTTestSign = tableTTest(intersect(find(h(:,1)==0),find(sum(h(:,7:9),2)==0)),:); % 考虑正态性和齐次性
% tableTTestSign = tableTTest(intersect(find(h(:,1)==0),find(h(:,9)==0)),:); % 考虑齐次性
% tableTTestSign = tableTTest(intersect(find(h(:,1)==0),find(sum(h(:,7:8),2)==0)),:); % 考虑正态性
if flagSignrank
    disp(['Wilcoxon signed rank test：正态性，',num2str(sum(sum(h(:,7:8)))/2/size(h,1)),'；齐次性，',num2str(sum(h(:,9))/size(h,1))]);
else
    disp(['t-test：正态性，',num2str(sum(sum(h(:,7:8)))/2/size(h,1)),'；齐次性，',num2str(sum(h(:,9))/size(h,1))]);
end