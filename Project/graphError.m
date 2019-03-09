clc, clear all, close all
load 'errorRelationData'

lim = 937;
angleGen = [1:10:180 180] * pi() / 180;


cTtrans = [calcTrack(2:lim).translation];
cDisplacement = sqrt( cTtrans(1,:).^2 + cTtrans(2,:).^2 ); 

mTtrans = [mouseTrack(1:lim).translation];    
mDisplacement = sqrt( mTtrans(1,:).^2 + mTtrans(2,:).^2 );

correctAngle = [mouseTrack(1:lim).angle];

angleAbsError = abs( [calcTrack(2:lim).angle] - [mouseTrack(1:lim).angle] );
displacementAbsError = abs( cDisplacement - mDisplacement );

angleRelError = angleAbsError * 100 / pi();
displacementRelError = displacementAbsError * 100 / 120;
                
mDisplacement = mDisplacement * 100 / 120;

n=7;
fg = figure;
for i=1:n
    angleIndexes(i,:) = [mouseTrack(1:lim).angle]==angleGen(i);
    
    % Displacement error
    %subplot(2,1,1)
    plot(mDisplacement(angleIndexes(i,:)), abs(angleRelError(angleIndexes(i,:))+displacementRelError(angleIndexes(i,:))),'b','LineWidth',2);
    hold on
    plot(mDisplacement(angleIndexes(i,:)), 10*ones(1,length(find(angleIndexes(i,:)))),'r--','LineWidth',2);
    title(num2str(angleGen(i) * 180 / pi() ))
    axis([1 30 0 100])
end
hy1 = ylabel('Error (\%)');
%lg1 = legend('Error behaviour','Error acceptance limit');

hx1 = xlabel('Displacement (\%)');

grid on

set(hx1,'Interpreter','latex');
set(hx1,'FontSize',16);

set(hy1,'Interpreter','latex');
set(hy1,'FontSize',16);

set(fg, 'Position', [0 0 700 500])

% subplot(2,1,2)
% for i=1:n
%     %Angle error    
%     plot(mDisplacement(angleIndexes(i,:)), angleRelError(angleIndexes(i,:)),'b','LineWidth',2);
%     hold on
%     plot(mDisplacement(angleIndexes(i,:)), 10*ones(1,length(find(angleIndexes(i,:)))),'r--','LineWidth',2);
%     %title(num2str(angleGen(i) * 180 / pi() ))
%     axis([1 100 0 100])   
% end
% hy2 = ylabel('Error (\%)');
% %lg2 = legend('Error behaviour','Error acceptance limit');
% 
% hx2 = xlabel('Angle ($^{\circ}$)');
% 
% grid on
% 
% % set(lg1,'Interpreter','latex');
% % set(lg1,'FontSize',14);
% % 
% % set(lg2,'Interpreter','latex');
% % set(lg2,'FontSize',14);
% 
% set(hy1,'Interpreter','latex');
% set(hy1,'FontSize',16);
% 
% set(hy2,'Interpreter','latex');
% set(hy2,'FontSize',16);
% 
% set(hx1,'Interpreter','latex');
% set(hx1,'FontSize',16);
% 
% set(hx2,'Interpreter','latex');
% set(hx2,'FontSize',16);
% 
% set(fg, 'Position', [0 0 600 500])

figure
plot3(mDisplacement, correctAngle * 180 / pi(), abs(angleRelError+displacementRelError), 'b-')
hold on
plot3(10*ones(1,length(mDisplacement)), 10*ones(1,length(mDisplacement)), 10*ones(1,length(mDisplacement)),'r--')

hx = xlabel('Displacement (\%)');

hy = ylabel('Angle ($^{\circ}$)');

hz = zlabel('Error (\%)');

set(hx,'Interpreter','latex');
set(hx,'FontSize',16);

set(hy,'Interpreter','latex');
set(hy,'FontSize',16);

set(hz,'Interpreter','latex');
set(hz,'FontSize',16);

axis([0 30 0 180 0 100])
grid on