% clc, clear all, close all

% if matlabpool('size') == 0 % checking to see if my pool is already open
%     matlabpool open 4
% end

%% Inicializações
% Image
i=1;
background.orig=imread('Samples/10L.jpg');
background.dim = size(background.orig);
background.mapping = uint8(zeros(background.dim));
frameDim = [240 ; 320]-1;

maxNoiseAmp = 0;

% Mouse path properties
mousePath.thick = 3;
mousePath.radius = floor( min(frameDim(1)/2, frameDim(2)/2) );
mousePath.angleEscale = [-pi pi];
mousePath.figure = 1;

% FAST properties
recommendedThreshold = 20;
FASTC.colorThreshold(i) = recommendedThreshold;
FASTC.usedCorners = 30;
%FASTC.askedCornersNumber = 3*FASTC.usedCorners;
FASTC.pixelPerimeter = 16;
FASTC.arcPixelRequired = 9;
FASTC.minCornersAllowed = 1.5*FASTC.usedCorners;

% Comparison properties
compare.matchingDiferencesProp = 0.45;
compare.firstPhaseMatches = 200;  %scene 17
compare.secondPhaseMatches = 14;
compare.distanceFilterProp = 8;
compare.acceptedNeighbourhood = 20;
compare.numberOfAngles = 1;
compare.triangleAngleDiff = 0.04; %rads
compare.triangleDistDiff = 4; %px

RSC.numberSelectedData = 2; %fixo
RSC.distThreshold = 0.8;
RSC.outlierRatio = 0.8;

% Cor das v�rias composi��es do path
trackStatic.mouse.colors.line = [0 0 255];
trackStatic.mouse.colors.step = [0 255 0];
trackStatic.mouse.colors.stepIni = [255 0 0];

trackStatic.calc.colors.line = [255 128 0];
trackStatic.calc.colors.step = [255 255 0];
trackStatic.calc.colors.stepIni = [255 0 0];

sigThreshold.pixelArc = 2;
sigThreshold.arcColor = 10*6;

%Figures
trackFg = 100;
mappingFG = 101;
%%

%[path, img] = mousePathRender(background.orig, mousePath.radius, mousePath.thick, mousePath.angleEscale, mousePath.figure);

mousePath.len = length(path);

