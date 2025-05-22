function DrawKinectGIF(jointArrayCell,f_parameters)
%% ÉèÖÃ
% dt,±íÊ¾Ã¿Ö¡»­Í¼Ê±µÄÑÓ³ÙÊ±¼ä£¬µ¥Î»Ãë
dt = f_parameters.dt;
color3 = f_parameters.color3; % É«²Ê£º¹Ø½Úµã£¬Ö«Ìå£¬Ðë×ô
gifSize = f_parameters.size; % GIF·Ö±æÂÊ
axisLimb = f_parameters.axis;
gifName = ['../videos/',f_parameters.fileName,'.gif'];

% axislimb = [xstart,xend, ystart,yend ,zstart,zend];
% dt = 0.03; % ¼ä¸ôÊ±¼ä
% color3 = {[0 1 0],[0.8500 0.3250 0.0980],[0.3 0.3 1]}; % É«²Ê£º¹Ø½Úµã£¬Ö«Ìå£¬Ðë×ô
% gifsize = [720 1080]; % GIF·Ö±æÂÊ
%% »æÍ¼ 3dÊÓ½Ç
figure;
set(gcf, 'Position', [0 0 gifSize]);
p1 = plot3(0,0,0);
p2 = plot3(0,0,0);
p3 = plot3(0,0,0);
p4 = plot3(0,0,0);
p5 = text(axisLimb(2)-0.3,axisLimb(3),axisLimb(6)-0.3,'0 Ö¡');
xlabel('x'); ylabel('y'); zlabel('z')
axis equal; axis(axisLimb);
view([1 1 0.5]);
hold on

