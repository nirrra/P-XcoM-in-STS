function posAnkleLift = GetSegAnkleLift(streamInter,pressurePlantar2DInter,labels)
    posAnkleLift = zeros(length(streamInter.wtime),1); 
    for idxFrame = 1:length(streamInter.wtime)
        img = reshape(pressurePlantar2DInter(idxFrame,:),32,32);
        if sum(img(labels==2)) < 5
            posAnkleLift(idxFrame) = 1;
        end
    end
    
    for idxFrame = 1:length(streamInter.wtime)-6
        if posAnkleLift(idxFrame)+posAnkleLift(idxFrame+6) == 2
            posAnkleLift(idxFrame:idxFrame+6) = 1;
        end
    end
    startsLeft = intersect(find(posAnkleLift(2:end)==1),find(posAnkleLift(1:end)==0))+1;
    endsLeft = intersect(find(posAnkleLift==1),find(posAnkleLift(2:end)==0));
    if startsLeft(1)>endsLeft(1), endsLeft(1) = []; end
    if startsLeft(end)>endsLeft(end), startsLeft(end) = []; end
    
    % 2. 对每一段，通过对应的streamInter.ANKLE.z确定
    posAnkleLift = zeros(length(streamInter.wtime),1);
    for i = 1:length(startsLeft)
        if endsLeft(i)-startsLeft(i)<10
            continue;
        end
        aux = streamInter.ANKLE_LEFT.z(startsLeft(i):endsLeft(i));
        pks = findpeaks(aux);
        if max(pks) - min(aux) > 0.03
            posAnkleLift(startsLeft(i):endsLeft(i)) = 1;
        end
    end