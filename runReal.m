clc, clear all, close all

%% Inicializações
% Camera
frameDim = [480 640];
vid = videoinput('linuxvideo', 1, ['YUYV_' int2str(frameDim(2)) 'x' int2str(frameDim(1))]);
vid.ReturnedColorspace = 'rgb';
vid.FramesPerTrigger = 1;
triggerconfig(vid, 'manual');

start(vid);

tic;
fprintf('1.5 seconds for photo stabilization...');
while toc<1.5, end
trigger(vid);
fprintf('Done.\n\n');

% Imagem
scaling = 1/4;
background.dim = frameDim;% / (scaling*2);
bgCalcTrack.bg = uint8(zeros([background.dim 3]));
frameDim = frameDim*scaling; 
frame.orig = imresize(getdata(vid), frameDim);

% Cor das v�rias composi��es do path
trackStatic.calc.colors.line = [255 127 0];
trackStatic.calc.colors.step = [255 255 0];


stoppreview(vid); % renova camera
start(vid);

% Captor
cpt.linex.b = 21.53;
cpt.linex.m = 1.13;
cpt.liney.b = 14.57;
cpt.liney.m = 0.85;
cpt.dist = 3107; %(mm)


% FAST properties
FASTC.colorThreshold = 10;
FASTC.askedCornersNumber = [20 23];
FASTC.minCornersAllowed = 6;

% Comparison properties
compare.matchingDiferencesProp = 0.6;
compare.requestedMatchesProp = 0.3;
trackStatic.mouse.colors.line = [0 0 255];
trackStatic.mouse.colors.step = [0 255 0];
compare.apcThreshold = 50;

sigThreshold.pixelArc = 2;
sigThreshold.arcColor = 10*6;

% Allocation
%FASTC.extractions(1:mousePath.len) = struct('coordinates',[],'circle',0,'number',0,'range',struct('number',[],'coordinates',[]));
%corners(1:mousePath.len) = struct('sig', struct('range', struct('number',[],'coordinates',[floor(frameDim(:,1)/2) -floor(frameDim(:,1)/2)]), 'c',[]));
%matches(1:mousePath.len-1) = struct('mate2',[],'avgDifs',[],'matchingQuality',Inf,'cornerMatchesNum',[],'more',[],'rejectMatchesLim',0,'matchesRatio',[]);
%calcTrack(1:mousePath.len-1) = struct('translation',zeros(2,1),'angle',0,'relativeTransformation',zeros(3,3),'originTransformation',zeros(3,3));


i=1;

% Aplica o FAST Corners nos frames
tic
fprintf('%d: Running FAST corners...',i-1);
[frame, e, FASTC.colorThreshold] = FAST.corners(frame, frameDim, FASTC);
FASTC.extractions(i).coordinates = e.coordinates; FASTC.extractions(i).features = e.features; FASTC.extractions(i).number = e.number; clear e;
FASTC.extractions(i).range.number = [1 FASTC.extractions(i).number];
time.FAST(i) = toc;
fprintf('FAST done with %d corners (%.2f seconds)\n\n', FASTC.extractions(i).number,time.FAST(i));

% Cria Assinaturas
tic
fprintf('%d: Creating signatures...',i-1);
corners(i).sig = sig.create(FASTC.extractions(i));
time.sig(i) = toc;
fprintf('Done (%.4f seconds).\n\n\n',time.sig(i))

% Declarar a posição inicial do captor
calcTrack(i).translation = zeros(3,3);
calcTrack(i).angle = 0;
calcTrack(i).relativeTransformation = eye(3);
calcTrack(i).originTransformation = calcTrack(i).relativeTransformation;

trackCoords.calc(:,i) = round( refConv.cartesianToMatrix(background.dim(1:2), calcTrack(i).originTransformation(1:2,3)) );

if ~isempty(input('Press enter to continue...','s'))
    break;
end
close all

