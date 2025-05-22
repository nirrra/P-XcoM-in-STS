
%% ʱ����,�������Ǿ���ʵ������ĵ���˫֧���࣬��������������ѧ����
support_time_temp = [];
for i=1:length(single_support_time)
    support_time_temp = [support_time_temp;single_support_time{i}];
    
end
for i=1:length(double_support_time)
    support_time_temp = [support_time_temp;double_support_time{i}];
end
first_index = min(support_time_temp);
end_index = max(support_time_temp);

supporttime = cell(length(support_time),1);
for i = 1:length(support_time)
    supporttime{i} = int32(support_time{i} * 1000);%��ʱ���ɺ���
end
tstart = min(supporttime{1});%���룬int32
tstop= max(supporttime{end});


kinect_cell_arrays = Kinect_Azure_Struct_To_Array(Kinectstream);
%% ��������巴������
ground_force.x =segments_force.reaction_force_Foot_Left_distal.x + segments_force.reaction_force_Foot_Right_distal.x;
ground_force.y =segments_force.reaction_force_Foot_Left_distal.y + segments_force.reaction_force_Foot_Right_distal.y;
ground_force.z =segments_force.reaction_force_Foot_Left_distal.z + segments_force.reaction_force_Foot_Right_distal.z;
valid_time = (first_index:end_index)/inter_freq;

figure
subplot(3,1,1),plot(valid_time,ground_force.x(first_index:end_index))
title('��������巴������')
ylabel('x���򣬶�״��(N)')
subplot(3,1,2),plot(valid_time,ground_force.y(first_index:end_index))
ylabel('y���򣬶�״��(N)')
subplot(3,1,3),plot(valid_time,ground_force.z(first_index:end_index))
ylabel('z���򣬶�״��(N)')

% �������ŷ�������
figure
subplot(3,1,1),plot(valid_time,ground_force_Left.x(first_index:end_index))
title('�������ŷ�������')
ylabel('x���򣬶�״��(N)')
subplot(3,1,2),plot(valid_time,ground_force_Left.y(first_index:end_index))
ylabel('y���򣬶�״��(N)')
subplot(3,1,3),plot(valid_time,ground_force_Left.z(first_index:end_index))
ylabel('z���򣬶�״��(N)')
% ������ҽŷ�������
figure
subplot(3,1,1),plot(valid_time,ground_force_Right.x(first_index:end_index))
title('������ҽŷ�������')
ylabel('x���򣬶�״��(N)')
subplot(3,1,2),plot(valid_time,ground_force_Right.y(first_index:end_index))
ylabel('y���򣬶�״��(N)')
subplot(3,1,3),plot(valid_time,ground_force_Right.z(first_index:end_index))
ylabel('z���򣬶�״��(N)')

%% ��������巴������ż��
ground_couple_moment_global.x = ground_couple_moment_global_Left.x + ground_couple_moment_global_Right.x;
ground_couple_moment_global.y = ground_couple_moment_global_Left.y + ground_couple_moment_global_Right.y;
ground_couple_moment_global.z = ground_couple_moment_global_Left.z + ground_couple_moment_global_Right.z;

figure
subplot(3,1,1),plot(valid_time,ground_couple_moment_global.x(first_index:end_index))
title('��������巴������ż��')
ylabel('x����(N*m)')
subplot(3,1,2),plot(valid_time,ground_couple_moment_global.y(first_index:end_index))
ylabel('y����(N*m)')
subplot(3,1,3),plot(valid_time,ground_couple_moment_global.z(first_index:end_index))
ylabel('z����(N*m)')

