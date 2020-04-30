%clc, clear all, close all

thestep=10;

fI_scene = 1:thestep:3000; %fI_scene = fI_scene(1:300);
fI_V1 = 'ABCDEFGMNHIJ';
%fI_V2 = 'KJIHGMNPOQR';
fI_V3 = ['_A' ; '_B' ; '_C' ; '_D' ; '_F' ; '_G' ; '_H' ; '_I' ; '_J' ; '_K' ; '_L' ; '_M' ; '_N' ; '_O' ; '_P' ; '_V' ; 'AD' ; 'AC' ; 'AB' ; 'AA' ; 'AM' ; 'AN' ; 'AO' ; 'AP'];

% Allocation
%FASTC.extractions(1:mousePath.len) = struct('coordinates',[],'circle',0,'number',0,'range',struct('number',[],'coordinates',[]));
%corners(1:mousePath.len) = struct('sig', struct('range', struct('number',[],'coordinates',[floor(frameDim(:,1)/2) -floor(frameDim(:,1)/2)]), 'c',[]));
%matches(1:mousePath.len-1) = struct('mate2',[],'avgDifs',[],'matchingQuality',Inf,'cornerMatchesNum',[],'more',[],'rejectMatchesLim',0,'matchesRatio',[]);
%calcTrack(1:mousePath.len-1) = struct('translation',zeros(2,1),'angle',0,'relativeTransformation',zeros(3,3),'originTransformation',zeros(3,3));
%frame(1:9) = struct('orig',uint8(zeros(frameDim(1),frameDim(2),3)), 'gray',uint8(zeros(frameDim)), 'corners',uint8(zeros(frameDim(1),frameDim(2),3)), 'bwcorners',uint8(zeros(frameDim)));

% Imagem
i=1;
background.dim = [800 800];
bgCalcTrack.bg = uint8(zeros([background.dim 3]));
background.mapping = uint8(zeros(background.dim));

frameDim = [480 640]/2;


% Scene
iterator = num2str(10000+fI_scene(i));
line.frame(i).orig = imread(['video/scene/video_10_complete_track_' iterator(2:5) '.jpg']);

% % V1
% iterator = num2str(100+i);
% line.frame(i).orig = imread(['video/V1/' iterator(2:3) fI_V1(i) '.jpg']);

% % V3
% iterator = num2str(100+i);
% line.frame(i).orig = imread(['video/V3/' iterator(2:3) fI_V3(i,:) '.jpg']);

% % 1
% line.frame(i).orig = imread(['video/1/' num2str(i) '.jpg']);


line.frame(i).orig = imresize(line.frame(i).orig, frameDim);

% Cor das v�rias composi��es do path
trackStatic.calc.colors.line = [255 128 0];
trackStatic.calc.colors.step = [255 255 0];

% Captor
cpt.l.b = 3.045;
cpt.l.m = 0.2525;
cpt.d = 3107; %(mm)

% FAST properties
recommendedThreshold = 24;
FASTC.colorThreshold(i) = recommendedThreshold;
FASTC.usedCorners = 40;
FASTC.askedCornersNumber = 3*FASTC.usedCorners;
FASTC.pixelPerimeter = 16;
FASTC.arcPixelRequired = 9;
FASTC.minCornersAllowed = 1.5*FASTC.usedCorners;

% Comparison properties
compare.matchingDiferencesProp = 0.45;
compare.firstPhaseMatches = 200;  
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

sigThreshold.pixelArc = 2;
sigThreshold.arcColor = 10*6;


% Aplica o FAST Corners nos frames
tic
fprintf('%d: Running FAST corners...',i-1);
[f, e] = FAST.collect9(line.frame(i), frameDim, recommendedThreshold);
line.FASTC.extractions(i).coordinates = e.coordinates; line.FASTC.extractions(i).features = e.features; line.FASTC.extractions(i).number = e.number; clear e;
line.frame(i).orig = f.orig; line.frame(i).gray = f.gray; clear f;
line.FASTC.extractions(i).range.number = [1 line.FASTC.extractions(i).number];
time.FAST(i) = toc;
fprintf('FAST done with %d corners (%.2f seconds)\n\n', line.FASTC.extractions(i).number,time.FAST(i));

% % Cria Assinaturas
% tic
% fprintf('%d: Creating signatures...',i-1);
% inst(2).corners(i).sig = sig.create(FASTC.extractions(i),compare.acceptedNeighbourhood);
% time.sig(i) = toc;
% fprintf('Done (%.4f seconds).\n\n\n',time.sig(i))

% Declarar a posição inicial do robot
calcTrack(i).translation = zeros(3,3);
calcTrack(i).angle = 0;
calcTrack(i).relativeTransformation = eye(3);
calcTrack(i).originTransformation = calcTrack(i).relativeTransformation;

trackCoords.calc(:,i) = round( refConv.cartesianToMatrix(background.dim(1:2), calcTrack(i).originTransformation(1:2,3)) );


for i=2:length(fI_scene)
%for i=2:9
%     if mod(i,10)==0
%         if ~isempty(input('Press enter to continue...','s'))
%             break;
%         end
%        close all;
%     end
    

    % Scene
    iterator = num2str(10000+fI_scene(i));
    line.frame(i).orig = imread(['video/scene/video_10_complete_track_' iterator(2:5) '.jpg']);
    
