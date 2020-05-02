clc, clear all, close all

if ~libisloaded('libbasic')
    %addpath(fullfile(matlabroot,'extern','examples','libbasic'))
    loadlibrary('libbasic', 'Basic.h')
end

calllib('libbasic', 'get_sum', 1, 2)
