close all
[cornerCmp] = interf.showMatchingComparison(frame(1).corners, frame(2).corners,frameDim,mate2Gen,matches.mate2,extractions);
load matc
matching = 4;

n = 11;
m = 35;

s = zeros(1,20);
figure
for i=1:50
    if matches.details(n,i).avgDif ~= Inf
        dists1 = corners(1).sig.c(n).dists( 1:length(matches.details(n,i).pos) );
        dists2 = corners(2).sig.c(i).dists( matches.details(n,i).pos);
        xc = xcorr(dists1, dists2);
%         autoXc1 = xcorr(dists1, dists1);
%         autoXc2 = xcorr(dists2, dists2);
%         avgAutoXc = (autoXc1+autoXc2)/2;
%         resXc = abs(xc-avgAutoXc);

            %figure(i)
            
            plot(xc,'b')
            hold on
%             hold on
%             plot(autoXc1,'g')
%             plot(resXc,'r')
        
        s(i) = sum(xc);
        %      avg(i) = mean(resXc);
        %          p(i) = length(findpeaks(resXc));
        % %
        % %     fprintf('i=%d   p=%d\n',i,p(i));
        %
        %         fprintf('i=%d   sum=%d   avg=%d  p=%d\n',i,s(i),avg(i),p(i));
        
    end
end

dists1 = corners(1).sig.c(n).dists( 1:length(matches.details(n,m).pos) );
dists2 = corners(2).sig.c(m).dists( matches.details(n,m).pos);
xc = xcorr(dists1, dists2);
% autoXc1 = xcorr(dists1, dists1);
% autoXc2 = xcorr(dists2, dists2);
% avgAutoXc = (autoXc1+autoXc2)/2;
% resXc = abs(xc-avgAutoXc);

%figure(100)
plot(xc,'r')
% hold on
% plot(autoXc1,'g')
% plot(resXc,'r')

fprintf('AngleDif = %.6f rads  :  %.6f degrees\n', abs(corners(1).sig.c(n).neighboursAngle-corners(2).sig.c(m).neighboursAngle), abs(corners(1).sig.c(n).neighboursAngle-corners(2).sig.c(m).neighboursAngle) * 180 / pi);
fprintf('Neibours of %d = [%d %d], Dists = [%.4f %.4f] : Neibours of %d = [%d %d], Dists = [%.4f %.4f] : Dists Diff = [%.4f %.4f]\n', n, [corners(1).sig.c(n).neighbours], [corners(1).sig.c(n).neighboursDists],  m, [corners(2).sig.c(m).neighbours], [corners(2).sig.c(m).neighboursDists],  abs([corners(1).sig.c(n).neighboursDists]-[corners(2).sig.c(m).neighboursDists]));

numZeros = sum(s==0);
[sorted,I] = sort(s);
Y = I(numZeros+1:end);
O = Y(end:-1:1)

id = (1:length(mate2Gen))
mate2Gen
matches.mate2