while true
    i=i+1;
    
    trigger(vid); % tira foto
    frame(i).orig = imresize(getdata(vid), frameDim);
    stoppreview(vid); % renova camera
    start(vid);
    
    % Aplica o FAST Corners nos frames
    tic
    fprintf('%d: Running FAST corners...',i-1);
    [frame(i), e, recommendedThreshold] = FAST.corners(frame(i), frameDim, FASTC);
    FASTC.colorThreshold = recommendedThreshold;
    FASTC.extractions(i).coordinates = e.coordinates; FASTC.extractions(i).features = e.features; FASTC.extractions(i).number = e.number; clear e;
    FASTC.extractions(i).range.number = [1 FASTC.extractions(i).number];
    time.FAST(i) = toc;
    fprintf('FAST done with %d corners (%.2f seconds)\n\n', FASTC.extractions(i).number,time.FAST(i));
   
    compare.matchingDiferences = round( compare.matchingDiferencesProp * min(FASTC.extractions(i-1).number, FASTC.extractions(i).number) );
    compare.requestedMatches = round( compare.requestedMatchesProp * compare.matchingDiferences );
    if compare.requestedMatches < 2
        compare.requestedMatches = 2;
    end
    
    % Cria Assinaturas
    tic
    fprintf('%d: Creating signatures...',i-1);
    corners(i).sig = sig.create(FASTC.extractions(i));
    time.sig(i) = toc;
    fprintf('Done (%.4f seconds).\n\n',time.sig(i))
    
    % Compara assinaturas
    tic
    fprintf('%d: Comparing signatures...',i-1);
    [m, ~] = matching.compareSigs([corners(i-1).sig corners(i).sig], [FASTC.extractions(i-1) FASTC.extractions(i)], compare); matches(i).mate2 = m.mate2; matches(i).matchingQuality = m.matchingQuality; matches(i).details = m.details;
    time.compare(i-1) = toc;
    fprintf('Done (%.2f seconds).\n\n',time.compare(i-1))
    
    % Corresponde as coordenadas dos cantos de uma imagem à próxima imagem    
    corners(i).matchCoords = matching.indexisToCoords(matches(i).mate2,FASTC.extractions(i-1:i));

    % Calcula transforma��o
    [calcTrack(i).translation, calcTrack(i).angle] = model.giveTransformation(corners(i).matchCoords);
    
    calcTrack(i).relativeTransformation = kin.transform2D_A( calcTrack(i).translation, calcTrack(i).angle );
    calcTrack(i).originTransformation = calcTrack(i-1).originTransformation * calcTrack(i).relativeTransformation;
    
    trackCoords.calc(:,i) = round( refConv.cartesianToMatrix(background.dim(1:2), calcTrack(i).originTransformation(1:2,3)) );

    fprintf('Corner Variation=%d\n', FASTC.extractions(i).number - FASTC.extractions(i-1).number);
    fprintf('Calculated Translation:\n');
    fprintf('\tX=%.2f px, Y=%.2f px, angle=%.2f\n', calcTrack(i).translation, calcTrack(i).angle*180/pi);
    fprintf('\tX=%.2f mm, Y=%.2f mm, angle=%.2f\n', captor.pixelToMM(cpt.linex, cpt.liney, scaling, cpt.dist, frameDim([2,1]), calcTrack(i).translation), calcTrack(i).angle*180/pi);    
    fprintf('Matching quality: %.3f\n', matches(i).matchingQuality);
    
    % Imagem de matching
    [frame(i).matches] = interf.showMatching(frame(i-1).corners, frame(i).corners, frameDim, matches(i).mate2, FASTC.extractions(i-1:i));
    
    % Mostra a trajetoria calculada online
    if prod(calcTrack(i).translation) %Apenas se existir movimento
        [bgCalcTrack, ~] = interf.drawTrack(background.dim(1:2), bgCalcTrack.bg, trackCoords.calc(:,i-1:i), trackStatic.calc.colors, 1);
        figure
        imshow(bgCalcTrack.bg)
        set(gcf,'units','normalized','outerposition',[0 0 1 1])
    end
    
    if ~isempty(input('Press enter to continue...','s'))
        break;
    end
    close all
end

trigger(vid); % tira foto
frame(i+1).orig = getdata(vid);
stoppreview(vid); % renova camera

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


