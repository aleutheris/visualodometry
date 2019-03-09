close all

% % Gráfico de detected corners / Threshold
% fg = figure;
% 
% n=500;
% 
% subplot(2,1,1)
% stem(1:n,FASTC.colorThreshold,'g-','LineWidth',1);
% hy2 = ylabel('Threshold ($t_k$)');
% axis([0 500 0 60])
% grid on
% 
% subplot(2,1,2)
% stem(1:n,[line.FASTC.extractions.number],'b--','LineWidth',1);
% hold on
% plot(1:n,FASTC.usedCorners*ones(1,n),'r--','LineWidth',1);
% hold on
% plot(1:n,FASTC.askedCornersNumber*ones(1,n),'c-','LineWidth',1);
% lg = legend('$N_k$','$N_f$','$N_{ask}$');
% hy1 = ylabel('Number of corners');
% axis([0 500 0 350])
% grid on
% 
% hx = xlabel('Frame (k)');
% 
% set(lg,'Interpreter','latex');
% set(lg,'FontSize',20);
% 
% set(hy1,'Interpreter','latex');
% set(hy1,'FontSize',16);
% 
% set(hy2,'Interpreter','latex');
% set(hy2,'FontSize',16);
% 
% set(hx,'Interpreter','latex');
% set(hx,'FontSize',16);
% 
% set(fg, 'Position', [0 0 800 500])


% % Gráfico de filtragem de cantos
% fg = figure;
% hold on
% n=23;
% d=0.04;
% plot(1:n,30*ones(1,n),'r--','LineWidth',2);
% stem((1:n)-d,[inst(1).FASTC.extractions.number],'bo--','LineWidth',2);
% stem((1:n)+d,[inst(2).FASTC.extractions.number],'mo--','LineWidth',2);
% lg = legend('$N_f$','$N_\alpha$','$N_\beta$');
% 
% % title('Number of filtered corners per match','FontSize',16)
% hy = ylabel('Number of corners');
% hx = xlabel('Frame Match');
% 
% set(lg,'Interpreter','latex');
% set(lg,'FontSize',20);
% 
% set(hy,'Interpreter','latex');
% set(hy,'FontSize',18);
% 
% set(hx,'Interpreter','latex');
% set(hx,'FontSize',18);
% 
% set(fg, 'Position', [0 0 800 500])
% axis([1-d-0.02 n+d+0.02 26 48]);
% grid on


% % Gráfico de cantos detetados
% fg = figure;
% hold on
% n=8;
% stem(1:n,[line.FASTC.extractions(1:n).number],'bo--','LineWidth',2);
% 
% hy = ylabel('Number of detected corners (N)');
% hx = xlabel('Frame (k)');
% 
% set(hy,'Interpreter','latex');
% set(hy,'FontSize',18);
% 
% set(hx,'Interpreter','latex');
% set(hx,'FontSize',18);
% 
% set(fg, 'Position', [0 0 800 500])
% axis([1 n 26 220]);
% grid on


% %Gráfico de comparação entre attemps, filtered corner difference, MC and tempo
% fg = figure;
% n=23;
% subplot(4,1,1);
% stem(1:n,[inst(1).FASTC.extractions.number].*[inst(2).FASTC.extractions.number]/2,'mo--','LineWidth',2);
% hy1 = ylabel('MC');
% axis([1 n 400 800]);
% grid on
% 
% subplot(4,1,2);
% stem(1:n,abs([inst(1).FASTC.extractions.number]-[inst(2).FASTC.extractions.number]),'co--','LineWidth',2);
% hy2 = ylabel('$|\Delta N|$');
% axis([1 n 0 20]);
% grid on
% 
% subplot(4,1,3);
% stem(1:n,constraint(2:n+1),'go--','LineWidth',2);
% hy3 = ylabel('Attempts');
% axis([1 n 1 4]);
% grid on
% 
% subplot(4,1,4);
% stem(1:n,time.FMBF(2:n+1)+time.ransac(2:n+1)+time.sig(2:n+1),'b--','LineWidth',2);
% %hold on
% %stem(1:n,mean(time.FMBF(2:n+1)+time.ransac(2:n+1)+time.sig(2:n+1))*ones(1,n),'c--','LineWidth',2);
% %lg3 = legend('Time','Average Time');
% hy4 = ylabel('Time (s)');
% axis([1 n 0 8]);
% grid on
% 
% hx = xlabel('Frame Match');
% 
% %set(lg3,'Interpreter','latex');
% %set(lg3,'FontSize',16);
%   
% set(hy1,'Interpreter','latex');
% set(hy1,'FontSize',16);
% 
% set(hy2,'Interpreter','latex');
% set(hy2,'FontSize',16);
% 
% set(hy3,'Interpreter','latex');
% set(hy3,'FontSize',16);
% 
% set(hy4,'Interpreter','latex');
% set(hy4,'FontSize',16);
% 
% set(hx,'Interpreter','latex');
% set(hx,'FontSize',16);
% 
% set(fg, 'Position', [0 0 800 800])