% �������ŷ�������ż��
figure
subplot(3,1,1),plot(valid_time,ground_couple_moment_global_Left.x(first_index:end_index))
title('�������ŷ�������ż��')
ylabel('x����(N*m )')
subplot(3,1,2),plot(valid_time,ground_couple_moment_global_Left.y(first_index:end_index))
ylabel('y����(N*m)')
subplot(3,1,3),plot(valid_time,ground_couple_moment_global_Left.z(first_index:end_index))
ylabel('z����(N*m)')
% ������ҽŷ�������ż��
figure
subplot(3,1,1),plot(valid_time,ground_couple_moment_global_Right.x(first_index:end_index))
title('������ҽŷ�������ż��')
ylabel('x����(N*m)')
subplot(3,1,2),plot(valid_time,ground_couple_moment_global_Right.y(first_index:end_index))
ylabel('y����(N*m)')
subplot(3,1,3),plot(valid_time,ground_couple_moment_global_Right.z(first_index:end_index))
ylabel('z����(N*m)')
%% �׹ؽ���������
% ���׹ؽ�������
figure
subplot(3,1,1),plot(valid_time,segments_force.reaction_force_Foot_Left_proximal.x(first_index:end_index))
title('���׹ؽ��ܵ���������')
ylabel('x���򣬶�״��(N)')
subplot(3,1,2),plot(valid_time,segments_force.reaction_force_Foot_Left_proximal.y(first_index:end_index))
ylabel('y���򣬶�״��(N)')
subplot(3,1,3),plot(valid_time,segments_force.reaction_force_Foot_Left_proximal.z(first_index:end_index))
ylabel('z���򣬶�״��(N)')
% ���׹ؽ���������
figure
for i =1:length(moment_reaction_couple_global.Foot_Left_proximal)
    Foot_Left_proximal_x(i) = moment_reaction_couple_global.Foot_Left_proximal{i}(1);
    Foot_Left_proximal_y(i) = moment_reaction_couple_global.Foot_Left_proximal{i}(2);
    Foot_Left_proximal_z(i) = moment_reaction_couple_global.Foot_Left_proximal{i}(3);
end
subplot(3,1,1),plot(valid_time,Foot_Left_proximal_x(first_index:end_index))
title('���׹ؽ��ܵ�������')
ylabel('x���򣬶�״��(N*m)')
subplot(3,1,2),plot(valid_time,Foot_Left_proximal_y(first_index:end_index))
ylabel('y���򣬶�״��(N*m)')
subplot(3,1,3),plot(valid_time,Foot_Left_proximal_z(first_index:end_index))
ylabel('z���򣬶�״��(N*m)')

% ���׹ؽ�������
figure
subplot(3,1,1),plot(valid_time,segments_force.reaction_force_Foot_Right_proximal.x(first_index:end_index))
title('���׹ؽ��ܵ���������')
ylabel('x���򣬶�״��(N)')
subplot(3,1,2),plot(valid_time,segments_force.reaction_force_Foot_Right_proximal.y(first_index:end_index))
ylabel('y���򣬶�״��(N)')
subplot(3,1,3),plot(valid_time,segments_force.reaction_force_Foot_Right_proximal.z(first_index:end_index))
ylabel('z���򣬶�״��(N)')
% ���׹ؽ���������
figure
for i =1:length(moment_reaction_couple_global.Foot_Right_proximal)
    Foot_Right_proximal_x(i) = moment_reaction_couple_global.Foot_Right_proximal{i}(1);
    Foot_Right_proximal_y(i) = moment_reaction_couple_global.Foot_Right_proximal{i}(2);
    Foot_Right_proximal_z(i) = moment_reaction_couple_global.Foot_Right_proximal{i}(3);
