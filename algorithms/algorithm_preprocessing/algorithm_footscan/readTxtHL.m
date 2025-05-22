%% FUNC readTxtHL：读取txt（同时保存原值高8位和低4位）
function [dataAllOri, datetimeArray] = readTxtHL(fileName)
    fid = fopen(fileName);
    dataAllOri = []; datetimeArray = [];
    while ~feof(fid)
        line = fgetl(fid);
        line = strsplit(line, ',');
        if length(line) == 2049
            aux = [];
            for i = 1:1024
                numH8 = str2num(line{2*i});
                numL4 = str2num(line{2*i+1});
                aux = [aux, numH8*16+numL4];
            end
            dataAllOri = [dataAllOri; aux];
            aux = datetime(line{1},'InputFormat','yyyy-MM-dd HH:mm:ss:SSS'); 
            aux.Format = 'yyyy-MM-dd HH:mm:ss:SSS';
            datetimeArray = [datetimeArray; aux];
        end
    end
end