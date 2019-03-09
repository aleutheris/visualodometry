clc
clear all
close all

%load gen1

frameDim = [240 320];

numCorners1 = 12;
variation = 2;%0.6*numCorners1;
numCorners2 = numCorners1 + variation;
numRequestedRepeatedCornersPic = 10;

compare.matchingDiferencesProp = 0.5;
compare.firstPhaseMatches = 30;  %scene 17
compare.secondPhaseMatches = 10;
compare.distanceFilterProp = 8;
compare.acceptedNeighbourhood = 20;
compare.numberOfAngles = 1;
compare.triangleAngleDiff = 0.04; %rads
compare.triangleDistDiff = 4; %px

RSC.numberSelectedData = 2;
RSC.iterations = 20;
RSC.distThreshold = 3;

trans = [15 40];
ag = 30;
ag = ag*pi/180;

extractions(1).features = 0;
extractions(1).coordinates = cornerSim.cornerGen1(frameDim,numCorners1);
extractions(1).range.number = [1 numCorners1];
extractions(1).number = extractions(1).range.number(2)-extractions(1).range.number(1)+1;
extractions(1).range.coordinates = [floor(frameDim/2) -floor(frameDim/2)];

frame(1).corners = uint8(230*ones(frameDim(1),frameDim(2),3));
frame(1).corners = interf.coordintesToImgGen(frameDim, extractions(1), frame(1).corners);

extractions(2).features = 0;
[mate2Gen, extractions(2).coordinates, numRepeatedCorners] = cornerSim.cornerGen2(frameDim,extractions(1).coordinates,numCorners2,numRequestedRepeatedCornersPic,trans,ag);
extractions(2).range.number = [1 length(extractions(2).coordinates)];
extractions(2).number = extractions(2).range.number(2)-extractions(2).range.number(1)+1;
extractions(2).range.coordinates = [floor(frameDim/2) -floor(frameDim/2)];

frame(2).corners = uint8(230*ones(frameDim(1),frameDim(2),3));
frame(2).corners = interf.coordintesToImgGen(frameDim, extractions(2), frame(2).corners);

% Ordenar as coordenadas para mais facil debug humano
[extractions(1).coordinates, extractions(2).coordinates, mate2Gen] = cornerSim.ordinateCoordinatesBoth(extractions(1).coordinates, extractions(2).coordinates, mate2Gen);

% Criação das assinaturas
tic
fprintf('Creating signatures...');
corners(1).sig = sig.create(extractions(1),compare);

corners(2).sig = sig.create(extractions(2),compare);
time.sig = toc;
fprintf('Done (%.4f seconds).\n\n',time.sig)

% imshow(frame(1).corners)
% figure
% imshow(frame(2).corners)

compare.matchingDiferences = round( compare.matchingDiferencesProp * min(extractions(1).number, extractions(2).number) );
% if compare.matchingDiferences >= min(extractions(1).number, extractions(2).number)
%     compare.matchingDiferences = min(extractions(1).number, extractions(2).number)-1;
% end
% compare.requestedMatches = round( compare.requestedMatchesProp * min(extractions(1).number, extractions(2).number) );
% if compare.requestedMatches < 4
%     compare.requestedMatches = 4;
% end
% RSC.requestedMatches = compare.requestedMatches;

% Criação dos matches
tic
fprintf('Comparing signatures...');

%[m1, aprovedCorners1, aprovedCorners2] = matching.rejectCornerNoise([corners.sig], [extractions(1) extractions(2)], compare); matches.mate2 = m1.mate2; matches.details = m1.details;

[m, am] = matching.compareSigs([corners.sig], [extractions(1) extractions(2)], compare, 4); matches.mate2 = m.mate2; matches.details = m.details; %matches(i).matchingMaxDist = m.matchingMaxDist; % matches(i).difs = m.difs; matches(i).infNum = m.infNum;

% m.mate2 = m.mate2(aprovedCorners1);


% % dataLink(1,:) = kron(1:extractions(1).number, ones(1, extractions(2).number));
% % dataLink(2,:) = repmat(1:extractions(2).number,1,extractions(1).number);
% dataLink(1,:) = find(matches.mate2);
% dataLink(2,:) = matches.mate2(dataLink(1,:));
% [bestModel, mate2, i] = matching.ransac(extractions(1:2), dataLink, RSC);
% matches.mate2 = mate2;
time.compare = toc;
fprintf('Done (%.2f seconds).\n\n',time.compare);

matchCoords = matching.indexisToCoords(matches.mate2,extractions(1:2));

[givenTrans, givenAg, transf_matrix] = model.giveTransformation(matchCoords);
givenAg = givenAg * 180 / pi();

% Imagem de matching
%interf.showMatching(frame(1).corners, frame(2).corners, frameDim(:,1), matches.mate2, extractions);    

[cornerCmp] = interf.showMatchingComparison(frame(1).corners, frame(2).corners,frameDim,mate2Gen,matches.mate2,extractions);

%interf.showMatching(img1,img2,frameDim,matches.mate2,extractions);

%[acceptedCorners,sigsFigs] = interf.showCornersSigs(corners.sig,matches,fullMatches);

motionRange = sqrt(trans(1)^2 + trans(2)^2) / sqrt((frameDim(1)/2)^2 + (frameDim(2)/2)^2);

fprintf('Number of corners in frame 1 = %d ; Number of corners in frame 2 = %d ; Variation = %d (%.2f%%)\n',numCorners1, numCorners2, numCorners2-numCorners1, numCorners2/numCorners1*100)
fprintf('Repeatability asked = %.2f%% ; Repeated Corners = %d (%.2f%%)\n',numRequestedRepeatedCornersPic/numCorners1*100, numRepeatedCorners, numRepeatedCorners*100/numCorners1);
fprintf('Corners: correct=%d, undetected=%d, incorrect=%d\n',cornerCmp(1), cornerCmp(2), cornerCmp(3));
fprintf('Generated Translation: X=%.2f, Y=%.2f, ag=%.2f  ;  Calculated Translation: X=%.2f, Y=%.2f, ag=%.2f\n',trans(1), trans(2), 180*ag/pi(),  givenTrans(1), givenTrans(2), givenAg);
fprintf('Motion range proportion = %.2f%%\n', motionRange*100); 
fprintf('Absolute error: dX=%.2f, dY=%.2f, dAg=%.2f\n',abs(trans(1)-givenTrans(1)), abs(trans(2)-givenTrans(2)), abs(180*ag/pi()-givenAg))
fprintf('Relative error: EX=%.2f%%, EY=%.2f%%, EAg=%.2f%%\n',(abs(trans(1)-givenTrans(1))/trans(1))*100, (abs(trans(2)-givenTrans(2))/trans(2))*100, (abs(180*ag/pi()-givenAg)/(180*ag/pi())*100))
%fprintf('Elapsed time is %f seconds.\n',time);