for numFrame = 1:length(jointArrayCell)
    %% »­ÈËÌå

    if ishandle(p1)
        delete(p1);
    end
    if ishandle(p2)
        delete(p2);
    end
    if ishandle(p3)
        delete(p3);
    end
    if ishandle(p4)
        delete(p4);
    end
    if ishandle(p5)
        delete(p5);
    end

    %% ×ø±ê¸³Öµ
    HeadNeck{1} = jointArrayCell{numFrame}.joints(2,:);
    HeadNeck{2} = jointArrayCell{numFrame}.joints(19,:);
    %
    Trunk{1} = jointArrayCell{numFrame}.joints(1,:);
    Trunk{2} = jointArrayCell{numFrame}.joints(19,:);
    %
    UpperarmLeft{1} = jointArrayCell{numFrame}.joints(4,:);
    UpperarmLeft{2} = jointArrayCell{numFrame}.joints(3,:);

    UpperarmRight{1} = jointArrayCell{numFrame}.joints(8,:);
    UpperarmRight{2} = jointArrayCell{numFrame}.joints(7,:);
    %
    ForearmLeft{1} = jointArrayCell{numFrame}.joints(5,:);
    ForearmLeft{2} = jointArrayCell{numFrame}.joints(4,:);

    ForearmRight{1} = jointArrayCell{numFrame}.joints(9,:);
    ForearmRight{2} = jointArrayCell{numFrame}.joints(8,:);
    %
    ThighLeft{1} = jointArrayCell{numFrame}.joints(12,:);
    ThighLeft{2} = jointArrayCell{numFrame}.joints(11,:);

    ThighRight{1} = jointArrayCell{numFrame}.joints(16,:);
    ThighRight{2} = jointArrayCell{numFrame}.joints(15,:);
    %
    ShankLeft{1} = jointArrayCell{numFrame}.joints(13,:);
    ShankLeft{2} = jointArrayCell{numFrame}.joints(12,:);

    ShankRight{1} = jointArrayCell{numFrame}.joints(17,:);
    ShankRight{2} = jointArrayCell{numFrame}.joints(16,:);
    %
    HandLeft{1} = jointArrayCell{numFrame}.joints(6,:);
    HandLeft{2} = jointArrayCell{numFrame}.joints(5,:);

    HandRight{1} = jointArrayCell{numFrame}.joints(10,:);
    HandRight{2} = jointArrayCell{numFrame}.joints(9,:);
    %
    FootLeft{1} = jointArrayCell{numFrame}.joints(14,:);
    FootLeft{2} = jointArrayCell{numFrame}.joints(13,:);

    FootRight{1} = jointArrayCell{numFrame}.joints(18,:);
    FootRight{2} = jointArrayCell{numFrame}.joints(17,:);
    %

    SpSder_SderL{1} = jointArrayCell{numFrame}.joints(19,:);
    SpSder_SderL{2} = jointArrayCell{numFrame}.joints(3,:);

    SpSder_SderR{1} = jointArrayCell{numFrame}.joints(19,:);
    SpSder_SderR{2} = jointArrayCell{numFrame}.joints(7,:);
    %
    SpB_HipL{1} = jointArrayCell{numFrame}.joints(1,:);
    SpB_HipL{2} = jointArrayCell{numFrame}.joints(11,:);

    SpB_HipR{1} = jointArrayCell{numFrame}.joints(1,:);
    SpB_HipR{2} = jointArrayCell{numFrame}.joints(15,:);

    %% »æÍ¼Íâ¿Ç
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
    %ÉèÖÃÏßÌõÊôÐÔ
    p3(1).LineWidth=12;%Í·
    p3(1).Color=color3{3};

    p3(2).LineWidth=8;%¼¹Öù
    p3(2).Color=color3{3};

    p3(3).LineWidth=7;%ÓÒ¸ì²²
    p3(3).Color=color3{3};
    p3(4).LineWidth=7;%×ó¸ì²²
    p3(4).Color=color3{3};

    p3(5).LineWidth=5;%×óÊÖ±Û
    p3(5).Color=color3{3};
    p3(6).LineWidth=5;%ÓÒÊÖ±Û
    p3(6).Color=color3{3};

    p3(7).LineWidth=9;%×ó´óÍÈ
    p3(7).Color=color3{3};
    p3(8).LineWidth=9;%ÓÒ´óÍÈ
    p3(8).Color=color3{3};

    p3(9).LineWidth=6;%×óÐ¡ÍÈ
    p3(9).Color=color3{3};
    p3(10).LineWidth=6;%ÓÒÐ¡ÍÈ
    p3(10).Color=color3{3};

    p3(11).LineWidth=3;%×óÕÆ
    p3(11).Color=color3{3};
    p3(12).LineWidth=3;%ÓÒÕÆ
    p3(12).Color=color3{3};

    p3(13).LineWidth=5;%×ó½Å
    p3(13).Color=color3{3};
    p3(14).LineWidth=5;%ÓÒ½Å
    p3(14).Color=color3{3};

    p3(15).LineWidth=8;%×ó¼ç°ò
    p3(15).Color=color3{3};
    p3(16).LineWidth=8;%ÓÒ¼ç°ò
    p3(16).Color=color3{3};

    p3(17).LineWidth=9;%×ó÷Åµ½¼¹×µµ×²¿
    p3(17).Color=color3{3};
    p3(18).LineWidth=9;%ÓÒ÷Åµ½¼¹×µµ×²¿
    p3(18).Color=color3{3};

    %% »æÖÆ¹Ø½Úµã
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
    %ÉèÖÃÏßÌõÊôÐÔ
    MS = 15;
    p1(1).MarkerSize=MS;%Í·
    p1(1).Color=color3{3};

    p1(2).MarkerSize=MS;%¼¹Öù
    p1(2).Color=color3{1};

    p1(3).MarkerSize=MS;%ÓÒ¸ì²²
    p1(3).Color=color3{1};
    p1(4).MarkerSize=MS;%×ó¸ì²²
    p1(4).Color=color3{1};

    p1(5).MarkerSize=MS;%×óÊÖ±Û
    p1(5).Color=color3{1};
    p1(6).MarkerSize=MS;%ÓÒÊÖ±Û
    p1(6).Color=color3{1};

    p1(7).MarkerSize=MS;%×ó´óÍÈ
    p1(7).Color=color3{1};
    p1(8).MarkerSize=MS;%ÓÒ´óÍÈ
    p1(8).Color=color3{1};

    p1(9).MarkerSize=MS;%×óÐ¡ÍÈ
    p1(9).Color=color3{1};
    p1(10).MarkerSize=MS;%ÓÒÐ¡ÍÈ
    p1(10).Color=color3{1};

    p1(11).MarkerSize=MS;%×óÕÆ
    p1(11).Color=color3{1};
    p1(12).MarkerSize=MS;%ÓÒÕÆ
    p1(12).Color=color3{1};

    p1(13).MarkerSize=MS;%×ó½Å
    p1(13).Color=color3{1};
    p1(14).MarkerSize=MS;%ÓÒ½Å
    p1(14).Color=color3{1};


    p1(15).MarkerSize=MS;%×ó¼ç°ò
    p1(15).Color=color3{1};
    p1(16).MarkerSize=MS;%ÓÒ¼ç°ò
    p1(16).Color=color3{1};

    p1(17).MarkerSize=MS;%×ó÷Åµ½¼¹×µµ×²¿
    p1(17).Color=color3{1};
    p1(18).MarkerSize=MS;%ÓÒ÷Åµ½¼¹×µµ×²¿
    p1(18).Color=color3{1};
    
    %% »æÍ¼¹Ç÷À
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
    %ÉèÖÃÏßÌõÊôÐÔ
    LW = 1;
    p2(1).LineWidth=LW;%Í·
    p2(1).Color=color3{2};

    p2(2).LineWidth=LW;%¼¹Öù
    p2(2).Color=color3{2};

    p2(3).LineWidth=LW;%ÓÒ¸ì²²
    p2(3).Color=color3{2};
    p2(4).LineWidth=LW;%×ó¸ì²²
    p2(4).Color=color3{2};

    p2(5).LineWidth=LW;%×óÊÖ±Û
    p2(5).Color=color3{2};
    p2(6).LineWidth=LW;%ÓÒÊÖ±Û
    p2(6).Color=color3{2};

    p2(7).LineWidth=LW;%×ó´óÍÈ
    p2(7).Color=color3{2};
    p2(8).LineWidth=LW;%ÓÒ´óÍÈ
    p2(8).Color=color3{2};

    p2(9).LineWidth=LW;%×óÐ¡ÍÈ
    p2(9).Color=color3{2};
    p2(10).LineWidth=LW;%ÓÒÐ¡ÍÈ
    p2(10).Color=color3{2};

    p2(11).LineWidth=LW;%×óÕÆ
    p2(11).Color=color3{2};
    p2(12).LineWidth=LW;%ÓÒÕÆ
    p2(12).Color=color3{2};

    p2(13).LineWidth=LW;%×ó½Å
    p2(13).Color=color3{2};
    p2(14).LineWidth=LW;%ÓÒ½Å
    p2(14).Color=color3{2};

    p2(15).LineWidth=LW;%×ó¼ç°ò
    p2(15).Color=color3{2};
    p2(16).LineWidth=LW;%ÓÒ¼ç°ò
    p2(16).Color=color3{2};

    p2(17).LineWidth=LW;%×ó÷Åµ½¼¹×µµ×²¿
    p2(17).Color=color3{2};
    p2(18).LineWidth=LW;%ÓÒ÷Åµ½¼¹×µµ×²¿
    p2(18).Color=color3{2};

    %% COM
    [comX, comY, comZ] = GravityKinectArray(jointArrayCell{1,numFrame}.joints, 'M');
    p4 = plot3(comX,comY,comZ,'*r','markersize',10,'linewidth',3);

    %% ÎÄ±¾
    p5 = text(axisLimb(2)-0.3,axisLimb(3),axisLimb(6)-0.3,[num2str(numFrame),' Ö¡']);

    %% Éú³Égif
    frame=getframe(gcf);
    imind=frame2im(frame);
    [imind,cm] = rgb2ind(imind,256);
    if numFrame==1
        imwrite(imind,cm,gifName,'gif','Loopcount',inf,'DelayTime',dt);
    else
        imwrite(imind,cm,gifName,'gif','WriteMode','append','DelayTime',dt);
    end

end
hold off
end
