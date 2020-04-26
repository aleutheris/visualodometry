clc, clear all, close all

% FAST properties
threshold = 1;

img.fileName = 'Samples/2.jpg';

frameDim = [240 320];

img.orig = imresize( imread(img.fileName), frameDim );

numberCorners = zeros(1,255);
time.FAST = zeros(1,255);

for i=1:255
    fprintf('%d: Starting FAST\n',i);
    tic
    [img, e] = FAST.collect9(img, frameDim, i);
    if e.number == 0
        fprintf('\nProcess ended with high threshold\n');
        break;
    end
    numberCorners(i) = e.number;
    [img] = FAST.drawCorners(e, frameDim, img);
    time.FAST(i) = toc;
    fprintf('FAST detected %d corners in %0.3f seconds\n\n', e.number, time.FAST(i));   
end