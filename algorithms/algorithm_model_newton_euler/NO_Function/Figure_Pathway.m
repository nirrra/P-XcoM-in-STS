clear;

i=1;
j=1;
%%
pathname = ['Pathway',' (', num2str(i),')', '.txt'];
if j==1
    Pathstream = Read_Pathway(pathname);
else
    Pathstream = Read_Pathway2(pathname);
end

% ��ⲽ�����ӿ���
maxrow  = 0;
for row=1:length(Pathstream.count)
    maxrow(row) =  max(Pathstream.x{row});
end
maxone = max(maxrow);
numpath = double(ceil((maxone)/32));
%����ʱ��
intial_time_pathway = min(Pathstream.time);
end_time_pathway = max(Pathstream.time);
pathtime_interval = round(seconds(end_time_pathway - intial_time_pathway)/length(Pathstream.count),3);
disp([pathname,':��������Ƶ��:',num2str(1/pathtime_interval)]);
Pathstream.time=(0:pathtime_interval:(length(Pathstream.time)-1)*pathtime_interval)';
%ԭʼ�㼣
footprint1 = FootprintMerge(Pathstream, numpath);
%��һ��ȥ������
Pathstream = Remove_Bad_Points_Stepone(Pathstream);
%�㼣ʶ��
footprint2 = FootprintMerge(Pathstream, numpath);
[label, left, right, n] = Mark(footprint2);%���껹��ԭʼ���꣬����Ϊx������Ϊy
% �ڶ���ȥ�����㣬��ӡ֮��ĵ�
Pathstream = Remove_Bad_Points_Steptwo(Pathstream,label,n);

figure(1);
footprint3 = FootprintMerge(Pathstream, numpath);
subplot(131)
imshow(footprint1)
subplot(132)
imshow(footprint2)
subplot(133)
imshow(footprint3)
% ���㵥����ӡʱ��
for j = 1: 1: n
    %�㼣ʱ��
    [x, y] = find(label == j);
    duration =[];
    for k = 1: 1: length(Pathstream.count)
        if ~isempty(intersect([x, y], double([Pathstream.x{k}, Pathstream.y{k}]), 'rows'))
            duration = [duration; Pathstream.time(k)];
        end
    end
    support{j} = duration;  % ���ÿ����ӡ���ֺͽ�����ʱ��
end

if(mean(support{n})<mean(support{1})) %����ÿ����ʱ��
    match_path = find(Pathstream.time >= (min(support{n})) & Pathstream.time <= (max((support{1}))));
else
    match_path = find(Pathstream.time >= (min(support{1})) & Pathstream.time <= (max((support{n}))));
end

%%
figure(2);
set(gcf, 'Position', [0 0 1920 1080]);
subplot(5, 2, [1 9]);
handle_footprint0 = plot(0, 0, '.b');
axis([0 0.48 0 numpath * 0.32]);
axis equal;
xlabel('x/m');
ylabel('y/m');
xlim([0 0.48 ]);
ylim([0 numpath * 0.32]);
hold on
%
subplot(5, 2, [2 10]);
hold on;
handle_footprint1 = plot(0, 0, '.b');
xlim([0 0.48 ]);
ylim([0 numpath * 0.32]);
axis equal;

for i = 1:length(match_path)
    if ishandle(handle_footprint0)
        delete(handle_footprint0);
    end
    [X, Y] = img2xy(double(Pathstream.x{match_path(i), 1}), double(Pathstream.y{match_path(i), 1}), numpath);
    subplot(5, 2, [1 9]);
    handle_footprint0 = plot(X, Y, '.b');
    xlabel('x/m');
    ylabel('y/m');
    xlim([0 0.48 ]);
    ylim([0 numpath * 0.32]);
    axis equal;
    %
    subplot(5, 2, [2 10]);
    plot(X, Y, '.b');
    xlabel('x/m');
    ylabel('y/m');
    xlim([0 0.48 ]);
    ylim([0 numpath * 0.32]);
    axis equal;
    pause(0.0001);
end