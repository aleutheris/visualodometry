clc, clear all, close all

if ~libisloaded('libpixels_generator_cbridge')
    %addpath(fullfile(matlabroot,'extern','examples','libbasic'))
    loadlibrary('libpixels_generator_cbridge', 'pixels_generator_cbridge.h')
end

calllib('libpixels_generator_cbridge', 'pixelsgenerator_generate_simple', [40 40], 20)

%calllib('libgenerator_cbridge', 'Generator_get_number', 1, 2)