% % Gráfico de elected corners / detected corners
% fg = figure;
% % aux = numberAcceptedMatches;
% % numberAcceptedMatches = numberElectedMatches;
% % numberElectedMatches = aux;
% n=8;
% d=0.025;
% subplot(2,1,1);
% stem((1:n)+d,numberAcceptedMatches(2:n+1),'b--','LineWidth',2);
% hold on
% stem((1:n)-d,numberElectedMatches(2:n+1),'m--','LineWidth',2);
% lg1 = legend('$M_a$','$M_e$');
% hy1 = ylabel('Number of corner matches');
% axis([1-d-0.05 n+d+0.05 0 14]);
% grid on
% 
% subplot(2,1,2);
% stem(1:n,(numberAcceptedMatches(2:n+1)-numberElectedMatches(2:n+1))./numberAcceptedMatches(2:n+1)*100,'g--','LineWidth',2);
% hold on
% plot(1:n,80*ones(1,n),'r--','LineWidth',2);
% lg2 = legend('RANSAC Rejection','$\eta_{out}$');
% hy2 = ylabel('(\%)');
% axis([1-d-0.05 n+d+0.05 0 100]);
% grid on
% 
% hx = xlabel('Frame Match');
% 
% set(lg1,'Interpreter','latex');
% set(lg1,'FontSize',20);
% 
% set(lg2,'Interpreter','latex');
% set(lg2,'FontSize',20);
% 
% set(hy1,'Interpreter','latex');
% set(hy1,'FontSize',13);
% 
% set(hy2,'Interpreter','latex');
% set(hy2,'FontSize',13);
% 
% set(hx,'Interpreter','latex');
% set(hx,'FontSize',16);
% 
% set(fg, 'Position', [0 0 800 500]);


