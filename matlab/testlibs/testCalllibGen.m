clc, clear all, close all

if ~libisloaded('libgenerator_cbridge')
    %addpath(fullfile(matlabroot,'extern','examples','libbasic'))
    loadlibrary('libgenerator_cbridge', 'generator_cbridge.h')
end

calllib('libgenerator_cbridge', 'Generator_get_sum', 1, 2)

calllib('libgenerator_cbridge', 'Generator_get_number', 1, 2)
