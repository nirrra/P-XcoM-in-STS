function [cellData] = ReadAndSortData(filePath)
if nargin<1, filePath = '../data/KinectMat'; end
dirOutput = dir([filePath,'/*.mat']);
filenames = {dirOutput.name};

cellData = cell(3,1);

for idxFile = 1:length(filenames)
    filename = filenames{idxFile}; % kinect名
    idxSub = str2num(filename(1:3));
    idxTest = str2num(filename(5:6));
    filename_floor = ['floorFile_',num2str(idxSub,'%03d'),'.txt'];
    Mas2floorT = Read_Floor(filename_floor);
    filename_sub2mas = ['sub2masT_',num2str(idxSub,'%03d'),'.txt'];
    sub2masT = ReadSub2Mas(filename_sub2mas);

    cellTest.plantar = FootScanMat2Struct(strrep(filename,'k','p'));
    cellTest.hip = FootScanMat2Struct(strrep(filename,'k','h'));
    cellTest.kinect = KinectMat2Struct(filename,Mas2floorT,sub2masT);
    cellTest.vicon = ViconMat2Struct(strrep(filename,'k','ik'));
    % vicon数据的方向与OpenSim中一致：X向前，Y向上，Z向右
    cellData{idxSub}{idxTest} = cellTest;
end

end

% 阵列的mat转化为struct
function [struct] = FootScanMat2Struct(fileName)
    eval(['load ',fileName]);
    struct.dataAllOri = dataAllOri;
    struct.datetimeF = datetimeF;
    struct.fsF = fsF;
end

% Kinect的mat转化为struct
function [struct] = KinectMat2Struct(fileName,Mas2floorT,sub2masT)
    eval(['load ',fileName]);
    % 是否将kinect转化至地面坐标系（X右，Y前，Z上）
    if true
        for i = 1:length(streamAllMaster)
            streamAllMaster{i} = Transform_Azure(Mas2floorT,streamAllMaster{i});
        end

        for i = 1:length(streamAllSub)
            streamAllSub{i} = Transform_Azure(sub2masT,streamAllSub{i}); % Sub放在Mas坐标系下
            streamAllSub{i} = Transform_Azure(Mas2floorT,streamAllSub{i});
        end
    end
    struct.master = streamAllMaster;
    struct.sub = streamAllSub;
    struct.T = T;
end

% Vicon的mat转化为struct
function [struct] = ViconMat2Struct(filename)
    ikname = filename;
    idname = strrep(filename,'ik','id');
    grfname = strrep(filename,'ik','grf');
    analysisname = strrep(filename,'ik','analysis');
    eval(['load ',ikname]);
    struct.ik = dataTable;
    eval(['load ',idname]);
    struct.id = dataTable;
    eval(['load ',grfname]);
    struct.grf = dataTable;
    eval(['load ',analysisname]);
    struct.analysis = dataTable; % 体段速度、角速度
end