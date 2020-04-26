close all

n = 71;

for i=1:74
    xc = xcorr(corners(1).sig.c(n).dists(1:compare.matchingDiferences), corners(2).sig.c(i).dists(1:compare.matchingDiferences));
    autoXc1 = xcorr(corners(1).sig.c(n).dists(1:compare.matchingDiferences), corners(1).sig.c(n).dists(1:compare.matchingDiferences));
    autoXc2 = xcorr(corners(2).sig.c(i).dists(1:compare.matchingDiferences), corners(2).sig.c(i).dists(1:compare.matchingDiferences));
    avgAutoXc = (autoXc1+autoXc2)/2;
    resXc = abs(xc-avgAutoXc);
%     len = length(xc);
%     maxi = max(xc);
    
%     figure
%     plot(xc,'b')
%     hold on
%     plot(autoXc1,'g')
%     plot(resXc,'r')
    
     s(i) = sum(resXc);
%      avg(i) = mean(resXc);
%          p(i) = length(findpeaks(resXc));
% % 
% %     fprintf('i=%d   p=%d\n',i,p(i));
%     
%         fprintf('i=%d   sum=%d   avg=%d  p=%d\n',i,s(i),avg(i),p(i));
    
%     figure
%     plot(corners(1).sig.c(24).distsNS,'b')
%     hold on
%     plot(corners(2).sig.c(i).distsNS,'g')
    
%     xc1 = xc(1:floor(len/2));
%     xc2 = xc(len:-1:ceil(len/2)+1);
    
    %xxc = xcorr( xc(1:floor(len/2)), xc(len:-1:ceil(len/2)));
%     figure
%     plot(xc1,'b')
%     hold on
%     plot(xc2,'g')

%     m(i) = mean(abs(xc1-xc2));
%     
%     fprintf('i=%d  residuo = %d\n',i,mean(abs(xc1-xc2)));
% 
%     figure
%     plot(abs(xc1-xc2),'r')
    
%     
%     tri = zeros(len,1);
%        
%     m = maxi / (ceil(len/2)+1);
%     
%     for x=1:ceil(len/2)
%        tri(x) = m*x;
%     end
%     
%     tri(ceil(len/2)+1:end) = tri(floor(len/2):-1:1);
%     
%     figure
%     plot(xc)
%     hold on
%     plot(tri,'g')
%     plot(xc-tri,'r')
end

[~,I] = sort(s)