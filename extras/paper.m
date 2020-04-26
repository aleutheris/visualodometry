clc
clear all
close all

compare.requestedMatches = 15;
sigThreshold.pixelArc = 2;
sigThreshold.arcColor = 10*6;

% FAST properties
FASTC.threshold = 200;

img(1) = struct('FileName',[],'orig',[],'dim',[],'gray',[],'corners',[],'bwcorners',[]);

img(1).fileName = 'Samples/10.1cornersC.tif';

img(1).orig = imread(img(1).fileName);

sizeImg(1,:) = (size(img(1).orig))';

img(1).dim = (sizeImg(1,1:2))';


fprintf('Starting FAST of 1ª pictures\n');
tic
[img(1), e] = FAST.corners(img(1), img(1).dim, FASTC.threshold);
FASTC.extractions(1).coordinates = e.coordinates; FASTC.extractions(1).features = e.features; FASTC.extractions(1).number = e.number; clear e;
FASTC.extractions(1).range.number = [1 FASTC.extractions(1).number];
FASTC.extractions(1).range.coordinates = [floor(img(1).dim/2) -floor(img(1).dim/2)];
fprintf('FAST of 1ª picture done with corners %d in %0.3f seconds\n\n', FASTC.extractions(1).number, toc);


coordsM = round(refConv.cartesianToMatrix(img(1).dim, FASTC.extractions.coordinates));

coordsCirfStd = [-3 -3 -2 -1  0  1  2  3  3  3  2  1  0 -1 -2 -3 ; 0  1  2  3  3  3  2  1  0 -1 -2 -3 -3 -3 -2 -1];  %Colunas
sizeCC = size(coordsCirfStd);

for i=1:FASTC.extractions.number
    
    coordsCheck = coordsM(:,i);
    
    if coordsCheck(1) >= 5 && coordsCheck(1) <= img(1).dim(1)-5  &&  coordsCheck(2) >= 5 && coordsCheck(2) <= img(1).dim(2)-5
        for j=1:sizeCC(2)
            coords =  coordsCheck + coordsCirfStd(:,j);
            
            img(1).corners( coords(1), coords(2), 1 ) = 0;
            img(1).corners( coords(1), coords(2), 2 ) = 0;
            img(1).corners( coords(1), coords(2), 3 ) = 255;
        end
    end
end

imshow(img(1).corners);