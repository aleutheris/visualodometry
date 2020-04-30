clc, clear all, close all

me2 = 'runRealOfflineSW failed';
try
    thestep=6;
    runRealOfflineSW
catch me2
    fprintf('error\n');
end

try
    thestep=10;
    runRealOfflineSW
catch me2
    fprintf('error\n');
end

pause(60)

system('sudo shutdown -h now')