end
subplot(3,1,1),plot(valid_time,Foot_Right_proximal_x(first_index:end_index))
title('���׹ؽ��ܵ�������')
ylabel('x���򣬶�״��(N*m)')
subplot(3,1,2),plot(valid_time,Foot_Right_proximal_y(first_index:end_index))
ylabel('y���򣬶�״��(N*m)')
subplot(3,1,3),plot(valid_time,Foot_Right_proximal_z(first_index:end_index))
ylabel('z���򣬶�״��(N*m)')
%% ϥ�ؽ���������
% ��ϥ�ؽ�������
figure
subplot(3,1,1),plot(valid_time,segments_force.reaction_force_Shank_Left_proximal.x(first_index:end_index))
title('��ϥ�ؽ��ܵ���������')
ylabel('x���򣬶�״��(N)')
subplot(3,1,2),plot(valid_time,segments_force.reaction_force_Shank_Left_proximal.y(first_index:end_index))
ylabel('y���򣬶�״��(N)')
subplot(3,1,3),plot(valid_time,segments_force.reaction_force_Shank_Left_proximal.z(first_index:end_index))
ylabel('z���򣬶�״��(N)')
% ��ϥ�ؽ���������
figure
for i =1:length(moment_reaction_couple_global.Shank_Left_proximal)
    Shank_Left_proximal_x(i) = moment_reaction_couple_global.Shank_Left_proximal{i}(1);
    Shank_Left_proximal_y(i) = moment_reaction_couple_global.Shank_Left_proximal{i}(2);
    Shank_Left_proximal_z(i) = moment_reaction_couple_global.Shank_Left_proximal{i}(3);
end
subplot(3,1,1),plot(valid_time,Shank_Left_proximal_x(first_index:end_index))
title('��ϥ�ؽ��ܵ�������')
ylabel('x���򣬶�״��(N*m)')
subplot(3,1,2),plot(valid_time,Shank_Left_proximal_y(first_index:end_index))
ylabel('y���򣬶�״��(N*m)')
subplot(3,1,3),plot(valid_time,Shank_Left_proximal_z(first_index:end_index))
ylabel('z���򣬶�״��(N*m)')

% ��ϥ�ؽ�������
figure
subplot(3,1,1),plot(valid_time,segments_force.reaction_force_Shank_Right_proximal.x(first_index:end_index))
title('��ϥ�ؽ��ܵ���������')
ylabel('x���򣬶�״��(N)')
subplot(3,1,2),plot(valid_time,segments_force.reaction_force_Shank_Right_proximal.y(first_index:end_index))
ylabel('y���򣬶�״��(N)')
subplot(3,1,3),plot(valid_time,segments_force.reaction_force_Shank_Right_proximal.z(first_index:end_index))
ylabel('z���򣬶�״��(N)')
% ��ϥ�ؽ���������
figure
for i =1:length(moment_reaction_couple_global.Shank_Right_proximal)
    Shank_Right_proximal_x(i) = moment_reaction_couple_global.Shank_Right_proximal{i}(1);
    Shank_Right_proximal_y(i) = moment_reaction_couple_global.Shank_Right_proximal{i}(2);
    Shank_Right_proximal_z(i) = moment_reaction_couple_global.Shank_Right_proximal{i}(3);
end
subplot(3,1,1),plot(valid_time,Shank_Right_proximal_x(first_index:end_index))
title('��ϥ�ؽ��ܵ�������')
ylabel('x���򣬶�״��(N*m)')
subplot(3,1,2),plot(valid_time,Shank_Right_proximal_y(first_index:end_index))
ylabel('y���򣬶�״��(N*m)')
subplot(3,1,3),plot(valid_time,Shank_Right_proximal_z(first_index:end_index))
ylabel('z���򣬶�״��(N*m)')

