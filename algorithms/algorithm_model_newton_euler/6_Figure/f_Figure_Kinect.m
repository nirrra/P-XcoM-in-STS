function f_Figure_Kinect(kinect_cell_arrays,f_parameters)
%% ����
%dt,��ʾÿ֡��ͼʱ���ӳ�ʱ�䣬��λ��
%dt,��ʾÿ֡��ͼʱ���ӳ�ʱ�䣬��λ��
dt = f_parameters.dt;
color3 = f_parameters.color3;%ɫ�ʹؽڵ㣬֫�壬����
gifsize = f_parameters.size;
axislimb = f_parameters.axis;
gifname = f_parameters.gifname;

% axislimb = [xstart,xend, ystart,yend ,zstart,zend];
% dt = 0.03;%���ʱ��
% color3 = {[0 1 0],[0.8500 0.3250 0.0980],[0.3 0.3 1]};%ɫ�ʹؽڵ㣬֫�壬����
% gifsize = [720 1080];%��С
%% ��ͼ 3d�ӽ�
figure;
set(gcf, 'Position', [0 0 gifsize]);
p1 = plot3(0,0,0);
p2 = plot3(0,0,0);
p3 = plot3(0,0,0);
xlabel('x')
ylabel('y')
zlabel('z')
axis equal;
axis(axislimb);
view([1 1 0.5]);
hold on
for m = 1:length(kinect_cell_arrays)

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

    %% ���긳ֵ
    HeadNeck{1} = kinect_cell_arrays{m}.joints(2,:);
    HeadNeck{2} = kinect_cell_arrays{m}.joints(19,:);
    %
    Trunk{1} = kinect_cell_arrays{m}.joints(1,:);
    Trunk{2} = kinect_cell_arrays{m}.joints(19,:);
    %
    UpperarmLeft{1} = kinect_cell_arrays{m}.joints(4,:);
    UpperarmLeft{2} = kinect_cell_arrays{m}.joints(3,:);

    UpperarmRight{1} = kinect_cell_arrays{m}.joints(8,:);
    UpperarmRight{2} = kinect_cell_arrays{m}.joints(7,:);
    %
    ForearmLeft{1} = kinect_cell_arrays{m}.joints(5,:);
    ForearmLeft{2} = kinect_cell_arrays{m}.joints(4,:);

    ForearmRight{1} = kinect_cell_arrays{m}.joints(9,:);
    ForearmRight{2} = kinect_cell_arrays{m}.joints(8,:);
    %
    ThighLeft{1} = kinect_cell_arrays{m}.joints(12,:);
    ThighLeft{2} = kinect_cell_arrays{m}.joints(11,:);

    ThighRight{1} = kinect_cell_arrays{m}.joints(16,:);
    ThighRight{2} = kinect_cell_arrays{m}.joints(15,:);
    %
    ShankLeft{1} = kinect_cell_arrays{m}.joints(13,:);
    ShankLeft{2} = kinect_cell_arrays{m}.joints(12,:);

    ShankRight{1} = kinect_cell_arrays{m}.joints(17,:);
    ShankRight{2} = kinect_cell_arrays{m}.joints(16,:);
    %
    HandLeft{1} = kinect_cell_arrays{m}.joints(6,:);
    HandLeft{2} = kinect_cell_arrays{m}.joints(5,:);

    HandRight{1} = kinect_cell_arrays{m}.joints(10,:);
    HandRight{2} = kinect_cell_arrays{m}.joints(9,:);
    %
    FootLeft{1} = kinect_cell_arrays{m}.joints(14,:);
    FootLeft{2} = kinect_cell_arrays{m}.joints(13,:);

    FootRight{1} = kinect_cell_arrays{m}.joints(18,:);
    FootRight{2} = kinect_cell_arrays{m}.joints(17,:);
    %

    SpSder_SderL{1} = kinect_cell_arrays{m}.joints(19,:);
    SpSder_SderL{2} = kinect_cell_arrays{m}.joints(3,:);

    SpSder_SderR{1} = kinect_cell_arrays{m}.joints(19,:);
    SpSder_SderR{2} = kinect_cell_arrays{m}.joints(7,:);
    %
    SpB_HipL{1} = kinect_cell_arrays{m}.joints(1,:);
    SpB_HipL{2} = kinect_cell_arrays{m}.joints(11,:);

    SpB_HipR{1} = kinect_cell_arrays{m}.joints(1,:);
    SpB_HipR{2} = kinect_cell_arrays{m}.joints(15,:);

    %% ��ͼ���
    p3= plot3([HeadNeck{1}(1),HeadNeck{2}(1)],[HeadNeck{1}(2),HeadNeck{2}(2)],[HeadNeck{1}(3),HeadNeck{2}(3)],...
        [Trunk{1}(1),Trunk{2}(1)],[Trunk{1}(2),Trunk{2}(2)],[Trunk{1}(3),Trunk{2}(3)],...
        [UpperarmLeft{1}(1),UpperarmLeft{2}(1)],[UpperarmLeft{1}(2),UpperarmLeft{2}(2)],[UpperarmLeft{1}(3),UpperarmLeft{2}(3)],...
        [UpperarmRight{1}(1),UpperarmRight{2}(1)],[UpperarmRight{1}(2),UpperarmRight{2}(2)],[UpperarmRight{1}(3),UpperarmRight{2}(3)],...
        [ForearmLeft{1}(1),ForearmLeft{2}(1)],[ForearmLeft{1}(2),ForearmLeft{2}(2)],[ForearmLeft{1}(3),ForearmLeft{2}(3)],...
        [ForearmRight{1}(1),ForearmRight{2}(1)],[ForearmRight{1}(2),ForearmRight{2}(2)],[ForearmRight{1}(3),ForearmRight{2}(3)],...
        [ThighLeft{1}(1),ThighLeft{2}(1)],[ThighLeft{1}(2),ThighLeft{2}(2)],[ThighLeft{1}(3),ThighLeft{2}(3)],...
        [ThighRight{1}(1),ThighRight{2}(1)],[ThighRight{1}(2),ThighRight{2}(2)],[ThighRight{1}(3),ThighRight{2}(3)],...
        [ShankLeft{1}(1),ShankLeft{2}(1)],[ShankLeft{1}(2),ShankLeft{2}(2)],[ShankLeft{1}(3),ShankLeft{2}(3)],...
        [ShankRight{1}(1),ShankRight{2}(1)],[ShankRight{1}(2),ShankRight{2}(2)],[ShankRight{1}(3),ShankRight{2}(3)],...
        [HandLeft{1}(1),HandLeft{2}(1)],[HandLeft{1}(2),HandLeft{2}(2)],[HandLeft{1}(3),HandLeft{2}(3)],...
        [HandRight{1}(1),HandRight{2}(1)],[HandRight{1}(2),HandRight{2}(2)],[HandRight{1}(3),HandRight{2}(3)],...
        [FootLeft{1}(1),FootLeft{2}(1)],[FootLeft{1}(2),FootLeft{2}(2)],[FootLeft{1}(3),FootLeft{2}(3)],...
        [FootRight{1}(1),FootRight{2}(1)],[FootRight{1}(2),FootRight{2}(2)],[FootRight{1}(3),FootRight{2}(3)],...
        [SpSder_SderL{1}(1),SpSder_SderL{2}(1)],[SpSder_SderL{1}(2),SpSder_SderL{2}(2)],[SpSder_SderL{1}(3),SpSder_SderL{2}(3)],...
        [SpSder_SderR{1}(1),SpSder_SderR{2}(1)],[SpSder_SderR{1}(2),SpSder_SderR{2}(2)],[SpSder_SderR{1}(3),SpSder_SderR{2}(3)],...
        [SpB_HipL{1}(1),SpB_HipL{2}(1)],[SpB_HipL{1}(2),SpB_HipL{2}(2)],[SpB_HipL{1}(3),SpB_HipL{2}(3)],...
        [SpB_HipR{1}(1),SpB_HipR{2}(1)],[SpB_HipR{1}(2),SpB_HipR{2}(2)],[SpB_HipR{1}(3),SpB_HipR{2}(3)]);
    %������������
    p3(1).LineWidth=12;%ͷ
    p3(1).Color=color3{3};

    p3(2).LineWidth=8;%����
    p3(2).Color=color3{3};

    p3(3).LineWidth=7;%�Ҹ첲
    p3(3).Color=color3{3};
    p3(4).LineWidth=7;%��첲
    p3(4).Color=color3{3};

    p3(5).LineWidth=5;%���ֱ�
    p3(5).Color=color3{3};
    p3(6).LineWidth=5;%���ֱ�
    p3(6).Color=color3{3};

    p3(7).LineWidth=9;%�����
    p3(7).Color=color3{3};
    p3(8).LineWidth=9;%�Ҵ���
    p3(8).Color=color3{3};

    p3(9).LineWidth=6;%��С��
    p3(9).Color=color3{3};
    p3(10).LineWidth=6;%��С��
    p3(10).Color=color3{3};

    p3(11).LineWidth=3;%����
    p3(11).Color=color3{3};
    p3(12).LineWidth=3;%����
    p3(12).Color=color3{3};

    p3(13).LineWidth=5;%���
    p3(13).Color=color3{3};
    p3(14).LineWidth=5;%�ҽ�
    p3(14).Color=color3{3};


    p3(15).LineWidth=8;%����
    p3(15).Color=color3{3};
    p3(16).LineWidth=8;%�Ҽ��
    p3(16).Color=color3{3};

    p3(17).LineWidth=9;%���ŵ���׵�ײ�
    p3(17).Color=color3{3};
    p3(18).LineWidth=9;%���ŵ���׵�ײ�
    p3(18).Color=color3{3};

    %% ���ƹؽڵ�
    p1= plot3([HeadNeck{1}(1),HeadNeck{2}(1)],[HeadNeck{1}(2),HeadNeck{2}(2)],[HeadNeck{1}(3),HeadNeck{2}(3)],'.',...
        [Trunk{1}(1),Trunk{2}(1)],[Trunk{1}(2),Trunk{2}(2)],[Trunk{1}(3),Trunk{2}(3)],'.',...
        [UpperarmLeft{1}(1),UpperarmLeft{2}(1)],[UpperarmLeft{1}(2),UpperarmLeft{2}(2)],[UpperarmLeft{1}(3),UpperarmLeft{2}(3)],'.',...
        [UpperarmRight{1}(1),UpperarmRight{2}(1)],[UpperarmRight{1}(2),UpperarmRight{2}(2)],[UpperarmRight{1}(3),UpperarmRight{2}(3)],'.',...
        [ForearmLeft{1}(1),ForearmLeft{2}(1)],[ForearmLeft{1}(2),ForearmLeft{2}(2)],[ForearmLeft{1}(3),ForearmLeft{2}(3)],'.',...
        [ForearmRight{1}(1),ForearmRight{2}(1)],[ForearmRight{1}(2),ForearmRight{2}(2)],[ForearmRight{1}(3),ForearmRight{2}(3)],'.',...
        [ThighLeft{1}(1),ThighLeft{2}(1)],[ThighLeft{1}(2),ThighLeft{2}(2)],[ThighLeft{1}(3),ThighLeft{2}(3)],'.',...
        [ThighRight{1}(1),ThighRight{2}(1)],[ThighRight{1}(2),ThighRight{2}(2)],[ThighRight{1}(3),ThighRight{2}(3)],'.',...
        [ShankLeft{1}(1),ShankLeft{2}(1)],[ShankLeft{1}(2),ShankLeft{2}(2)],[ShankLeft{1}(3),ShankLeft{2}(3)],'.',...
        [ShankRight{1}(1),ShankRight{2}(1)],[ShankRight{1}(2),ShankRight{2}(2)],[ShankRight{1}(3),ShankRight{2}(3)],'.',...
        [HandLeft{1}(1),HandLeft{2}(1)],[HandLeft{1}(2),HandLeft{2}(2)],[HandLeft{1}(3),HandLeft{2}(3)],'.',...
        [HandRight{1}(1),HandRight{2}(1)],[HandRight{1}(2),HandRight{2}(2)],[HandRight{1}(3),HandRight{2}(3)],'.',...
        [FootLeft{1}(1),FootLeft{2}(1)],[FootLeft{1}(2),FootLeft{2}(2)],[FootLeft{1}(3),FootLeft{2}(3)],'.',...
        [FootRight{1}(1),FootRight{2}(1)],[FootRight{1}(2),FootRight{2}(2)],[FootRight{1}(3),FootRight{2}(3)],'.',...
        [SpSder_SderL{1}(1),SpSder_SderL{2}(1)],[SpSder_SderL{1}(2),SpSder_SderL{2}(2)],[SpSder_SderL{1}(3),SpSder_SderL{2}(3)],'.',...
        [SpSder_SderR{1}(1),SpSder_SderR{2}(1)],[SpSder_SderR{1}(2),SpSder_SderR{2}(2)],[SpSder_SderR{1}(3),SpSder_SderR{2}(3)],'.',...
        [SpB_HipL{1}(1),SpB_HipL{2}(1)],[SpB_HipL{1}(2),SpB_HipL{2}(2)],[SpB_HipL{1}(3),SpB_HipL{2}(3)],'.',...
        [SpB_HipR{1}(1),SpB_HipR{2}(1)],[SpB_HipR{1}(2),SpB_HipR{2}(2)],[SpB_HipR{1}(3),SpB_HipR{2}(3)],'.');
    %������������
    MS = 15;
    p1(1).MarkerSize=MS;%ͷ
    p1(1).Color=color3{3};

    p1(2).MarkerSize=MS;%����
    p1(2).Color=color3{1};

    p1(3).MarkerSize=MS;%�Ҹ첲
    p1(3).Color=color3{1};
    p1(4).MarkerSize=MS;%��첲
    p1(4).Color=color3{1};

    p1(5).MarkerSize=MS;%���ֱ�
    p1(5).Color=color3{1};
    p1(6).MarkerSize=MS;%���ֱ�
    p1(6).Color=color3{1};

    p1(7).MarkerSize=MS;%�����
    p1(7).Color=color3{1};
    p1(8).MarkerSize=MS;%�Ҵ���
    p1(8).Color=color3{1};

    p1(9).MarkerSize=MS;%��С��
    p1(9).Color=color3{1};
    p1(10).MarkerSize=MS;%��С��
    p1(10).Color=color3{1};

    p1(11).MarkerSize=MS;%����
    p1(11).Color=color3{1};
    p1(12).MarkerSize=MS;%����
    p1(12).Color=color3{1};

    p1(13).MarkerSize=MS;%���
    p1(13).Color=color3{1};
    p1(14).MarkerSize=MS;%�ҽ�
    p1(14).Color=color3{1};


    p1(15).MarkerSize=MS;%����
    p1(15).Color=color3{1};
    p1(16).MarkerSize=MS;%�Ҽ��
    p1(16).Color=color3{1};

    p1(17).MarkerSize=MS;%���ŵ���׵�ײ�
    p1(17).Color=color3{1};
    p1(18).MarkerSize=MS;%���ŵ���׵�ײ�
    p1(18).Color=color3{1};
    %% ��ͼ����
    p2= plot3([HeadNeck{1}(1),HeadNeck{2}(1)],[HeadNeck{1}(2),HeadNeck{2}(2)],[HeadNeck{1}(3),HeadNeck{2}(3)],...
        [Trunk{1}(1),Trunk{2}(1)],[Trunk{1}(2),Trunk{2}(2)],[Trunk{1}(3),Trunk{2}(3)],...
        [UpperarmLeft{1}(1),UpperarmLeft{2}(1)],[UpperarmLeft{1}(2),UpperarmLeft{2}(2)],[UpperarmLeft{1}(3),UpperarmLeft{2}(3)],...
        [UpperarmRight{1}(1),UpperarmRight{2}(1)],[UpperarmRight{1}(2),UpperarmRight{2}(2)],[UpperarmRight{1}(3),UpperarmRight{2}(3)],...
        [ForearmLeft{1}(1),ForearmLeft{2}(1)],[ForearmLeft{1}(2),ForearmLeft{2}(2)],[ForearmLeft{1}(3),ForearmLeft{2}(3)],...
        [ForearmRight{1}(1),ForearmRight{2}(1)],[ForearmRight{1}(2),ForearmRight{2}(2)],[ForearmRight{1}(3),ForearmRight{2}(3)],...
        [ThighLeft{1}(1),ThighLeft{2}(1)],[ThighLeft{1}(2),ThighLeft{2}(2)],[ThighLeft{1}(3),ThighLeft{2}(3)],...
        [ThighRight{1}(1),ThighRight{2}(1)],[ThighRight{1}(2),ThighRight{2}(2)],[ThighRight{1}(3),ThighRight{2}(3)],...
        [ShankLeft{1}(1),ShankLeft{2}(1)],[ShankLeft{1}(2),ShankLeft{2}(2)],[ShankLeft{1}(3),ShankLeft{2}(3)],...
        [ShankRight{1}(1),ShankRight{2}(1)],[ShankRight{1}(2),ShankRight{2}(2)],[ShankRight{1}(3),ShankRight{2}(3)],...
        [HandLeft{1}(1),HandLeft{2}(1)],[HandLeft{1}(2),HandLeft{2}(2)],[HandLeft{1}(3),HandLeft{2}(3)],...
        [HandRight{1}(1),HandRight{2}(1)],[HandRight{1}(2),HandRight{2}(2)],[HandRight{1}(3),HandRight{2}(3)],...
        [FootLeft{1}(1),FootLeft{2}(1)],[FootLeft{1}(2),FootLeft{2}(2)],[FootLeft{1}(3),FootLeft{2}(3)],...
        [FootRight{1}(1),FootRight{2}(1)],[FootRight{1}(2),FootRight{2}(2)],[FootRight{1}(3),FootRight{2}(3)],...
        [SpSder_SderL{1}(1),SpSder_SderL{2}(1)],[SpSder_SderL{1}(2),SpSder_SderL{2}(2)],[SpSder_SderL{1}(3),SpSder_SderL{2}(3)],...
        [SpSder_SderR{1}(1),SpSder_SderR{2}(1)],[SpSder_SderR{1}(2),SpSder_SderR{2}(2)],[SpSder_SderR{1}(3),SpSder_SderR{2}(3)],...
        [SpB_HipL{1}(1),SpB_HipL{2}(1)],[SpB_HipL{1}(2),SpB_HipL{2}(2)],[SpB_HipL{1}(3),SpB_HipL{2}(3)],...
        [SpB_HipR{1}(1),SpB_HipR{2}(1)],[SpB_HipR{1}(2),SpB_HipR{2}(2)],[SpB_HipR{1}(3),SpB_HipR{2}(3)]);
    %������������
    LW = 1;
    p2(1).LineWidth=LW;%ͷ
    p2(1).Color=color3{2};

    p2(2).LineWidth=LW;%����
    p2(2).Color=color3{2};

    p2(3).LineWidth=LW;%�Ҹ첲
    p2(3).Color=color3{2};
    p2(4).LineWidth=LW;%��첲
    p2(4).Color=color3{2};

    p2(5).LineWidth=LW;%���ֱ�
    p2(5).Color=color3{2};
    p2(6).LineWidth=LW;%���ֱ�
    p2(6).Color=color3{2};

    p2(7).LineWidth=LW;%�����
    p2(7).Color=color3{2};
    p2(8).LineWidth=LW;%�Ҵ���
    p2(8).Color=color3{2};

    p2(9).LineWidth=LW;%��С��
    p2(9).Color=color3{2};
    p2(10).LineWidth=LW;%��С��
    p2(10).Color=color3{2};

    p2(11).LineWidth=LW;%����
    p2(11).Color=color3{2};
    p2(12).LineWidth=LW;%����
    p2(12).Color=color3{2};

    p2(13).LineWidth=LW;%���
    p2(13).Color=color3{2};
    p2(14).LineWidth=LW;%�ҽ�
    p2(14).Color=color3{2};



    p2(15).LineWidth=LW;%����
    p2(15).Color=color3{2};
    p2(16).LineWidth=LW;%�Ҽ��
    p2(16).Color=color3{2};

    p2(17).LineWidth=LW;%���ŵ���׵�ײ�
    p2(17).Color=color3{2};
    p2(18).LineWidth=LW;%���ŵ���׵�ײ�
    p2(18).Color=color3{2};

    %% ����gif
    frame=getframe(gcf);
    imind=frame2im(frame);
    [imind,cm] = rgb2ind(imind,256);
    if m==1
        imwrite(imind,cm,gifname,'gif', 'Loopcount',inf,'DelayTime',dt);
    else
        imwrite(imind,cm,gifname,'gif','WriteMode','append','DelayTime',dt);
    end

end
hold off
end
