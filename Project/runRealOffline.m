clc, clear all, close all

fI_scene = 1:6:3000;
fI_V1 = 'ABCDEFGMNHIJ';
%fI_V2 = 'KJIHGMNPOQR';

% Imagem
i=1;
background.dim = [800 800];
bgCalcTrack.bg = uint8(zeros([background.dim 3]));
background.mapping = uint8(zeros(background.dim));

% % Scene
% iterator = num2str(10000+fI_scene(i));
% frame(i).orig = imread(['video/scene/video_10_complete_track_' iterator(2:5) '.jpg']);

% % V1
% iterator = num2str(100+i);
% frame(i).orig = imread(['video/V1/' iterator(2:3) fI_V1(i) '.jpg']);

% 1
frame(i).orig = imread(['video/1/' num2str(i) '.jpg']);

frameDim = [480 640]/2;
frame(i).orig = imresize(frame(i).orig, frameDim);

% Cor das v�rias composi��es do path
trackStatic.calc.colors.line = [255 128 0];
trackStatic.calc.colors.step = [255 255 0];

% Captor
% cpt.linex.b = 21.53;
% cpt.linex.m = 1.13;
% cpt.liney.b = 14.57;
% cpt.liney.m = 0.85;
% cpt.dist = 3107; %(mm)

% FAST properties
lastThreshold = 256;
recommendedThreshold = 31;
FASTC.askedCornersNumber = 30; %scene 66
FASTC.pixelPerimeter = 16;
FASTC.arcPixelRequired = 9;
FASTC.minCornersAllowed = 10;
FASTC.colorThreshold(i) = recommendedThreshold;

% Comparison properties
compare.matchingDiferencesProp = 0.6; %scene 0.3
compare.firstPhaseMatches = 140;  %scene 17
compare.secondPhaseMatches = 20;
compare.distanceFilterProp = 8;
compare.acceptedNeighbourhood = 20;
compare.numberOfAngles = 1;
compare.triangleAngleDiff = 0.04; %rads
compare.triangleDistDiff = 4; %px

RSC.numberSelectedData = 2; %fixo
RSC.distThreshold = 0.8;
RSC.outlierRatio = 0.8;

trackStatic.mouse.colors.line = [0 0 255];
trackStatic.mouse.colors.step = [0 255 0];

sigThreshold.pixelArc = 2;
sigThreshold.arcColor = 10*6;

% Allocation
%FASTC.extractions(1:mousePath.len) = struct('coordinates',[],'circle',0,'number',0,'range',struct('number',[],'coordinates',[]));
%corners(1:mousePath.len) = struct('sig', struct('range', struct('number',[],'coordinates',[floor(frameDim(:,1)/2) -floor(frameDim(:,1)/2)]), 'c',[]));
%matches(1:mousePath.len-1) = struct('mate2',[],'avgDifs',[],'matchingQuality',Inf,'cornerMatchesNum',[],'more',[],'rejectMatchesLim',0,'matchesRatio',[]);
%calcTrack(1:mousePath.len-1) = struct('translation',zeros(2,1),'angle',0,'relativeTransformation',zeros(3,3),'originTransformation',zeros(3,3));


% Aplica o FAST Corners nos frames
tic
fprintf('%d: Running FAST corners...',i-1);

[f, e] = FAST.collect9(frame(i), frameDim, recommendedThreshold);
[f, e, recommendedThreshold, lastThreshold] = FAST.oneFrameController(f, frameDim, recommendedThreshold, lastThreshold, e, FASTC);

frame(i).gray = f.gray; frame(i).corners = f.corners; frame(i).bwcorners = f.bwcorners; clear f;

FASTC.extractions(i).coordinates = e.coordinates; FASTC.extractions(i).features = e.features; FASTC.extractions(i).number = e.number; clear e;
FASTC.extractions(i).range.number = [1 FASTC.extractions(i).number];
FASTC.extractions(i).range.coordinates = [floor(frameDim/2) -floor(frameDim/2)];
FASTC.colorThreshold(i) = recommendedThreshold;

