function [icc,dataV] = CalICC(timeK,dataK,timeV,dataV)
    % vicon数据插值到kinect
    dataV = interp1(timeV,dataV,timeK,'linear');
    icc = ICC([dataK,dataV],'C-1');
end