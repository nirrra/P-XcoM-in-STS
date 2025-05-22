function FigureMeanAndStd(time_curves, mean_curves, std_curves, time_stages, str_paras, idxParas, colors, fig_options)

if nargin<8
    figure_name = [];
    for i = idxParas
        figure_name = [figure_name, str_paras{i}, '; '];
    end
    figure_name(end-1:end) = [];
    figure_name = strrep(figure_name,'seg.','');
    figure_name = upper(figure_name);


    legend_names = str_paras(idxParas);
    for j = 1:length(legend_names)
        legend_names{j} = strrep(legend_names{j},'seg.','');
    end
    
    y_name = 'Signal Amplitude';
else
    figure_name = fig_options.figure_name;
    legend_names = fig_options.legend_names;
    y_name = fig_options.y_name;
end


f = figure('Color', 'white', 'Position', [100, 100, 1280, 480]); % 白色背景，适当大小
title_names = {'All','MT','ETF','DVR'};

pos = [0.06 0.25 0.26 0.6]; w = 0.325;

% 初始化存储所有 y 轴范围
all_y_min = [];
all_y_max = [];

for i = 2:4 % 四组STS策略
    axes('Position',[pos(1)+w*(i-2),pos(2),pos(3),pos(4)]);

    % 设置图形属性
    grid on;
    box on;
    set(gca, 'FontSize', 14, 'FontName', 'Arial', 'LineWidth', 1.5, ...
        'XMinorTick', 'on', 'YMinorTick', 'on');

    hold on;

    h_mean = []; % 存储均值线句柄

    y_min = []; y_max = [];

    for k = 1:length(idxParas)
        idxPara = idxParas(k);
        time = time_curves{idxPara}(i,:);
        signal_mean = mean_curves{idxPara}(i,:);
        signal_std = std_curves{idxPara}(i,:);
        time_stage = time_stages{idxPara}(i,:);

        % 绘制标准差区域（浅色阴影）
        fill([time, fliplr(time)], [signal_mean + signal_std, fliplr(signal_mean - signal_std)], ...
            colors(k+1,:) * 0.7 + 0.3, 'EdgeColor', 'none', 'FaceAlpha', 0.3); % 浅色半透明区域

        % 绘制阶段标记线并标注横坐标值
        for j = 1:length(time_stage)
            xline(time_stage(j), 'LineWidth', 1.5, 'LineStyle', '-.', ...
                  'Color', [0.80 0.40 0.40], ...
                  'Label', sprintf('%.1f', time_stage(j)), ...
                  'LabelOrientation', 'horizontal', ...
                  'LabelHorizontalAlignment', 'left', ...  
                  'LabelVerticalAlignment', 'bottom');     
        end
        
        % 绘制均值线（深色实线）
        h = plot(time, signal_mean, 'LineWidth', 2.5, 'Color', colors(k+1,:)); % 深色实线
        h_mean = [h_mean, h];

        % 计算当前曲线的 y 范围
        current_y_min = min(signal_mean - signal_std);
        current_y_max = max(signal_mean + signal_std);
        
        y_min(end+1) = current_y_min;
        y_max(end+1) = current_y_max;
    end
   
    % 更新全局 y 范围
    all_y_min = [all_y_min, min(y_min)];
    all_y_max = [all_y_max, max(y_max)];

    xlabel('Time / s', 'FontSize', 14, 'Interpreter', 'latex');
    ylabel(y_name, 'FontSize', 14, 'Interpreter', 'latex');

    xlim([0 2.5]);
    title(title_names{i}, 'Interpreter', 'latex');
end

% 计算全局 y 范围（可额外增加 5% 的边距）
global_y_min = min(all_y_min) - 0.05 * range([min(all_y_min), max(all_y_max)]);
global_y_max = max(all_y_max) + 0.05 * range([min(all_y_min), max(all_y_max)]);

% 统一设置所有子图的 y 轴范围
for i = 1:3
    ax = findobj(f, 'Type', 'axes', 'Position', [pos(1)+w*(i-1), pos(2), pos(3), pos(4)]);
    ylim(ax, [global_y_min, global_y_max]);
end

% 添加图例和标题
legend(h_mean, legend_names, 'Location','southoutside', ...
    'Position',[pos(1)+1.25*w, pos(2)-0.23, 0.1, 0.1], ...
    'FontSize', 14, 'Interpreter', 'latex', 'Orientation', 'horizontal', 'Box', 'on');

% sgtitle(figure_name, 'FontSize', 16, 'FontWeight', 'bold', 'Interpreter', 'latex');

print(f, ['./outputs/images mean std/', figure_name, '.png'], '-dpng', '-r600');
% print(f, ['./outputs/images mean std/','The Average Trends of omega2 and k','.png'],'-dpng','-r600');