time.FAST(i) = toc;
fprintf('FAST done with %d corners (%.2f seconds)\n\n', FASTC.extractions(i).number,time.FAST(i));

% Cria Assinaturas
tic
fprintf('%d: Creating signatures...',i-1);
corners(i).sig = sig.create(FASTC.extractions(i),compare);
time.sig(i) = toc;
fprintf('Done (%.4f seconds).\n\n\n',time.sig(i))

% Declarar a posição inicial do captor
calcTrack(i).translation = zeros(3,3);
calcTrack(i).angle = 0;
calcTrack(i).relativeTransformation = eye(3);
calcTrack(i).originTransformation = calcTrack(i).relativeTransformation;

trackCoords.calc(:,i) = round( refConv.cartesianToMatrix(background.dim(1:2), calcTrack(i).originTransformation(1:2,3)) );


%for i=2:length(fI_scene)
for i=2:9
%     if mod(i,10*6+1)==0
%         if ~isempty(input('Press enter to continue...','s'))
%             break;
%         end
%        close all;
%     end
    
%     % Scene
%     iterator = num2str(10000+fI_scene(i));
%     frame(i).orig = imread(['video/scene/video_10_complete_track_' iterator(2:5) '.jpg']);

% %     % V1
% %     iterator = num2str(100+i);
% %     frame(i).orig = imread(['video/V1/' iterator(2:3) fI_V1(i) '.jpg']);

    % 1
    frame(i).orig = imread(['video/1/' num2str(i) '.jpg']);
    
    frame(i).orig = imresize(frame(i).orig, frameDim);
    
    % Aplica o FAST Corners nos frames
    tic
    fprintf('%d: Running FAST corners...',i-1);
    
    [f, e] = FAST.collect9(frame(i), frameDim, recommendedThreshold);
    [f, e, recommendedThreshold, lastThreshold] = FAST.oneFrameController(f, frameDim, recommendedThreshold, lastThreshold, e, FASTC);
    
    frame(i).gray = f.gray; frame(i).corners = f.corners; frame(i).bwcorners = f.bwcorners; clear f;
    
    FASTC.extractions(i).coordinates = e.coordinates; FASTC.extractions(i).features = e.features; FASTC.extractions(i).number = e.number; clear e;
    FASTC.extractions(i).range.number = [1 FASTC.extractions(i).number];
    FASTC.extractions(i).range.coordinates = [floor(frameDim/2) -floor(frameDim/2)];
    FASTC.colorThreshold(i) = recommendedThreshold;
    
    time.FAST(i) = toc;
    fprintf('FAST done with %d corners (%.2f seconds)\n\n', FASTC.extractions(i).number,time.FAST(i));
    
%     compare.matchingDiferencesProp = min(FASTC.extractions(i-1).number, FASTC.extractions(i).number) / max(FASTC.extractions(i-1).number, FASTC.extractions(i).number);
%     compare.matchingDiferencesProp = 0.5 * compare.matchingDiferencesProp + 0.1;
%     if compare.matchingDiferencesProp < 0.2
%         compare.matchingDiferencesProp = 0.2;
%     elseif compare.matchingDiferencesProp > 0.6
%         compare.matchingDiferencesProp = 0.6;
%     end
    compare.matchingDiferences = round( compare.matchingDiferencesProp * min(FASTC.extractions(i-1).number, FASTC.extractions(i).number) );
