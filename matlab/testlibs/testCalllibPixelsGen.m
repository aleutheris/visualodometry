clc, clear all, close all

number_of_pixels_to_generate = 40;
array_cenas = zeros(2, number_of_pixels_to_generate);

if ~libisloaded('libpixels_generator_cbridge')
    %addpath(fullfile(matlabroot,'extern','examples','libbasic'))
    loadlibrary('libpixels_generator_cbridge', 'pixels_generator_cbridge.h')
end

[~, gen] = calllib('libpixels_generator_cbridge', 'pixelsgenerator_generate_simple', [30 50], number_of_pixels_to_generate, array_cenas);

sum = calllib('libpixels_generator_cbridge', 'pixelsgenerator_get_sum', 1, 3);

%get(p)

%[~, gen] = calllib('libpixels_generator_cbridge', 'pixelsgenerator_generate_simple', [1 5], number_of_pixels_to_generate, array_cenas);

unloadlibrary libpixels_generator_cbridge

gen
sum