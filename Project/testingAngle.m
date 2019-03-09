clc, clear all, close all

ags = zeros(27,2);
neighbours = zeros(27,2);
neighboursAngle = zeros(27,1);

ags(1,:) = [80 10];
ags(2,:) = [10 80];
ags(3,:) = [100 170];
ags(4,:) = [170 100];
ags(5,:) = [-170 -100];
ags(6,:) = [-100 -170];
ags(7,:) = [-80 -10];
ags(8,:) = [-10 -80];
ags(9,:) = [20 160];
ags(10,:) = [160 20];
ags(11,:) = [150 -100];
ags(12,:) = [-100 150];
ags(13,:) = [-140 -40];
ags(14,:) = [-40 -140];
ags(15,:) = [-20 70];
ags(16,:) = [70 -20];
ags(17,:) = [70 -160];
ags(18,:) = [-160 70];
ags(19,:) = [-100 20];
ags(20,:) = [20 -100];
ags(21,:) = [-10 100];
ags(22,:) = [100 -10];
ags(23,:) = [160 -80];
ags(24,:) = [-80 160];
ags(25,:) = [-50 100];
ags(26,:) = [-100 50];
ags(27,:) = [50 -100];

ags = ags * pi / 180;

for i=1:length(ags)
    % calculo do angulo de 3 em relação a 2
    ag = ags(i,2) - ags(i,1); 
    if ag > pi() % angulo calculado pela volta maior (foi positiva)
        ag = ag - 2*pi(); % normalizar
    elseif ag < -pi() % angulo calculado pela volta maior (foi negativa)
        ag = 2*pi() + ag; % normalizar
    end

    if ag > 0
        neighbours(i,:) = ags(i,[1 2]); % se ag positivo então 2 é o primeiro e 3 é o segundo
    else
        neighbours(i,:) = ags(i,[2 1]); % caso contrario
        ag = -ag; % angulo entre 2 e 3 é sempre positivo
    end

    neighboursAngle(i) = ag;
    
    fprintf('[%d %d] %.5f\n',neighbours(i,:) * 180 / pi, ag * 180 / pi);
end