%% �Źؽ���������
% ���Źؽ�������
figure
subplot(3,1,1),plot(valid_time,segments_force.reaction_force_Thigh_Left_proximal.x(first_index:end_index))
title('���Źؽ��ܵ���������')
ylabel('x���򣬶�״��(N)')
subplot(3,1,2),plot(valid_time,segments_force.reaction_force_Thigh_Left_proximal.y(first_index:end_index))
ylabel('y���򣬶�״��(N)')
subplot(3,1,3),plot(valid_time,segments_force.reaction_force_Thigh_Left_proximal.z(first_index:end_index))
ylabel('z���򣬶�״��(N)')
% ���Źؽ���������
figure
for i =1:length(moment_reaction_couple_global.Thigh_Left_proximal)
    Thigh_Left_proximal_x(i) = moment_reaction_couple_global.Thigh_Left_proximal{i}(1);
    Thigh_Left_proximal_y(i) = moment_reaction_couple_global.Thigh_Left_proximal{i}(2);
    Thigh_Left_proximal_z(i) = moment_reaction_couple_global.Thigh_Left_proximal{i}(3);
end
subplot(3,1,1),plot(valid_time,Thigh_Left_proximal_x(first_index:end_index))
title('���Źؽ��ܵ�������')
ylabel('x���򣬶�״��(N*m)')
subplot(3,1,2),plot(valid_time,Thigh_Left_proximal_y(first_index:end_index))
ylabel('y���򣬶�״��(N*m)')
subplot(3,1,3),plot(valid_time,Thigh_Left_proximal_z(first_index:end_index))
ylabel('z���򣬶�״��(N*m)')

% ���Źؽ�������
figure
subplot(3,1,1),plot(valid_time,segments_force.reaction_force_Thigh_Right_proximal.x(first_index:end_index))
title('���Źؽ��ܵ���������')
ylabel('x���򣬶�״��(N)')
subplot(3,1,2),plot(valid_time,segments_force.reaction_force_Thigh_Right_proximal.y(first_index:end_index))
ylabel('y���򣬶�״��(N)')
subplot(3,1,3),plot(valid_time,segments_force.reaction_force_Thigh_Right_proximal.z(first_index:end_index))
ylabel('z���򣬶�״��(N)')
% ���Źؽ���������
figure
for i =1:length(moment_reaction_couple_global.Thigh_Right_proximal)
    Thigh_Right_proximal_x(i) = moment_reaction_couple_global.Thigh_Right_proximal{i}(1);
    Thigh_Right_proximal_y(i) = moment_reaction_couple_global.Thigh_Right_proximal{i}(2);
    Thigh_Right_proximal_z(i) = moment_reaction_couple_global.Thigh_Right_proximal{i}(3);
end
subplot(3,1,1),plot(valid_time,Thigh_Right_proximal_x(first_index:end_index))
title('���Źؽ��ܵ�������')
ylabel('x���򣬶�״��(N*m)')
subplot(3,1,2),plot(valid_time,Thigh_Right_proximal_y(first_index:end_index))
ylabel('y���򣬶�״��(N*m)')
subplot(3,1,3),plot(valid_time,Thigh_Right_proximal_z(first_index:end_index))
ylabel('z���򣬶�״��(N*m)')
%%
close all;
%% ���ƶ�ͼ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ��������巴�������涯ͼ
%�������귶Χ
xstart = -0.1;
xend =  0.7;
ystart = -0.32;
yend = (numpath + 1) * 0.32;

zstart = -0.1;
zend = 1.8;

m1 = find(Kinectstream.wtime > double(tstart)/1000,1,'first');
m2 = find(Kinectstream.wtime < double(tstop)/1000,1,'last');
% �����Ÿտ�ʼ�Ӵ������ʱ��
leftfootcontacttime = [];
leftfootleavetime = [];
for i=1:length(left)
    leftfootcontacttime(i) = min(supporttime{left(i)});
end

for i=1:length(left)
    leftfootleavetime(i) = max(supporttime{left(i)});
end

% ����ҽŸտ�ʼ�Ӵ������ʱ��
rightfootcontacttime = [];
rightfootleavetime = [];
for i=1:length(right)
    rightfootcontacttime(i) = min(supporttime{right(i)});
end

for i=1:length(right)
    rightfootleavetime(i) = max(supporttime{right(i)});
end

ground_force_xstart = double(tstart)/1000;
ground_force_xend = double(tstop)/1000;

% ����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%dt,��ʾÿ֡��ͼʱ���ӳ�ʱ�䣬��λ��
%dt = 1/inter_freq;%���ʱ��,ʵ�ʼ��matlab�����ˣ����������������й�
dt = 0.03;%���ʱ��
color3 = {[0 1 0],[0.8500 0.3250 0.0980],[0.3 0.3 1]};%ɫ�ʹؽڵ㣬֫�壬����
gifsize = [720 1080];%��С
axislimb = [xstart,xend, ystart,yend ,zstart,zend];
gifname = 'Ground_force.gif';
%
figure;
fx = 0;
set(gcf, 'Position', [0 0 gifsize]);
%
subplot(10,1,[5 6]),pLGF=plot(0,0);
axis([ground_force_xstart,ground_force_xend,min(ground_force_Left.z)-100,max(ground_force_Left.z)+100]);
hold on
subplot(10,1,[7 8]),pRGF=plot(0,0);
axis([ground_force_xstart,ground_force_xend,min(ground_force_Right.z)-100,max(ground_force_Right.z)+100]);
hold on
subplot(10,1,[9 10]),pGF=plot(0,0);
axis([ground_force_xstart,ground_force_xend,min(ground_force.z)-100,max(ground_force.z)+100]);
hold on
%
subplot(10,1,[1 4]);
p1 = plot3(0,0,0);
p2 = plot3(0,0,0);
p3 = plot3(0,0,0);
xlabel('x')
ylabel('y')
zlabel('z')
title('VGRF','Fontsize',20)
axis(axislimb);
view([1 0 0]);
hold on
for t = tstart:1:tstop
    %���ֽ�������ŵ�
    if ismember(t, leftfootcontacttime)
        subplot(10,1,[5 6]),
        line([double(t)/1000,double(t)/1000],[min(ground_force_Left.z)-100,max(ground_force_Left.z)+100],'color','k');
        text(double(t)/1000,(max(ground_force_Left.z)+100)*0.9,'����ŵ�','HorizontalAlignment','right','FontSize',8);
    end
    %���ֽ����ҽ��ŵ�
    if ismember(t, rightfootcontacttime)
        subplot(10,1,[7 8]),
        line([double(t)/1000,double(t)/1000],[min(ground_force_Right.z)-100,max(ground_force_Right.z)+100],'color','k');
        text(double(t)/1000,(max(ground_force_Right.z)+100)*0.9,'�ҽ��ŵ�','HorizontalAlignment','right','FontSize',8);
    end
    %���ֽ���������
    if ismember(t, leftfootleavetime)
        subplot(10,1,[5 6]),
        line([double(t)/1000,double(t)/1000],[min(ground_force_Left.z)-100,max(ground_force_Left.z)+100],'color','y');
        text(double(t)/1000,(max(ground_force_Left.z)+100)*0.9,'������','HorizontalAlignment','right','FontSize',8);
        
    end
    %���ֽ����ҽ����
    if ismember(t, rightfootleavetime)
        
        subplot(10,1,[7 8]),
        line([double(t)/1000,double(t)/1000],[min(ground_force_Right.z)-100,max(ground_force_Right.z)+100],'color','y');
        text(double(t)/1000,(max(ground_force_Right.z)+100)*0.9,'�ҽ����','HorizontalAlignment','right','FontSize',8);
        
    end
    %% �����弰�������ŷ�������ż��
    if ismember(t,int32(1000*Kinectstream.wtime))
        fx = fx+1;
        m = find(int32(1000*Kinectstream.wtime) == t);
        if ishandle(pLGF)
            delete(pLGF);%����һ�ε�ͼ�����
        end
        
        if ishandle(pRGF)
            delete(pRGF);%����һ�ε�ͼ�����
        end
        if ishandle(pGF)
            delete(pGF);%����һ�ε�ͼ�����
        end
        
        %% ���淴������
        subplot(10,1,[5 6]),pLGF=plot(Kinectstream.wtime(m1:m),ground_force_Left.z(m1:m),'b');
        
        xlabel('ʱ��(S)','Fontsize',15)
        ylabel('���(N)','Fontsize',15)
        subplot(10,1,[ 7 8]),pRGF=plot(Kinectstream.wtime(m1:m),ground_force_Right.z(m1:m),'g');
        xlabel('ʱ��(S)','Fontsize',15)
        ylabel('�ҽ�(N)','Fontsize',15)
        subplot(10,1,[9 10]),pGF=plot(Kinectstream.wtime(m1:m),ground_force.z(m1:m),'r');
        xlabel('ʱ��(S)','Fontsize',15)
        ylabel('��(N)','Fontsize',15)
        %% ������
        
        if ishandle(p1)
            delete(p1);
        end
        if ishandle(p2)
            delete(p2);
        end
        if ishandle(p3)
            delete(p3);
        end
        subplot(10,1,[1 4]);
        figure_body_part;
        
        %% ����gif
        frame=getframe(gcf);
        imind=frame2im(frame);
        [imind,cm] = rgb2ind(imind,256);
        if fx ==1
            imwrite(imind,cm,gifname,'gif', 'Loopcount',inf,'DelayTime',dt);
        else
            imwrite(imind,cm,gifname,'gif','WriteMode','append','DelayTime',dt);
        end
        
    end
