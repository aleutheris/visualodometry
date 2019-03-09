clc, clear all, close all

% Corners Signature properties
compare.matchingDiferencesProp = 0.6; % all2all 0.7
compare.firstPhaseMatches = 60;  %scene 17
compare.secondPhaseMatches = 11;
compare.distanceFilterProp = 8;
compare.acceptedNeighbourhood = 20;
compare.numberOfAngles = 1;
compare.triangleAngleDiff = 0.04; %rads
compare.triangleDistDiff = 4; %px

RSC.numberSelectedData = 2; %fixo
RSC.distThreshold = 0.8;
RSC.outlierRatio = 0.8;

% FAST properties
recommendedThreshold = 105;
FASTC.colorThreshold(1) = recommendedThreshold;
%FASTC.askedCornersNumber = 60;
%FASTC.minCornersAllowed = 10*16;

img(1:2) = struct('FileName',[],'orig',[],'dim',[],'gray',[],'corners',[],'bwcorners',[]);

img(1).fileName = 'video/V3/14_O.jpg';
img(2).fileName = 'video/V3/15_P.jpg';

frameDim = [480 640]/2;

img(1).orig = imresize( imread(img(1).fileName), frameDim );
img(2).orig = imresize( imread(img(2).fileName), frameDim );

i=1;
fprintf('Starting FAST of %dº pictures\n', i);
tic
[img(i), e] = FAST.collect9(img(i), frameDim, recommendedThreshold);
[img(i)] = FAST.drawCorners(e, frameDim, img(i));
FASTC.extractions(i).coordinates = e.coordinates; FASTC.extractions(i).features = e.features; FASTC.extractions(i).number = e.number; clear e;
FASTC.extractions(i).range.number = [1 FASTC.extractions(i).number];
FASTC.extractions(i).range.coordinates = [floor(frameDim/2) -floor(frameDim/2)];
fprintf('FAST of 1ª picture done with corners %d in %0.3f seconds\n\n', FASTC.extractions(i).number, toc);


for i=2:2
    fprintf('Starting FAST of %dº pictures\n', i);
    tic
    [img(i), e] = FAST.collect9(img(i), frameDim, recommendedThreshold);
    [img(i)] = FAST.drawCorners(e, frameDim, img(i));
    FASTC.extractions(i).coordinates = e.coordinates; FASTC.extractions(i).features = e.features; FASTC.extractions(i).number = e.number; clear e;
    FASTC.extractions(i).range.number = [1 FASTC.extractions(i).number];
    FASTC.extractions(i).range.coordinates = [floor(frameDim/2) -floor(frameDim/2)];
    fprintf('FAST of 1ª picture done with corners %d in %0.3f seconds\n\n', FASTC.extractions(i).number, toc);
end

imshow(img(1).corners)
figure
imshow(img(2).corners)

compare.matchingDiferences = round( compare.matchingDiferencesProp * min(FASTC.extractions(1).number, FASTC.extractions(2).number) );
if compare.matchingDiferences >= min(FASTC.extractions(1).number, FASTC.extractions(2).number)
    compare.matchingDiferences = min(FASTC.extractions(1).number, FASTC.extractions(2).number)-1;
end
% compare.requestedMatches = round( compare.requestedMatchesProp * min(FASTC.extractions(1).number, FASTC.extractions(2).number) );
% if compare.requestedMatches < 4
%     compare.requestedMatches = 4;
% end

% Ordenar as coordenadas para mais facil debug humano
%[extractions(1).coordinates, extractions(2).coordinates, mate2] = cornerSim.cordinateCoordinatesBoth(extractions(1).coordinates, extractions(2).coordinates, mate2);

% Criação das assinaturas
fprintf('Creating signatures\n');
tic
cornersSig(1) = sig.create(FASTC.extractions(1),compare);
%img1 = cornerSim.coordintesToImg(imgDim(:,1), extractions(1).coordinates);
cornersSig(2) = sig.create(FASTC.extractions(2),compare);
%img2 = cornerSim.coordintesToImg(imgDim(:,1), extractions(2).coordinates);
fprintf('Signatures done in %0.3f seconds\n\n',toc);


% Criação dos matches
fprintf('Comparing signatures started\n');
tic

    
time.ransac=0; 

j = 1;
numberAcceptedMatches = 0;
while numberAcceptedMatches <= 4 && j <= 4
    aMatches = 0;
    while aMatches <= 4 && j <= 4
        [matches, aMatches] = matching.compareSigs(cornersSig(1:2), FASTC.extractions(1:2), compare, j); time.FMBF = toc; %matches(i).matchingMaxDist = m.matchingMaxDist; % matches(i).difs = m.difs; matches(i).infNum = m.infNum;
        j = j + 1;
    end

    dataLink(1,:) = find(matches.mate2);
    dataLink(2,:) = matches.mate2(dataLink(1,:));
    tic; [bestModel, mate2, iterations] = matching.ransac(FASTC.extractions(1:2), dataLink, RSC);  time.ransac = toc; matches.mate2 = mate2; clear dataLink;

    numberAcceptedMatches = sum(matches.mate2>0);
    %j = j + 1;
end    

constraint = j-1;

fprintf('Comparing signatures: %d attempts ; done in %0.3f seconds ; FMBF in %0.3f seconds and RANSAC in %0.3f seconds\n\n',constraint,time.FMBF+time.ransac, time.FMBF, time.ransac);
    

matchCoords = matching.indexisToCoords(matches.mate2,FASTC.extractions(1:2));

[givenTrans, givenAg] = model.giveTransformation(matchCoords);
givenAg = 180*givenAg/pi();

[imgConcMatches] = interf.showMatching(img(1).corners,img(2).corners,frameDim,matches.mate2,FASTC.extractions);
figure
imshow(imgConcMatches) 

%interf.showMatching(img1,img2,imgDim,matches.mate2,extractions);

%[acceptedCorners,sigsFigs] = interf.showCornersSigs(cornersSig,matches,fullMatches);

numberAcceptedMatches = sum(matches.mate2>0);

fprintf('Corner variation=%d : Number of accepted matches=%d\n',abs(FASTC.extractions(1).number-FASTC.extractions(2).number), numberAcceptedMatches);
fprintf('Calculated Translation: X=%.2f, Y=%.2f, ag=%.2f degrees\n\n', givenTrans(1), givenTrans(2), givenAg);
% fprintf('Absule error: dX=%.2f, dY=%.2f, dAg=%.2f\n\n',abs(trans(1)-givenTrans(1)), abs(trans(2)-givenTrans(2)), abs(180*ag/pi()-givenAg))
% fprintf('Relative error: EX=%.2f%%, EY=%.2f%%, EAg=%.2f%%\n\n',(abs(trans(1)-givenTrans(1))/trans(1))*100, (abs(trans(2)-givenTrans(2))/trans(2))*100, (abs(180*ag/pi()-givenAg)/(180*ag/pi())*100))


% figure
% imshow(img(1).corners(:,:,:));
% 
% figure
% imshow(img(2).corners(:,:,:));

% figure
% plot(lengthCS,'b')