% %2D path
% load 'video/V3/trans.mat'
% trans=-trans;
% clearvars X Y
% 
% fg = figure;
% hold on
% n=24;
% 
% pose(:,1)=[0 ; 0];
% for i=2:n
%     pose(:,i) = trans(:,i)+pose(:,i-1);
% end
% 
% for i=1:n
%     X(i) = captor.pixelToMM(cpt.l, frameDim, cpt.d, calcTrack(i).originTransformation(1,3));
%     Y(i) = captor.pixelToMM(cpt.l, frameDim, cpt.d, calcTrack(i).originTransformation(2,3));
% 
% %      X(i) = calcTrack(i).originTransformation(1,3);
% %      Y(i) = calcTrack(i).originTransformation(2,3);
%     
%     Xgt(i)=pose(1,i);
%     Ygt(i)=pose(2,i);
% end
% plot(Xgt,Ygt,'gx-','LineWidth',1');
% plot(Xgt,Ygt,'gx','LineWidth',2','MarkerSize',10);
% 
% plot(X,Y,'bx','LineWidth',1');
% plot(X,Y,'bx','LineWidth',2','MarkerSize',10);
% 
% lg = legend('Ground Truth','Estimated');
% 
% set(lg,'Interpreter','latex');
% set(lg,'FontSize',18);
% 
% hy = ylabel('Y (px)');
% hx = xlabel('X (px)');
% 
% set(hy,'Interpreter','latex');
% set(hy,'FontSize',18);
% 
% set(hx,'Interpreter','latex');
% set(hx,'FontSize',18);
% 
% set(fg, 'Position', [0 0 600 500])
% axis([-3100 100 -2600 100]);
% grid on


% % 2D path scene
% clearvars X Y
% 
% fg = figure;
% hold on
% n=100;
% 
% for i=1:n
%     X(i) = captor.pixelToMM(cpt.l, frameDim, cpt.d, calcTrack(i).originTransformation(1,3));
%     Y(i) = captor.pixelToMM(cpt.l, frameDim, cpt.d, calcTrack(i).originTransformation(2,3));   
% end
% 
% plot(X,Y,'bx','LineWidth',1');
% 
% %lg = legend('Ground Truth','Estimated');
% 
% % set(lg,'Interpreter','latex');
% % set(lg,'FontSize',18);
% 
% hy = ylabel('Y (px)');
% hx = xlabel('X (px)');
% 
% set(hy,'Interpreter','latex');
% set(hy,'FontSize',18);
% 
% set(hx,'Interpreter','latex');
% set(hx,'FontSize',18);
% 
% set(fg, 'Position', [0 0 600 500])
% %axis([-3100 100 -2600 100]);
% grid on


% %Relative Position
% load 'video/V3/trans.mat'
% trans=-trans;
% fg = figure;
% hold on
% n=24;
% 
% for i=1:n
%     X(i) = captor.pixelToMM(cpt.l, frameDim, cpt.d, calcTrack(i).relativeTransformation(1,3));
%     Y(i) = captor.pixelToMM(cpt.l, frameDim, cpt.d, calcTrack(i).relativeTransformation(2,3));
% end
% 
% plot(1:length(X),sqrt( (X-trans(1,:)).^2 + (Y-trans(2,:)).^2 ),'mx-','LineWidth',2','MarkerSize',10);
% hy = ylabel('Absolute Error (mm)');
% grid on
% 
% hx = xlabel('$H_k$');
% 
% set(hy,'Interpreter','latex');
% set(hy,'FontSize',14);
% 
% set(hx,'Interpreter','latex');
% set(hx,'FontSize',18);
% 
% set(fg, 'Position', [0 0 700 500])



% %Absolute Position
% load 'video/V3/trans.mat'
% trans=-trans;
% fg = figure;
% hold on
% n=24;
% 
% pose(:,1)=[0 ; 0];
% for i=2:n
%     pose(:,i) = trans(:,i)+pose(:,i-1);
% end
% 
% for i=1:n
%     X(i) = captor.pixelToMM(cpt.l, frameDim, cpt.d, calcTrack(i).originTransformation(1,3));
%     Y(i) = captor.pixelToMM(cpt.l, frameDim, cpt.d, calcTrack(i).originTransformation(2,3));
% end
% 
% % M = sqrt(X.^2 + Y.^2);
% % Mgt = sqrt(pose(1,:).^2 + pose(2,:).^2);
% 
% %subplot(2,1,1)
% plot(1:length(X),sqrt( (X-pose(1,:)).^2 + (Y-pose(2,:)).^2 ),'mx-','LineWidth',2','MarkerSize',10);
% hy2 = ylabel('Absolute Error (mm)');
% grid on
% 
% % subplot(2,1,2)
% % plot(1:length(M),sqrt( (X-pose(1,:)).^2 + (Y-pose(2,:)).^2 )./Mgt*100,'rx-','LineWidth',2','MarkerSize',10);
% % hy3 = ylabel('Relative Error (\%)');
% % grid on
% 
% hx = xlabel('$k$');
% 
% set(hy2,'Interpreter','latex');
% set(hy2,'FontSize',14);
% 
% % set(hy3,'Interpreter','latex');
% % set(hy3,'FontSize',14);
% 
% set(hx,'Interpreter','latex');
% set(hx,'FontSize',18);
% 
% set(fg, 'Position', [0 0 700 500])



% % Gráfico de FAST
% lineX = numberCorners;
% 
% % p1 = 7.394;
% % p2 = 866.9;
% % q1 = 191.8;
% % lineY = (p1.*lineX+p2)./(lineX+q1);
% 
% m=0.0032;
% b=4.493;
% lineY = m*lineX+b;
% 
% fg = figure;
% plot(numberCorners,time.FAST,'bo-','LineWidth',2);
% hold on
% plot(lineX,lineY,'r--','LineWidth',2);
% 
% hy = ylabel('FAST Time (s)');
% hx = xlabel('Number of detected corners');
% 
% set(hy,'Interpreter','latex');
% set(hy,'FontSize',18);
% 
% set(hx,'Interpreter','latex');
% set(hx,'FontSize',18);
% 
% set(fg, 'Position', [0 0 800 500]);
% 
% grid on