end
%% �׹ؽ����ػ涯ͼ

% ����
gifname = 'Ankle_Moment.gif';
%
figure;
fx = 0;
set(gcf, 'Position', [0 0 gifsize]);
%
subplot(10,1,[5 6]),plx=plot(0,0);
axis([ground_force_xstart,ground_force_xend,min(Foot_Left_proximal_x)-100,max(Foot_Left_proximal_x)+100]);
hold on
subplot(10,1,[7 8]),ply=plot(0,0);
axis([ground_force_xstart,ground_force_xend,min(Foot_Left_proximal_y)-100,max(Foot_Left_proximal_y)+100]);
hold on
subplot(10,1,[9 10]),plz=plot(0,0);
axis([ground_force_xstart,ground_force_xend,min(Foot_Left_proximal_z)-100,max(Foot_Left_proximal_z)+100]);
hold on
%
subplot(10,1,[1 4]);
p1 = plot3(0,0,0);
p2 = plot3(0,0,0);
p3 = plot3(0,0,0);
xlabel('x')
ylabel('y')
zlabel('z')
title('����ʱ���׹ؽ�����','Fontsize',20)
axis(axislimb);
view([1 0 0]);
hold on
for t = tstart:1:tstop
    %���ֽ�������ŵ�
    if ismember(t, leftfootcontacttime)
        subplot(10,1,[5 6]),
        line([double(t)/1000,double(t)/1000],[min(Foot_Left_proximal_x)-100,max(Foot_Left_proximal_x)+100],'color','k');
        text(double(t)/1000,(max(Foot_Left_proximal_x)+100)*0.9,'����ŵ�','HorizontalAlignment','right','FontSize',8);
        
        subplot(10,1,[7 8]),
        line([double(t)/1000,double(t)/1000],[min(Foot_Left_proximal_y)-100,max(Foot_Left_proximal_y)+100],'color','k');
        text(double(t)/1000,(max(Foot_Left_proximal_y)+100)*0.9,'����ŵ�','HorizontalAlignment','right','FontSize',8);
        
        subplot(10,1,[9 10]),
        line([double(t)/1000,double(t)/1000],[min(Foot_Left_proximal_z)-100,max(Foot_Left_proximal_z)+100],'color','k');
        text(double(t)/1000,(max(Foot_Left_proximal_z)+100)*0.9,'����ŵ�','HorizontalAlignment','right','FontSize',8);
    end
    %���ֽ���������
    if ismember(t, leftfootleavetime)
        subplot(10,1,[5 6]),
        line([double(t)/1000,double(t)/1000],[min(Foot_Left_proximal_x)-100,max(Foot_Left_proximal_x)+100],'color','y');
        text(double(t)/1000,(max(Foot_Left_proximal_x)+100)*0.9,'������','HorizontalAlignment','right','FontSize',8);
        
        subplot(10,1,[7 8]),
        line([double(t)/1000,double(t)/1000],[min(Foot_Left_proximal_y)-100,max(Foot_Left_proximal_y)+100],'color','y');
        text(double(t)/1000,(max(Foot_Left_proximal_y)+100)*0.9,'������','HorizontalAlignment','right','FontSize',8);
        
        subplot(10,1,[9 10]),
        line([double(t)/1000,double(t)/1000],[min(Foot_Left_proximal_z)-100,max(Foot_Left_proximal_z)+100],'color','y');
        text(double(t)/1000,(max(Foot_Left_proximal_z)+100)*0.9,'������','HorizontalAlignment','right','FontSize',8);
    end
    
    %% �����弰�׹ؽ�����
    if ismember(t,int32(1000*Kinectstream.wtime))
        fx = fx+1;
        m = find(int32(1000*Kinectstream.wtime) == t);
        if ishandle(plx)
            delete(plx);%����һ�ε�ͼ�����
        end
        
        if ishandle(ply)
            delete(ply);%����һ�ε�ͼ�����
        end
        if ishandle(plz)
            delete(plz);%����һ�ε�ͼ�����
        end
        
        %% �׹ؽ�����
        subplot(10,1,[5 6]),plx=plot(Kinectstream.wtime(m1:m),Foot_Left_proximal_x(m1:m),'b');
        
        ylabel('x����(N*m)','Fontsize',15)
        xlabel('ʱ��(S)','Fontsize',15)
        subplot(10,1,[ 7 8]),ply=plot(Kinectstream.wtime(m1:m),Foot_Left_proximal_y(m1:m),'g');
        ylabel('y����(N*m)','Fontsize',15)
        xlabel('ʱ��(N*m)','Fontsize',15)
        subplot(10,1,[9 10]),plz=plot(Kinectstream.wtime(m1:m),Foot_Left_proximal_z(m1:m),'r');
        ylabel('z����(N*m)','Fontsize',15)
        xlabel('ʱ��(S)','Fontsize',15)
       %% ������
        
        if ishandle(p1)
            delete(p1);
        end
        if ishandle(p2)
            delete(p2);
        end
        if ishandle(p3)
            delete(p3);
        end
        subplot(10,1,[1 4]);
        figure_body_part;
        
        %% ����gif
        frame=getframe(gcf);
        imind=frame2im(frame);
        [imind,cm] = rgb2ind(imind,256);
        if fx ==1
            imwrite(imind,cm,gifname,'gif', 'Loopcount',inf,'DelayTime',dt);
        else
            imwrite(imind,cm,gifname,'gif','WriteMode','append','DelayTime',dt);
        end
        
    end
end
%% kinect ���� ͳһ ��ͼ
%����
%f_parameters_KP.dt = 1/inter_freq;%���ʱ�䣬matlab�ƺ����ܴ����С�ļ��
f_parameters_KP.dt = 0.03;%���ʱ��
f_parameters_KP.color3 = {[0 1 0],[0.8500 0.3250 0.0980],[0.3 0.3 1]};%ɫ�ʹؽڵ㣬֫�壬����
f_parameters_KP.size = [1920 1080];%��С
f_parameters_KP.axis = [xstart,xend, ystart,yend ,zstart,zend];
f_parameters_KP.gifname = 'KP.gif';
f_Figure_Kinectarray_Pathway(kinect_cell_arrays,Pathstream,support_time,sex,f_parameters_KP)