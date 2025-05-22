function [tableCorr,tableCorrSign,tableStrCorrSign,tableCellCorrSign] = CalCorrCoef(tableParas,level)
if nargin<2
    level = 0.9;
end
arrayParas = table2array(tableParas); p_nameParas = tableParas.Properties.VariableNames(1:end-1);
tableCorr = zeros(length(p_nameParas)); arrayCorrSign = zeros(length(p_nameParas));
for i = 1:length(p_nameParas)
    for j = 1:length(p_nameParas)
        g1 = arrayParas(:,i);
        g2 = arrayParas(:,j);
        aux = intersect(find(~isnan(g1)),find(~isnan(g2)));
        aux = corrcoef(g1(aux),g2(aux));
        tableCorr(i,j) = aux(1,2);
        if abs(aux(1,2))>level
            arrayCorrSign(i,j) = aux(1,2);
        end
    end
end

tableCorr = array2table(tableCorr,'VariableNames',p_nameParas,'RowNames',p_nameParas);
tableCorrSign = array2table(arrayCorrSign,'VariableNames',p_nameParas,'RowNames',p_nameParas);
cellCorrSign = cellfun(@(x) cell(0, 0),cell(length(p_nameParas), 1),'UniformOutput',false);
strCorrSign = cellfun(@(x) '',cell(length(p_nameParas), 1),'UniformOutput',false);
for i = 1:length(p_nameParas)
    for j = 1:length(p_nameParas)
        if i~=j && arrayCorrSign(i,j)~=0
            cellCorrSign{i,1} = [cellCorrSign{i,1};p_nameParas{j}];
            strCorrSign{i,1} = [strCorrSign{i,1},p_nameParas{j},';  '];
        end
    end
end
tableStrCorrSign = cell2table(strCorrSign,'RowNames',p_nameParas);
tableCellCorrSign = cell2table(cellCorrSign,'RowNames',p_nameParas);