function [tempCurves] = BlendCurves(cellCurves,method,showFig)
if nargin<3, showFig = false; end
if nargin<2, method = 'mean'; end
names = fieldnames(cellCurves{1,1});
lengthTemp = 500;
for typeCurve = 1:length(names)
    name = names{typeCurve};
    arrayCurveInterps = zeros(0,lengthTemp);
    for i = 1:length(cellCurves)
        idx = floor(cellCurves{i,2}/1000);
        curve = cellCurves{i,1}.(name);
        xo = linspace(1,lengthTemp,length(curve));
        xi = 1:lengthTemp;
        curveInterp = interp1(xo,curve,xi,'linear','extrap');
        arrayCurveInterps = [arrayCurveInterps;[curveInterp,idx]];
    end
    
    % 融合
    for i = 1:max(arrayCurveInterps(:,end))
        idxGroup = find(arrayCurveInterps(:,end)==i);
        aux = arrayCurveInterps(idxGroup,1:end-1);
        % 融合方法
        if strcmp(method,'mean')
            tempCurve = mean(aux,1);
        elseif strcmp(method,'median')
            tempCurve = median(aux,1);
        end
        tempCurves.(['g',num2str(i)]).(name) = tempCurve;
    end
end

if showFig
    for type = 1:length(names)
        name = names{type};
        curves = cellfun(@(x) cell(0,0),cell(3,1),'UniformOutput',false);
        yMax = -realmax; yMin = realmax;
        for i  = 1:length(cellCurves)
            idx = floor(cellCurves{i,2}/1000);
            curve = cellCurves{i,1}.(name);
            curves{idx} = [curves{idx};curve];
            yMax = max(yMax,max(curve));
            yMin = min(yMin,min(curve));
        end
        figure;
        subplot(3,1,1); hold on;
        for i = 1:length(curves{1,1})
            curve = curves{1,1}{i,1};
            x = linspace(1,lengthTemp,length(curve));
            plot(x,curve,'Color',[0.3, 0.3, 0.3, 0.5]);
        end
        plot(1:lengthTemp,tempCurves.g1.(name),'LineWidth',5);
        hold off; ylim([yMin,yMax]); title('g1');
        subplot(3,1,2); hold on;
        for i = 1:length(curves{2,1})
            curve = curves{2,1}{i,1};
            x = linspace(1,lengthTemp,length(curve));
            plot(x,curve,'Color',[0.3, 0.3, 0.3, 0.5]);
        end
        plot(1:lengthTemp,tempCurves.g2.(name),'LineWidth',5);
        hold off; ylim([yMin,yMax]); title('g2');
        subplot(3,1,3); hold on;
        for i = 1:length(curves{3,1})
            curve = curves{3,1}{i,1};
            x = linspace(1,lengthTemp,length(curve));
            plot(x,curve,'Color',[0.3, 0.3, 0.3, 0.5]);
        end
        plot(1:lengthTemp,tempCurves.g3.(name),'LineWidth',5);
        hold off; ylim([yMin,yMax]); title('g3');
        sgtitle(name);
    end
end

