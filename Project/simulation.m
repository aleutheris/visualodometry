clc
clear all
close all

imgDim=[443 6; 443 6];
imgDim(:,3)=imgDim(:,1)-imgDim(:,2);
%imgDiagonal = round(sqrt(imgDim(1)^2 + imgDim(2)^2));

numCorners1 = 14:2:30;
repeatabilityPic = 0.2:0.1:1;
variation1 = -0.9:0.2:1;
variation2 = 1.1:0.5:2.1;
variation3 = 3:1:6;
vari = [variation1 variation2 variation3];

trans = [10 20 ; 100 130 ; 0 40 ; 60 30];
ag = [20 60 90 120];
ag = ag*pi/180;

time = zeros(6000);

sim = 0;

for a = length(ag) % ciclo para transformações
    for i=numCorners1 % ciclo para cantos
        
        for rP = repeatabilityPic  %repeatability
            
            variation1 = rP-1:0.2:1;
            vari = [variation1 variation2 variation3];
            
            for v = vari   %variation
                
                for cmd = round(i*giveCMD(rP))
                    sim=sim+1;
                    tic

                    clear extractions
                    clear sucessRegister

                    % Primeira extracção
                    extractions(1).features = 0;
                    extractions(1).coordinates = cornerSim.cornerGen1(imgDim(:,3),i);
                    extractions(1).range.number = [1 i];
                    extractions(1).number = extractions(1).range.number(2)-extractions(1).range.number(1)+1;
                    extractions(1).range.coordinates = [floor(imgDim(:,1)/2) -floor(imgDim(:,1)/2)];
                    % %%               

                    % Segunda extracção
                    extractions(2).features = 0;
                    [mate2, extractions(2).coordinates, numIntersectedCorners] = cornerSim.cornerGen2(imgDim(:,3),extractions(1).coordinates,v,rP,trans(a,:),ag(a));
                    extractions(2).range.number = [1 length(extractions(2).coordinates)];
                    extractions(2).number = extractions(2).range.number(2)-extractions(2).range.number(1)+1;
                    extractions(2).range.coordinates = [floor(imgDim(:,1)/2) -floor(imgDim(:,1)/2)];
                    % %%


                    clear cornersSig
                    clear matches

                    % Criação das assinaturas
                    cornersSig(1) = sig.create(extractions(1));
                    img1 = cornerSim.coordintesToImg(imgDim(:,1), extractions(1).coordinates);

                    cornersSig(2) = sig.create(extractions(2));
                    img2 = cornerSim.coordintesToImg(imgDim(:,1), extractions(2).coordinates);
                    % %%

                    compare.requestedMatches = i;
                    compare.matchingDiferences = cmd;

                    % Criação dos matches
                    matches = matching.compareSigs(cornersSig(1:2), compare);

                    time(sim)=toc;

                    close all
                    [correctMatches,missingMatches,misMatches,cornerCmp] = matching.cornerComparation(mate2, matches.mate2);                

                    message = [int2str(sim) ':' ' corners=' int2str(i) ' transf=[' num2str(trans(a,1)) ' ' num2str(trans(a,2)) ' ' num2str(angle(a)) '] : ' 'rP=' num2str(rP) ' v=' num2str(v) ' : cmd='  num2str(cmd) ' cmp=[' int2str(cornerCmp(1)) ' ' int2str(cornerCmp(2)) ' ' int2str(cornerCmp(3)) '] : correctMatches=[' int2str(correctMatches(1)) ' ' int2str(correctMatches(2)) ' ' int2str(correctMatches(3)) ' ' int2str(correctMatches(4)) '] in ' num2str(time(sim)) ' seconds \n'];
                    save(['Data/data ' int2str(sim)]);
                    fprintf(message);                
                end
                                
            end
        end
    end
    
    
end

% [cornerCmp] = interf.showMatching(img1,img2,imgDim,mate2,matches,extractions);
%
% interf.showCornersSigs(cornersSig,matches,fullMatches)
%
% numCorners1
% repeatedCorners = repeatabilityPic/100 * numCorners1
% variationCorners = variation/ 100 * numCorners1
% cornerCmp


