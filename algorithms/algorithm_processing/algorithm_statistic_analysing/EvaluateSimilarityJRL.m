function [testValue] = EvaluateSimilarityJRL(timeA,dataA,timeB,dataB)
    funcNormal = @(curve) curve./(range(curve(floor(0.25*length(curve)):floor(0.75*length(curve)))));
%     funcNormal = @(curve) curve;
    
    [~,aux] = unique(timeB);
    timeB = timeB(aux); dataB = dataB(aux);

    % 插值    
    dataB_inter = interp1(timeB,dataB,timeA,'linear');
    a = funcNormal(dataA); b = funcNormal(dataB_inter);
    aux = intersect(find(~isnan(a)),find(~isnan(b)));
    a = a(aux); b = b(aux);
    % rmsd
    rmsd = rms(a-b);
    rrmsd = rmsd/(std(a));
    % corr
    corr = corrcoef(a,b);
    corr = corr(2,1);
    % ICC
    icc = ICC([a,b],'C-1');

%     testValue.rmsd = rmsd;
    testValue.rrmsd = rrmsd;
    testValue.corr = corr;
    testValue.icc = icc;
end