% Allocation
%frame(1:mousePath.len) = struct('orig',zeros([frameDim(1:2,1)' 3]),'gray',zeros(frameDim(1:2,1)'),'corners',zeros([frameDim(1:2,1)' 3]),'bwcorners',zeros(frameDim(1:2,1)'),'matches',zeros(frameDim(1),2*frameDim(2)+1));
%time(1:mousePath.len) = struct('frame',0,'FAST',0);
%FASTC.extractions(1:mousePath.len) = struct('coordinates',[],'circle',0,'number',0,'range',struct('number',[],'coordinates',[]));
%corners(1:mousePath.len) = struct('sig', struct('range', struct('number',[],'coordinates',[floor(frameDim(:,1)/2) -floor(frameDim(:,1)/2)]), 'c',[]));
%matches(1:mousePath.len-1) = struct('mate2',[],'avgDifs',[],'matchingQuality',Inf,'cornerMatchesNum',[],'more',[],'rejectMatchesLim',0,'matchesRatio',[]);
%calcTrack(1:mousePath.len-1) = struct('translation',zeros(2,1),'angle',0,'relativeTransformation',zeros(3,3),'originTransformation',zeros(3,3));
%trackCoords = struct('mouse',zeros(2,mousePath.len-1), 'calc',zeros(2,mousePath.len-1));
%trackError(1:mousePath.len-1) = struct('absolute', zeros(3,1), 'relative', zeros(2,1));

% Path mouseTrack.transformation
%mouseTrack(1:mousePath.len) = struct('translation',zeros(2,1),'angle',0,'relativeTransformation',zeros(3,3),'origTransformation',zeros(3,3)); % Aloca espa�o para a variavel mouseTrack.transformation

if mousePath.len <= 2
    error('Path too short!');
end

% % MOVIMENTO SEMPRE EM FRENTE (X)
% mouseTrack(1).relativeTransformation = kin.transform2D_A([path(1).pointerCoords.cartesian(1) ; path(1).pointerCoords.cartesian(2)], path(2).relativeAngle);
% mouseTrack(1).translation = mouseTrack(1).relativeTransformation(1:2,3);
% mouseTrack(1).angle = path(2).relativeAngle;
% mouseTrack(1).origTransformation = mouseTrack(1).relativeTransformation;
% for j=3:mousePath.len
%     mouseTrack(j-1).relativeTransformation = kin.transform2D_A([path(j-1).magnitude ; 0],path(j).relativeAngle);
%     mouseTrack(j-1).translation = mouseTrack(j-1).relativeTransformation(1:2,3);
%     mouseTrack(j-1).angle = path(j).relativeAngle;
%     mouseTrack(j-1).origTransformation = mouseTrack(j-2).origTransformation * mouseTrack(j-1).relativeTransformation;
% end
% mouseTrack(j).relativeTransformation = kin.transform2D_A([path(j).magnitude ; 0],path(j).relativeAngle);
% mouseTrack(j).translation = mouseTrack(j).relativeTransformation(1:2,3);
% mouseTrack(j).angle = path(j).relativeAngle;
% mouseTrack(j).origTransformation = mouseTrack(j-1).origTransformation * mouseTrack(j).relativeTransformation; % mesmo relativeAngle de prop�sito

mouseTrack = pathGen();
mousePath.len = length(mouseTrack);


background.mouseTrack = background.orig;
bgCalcTrack.bg = background.orig;


% Busca frame
tic
fprintf('%d: Collecting frame...\n',i-1);
[background, line.frame(i).orig] = interf.frame( background, frameDim, mouseTrack(i).origTransformation, mousePath.thick );
time.frame(i) = toc;
fprintf('Done (%.2f seconds).\n\n',time.frame(i))

% Aplica o FAST Corners nos frame
tic
fprintf('%d: Running FAST corners...',i-1);
% frame(i).orig = frame(i).orig + uint8( round( rand(frameDim(1),frameDim(2),3) * maxNoiseAmp ) ); % adição de ruído branco
[f, e] = FAST.collect9(line.frame(i), frameDim, recommendedThreshold);
line.FASTC.extractions(i).coordinates = e.coordinates; line.FASTC.extractions(i).features = e.features; line.FASTC.extractions(i).number = e.number; clear e;
line.frame(i).orig = f.orig; line.frame(i).gray = f.gray; clear f;
line.FASTC.extractions(i).range.number = [1 line.FASTC.extractions(i).number];
time.FAST(i) = toc;
fprintf('FAST done with %d corners (%.2f seconds)\n\n', line.FASTC.extractions(i).number,time.FAST(i));

% Declarar a posi��o inicial do robot
calcTrack(i).translation = mouseTrack(i).origTransformation(1:2,3);
calcTrack(i).angle = kin.getRefAngle2D( mouseTrack(i).origTransformation );
calcTrack(i).originTransformation = kin.transform2D_A( calcTrack(i).translation, calcTrack(i).angle );

trackCoords.mouse(:,i) = round( refConv.cartesianToMatrix(background.dim(1:2),  mouseTrack(i).origTransformation(1:2,3)) ); % path(i).pointerCoords.matrix;
trackCoords.calc(:,i) = round( refConv.cartesianToMatrix(background.dim(1:2), calcTrack(i).originTransformation(1:2,3)) );

save('errorRelation/data','mouseTrack');

% % Mostra mapping    
% figure(mappingFG)
% imshow(background.mapping)
% set(gcf,'units','normalized','outerposition',[0 0 1 1])


% if ~isempty(input('Press enter to continue...','s'))
%     break;
% end
% close all


for i=1:mousePath.len-1
    tic
    % Busca frame
    fprintf('%d: Collecting frame...\n',i-1);
    [background, line.frame(i).orig] = interf.frame( background, frameDim, mouseTrack(i).origTransformation, mousePath.thick );
    time.frame(i) = toc;
    fprintf('Done (%.2f seconds).\n\n',time.frame(i))
    
    
    % Aplica o FAST Corners no frame
    tic
    fprintf('%d: Running FAST corners...',i-1);
    [f, e] = FAST.collect9(line.frame(i), frameDim, recommendedThreshold);    
    line.FASTC.extractions(i).coordinates = e.coordinates; line.FASTC.extractions(i).features = e.features; line.FASTC.extractions(i).number = e.number; clear e;
    line.frame(i).orig = f.orig; line.frame(i).gray = f.gray; clear f;    
    
    [f, e, recommendedThreshold] = FAST.twoFramesController([line.frame(i-1) line.frame(i)], frameDim, recommendedThreshold, [line.FASTC.extractions(i-1) line.FASTC.extractions(i)], FASTC);
    inst(1).FASTC.extractions(i).coordinates = e(1).coordinates; inst(1).FASTC.extractions(i).features = e(1).features; inst(1).FASTC.extractions(i).number = e(1).number;   
    inst(2).FASTC.extractions(i).coordinates = e(2).coordinates; inst(2).FASTC.extractions(i).features = e(2).features; inst(2).FASTC.extractions(i).number = e(2).number; clear e;
    
    inst(1).frame(i).corners = f(1).corners; inst(1).frame(i).bwcorners = f(1).bwcorners;     
    inst(2).frame(i).corners = f(2).corners; inst(2).frame(i).bwcorners = f(2).bwcorners; clear f;        

    inst(1).FASTC.extractions(i).range.number = [1 inst(1).FASTC.extractions(i).number];
    inst(2).FASTC.extractions(i).range.number = [1 inst(2).FASTC.extractions(i).number];
    
    FASTC.colorThreshold(i) = recommendedThreshold;
    time.FAST(i) = toc;
    fprintf('FAST extracted %d corners and filtered 1-%d 2-%d corners (%.2f seconds)\n\n', line.FASTC.extractions(i).number, inst(1).FASTC.extractions(i).number, inst(2).FASTC.extractions(i).number, time.FAST(i));
    
    compare.matchingDiferences = round( compare.matchingDiferencesProp * min(inst(1).FASTC.extractions(i).number, inst(2).FASTC.extractions(i).number) );
%     if compare.matchingDiferences >= min(inst(1).FASTC.extractions(i).number, inst(2).FASTC.extractions(i).number)
%         compare.matchingDiferences = min(inst(1).FASTC.extractions(i).number, inst(2).FASTC.extractions(i).number)-1;
%     end
    
    % Cria Assinaturas
    tic
    fprintf('%d: Creating signatures...',i-1);
    inst(1).corners(i).sig = sig.create(inst(1).FASTC.extractions(i), compare);
    inst(2).corners(i).sig = sig.create(inst(2).FASTC.extractions(i), compare);
    time.sig(i) = toc;
    fprintf('Done (%.4f seconds).\n\n',time.sig(i))

    % Compara assinaturas
    tic
    fprintf('%d: Comparing signatures...',i-1);

    time.ransac(i)=0;

    j = 1;
    numberAcceptedMatches(i) = 0;
    while numberAcceptedMatches(i) <= 4 && j <= 4
        aMatches = 0;
        while aMatches <= 4 && j <= 4
            [matches(i), aMatches] = matching.compareSigs([inst(1).corners(i).sig inst(2).corners(i).sig], [inst(1).FASTC.extractions(i) inst(2).FASTC.extractions(i)], compare, j); time.FMBF(i) = toc; %matches(i).matchingMaxDist = m.matchingMaxDist; % matches(i).difs = m.difs; matches(i).infNum = m.infNum;
            j = j + 1;
        end
        % %     dataLink(1,:) = kron(1:inst(1).FASTC.extractions(i).number, ones(1, inst(2).FASTC.extractions(i).number));
        % %     dataLink(2,:) = repmat(1:inst(1).FASTC.extractions(i).number,1,inst(2).FASTC.extractions(i).number);
        % %     RSC.outlierRatio = 0.9;
        dataLink(1,:) = find(matches(i).mate2);
        dataLink(2,:) = matches(i).mate2(dataLink(1,:));
        tic; [bestModel, mate2, iterations(i)] = matching.ransac([inst(1).FASTC.extractions(i) inst(2).FASTC.extractions(i)], dataLink, RSC);  time.ransac(i) = toc; matches(i).mate2 = mate2; clear dataLink;

        numberAcceptedMatches(i) = sum(matches(i).mate2>0);
        %j = j + 1;
    end

    constraint(i) = j-1;

    fprintf('Comparing signatures: %d attempts ; done in %0.3f seconds ; FMBF in %0.3f seconds and RANSAC in %0.3f seconds\n\n',constraint(i),time.FMBF(i)+time.ransac(i), time.FMBF(i), time.ransac(i));

    % Corresponde as coordenadas dos cantos de uma imagem à próxima imagem
    line.corners(i).matchCoords = matching.indexisToCoords(matches(i).mate2,[inst(1).FASTC.extractions(i) inst(2).FASTC.extractions(i)]);


    % Calcula transforma��o
    [calcTrack(i).translation, calcTrack(i).angle] = model.giveTransformation(line.corners(i).matchCoords);
    
    calcTrack(i).relativeTransformation = kin.transform2D_A( calcTrack(i).translation, calcTrack(i).angle );
    calcTrack(i).originTransformation = calcTrack(i-1).originTransformation * calcTrack(i).relativeTransformation;
    
    trackCoords.mouse(:,i) = round( refConv.cartesianToMatrix(background.dim(1:2),  mouseTrack(i).origTransformation(1:2,3)) ); %path(i).pointerCoords.matrix;
    trackCoords.calc(:,i) = round( refConv.cartesianToMatrix(background.dim(1:2), calcTrack(i).originTransformation(1:2,3)) );
    
    trackError(i).absolute = [abs(mouseTrack(i).translation-calcTrack(i).translation) ; abs(mouseTrack(i).angle-calcTrack(i).angle)*180/pi];
    trackError(i).relative = [sqrt( sum(abs(mouseTrack(i).translation-calcTrack(i).translation).^2) ) / mousePath.radius * 100 ; abs(mouseTrack(i).angle-calcTrack(i).angle) / (2*pi) * 100];
    
    fprintf('Corner Variation=%d; Number of accepted matches=%d\n', inst(1).FASTC.extractions(i).number - inst(2).FASTC.extractions(i).number, numberAcceptedMatches(i));
    fprintf('Mouse Translation: X=%.2f, Y=%.2f, angle=%.2f  ;  Calculated Translation: X=%.2f, Y=%.2f, angle=%.2f\n', mouseTrack(i).translation, mouseTrack(i).angle*180/pi, calcTrack(i).translation, calcTrack(i).angle*180/pi);
    fprintf('Absolute error: dX=%.2f, dY=%.2f, dAg=%.2f\n', trackError(i).absolute);
    fprintf('Relative error: Displacement=%.2f%%, Angle=%.2f%%, Total=%.2f%%\n\n',trackError(i).relative, sum(trackError(i).relative));
    
    % Imagem de matching
    [line.frame(i).matches] = interf.showMatching(inst(1).frame(i).corners, inst(2).frame(i).corners, frameDim, matches(i).mate2, [inst(1).FASTC.extractions(i) inst(2).FASTC.extractions(i)]);
        
    % Mostra a trajetoria calculada
%     [bgCalcTrack, ~] = interf.drawTrack(background.dim(1:2), bgCalcTrack.bg, trackCoords.calc(:,i-1:i), trackStatic.calc.colors, 1);
%     figure(trackFg)
%     imshow(bgCalcTrack.bg)
%     set(gcf,'units','normalized','outerposition',[0 0 1 1])
    
%     % Mostra mapping    
%     figure(mappingFG)
%     imshow(background.mapping)
%     set(gcf,'units','normalized','outerposition',[0 0 1 1])
    
%     if ~isempty(input('Press enter to continue...','s'))
%         break;
%     end
%     close all

    save('errorRelation/data','time','trackError','calcTrack','-append');
    save(['errorRelation/current' num2str(i)],'i');
end

% for i=1:mousePath.len-1
%     figure
%     imshow(frame(i).corners)
% end

% Mostra a trajetoria do rato
[bgMouseTrack, ~] = interf.drawTrack(background.dim(1:2), background.orig, trackCoords.mouse, trackStatic.mouse.colors, mousePath.thick);

figure
imshow(bgMouseTrack.bg)
set(gcf,'units','normalized','outerposition',[0 0 1 1])

% figure
% imshow(bgMouseTrack.bw)
% set(gcf,'units','normalized','outerposition',[0 0 1 1])


% Mostra a trajetoria calculada
[bgCalcTrack, ~] = interf.drawTrack(background.dim(1:2), background.orig, trackCoords.calc, trackStatic.calc.colors, mousePath.thick);
figure
imshow(bgCalcTrack.bg)
imwrite(bgCalcTrack.bg,'bg.jpg','jpg')
set(gcf,'units','normalized','outerposition',[0 0 1 1])

% figure
% imshow(bgCalcTrack.bw)
% set(gcf,'units','normalized','outerposition',[0 0 1 1])


%Mostra ambas as trajetorias (do rato e a calculada)
[bgCalcTrack, ~] = interf.drawTrack(background.dim(1:2), bgMouseTrack.bg, trackCoords.calc, trackStatic.calc.colors, mousePath.thick);
figure
imshow(bgCalcTrack.bg)
set(gcf,'units','normalized','outerposition',[0 0 1 1])

% figure
% imshow(bgCalcTrack.bw)
% set(gcf,'units','normalized','outerposition',[0 0 1 1])


% figure
% imshow(img.previous)
% set(gcf,'units','normalized','outerposition',[0 0 1 1])


figure
imshow(background.mouseTrack)
set(gcf,'units','normalized','outerposition',[0 0 1 1])

% load graph
% calcTrackGraph = [calcTrackGraph calcTrack];
% trackErrorGraph = [trackErrorGraph trackError];
% save graph trackErrorGraph calcTrackGraph

save('errorRelation/done','i');