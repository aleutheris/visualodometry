
load gen1
close all
clc


%[inc1, correctCorners1, incorrectCorners1] = analyser.cornerPropertiesAll(matches,mate2);

[inc1, correctCorners1, incorrectCorners1] = analyser.cornerPropertiesAll(matches.details,mate2Gen);

%[inc2, correctCorners2, incorrectCorners2] = analyser.cornerPropertiesCut(fullMatches.details,mate2);

% close all
% 
% cC = [correctCorners2.dif];
% iC = [incorrectCorners2.dif];
% 
% plot(1:length(cC),cC);
% 
% figure
% plot(1:length(iC),iC);