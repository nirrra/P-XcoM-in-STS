idx_sts = 3;
flag_xlim = false;

f = figure; 
set(gcf, 'units', 'normalized', 'outerposition', [0 0 1 1], 'color', 'w');
subplot(3,1,1);
hold on; grid on;
p3 = plot(times.union,dis_com_bos_plantar.dis,'Color', colors(2,:), 'LineWidth', 1.5, 'DisplayName', 'com-bos 足部');
p4 = plot(times.union,dis_xcom_bos_plantar.dis,'Color', colors(10,:), 'LineWidth', 1.5, 'DisplayName', 'xcom-bos 足部');
p1 = plot(times.union,dis_com_bos.dis,'Color', colors(1,:), 'LineWidth', 1.5, 'DisplayName', 'com-bos 包含臀部');
p2 = plot(times.union,dis_xcom_bos.dis,'Color', colors(8,:), 'LineWidth', 1.5, 'DisplayName', 'xcom-bos 包含臀部');

xline(sts_segments.time_start, '--', 'Color', line_colors(1,:), 'LineWidth', 0.5, 'Alpha', 0.7);
xline(sts_segments.time_p1, '--', 'Color', line_colors(6,:), 'LineWidth', 0.5, 'Alpha', 0.7);
xline(sts_segments.time_p2, '--', 'Color', line_colors(7,:), 'LineWidth', 0.5, 'Alpha', 0.7);
xline(sts_segments.time_p3, '--', 'Color', line_colors(8,:), 'LineWidth', 0.5, 'Alpha', 0.7);
xline(sts_segments.time_p4, '--', 'Color', line_colors(9,:), 'LineWidth', 0.5, 'Alpha', 0.7);
xline(sts_segments.time_end, '--', 'Color', line_colors(5,:), 'LineWidth', 0.5, 'Alpha', 0.7);

hold off; 
legend([p1, p2, p3, p4], 'Location', 'northwest', 'FontSize', 9);
title('到BoS最短直线距离（负值表示在BoS之外）'); xlabel('time / s'); ylabel('distance / m');

if flag_xlim, xlim([sts_segments.time_start(idx_sts)-1,sts_segments.time_end(idx_sts)+1]); end

subplot(3,1,2);
hold on; grid on;
p1 = plot(times.union,dis_com_bos.y_back,'Color', colors(1,:), 'LineWidth', 1.5, 'DisplayName', 'com-bos 包含臀部');
p2 = plot(times.union,dis_xcom_bos.y_back,'Color', colors(8,:), 'LineWidth', 1.5, 'DisplayName', 'xcom-bos 包含臀部');
% p3 = plot(times.union,dis_com_bos_plantar.y_back,'Color', colors(2,:), 'LineWidth', 1.5, 'DisplayName', 'com-bos 足部');
% p4 = plot(times.union,dis_xcom_bos_plantar.y_back,'Color', colors(10,:), 'LineWidth', 1.5, 'DisplayName', 'xcom-bos 足部');

xline(sts_segments.time_start, '--', 'Color', line_colors(1,:), 'LineWidth', 0.5, 'Alpha', 0.7);
xline(sts_segments.time_p1, '--', 'Color', line_colors(6,:), 'LineWidth', 0.5, 'Alpha', 0.7);
xline(sts_segments.time_p2, '--', 'Color', line_colors(7,:), 'LineWidth', 0.5, 'Alpha', 0.7);
xline(sts_segments.time_p3, '--', 'Color', line_colors(8,:), 'LineWidth', 0.5, 'Alpha', 0.7);
xline(sts_segments.time_p4, '--', 'Color', line_colors(9,:), 'LineWidth', 0.5, 'Alpha', 0.7);
xline(sts_segments.time_end, '--', 'Color', line_colors(5,:), 'LineWidth', 0.5, 'Alpha', 0.7);

hold off;
legend([p1, p2], 'Location', 'northwest', 'FontSize', 9);
title('到BoS后边界距离（正值表示位于BoS后边界前方）'); xlabel('time / s'); ylabel('后 ← distance / m → 前');

if flag_xlim, xlim([sts_segments.time_start(idx_sts)-1,sts_segments.time_end(idx_sts)+1]); end

subplot(3,1,3);
hold on; grid on;
p1 = plot(times.union,dis_com_bos_plantar.y_back,'Color', colors(2,:), 'LineWidth', 1.5, 'DisplayName', 'com-bos 足部');
p2 = plot(times.union,dis_xcom_bos_plantar.y_back,'Color', colors(10,:), 'LineWidth', 1.5, 'DisplayName', 'xcom-bos 足部');

xline(sts_segments.time_start, '--', 'Color', line_colors(1,:), 'LineWidth', 0.5, 'Alpha', 0.7);
xline(sts_segments.time_p1, '--', 'Color', line_colors(6,:), 'LineWidth', 0.5, 'Alpha', 0.7);
xline(sts_segments.time_p2, '--', 'Color', line_colors(7,:), 'LineWidth', 0.5, 'Alpha', 0.7);
xline(sts_segments.time_p3, '--', 'Color', line_colors(8,:), 'LineWidth', 0.5, 'Alpha', 0.7);
xline(sts_segments.time_p4, '--', 'Color', line_colors(9,:), 'LineWidth', 0.5, 'Alpha', 0.7);
xline(sts_segments.time_end, '--', 'Color', line_colors(5,:), 'LineWidth', 0.5, 'Alpha', 0.7);

hold off;
legend([p1, p2], 'Location', 'northwest', 'FontSize', 9);
title('到BoS后边界距离（正值表示位于BoS后边界前方）'); xlabel('time / s'); ylabel('后 ← distance / m → 前');

if flag_xlim, xlim([sts_segments.time_start(idx_sts)-1,sts_segments.time_end(idx_sts)+1]); end

sgtitle('图.8 com-bos距离', 'FontWeight', 'normal', 'FontSize', 11, 'Color', [.2 .2 .2]);


print(f, ['./outputs/images distance/',filename,'_com_bos.png'],'-dpng','-r300');