%     if compare.matchingDiferences >= min(FASTC.extractions(1).number, FASTC.extractions(2).number)
%         compare.matchingDiferences = min(FASTC.extractions(1).number, FASTC.extractions(2).number)-1;
%     end
    
    % Cria Assinaturas
    tic
    fprintf('%d: Creating signatures...',i-1);
    corners(i).sig = sig.create(FASTC.extractions(i),compare);
    time.sig(i) = toc;
    fprintf('Done (%.4f seconds).\n\n',time.sig(i))
    
    % Compara assinaturas
    tic
    fprintf('%d: Comparing signatures...',i-1);
    
    time.ransac(i)=0;   
    
    %matches(i) = matching.compareSigs([corners(i-1:i).sig], FASTC.extractions(i-1:i), compare); time.FMBF(i) = toc;
    [matches(i), aMatches] = matching.compareSigs([corners(i-1:i).sig], FASTC.extractions(i-1:i), compare, 1); time.FMBF(i) = toc; %matches(i).matchingMaxDist = m.matchingMaxDist; % matches(i).difs = m.difs; matches(i).infNum = m.infNum;
        
    % dataLink(1,:) = kron(1:FASTC.extractions(i-1).number, ones(1, FASTC.extractions(i).number));
    % dataLink(2,:) = repmat(1:FASTC.extractions(i).number,1,FASTC.extractions(i-1).number);
    dataLink(1,:) = find(matches(i).mate2);
    dataLink(2,:) = matches(i).mate2(dataLink(1,:));
    tic; [bestModel, mate2, iterations(i), lengthCS] = matching.ransac(FASTC.extractions(i-1:i), dataLink, RSC); time.ransac(i) = toc; matches(i).mate2 = mate2; clear dataLink; 
    
    fprintf('Comparing signatures done in %0.3f seconds : FMBF in %0.3f seconds and RANSAC in %0.3f seconds\n\n',time.FMBF(i)+time.ransac(i), time.FMBF(i), time.ransac(i));
    
    % Corresponde as coordenadas dos cantos de uma imagem à próxima imagem    
    corners(i).matchCoords = matching.indexisToCoords(matches(i).mate2, FASTC.extractions(i-1:i));

    % Calcula transforma��o
    [calcTrack(i).translation, calcTrack(i).angle] = model.giveTransformation(corners(i).matchCoords);
    
    calcTrack(i).relativeTransformation = kin.transform2D_A( calcTrack(i).translation, calcTrack(i).angle );
    calcTrack(i).originTransformation = calcTrack(i-1).originTransformation * calcTrack(i).relativeTransformation;
    
    trackCoords.calc(:,i) = round( refConv.cartesianToMatrix(background.dim(1:2), calcTrack(i).originTransformation(1:2,3)) );
    
    numberAcceptedMatches(i) = sum(matches(i).mate2>0);

    fprintf('Corner Variation=%d : Number of accepted matches=%d\n', FASTC.extractions(i).number - FASTC.extractions(i-1).number,numberAcceptedMatches(i));
    fprintf('Calculated Translation:\n');
    fprintf('\tX=%.2f px, Y=%.2f px, angle=%.2f\n\n\n', calcTrack(i).translation, calcTrack(i).angle*180/pi);
    %fprintf('\tX=%.2f mm, Y=%.2f mm, angle=%.2f\n', captor.pixelToMM(cpt.linex, cpt.liney, scaling, cpt.dist, frameDim([2,1]), calcTrack(i).translation), calcTrack(i).angle*180/pi);    
    
    % Imagem de matching
    [frame(i).matches] = interf.showMatching(frame(i-1).corners, frame(i).corners, frameDim, matches(i).mate2, FASTC.extractions(i-1:i));
    
%     % Mostra a trajetoria calculada online
%     if prod(calcTrack(i).translation) %Apenas se existir movimento
%         [bgCalcTrack, ~] = interf.drawTrack(background.dim(1:2), bgCalcTrack.bg, trackCoords.calc(:,i-1:i), trackStatic.calc.colors, 1);
%         figure
%         imshow(bgCalcTrack.bg)
%         set(gcf,'units','normalized','outerposition',[0 0 1 1])
%     end    
end

% for i=1:mousePath.len-1
%     figure
%     imshow(pattern(i).corners)
% end

% figure
% imshow(bgMouseTrack.bw)
% set(gcf,'units','normalized','outerposition',[0 0 1 1])

% figure
% imshow(bgCalcTrack.bw)
% set(gcf,'units','normalized','outerposition',[0 0 1 1])

% figure
% imshow(bgCalcTrack.bw)
% set(gcf,'units','normalized','outerposition',[0 0 1 1])

% figure
% imshow(img.previous)
% set(gcf,'units','normalized','outerposition',[0 0 1 1])


