% clc, clear all, close all

load('8.mat')

mapDim = [13000 13000]; %background.dim*2;
map = uint8(zeros([mapDim 3]));

% i=1;
% %calcTrack(i).originTransformation = calcTrack(i).relativeTransformation;
% map = interf.mapping(map, frame(i).orig, mapDim, frameDim, calcTrack(i).originTransformation );
for i=1:length(numberAcceptedMatches)
    tic
    %calcTrack(i).originTransformation = calcTrack(i-1).originTransformation * calcTrack(i).relativeTransformation;
    map = interf.mapping(map, line.frame(i).orig, mapDim, frameDim, calcTrack(i).originTransformation );
    timeSave(i) = toc;
    fprintf('i = %d took %.3f seconds\n',i,timeSave(i));
end

fprintf('\nTotal time = %.3d seconds\n\n',sum(timeSave));
imwrite(map,'mapScene.jpg','jpg');