%     % V1
%     iterator = num2str(100+i);
%     line.frame(i).orig = imread(['video/V1/' iterator(2:3) fI_V1(i) '.jpg']);
%     
%     % V3
%     iterator = num2str(100+i);
%     line.frame(i).orig = imread(['video/V3/' iterator(2:3) fI_V3(i,:) '.jpg']);

%     % 1
%     line.frame(i).orig = imread(['video/1/' num2str(i) '.jpg']);


    line.frame(i).orig = imresize(line.frame(i).orig, frameDim);
    
    % Aplica o FAST Corners no frames
    tic
    fprintf('%d: Running FAST corners...',i-1);
    [f, e] = FAST.collect9(line.frame(i), frameDim, recommendedThreshold);    
    line.FASTC.extractions(i).coordinates = e.coordinates; line.FASTC.extractions(i).features = e.features; line.FASTC.extractions(i).number = e.number; clear e;
    line.frame(i).orig = f.orig; line.frame(i).gray = f.gray; clear f;    
    
    [f,  e, recommendedThreshold] = FAST.twoFramesController([line.frame(i-1) line.frame(i)], frameDim, recommendedThreshold, [line.FASTC.extractions(i-1) line.FASTC.extractions(i)], FASTC);
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
    numberElectedMatches(i) = 0;
    while numberElectedMatches(i) <= 4 && j <= 4
        aMatches = 0;
        while aMatches <= 4 && j <= 4
            [matches(i), aMatches] = matching.compareSigs([inst(1).corners(i).sig inst(2).corners(i).sig], [inst(1).FASTC.extractions(i) inst(2).FASTC.extractions(i)], compare, j); time.FMBF(i) = toc; %matches(i).matchingMaxDist = m.matchingMaxDist; % matches(i).difs = m.difs; matches(i).infNum = m.infNum;
            j = j + 1;
        end

        dataLink(1,:) = find(matches(i).mate2);
        numberAcceptedMatches(i) = length(dataLink(1,:));
        dataLink(2,:) = matches(i).mate2(dataLink(1,:));
        tic; [bestModel, mate2, iterations(i)] = matching.ransac([inst(1).FASTC.extractions(i) inst(2).FASTC.extractions(i)], dataLink, RSC);  time.ransac(i) = toc; matches(i).mate2 = mate2; clear dataLink;
        
        numberElectedMatches(i) = sum(matches(i).mate2>0);
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
    
    trackCoords.calc(:,i) = round( refConv.cartesianToMatrix(background.dim(1:2), calcTrack(i).originTransformation(1:2,3)) );
    
    

    fprintf('Corner Variation=%d\n', inst(1).FASTC.extractions(i).number - inst(2).FASTC.extractions(i).number);
    fprintf('Number of accepted matches=%d, Number of elected matches=%d, RANSAC rejection=%0.1f%%\n',numberAcceptedMatches(i),numberElectedMatches(i),abs(numberAcceptedMatches(i)-numberElectedMatches(i))/numberAcceptedMatches(i)*100);    fprintf('Calculated Translation:\n');
    fprintf('\tX=%.2f px, Y=%.2f px, angle=%.2f\n', calcTrack(i).translation, calcTrack(i).angle*180/pi);
    %fprintf('\tX=%.2f mm, Y=%.2f mm, angle=%.2f\n', captor.pixelToMM(cpt.linex, cpt.liney, scaling, cpt.dist, frameDim([2,1]), calcTrack(i).translation), calcTrack(i).angle*180/pi);    
    %fprintf('Matching quality: %.5f\n', matches(i).matchingQuality);
    %fprintf('Matching max distance: %.5f\n', matches(i).matchingMaxDist);
    %fprintf('Distances number average: %.3f\n', mean(matches(i).difs));
    %fprintf('InfNum number average: %.3f\n\n', mean(matches(i).infNum));
    
    % Imagem de matching
    [line.frame(i).matches] = interf.showMatching(inst(1).frame(i).corners, inst(2).frame(i).corners, frameDim, matches(i).mate2, [inst(1).FASTC.extractions(i) inst(2).FASTC.extractions(i)]);
    %imwrite(line.frame(i).matches,[num2str(thestep) '/' num2str(i) '.jpg'],'jpg')
    
%     % Mostra a trajetoria calculada online
%     if prod(calcTrack(i).translation) %Apenas se existir movimento
%         [bgCalcTrack, ~] = interf.drawTrack(background.dim(1:2), bgCalcTrack.bg, trackCoords.calc(:,i-1:i), trackStatic.calc.colors, 1);
%         figure
%         imshow(bgCalcTrack.bg)
%         set(gcf,'units','normalized','outerposition',[0 0 1 1])
%     end    
end

% trigger(vid); % tira foto
% frame(i+1).orig = getdata(vid);
% stoppreview(vid); % renova camera

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

fprintf('Total time = %0.3f (s). Average time = %0.3f (s)\n', sum(time.sig + time.ransac + time.FMBF), sum(time.sig + time.ransac + time.FMBF)/length(time.FMBF));

%save(num2str(thestep))