% function FigureMeanAndStd(time_curves, mean_curves, std_curves, time_stages, str_paras, idxParas, colors, fig_options)
% 
% if nargin<8
%     figure_name = [];
%     for i = idxParas
%         figure_name = [figure_name, str_paras{i}, '; '];
%     end
%     figure_name(end-1:end) = [];
%     figure_name = strrep(figure_name,'seg.','');
%     figure_name = upper(figure_name);
% 
% 
%     legend_names = str_paras(idxParas);
%     for j = 1:length(legend_names)
%         legend_names{j} = strrep(legend_names{j},'seg.','');
%     end
%     
%     y_name = 'Signal Amplitude';
% else
%     figure_name = fig_options.figure_name;
%     legend_names = fig_options.legend_names;
%     y_name = fig_options.y_name;
% end
% 
% 
% f = figure('Color', 'white', 'Position', [100, 100, 1280, 480]); % 白色背景，适当大小
% title_names = {'All','MT','ETF','DVR'};
% 
% for i = 2:4 % 四组STS策略
%     subplot(1,3,i-1);
%     hold on;
% 
%     h_mean = []; % 存储均值线句柄
% 
%     y_min = []; y_max = [];
% 
%     for k = 1:length(idxParas)
%         idxPara = idxParas(k);
%         time = time_curves{idxPara}(i,:);
%         signal_mean = mean_curves{idxPara}(i,:);
%         signal_std = std_curves{idxPara}(i,:);
%         time_stage = time_stages{idxPara}(i,:);
% 
%         % 绘制标准差区域（浅色阴影）
%         fill([time, fliplr(time)], [signal_mean + signal_std, fliplr(signal_mean - signal_std)], ...
%             colors(k+1,:) * 0.7 + 0.3, 'EdgeColor', 'none', 'FaceAlpha', 0.3); % 浅色半透明区域
% 
%         %     xline(time_stage, 'LineWidth', 1.5, 'LineStyle', '-.' , 'Color', [0.80 0.40 0.40]);
%         % 绘制阶段标记线并标注横坐标值
%         for j = 1:length(time_stage)
%             xline(time_stage(j), 'LineWidth', 1.5, 'LineStyle', '-.', ...
%                   'Color', [0.80 0.40 0.40], ...
%                   'Label', sprintf('%.1f', time_stage(j)), ...
%                   'LabelOrientation', 'horizontal', ...
%                   'LabelHorizontalAlignment', 'left', ...  
%                   'LabelVerticalAlignment', 'bottom');     
%         end
%         
%         % 绘制均值线（深色实线）
%         h = plot(time, signal_mean, 'LineWidth', 2.5, 'Color', colors(k+1,:)); % 深色实线
%         h_mean = [h_mean, h];
% 
%         y_min(end+1) = min(mean_curves{idxPara}(1,:)-std_curves{idxPara}(1,:))-range(mean_curves{idxPara}(1,:))./3;
%         y_max(end+1) = max(mean_curves{idxPara}(1,:)+std_curves{idxPara}(1,:))+range(mean_curves{idxPara}(1,:))./3;
%     end
%    
%     % 设置图形属性
%     grid on;
%     box on;
%     set(gca, 'FontSize', 12, 'FontName', 'Arial', 'LineWidth', 1.5, ...
%         'XMinorTick', 'on', 'YMinorTick', 'on');
%     xlabel('Time / s', 'FontSize', 10, 'Interpreter', 'latex');
%     ylabel(y_name, 'FontSize', 10, 'Interpreter', 'latex');
% 
%     xlim([0 2.5]);
% %     ylim([min(y_min),max(y_max)]);
% 
%     title(title_names{i}, 'Interpreter', 'latex');
% 
% %     legend(h_mean, legend_names, 'Location', 'southoutside', 'FontSize', 10, 'Interpreter', 'none');
%     legend(h_mean, legend_names, 'Location', 'southoutside', 'FontSize', 10, 'Interpreter', 'latex');
% end
% 
% % 获取所有子图的y轴范围并统一设置
% all_ylim = [];
% for i = 1:3
%     subplot(1,3,i);
%     ylim_current = ylim;
%     all_ylim = [all_ylim; ylim_current];
% end
% 
% % 计算最大最小范围
% y_min = min(all_ylim(:,1));
% y_max = max(all_ylim(:,2));
% 
% % 统一设置y轴范围
% for i = 1:3
%     subplot(1,3,i);
%     ylim([y_min y_max]);
% end
% 
% sgtitle(figure_name, 'FontSize', 16, 'FontWeight', 'bold', 'Interpreter', 'latex');
% % sgtitle(figure_name, 'FontSize', 16, 'FontWeight', 'bold', 'Interpreter', 'none');
% 
% print(f, ['./outputs/images mean std/',figure_name,'.png'],'-dpng','-r300');
% % print(f, ['./outputs/images mean std/','The Average Trends of omega2 and k','.png'],'-dpng','-r300');
% 
