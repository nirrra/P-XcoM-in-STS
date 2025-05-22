function [plantarTemplate] = CreatePlantarTemplate(l,lr)
    % r 足跟直径；d M相对于C的水平偏移；l 足弓长度
    template = zeros(32,32);
    a = 30; b = 3; % 足跟左下一格
    template(a-6:a-1,b+1:b+5) = 1;
    template(a-5:a-2,b+2:b+4) = 3;
    template(a-6-l:a-7,b+1:b+4) = 1;
    template(a-6-l-4:a-6-l-1,b+1:b+6) = 1;
    template(a-6-l-4:a-6-l-1,b+2:b+4) = 3;

    a2 = max(1,a-6-l-4-4); b2 = b+9;
    rect = [a2,b;
        a,b;
        a,b2;
        a2,b2];

    if lr == 'r'
        template = template(:,32:-1:1);
        rect(:,2) = 33-rect(:,2);
        b = 33-b;
    end
    plantarTemplate.template = template;
    plantarTemplate.rect = rect;
    plantarTemplate.a = a;
    plantarTemplate.b = b;
    plantarTemplate.l = l;


    %%
%     cmap = [39, 150, 235; 
%             255, 217, 102;  
%             255 0 0]./255;  
%       
%     % 使用imagesc显示矩阵，并应用自定义颜色映射  
%     f = figure(1); hold on;     
% %     set(f, 'Color', [230,230,230]./255); % 设置为白色背景，可以根据需要更改RGB值
%     set(f, 'Color', [255,255,255]./255);
% 
%     template2 = template(32:-1:1,:);
%     imagesc(template2);
%     colormap(cmap);  
%     h3 = patch([1 2 2 1], [1 1 2 2],cmap(3,:)); set(h3, 'EdgeColor',cmap(3,:));  
%     h2 = patch([1 2 2 1], [1 1 2 2],cmap(2,:)); set(h2, 'EdgeColor',cmap(2,:));  
%     h1 = patch([1 2 2 1], [1 1 2 2],cmap(1,:)); set(h1, 'EdgeColor',cmap(1,:));  
%     axis image; % 保持图像纵横比  
% 
%     ax = gca; % 获取当前坐标轴的句柄
%     set(ax, 'FontSize', 16); % 设置坐标数字的大小为 12
% 
%     hold off; 
%     legend([h3, h2, h1], ...
%         {'Strong-reward Area', 'Weak-reward Area', 'None-reward Area'}, ...
%         'Location', 'eastoutside', 'FontName', 'Times New Roman' , 'FontSize', 13, 'Box','off');
% %     legend([h3, h2, h1], ...
% %         {'高奖赏区', '低奖赏区', '无奖赏区'}, ...
% %         'Location', 'eastoutside', 'FontName', 'songti' , 'FontSize', 22, 'Box','off');
%       
% 
% %     exportgraphics(f,'Plantar template.png', 'Resolution',600) % 去白边
%     set(gcf, 'InvertHardCopy', 'off');
%     print(f, 'Plantar template.png', '-dpng', '-r600', '-painters');

end