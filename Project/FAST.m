classdef FAST
    
    methods (Static)
        
        function [f, extractions, recommendedThreshold, lastThreshold] = oneFrameController(frame, frameDim, recommendedThreshold, lastThreshold, extractions, FASTC)
            [minimumAllowed1, minimumSorted1, ~] = FAST.oneFrameAnalysis(extractions, FASTC.pixelPerimeter, FASTC.arcPixelRequired);
            
            filterIndices1 = minimumAllowed1<=lastThreshold;
            extractions = FAST.filter(extractions, filterIndices1);
            
            %não muito grave
            if extractions.number > FASTC.askedCornersNumber %se o numero de cantos extraidos for maior que askedCornersNumber
                recommendedThreshold = minimumSorted1(extractions.number-FASTC.askedCornersNumber+1); %recomendação para extrair askedCornersNumber número de cantos
                extractions = FAST.filter(extractions, minimumAllowed1>=recommendedThreshold); % filtra
                %mais grave!
            elseif extractions.number < FASTC.askedCornersNumber %se o numero de cantos extraidos for menor que askedCornersNumber
                recommendedThreshold = FAST.newThreshold(extractions.number, recommendedThreshold, FASTC.askedCornersNumber, FASTC.minCornersAllowed); % diminui-se o threshold de acordo com a função
            end
            
            lastThreshold = minimumSorted1(end);
            f = FAST.drawCorners(extractions, frameDim, frame);
        end
        
        function [f, extractions, recommendedThreshold] = twoFramesController(frame, frameDim, recommendedThreshold, extractions, FASTC)            
            [minimumAllowed1, minimumSorted1, ~] = FAST.oneFrameAnalysis(extractions(1), FASTC.pixelPerimeter, FASTC.arcPixelRequired);          
            [minimumAllowed2, minimumSorted2, ~] = FAST.oneFrameAnalysis(extractions(2), FASTC.pixelPerimeter, FASTC.arcPixelRequired);            
            
            if extractions(2).number > FASTC.askedCornersNumber %se o numero de cantos extraidos for maior que askedCornersNumber
                recommendedThreshold = minimumSorted2(extractions(2).number-FASTC.askedCornersNumber+1); %recomendação para extrair askedCornersNumber número de cantos
            elseif extractions(2).number < FASTC.askedCornersNumber %se o numero de cantos extraidos for menor que askedCornersNumber
                recommendedThreshold = FAST.newThreshold(extractions(2).number, recommendedThreshold, FASTC.askedCornersNumber, FASTC.minCornersAllowed); % altera-se o threshold de acordo com a função
            end                       

            
%             [modeThresholds1, freqThresholds1] = basic.modeSort(minimumAllowed1);
%             [modeThresholds2, freqThresholds2] = basic.modeSort(minimumAllowed2);
%             
%             idx2Pos1 = zeros(1,max([max(modeThresholds1) max(modeThresholds2)]));
%             idx2Pos2 = zeros(1,max([max(modeThresholds1) max(modeThresholds2)]));
%             
%             idx2Pos1(modeThresholds1) = 1:length(modeThresholds1);
%             idx2Pos2(modeThresholds2) = 1:length(modeThresholds2);
%             
%             bestThrshds = idx2Pos1 + idx2Pos2;
%             bestThrshds(bestThrshds==0) = Inf;
%             [~,idxBestThrs] = sort(bestThrshds);       
            
            rddColorThreshold1 = minimumSorted1(extractions(1).number-FASTC.usedCorners+1); %recomendação para usedCorners número de cantos
            rddColorThreshold2 = minimumSorted2(extractions(2).number-FASTC.usedCorners+1); %recomendação para usedCorners número de cantos                                           
                                  
            if rddColorThreshold1 <= rddColorThreshold2
                if minimumSorted1(end) <= minimumSorted2(end)                
                    filterIndices1 = minimumAllowed1 >= rddColorThreshold1;
                    filterIndices2 = minimumAllowed2 >= rddColorThreshold1 & minimumAllowed2 <= minimumSorted1(end);
                else
                    filterIndices1 = minimumAllowed1 >= rddColorThreshold1 & minimumAllowed1 <= minimumSorted2(end);
                    filterIndices2 = minimumAllowed2 >= rddColorThreshold1;
                end
            else
                if minimumSorted1(end) <= minimumSorted2(end)                
                    filterIndices1 = minimumAllowed1 >= rddColorThreshold2;
                    filterIndices2 = minimumAllowed2 >= rddColorThreshold2 & minimumAllowed2 <= minimumSorted1(end);
                else
                    filterIndices1 = minimumAllowed1 >= rddColorThreshold2 & minimumAllowed1 <= minimumSorted2(end);
                    filterIndices2 = minimumAllowed2 >= rddColorThreshold2;
                end
            end

%             filterIndexes = cornersSortedIdx(extractions.number-usedCornersMin+1:extractions.number);            
%             cornersSortedIdx1 = cornersSortedIdx1(minimumSorted1>=rddColorThreshold);
%             cornersSortedIdx2 = cornersSortedIdx2(minimumSorted2>=rddColorThreshold);      


%             cumfreqThresholds1 = cumsum(freqThresholds1);
%             cumfreqThresholds2 = cumsum(freqThresholds2);
%             
%             idxBestThrs = idxBestThrs(1: max([sum(cumfreqThresholds1<=FASTC.usedCorners) sum(cumfreqThresholds2<=FASTC.usedCorners)]) + 1);
%             
%             filterIndices1 = find( ismember(minimumAllowed1, idxBestThrs) );
%             filterIndices2 = find( ismember(minimumAllowed2, idxBestThrs) );
            
            extractions(1) = FAST.filter(extractions(1), filterIndices1);
            extractions(2) = FAST.filter(extractions(2), filterIndices2);
            
            f(1) = FAST.drawCorners(extractions(1), frameDim, frame(1));
            f(2) = FAST.drawCorners(extractions(2), frameDim, frame(2));            
        end      
        
        function out = newThreshold(givenCornersNumber, recommendedThreshold, askedCornersNumber, minCornersAllowed)
            if givenCornersNumber<=minCornersAllowed
                if recommendedThreshold > 12
                    out = recommendedThreshold - 12;
                else
                   out = 8; 
                end
                return;
            elseif givenCornersNumber<askedCornersNumber;
                out = round(recommendedThreshold - 1.1^(0.5*(askedCornersNumber-givenCornersNumber)));
                if out < 6
                    out = 6;
                end
                return;
            end
            out = recommendedThreshold;
        end
        
        function [frame] = drawCorners(extractions, frameDim, frame)
            frame.corners(:,:,1)=frame.gray;
            frame.corners(:,:,2)=frame.gray;
            frame.corners(:,:,3)=frame.gray;
            frame.corners = uint8(frame.corners);
            frame.corners = interf.coordintesToImg(frameDim, extractions, frame.corners);
            frame.bwcorners = uint8(zeros(frameDim(1), frameDim(2)));
            frame.bwcorners = interf.coordintesToImg(frameDim, extractions, frame.bwcorners);
        end        
        
        function [img, extractions] = collect9(img, imgDim, colorThreshold)
            pixelPerimeter = 16;
            arcPixelRequired = 9;
            pixelMargin = 3;
            idx=1;
            
            coordsSelect(1,:) = [-3 -3 -2 -1  0  1  2  3  3  3  2  1  0 -1 -2 -3];  %Linhas
            coordsSelect(2,:) = [ 0  1  2  3  3  3  2  1  0 -1 -2 -3 -3 -3 -2 -1];  %Colunas
            
            img.gray = int16(( uint16(img.orig(:,:,1)) + uint16(img.orig(:,:,2)) + uint16(img.orig(:,:,3)) )/3);
%             img.gray = rgb2gray(img.orig);
%             img.gray = histeq(img.gray,256);
            
            extractions.coordinates = zeros(2,50);
            extractions.features = struct('arcPixelsNumber',zeros(1,50),'arcPixelsColor',zeros(1,50));
            %extractions.features = struct('arcPixelNumber',zeros(1,pixelPerimeter),'arcPixelsColor',zeros(1,pixelPerimeter),'arcColorDiferences',zeros(1,pixelPerimeter));
            
            %             img.bwcorners = uint8(zeros(imgDim(1), imgDim(2)));
            
            % Colocar a imagem colorida, com 3 canais, a cinzento
            %             img.corners(:,:,1)=img.gray;
            %             img.corners(:,:,2)=img.gray;
            %             img.corners(:,:,3)=img.gray;
            
            rep=0;
            
            for r = 1+pixelMargin:imgDim(1)-pixelMargin                
                for c = 1+pixelMargin:imgDim(2)-pixelMargin
                    
                    colorThrSymmetry = 1;
                    if( (img.gray( r+coordsSelect(1,1), c+coordsSelect(2,1) ) - img.gray(r,c) ) >= colorThreshold ) %Pixel 1 TRUE
                        if( (img.gray( r+coordsSelect(1,9), c+coordsSelect(2,9)) - img.gray(r,c)) >= colorThreshold )   %Pixel 9 TRUE
                            if( (img.gray( r+coordsSelect(1,5), c+coordsSelect(2,5)) - img.gray(r,c) ) >= colorThreshold )  %Pixel 5 TRUE
                                if( (img.gray(r+coordsSelect(1,13),c+coordsSelect(2,13)) - img.gray(r,c)) >= colorThreshold ) %Pixel 13 TRUE
                                    
                                    %Testa 5
                                    [arcPixelNumber, arcPixelsColor, arcColorDiferences] = FAST.pixelChecker([r c],5,img.gray,pixelPerimeter,arcPixelRequired,coordsSelect,colorThreshold,colorThrSymmetry);
                                    if arcPixelNumber >= arcPixelRequired % verifica se � canto
                                        [extractions, img, idx] = FAST.treatFoundCorner(extractions, img, [r ; c], arcPixelNumber, arcPixelsColor, arcColorDiferences, colorThrSymmetry, idx);
                                    else
                                        %Testa 13
                                        [arcPixelNumber, arcPixelsColor, arcColorDiferences] = FAST.pixelChecker([r c],13,img.gray,pixelPerimeter,arcPixelRequired,coordsSelect,colorThreshold,colorThrSymmetry);
                                        if arcPixelNumber >= arcPixelRequired % verifica se � canto
                                            [extractions, img, idx] = FAST.treatFoundCorner(extractions, img, [r ; c], arcPixelNumber, arcPixelsColor, arcColorDiferences, colorThrSymmetry, idx);
                                        end
                                        
                                    end
                                    
                                else    %Pixel 13 FALSE
                                    
                                    %Testa 5
                                    [arcPixelNumber, arcPixelsColor, arcColorDiferences] = FAST.pixelChecker([r c],5,img.gray,pixelPerimeter,arcPixelRequired,coordsSelect,colorThreshold,colorThrSymmetry);
                                    if arcPixelNumber >= arcPixelRequired % verifica se � canto
                                        [extractions, img, idx] = FAST.treatFoundCorner(extractions, img, [r ; c], arcPixelNumber, arcPixelsColor, arcColorDiferences, colorThrSymmetry, idx);
                                    end
                                    
                                end
                                
                            else %Pixel 5 FALSE
                                
                                if( (img.gray(r+coordsSelect(1,13),c+coordsSelect(2,13)) - img.gray(r,c)) >= colorThreshold ) %Pixel 13 TRUE
                                    
                                    %Testa 13
                                    [arcPixelNumber, arcPixelsColor, arcColorDiferences] = FAST.pixelChecker([r c],13,img.gray,pixelPerimeter,arcPixelRequired,coordsSelect,colorThreshold,colorThrSymmetry);
                                    if arcPixelNumber >= arcPixelRequired % verifica se � canto
                                        [extractions, img, idx] = FAST.treatFoundCorner(extractions, img, [r ; c], arcPixelNumber, arcPixelsColor, arcColorDiferences, colorThrSymmetry, idx);
                                    end
                                    
                                end
                                
                            end
                            
                        else    %Pixel 9 FALSE
                            
                            %Testa 1
                            [arcPixelNumber, arcPixelsColor, arcColorDiferences] = FAST.pixelChecker([r c],1,img.gray,pixelPerimeter,arcPixelRequired,coordsSelect,colorThreshold,colorThrSymmetry);
                            if arcPixelNumber >= arcPixelRequired % verifica se � canto
                                [extractions, img, idx] = FAST.treatFoundCorner(extractions, img, [r ; c], arcPixelNumber, arcPixelsColor, arcColorDiferences, colorThrSymmetry, idx);
                            end
                            
                        end
                        
                    else
                        
                        if( (img.gray( r+coordsSelect(1,9), c+coordsSelect(2,9)) - img.gray(r,c)) >= colorThreshold )   %Pixel 9 TRUE
                            
                            %Testa 9
                            [arcPixelNumber, arcPixelsColor, arcColorDiferences] = FAST.pixelChecker([r c],9,img.gray,pixelPerimeter,arcPixelRequired,coordsSelect,colorThreshold,colorThrSymmetry);
                            if arcPixelNumber >= arcPixelRequired % verifica se � canto
                                [extractions, img, idx] = FAST.treatFoundCorner(extractions, img, [r ; c], arcPixelNumber, arcPixelsColor, arcColorDiferences, colorThrSymmetry, idx);
                            end
                            
                        end
                        
                    end
                    
                    
                    colorThrSymmetry = 2;
                    if( (img.gray(r,c) - img.gray( r+coordsSelect(1,1), c+coordsSelect(2,1) )) >= colorThreshold ) %Pixel 1 TRUE
                        if( (img.gray(r,c) - img.gray( r+coordsSelect(1,9), c+coordsSelect(2,9))) >= colorThreshold )   %Pixel 9 TRUE
                            if( (img.gray(r,c) - img.gray( r+coordsSelect(1,5), c+coordsSelect(2,5) )) >= colorThreshold )  %Pixel 5 TRUE
                                if( (img.gray(r,c) - img.gray( r+coordsSelect(1,13), c+coordsSelect(2,13) )) >= colorThreshold ) %Pixel 13 TRUE
                                    
                                    %Testa 5
                                    [arcPixelNumber, arcPixelsColor, arcColorDiferences] = FAST.pixelChecker([r c],5,img.gray,pixelPerimeter,arcPixelRequired,coordsSelect,colorThreshold,colorThrSymmetry);
                                    if arcPixelNumber >= arcPixelRequired % verifica se � canto
                                        [extractions, img, idx] = FAST.treatFoundCorner(extractions, img, [r ; c], arcPixelNumber, arcPixelsColor, arcColorDiferences, colorThrSymmetry, idx);
                                    else
                                        %Testa 13
                                        [arcPixelNumber, arcPixelsColor, arcColorDiferences] = FAST.pixelChecker([r c],13,img.gray,pixelPerimeter,arcPixelRequired,coordsSelect,colorThreshold,colorThrSymmetry);
                                        if arcPixelNumber >= arcPixelRequired % verifica se � canto
                                            [extractions, img, idx] = FAST.treatFoundCorner(extractions, img, [r ; c], arcPixelNumber, arcPixelsColor, arcColorDiferences, colorThrSymmetry, idx);
                                        end
                                        
                                    end
                                    
                                else    %Pixel 13 FALSE
                                    
                                    %Testa 5
                                    [arcPixelNumber, arcPixelsColor, arcColorDiferences] = FAST.pixelChecker([r c],5,img.gray,pixelPerimeter,arcPixelRequired,coordsSelect,colorThreshold,colorThrSymmetry);
                                    if arcPixelNumber >= arcPixelRequired % verifica se � canto
                                        [extractions, img, idx] = FAST.treatFoundCorner(extractions, img, [r ; c], arcPixelNumber, arcPixelsColor, arcColorDiferences, colorThrSymmetry, idx);
                                    end
                                    
                                end
                                
                            else %Pixel 5 FALSE
                                
                                if( (img.gray(r,c) - img.gray( r+coordsSelect(1,13), c+coordsSelect(2,13) )) >= colorThreshold ) %Pixel 13 TRUE
                                    
                                    %Testa 13
                                    [arcPixelNumber, arcPixelsColor, arcColorDiferences] = FAST.pixelChecker([r c],13,img.gray,pixelPerimeter,arcPixelRequired,coordsSelect,colorThreshold,colorThrSymmetry);
                                    if arcPixelNumber >= arcPixelRequired % verifica se � canto
                                        [extractions, img, idx] = FAST.treatFoundCorner(extractions, img, [r ; c], arcPixelNumber, arcPixelsColor, arcColorDiferences, colorThrSymmetry, idx);
                                    end
                                    
                                end
                                
                            end
                            
                        else    %Pixel 9 FALSE
                            
                            %Testa 1
                            [arcPixelNumber, arcPixelsColor, arcColorDiferences] = FAST.pixelChecker([r c],1,img.gray,pixelPerimeter,arcPixelRequired,coordsSelect,colorThreshold,colorThrSymmetry);
                            if arcPixelNumber >= arcPixelRequired % verifica se � canto
                                [extractions, img, idx] = FAST.treatFoundCorner(extractions, img, [r ; c], arcPixelNumber, arcPixelsColor, arcColorDiferences, colorThrSymmetry, idx);
                            end
                            
                        end
                        
                    else
                        
                        if( (img.gray(r,c) - img.gray( r+coordsSelect(1,9), c+coordsSelect(2,9) )) >= colorThreshold )   %Pixel 9 TRUE
                            
                            %Testa 9
                            [arcPixelNumber, arcPixelsColor, arcColorDiferences] = FAST.pixelChecker([r c],9,img.gray,pixelPerimeter,arcPixelRequired,coordsSelect,colorThreshold,colorThrSymmetry);
                            if arcPixelNumber >= arcPixelRequired % verifica se � canto
                                [extractions, img, idx] = FAST.treatFoundCorner(extractions, img, [r ; c], arcPixelNumber, arcPixelsColor, arcColorDiferences, colorThrSymmetry, idx);
                            end
                            
                        end
                        
                    end
                    
                    
                end
                
                if mod(round(r/(imgDim(1)-1)*100),5)==0 && rep~=round(r/(imgDim(1)-1)*100)
                    fprintf('%.0f%% ',r/(imgDim(1)-1)*100);
                    rep=round(r/(imgDim(1)-1)*100);
                end
            end
            fprintf('\n\n');
            
            % Treat extractions
            extractions.number = idx-1;
            if extractions.number == 0
                warning('NO CORNERS FOUND!');
            end
            extractions.coordinates = refConv.matrixToCartesian(imgDim, extractions.coordinates(:,1:extractions.number));
            extractions.features.arcPixelsNumber = extractions.features.arcPixelsNumber(1:extractions.number);
            extractions.features.arcPixelsColor = extractions.features.arcPixelsColor(:,1:extractions.number);
            
            img.gray = uint8(img.gray);
        end
        
        function [img, extractions] = collect12(img, imgDim, colorThreshold)
            pixelPerimeter = 16;
            arcPixelRequired = 12;
            pixelMargin = 3;
            idx=1;           
            
            coordsSelect(1,:) = [-3 -3 -2 -1  0  1  2  3  3  3  2  1  0 -1 -2 -3];  %Linhas
            coordsSelect(2,:) = [ 0  1  2  3  3  3  2  1  0 -1 -2 -3 -3 -3 -2 -1];  %Colunas           
            
            img.gray = int16(( uint16(img.orig(:,:,1)) + uint16(img.orig(:,:,2)) + uint16(img.orig(:,:,3)) )/3);
%             img.corners = img.orig;             
          
            extractions.coordinates = zeros(2,50);
            extractions.features = struct('arcPixelsNumber',zeros(1,50),'arcPixelsColor',zeros(1,50));
            %extractions.features = struct('arcPixelNumber',zeros(1,pixelPerimeter),'arcPixelsColor',zeros(1,pixelPerimeter),'arcColorDiferences',zeros(1,pixelPerimeter));
            
%             img.bwcorners = uint8(zeros(imgDim(1), imgDim(2)));
            
            % Colocar a imagem colorida, com 3 canais, a cinzento
%             img.corners(:,:,1)=img.gray;
%             img.corners(:,:,2)=img.gray;
%             img.corners(:,:,3)=img.gray;
            
            rep=0;
            
            for r = 1+pixelMargin:imgDim(1)-pixelMargin
                for c = 1+pixelMargin:imgDim(2)-pixelMargin                   
                                        
                    colorThrSymmetry = 1;
                    if( (img.gray( r+coordsSelect(1,1), c+coordsSelect(2,1) ) - img.gray(r,c) ) >= colorThreshold )    %Pixel 1 TRUE
                        if( (img.gray( r+coordsSelect(1,9), c+coordsSelect(2,9) ) - img.gray(r,c) ) >= colorThreshold )    %Pixel 9 TRUE
                            if( (img.gray( r+coordsSelect(1,5), c+coordsSelect(2,5)) - img.gray(r,c) ) >= colorThreshold )  %Pixel 5 TRUE
                                
                                %No caso em que é possível                                
                                [arcPixelNumber, arcPixelsColor, arcColorDiferences] = FAST.pixelChecker([r c],1,img.gray,pixelPerimeter,arcPixelRequired,coordsSelect,colorThreshold,colorThrSymmetry);
                                if arcPixelNumber >= arcPixelRequired % verifica se � canto
                                    [extractions, img, idx] = FAST.treatFoundCorner(extractions, img, [r ; c], arcPixelNumber, arcPixelsColor, arcColorDiferences, colorThrSymmetry, idx);
                                end
                                
                            else    %Pixel 5 FALSE
                                
                                if( (img.gray(r+coordsSelect(1,13),c+coordsSelect(2,13)) - img.gray(r,c)) >= colorThreshold ) %Pixel 13 TRUE
                                    
                                    %No caso em que é possível                                    
                                    [arcPixelNumber, arcPixelsColor, arcColorDiferences] = FAST.pixelChecker([r c],9,img.gray,pixelPerimeter,arcPixelRequired,coordsSelect,colorThreshold,colorThrSymmetry);
                                    if arcPixelNumber >= arcPixelRequired % verifica se � canto
                                        [extractions, img, idx] = FAST.treatFoundCorner(extractions, img, [r ; c], arcPixelNumber, arcPixelsColor, arcColorDiferences, colorThrSymmetry, idx);
                                    end
                                    
                                end
                                
                            end
                        else    %Pixel 9 FALSE
                            
                            if( (img.gray( r+coordsSelect(1,5), c+coordsSelect(2,5)) - img.gray(r,c)) >= colorThreshold ) %Pixel 5 TRUE
                                if( (img.gray( r+coordsSelect(1,13), c+coordsSelect(2,13)) - img.gray(r,c)) >= colorThreshold ) %Pixel 13 TRUE
                                    
                                    %No caso em que é possível                                    
                                    [arcPixelNumber, arcPixelsColor, arcColorDiferences] = FAST.pixelChecker([r c],13,img.gray,pixelPerimeter,arcPixelRequired,coordsSelect,colorThreshold,colorThrSymmetry);
                                    if arcPixelNumber >= arcPixelRequired % verifica se � canto
                                        [extractions, img, idx] = FAST.treatFoundCorner(extractions, img, [r ; c], arcPixelNumber, arcPixelsColor, arcColorDiferences, colorThrSymmetry, idx);
                                    end
                                    
                                end
                            end
                            
                        end
                    else    %Pixel 1 FALSE
                        
                        if( (img.gray( r+coordsSelect(1,9), c+coordsSelect(2,9)) - img.gray(r,c)) >= colorThreshold ) %Pixel 9 TRUE
                            if( (img.gray( r+coordsSelect(1,5), c+coordsSelect(2,5)) - img.gray(r,c)) >= colorThreshold ) %Pixel 5 TRUE
                                if( (img.gray( r+coordsSelect(1,13), c+coordsSelect(2,13)) - img.gray(r,c)) >= colorThreshold ) %Pixel 13 TRUE
                                    
                                    %No caso em que é possível                                    
                                    [arcPixelNumber, arcPixelsColor, arcColorDiferences] = FAST.pixelChecker([r c],5,img.gray,pixelPerimeter,arcPixelRequired,coordsSelect,colorThreshold,colorThrSymmetry);
                                    if arcPixelNumber >= arcPixelRequired % verifica se � canto
                                        [extractions, img, idx] = FAST.treatFoundCorner(extractions, img, [r ; c], arcPixelNumber, arcPixelsColor, arcColorDiferences, colorThrSymmetry, idx);
                                    end
                                    
                                end
                            end
                        end
                        
                    end                   
                    
                    
                    colorThrSymmetry = 2;
                    if( (img.gray(r,c) - img.gray( r+coordsSelect(1,1), c+coordsSelect(2,1)) ) >= colorThreshold )    %Pixel 1 TRUE
                        if( (img.gray(r,c) - img.gray( r+coordsSelect(1,9), c+coordsSelect(2,9)) ) >= colorThreshold )    %Pixel 9 TRUE
                            if( (img.gray(r,c) - img.gray( r+coordsSelect(1,5), c+coordsSelect(2,5)) ) >= colorThreshold )  %Pixel 5 TRUE
                                
                                %No caso em que é possível                                
                                [arcPixelNumber, arcPixelsColor, arcColorDiferences] = FAST.pixelChecker([r c],1,img.gray,pixelPerimeter,arcPixelRequired,coordsSelect,colorThreshold,colorThrSymmetry);
                                if arcPixelNumber >= arcPixelRequired % verifica se � canto
                                    [extractions, img, idx] = FAST.treatFoundCorner(extractions, img, [r ; c], arcPixelNumber, arcPixelsColor, arcColorDiferences, colorThrSymmetry, idx);
                                end
                                
                            else    %Pixel 5 FALSE
                                
                                if( (img.gray(r,c) - img.gray( r+coordsSelect(1,13), c+coordsSelect(2,13)) ) >= colorThreshold ) %Pixel 13 TRUE
                                    
                                    %No caso em que é possível                                    
                                    [arcPixelNumber, arcPixelsColor, arcColorDiferences] = FAST.pixelChecker([r c],9,img.gray,pixelPerimeter,arcPixelRequired,coordsSelect,colorThreshold,colorThrSymmetry);
                                    if arcPixelNumber >= arcPixelRequired % verifica se � canto
                                        [extractions, img, idx] = FAST.treatFoundCorner(extractions, img, [r ; c], arcPixelNumber, arcPixelsColor, arcColorDiferences, colorThrSymmetry, idx);
                                    end
                                    
                                end
                                
                            end
                        else    %Pixel 9 FALSE
                            
                            if( (img.gray(r,c) - img.gray( r+coordsSelect(1,5), c+coordsSelect(2,5)) ) >= colorThreshold ) %Pixel 5 TRUE
                                if( (img.gray(r,c) - img.gray( r+coordsSelect(1,13), c+coordsSelect(2,13)) ) >= colorThreshold ) %Pixel 13 TRUE
                                    
                                    %No caso em que é possível
                                    [arcPixelNumber, arcPixelsColor, arcColorDiferences] = FAST.pixelChecker([r c],13,img.gray,pixelPerimeter,arcPixelRequired,coordsSelect,colorThreshold,colorThrSymmetry);
                                    if arcPixelNumber >= arcPixelRequired % verifica se � canto
                                        [extractions, img, idx] = FAST.treatFoundCorner(extractions, img, [r ; c], arcPixelNumber, arcPixelsColor, arcColorDiferences, colorThrSymmetry, idx);
                                    end
                                    
                                end
                            end
                            
                        end
                    else    %Pixel 1 FALSE
                        
                        if( (img.gray(r,c) - img.gray( r+coordsSelect(1,9), c+coordsSelect(2,9)) ) >= colorThreshold ) %Pixel 9 TRUE
                            if( (img.gray(r,c) - img.gray( r+coordsSelect(1,5), c+coordsSelect(2,5)) ) >= colorThreshold ) %Pixel 5 TRUE
                                if( (img.gray(r,c) - img.gray( r+coordsSelect(1,13), c+coordsSelect(2,13)) ) >= colorThreshold ) %Pixel 13 TRUE
                                    
                                    %No caso em que é possível
                                    [arcPixelNumber, arcPixelsColor, arcColorDiferences] = FAST.pixelChecker([r c],5,img.gray,pixelPerimeter,arcPixelRequired,coordsSelect,colorThreshold,colorThrSymmetry);
                                    if arcPixelNumber >= arcPixelRequired % verifica se � canto
                                        [extractions, img, idx] = FAST.treatFoundCorner(extractions, img, [r ; c], arcPixelNumber, arcPixelsColor, arcColorDiferences, colorThrSymmetry, idx);
                                    end
                                    
                                end
                            end
                        end
                        
                    end
                    
                    
                end
                
                if mod(round(r/(imgDim(1)-1)*100),5)==0 && rep~=round(r/(imgDim(1)-1)*100)
                    fprintf('%.0f%% ',r/(imgDim(1)-1)*100);
                    rep=round(r/(imgDim(1)-1)*100);
                end
            end
            fprintf('\n\n');
            
            % Remover a posição 1
            extractions.number = idx-1;
            if extractions.number == 1
                warning('NO CORNERS FOUND!');
            end
            extractions.coordinates = refConv.matrixToCartesian(imgDim, extractions.coordinates(:,1:extractions.number));
            extractions.features.arcPixelsNumber = extractions.features.arcPixelsNumber(1:extractions.number);
            extractions.features.arcPixelsColor = extractions.features.arcPixelsColor(:,1:extractions.number);
            
            img.gray = uint8(img.gray);
        end
        
        % Adiciona todas as extractions do canto nas coordenadas (r,c) ao
        % extractions e coloca os cantos em imgGrayFAST e imgFAST
        function [extractions, img, idx] = treatFoundCorner(extractions, img, cornerCoord, arcPixelsNumber, arcPixelsColor, arcColorDiferences, colorThrSymmetry, idx)
            extractions.coordinates(:,idx) = cornerCoord;
            extractions.features.arcPixelsNumber(idx) = arcPixelsNumber;
            extractions.features.arcPixelsColor(idx) = arcPixelsColor;
            extractions.features.arcColorDiferences(:,idx) = arcColorDiferences;
            extractions.features.colorThrSymmetry(idx) = colorThrSymmetry;
            
%             img.corners(cornerCoord(1),cornerCoord(2),1)=255;
%             img.corners(cornerCoord(1),cornerCoord(2),2)=0;
%             img.corners(cornerCoord(1),cornerCoord(2),3)=0;
%             
%             img.bwcorners(cornerCoord(1),cornerCoord(2)) = 255;
            idx=idx+1;
        end
        
        function [arcPixelNumber, arcPixelsColor, arcColorDiferences] = pixelChecker(pixelMainCoords, pixelCheck, img, pixelPerimeter, arcPixelRequired, coordsSelect, colorThreshold, colorThrSymmetry)
            arcPixelNumber = 0;
            centerPixelColor = img(pixelMainCoords(1), pixelMainCoords(2));
            pixelCheckIni = pixelCheck;
            pixelCheckIt = pixelCheck;
            arcPixelsColor = 0;
            arcColorDiferences = zeros(pixelPerimeter,1);
            
            r = pixelMainCoords(1) + coordsSelect(1, pixelCheckIt);   %Pixel inicial
            c = pixelMainCoords(2) + coordsSelect(2, pixelCheckIt);
            
            
            switch colorThrSymmetry
                
                case 1
                    
                    dif = img(r,c) - centerPixelColor;   %Diferença entre o pixel inicial e o pixel em análise (pixelMainCurr)
                    
                    %Contagem em sentido horário
                    while (dif >= colorThreshold)
                        if arcPixelNumber >= pixelPerimeter; return; end;
                        arcPixelNumber = arcPixelNumber + 1;
                        arcColorDiferences(arcPixelNumber) = dif;
                        arcPixelsColor = arcPixelsColor + img(r,c);
                        pixelCheckIt = FAST.increment(pixelCheckIt,pixelPerimeter);
                        r = pixelMainCoords(1) + coordsSelect(1, pixelCheckIt);
                        c = pixelMainCoords(2) + coordsSelect(2, pixelCheckIt);
                        dif = img(r,c) - centerPixelColor;
                    end
                    
                    arcColorDiferences(1:arcPixelNumber) = arcColorDiferences(arcPixelNumber:-1:1);
                    
                    pixelCheckIt = FAST.decrement(pixelCheckIni,pixelPerimeter);   %Coloca o pixelCheck depois (em anti-horário) do pixelCheck inicial
                    
                    r = pixelMainCoords(1) + coordsSelect(1, pixelCheckIt);
                    c = pixelMainCoords(2) + coordsSelect(2, pixelCheckIt);
                    dif = img(r,c) - centerPixelColor;
                    
                    %Contagem em sentido anti-horário
                    while (dif >= colorThreshold)
                        if arcPixelNumber >= pixelPerimeter; return; end;
                        arcPixelNumber = arcPixelNumber + 1;
                        arcColorDiferences(arcPixelNumber) = dif;
                        arcPixelsColor = arcPixelsColor + img(r,c);
                        pixelCheckIt = FAST.decrement(pixelCheckIt,pixelPerimeter);
                        r = pixelMainCoords(1) + coordsSelect(1, pixelCheckIt);
                        c = pixelMainCoords(2) + coordsSelect(2, pixelCheckIt);
                        dif = img(r,c) - centerPixelColor;
                    end
                    
                    
                    % for controling
                    if arcPixelNumber>=arcPixelRequired                     
                        restArc = arcPixelNumber+1;

                        while restArc <= pixelPerimeter
                            arcColorDiferences(restArc) = dif;
                            %arcPixelsColor = arcPixelsColor + img(r,c);
                            pixelCheckIt = FAST.decrement(pixelCheckIt,pixelPerimeter);
                            r = pixelMainCoords(1) + coordsSelect(1, pixelCheckIt);
                            c = pixelMainCoords(2) + coordsSelect(2, pixelCheckIt);
                            dif = img(r,c) - centerPixelColor;

                            restArc = restArc+1;
                        end                        
                    end
                    
                    
                case 2
                    
                    dif = centerPixelColor - img(r,c);   %Diferença entre o pixel inicial e o pixel em análise (pixelMainCurr)
                    
                    %Contagem em sentido horário
                    while (dif >= colorThreshold)
                        if arcPixelNumber >= pixelPerimeter; return; end;
                        arcPixelNumber = arcPixelNumber + 1;
                        arcColorDiferences(arcPixelNumber) = dif;
                        arcPixelsColor = arcPixelsColor + img(r,c);
                        pixelCheckIt = FAST.increment(pixelCheckIt,pixelPerimeter);
                        r = pixelMainCoords(1) + coordsSelect(1, pixelCheckIt);
                        c = pixelMainCoords(2) + coordsSelect(2, pixelCheckIt);
                        dif = centerPixelColor - img(r,c);
                    end
                    
                    arcColorDiferences(1:arcPixelNumber) = arcColorDiferences(arcPixelNumber:-1:1);
                    
                    pixelCheckIt = FAST.decrement(pixelCheckIni,pixelPerimeter);   %Coloca o pixelCheck depois (em anti-horário) do pixelCheck inicial
                    
                    r = pixelMainCoords(1) + coordsSelect(1, pixelCheckIt);
                    c = pixelMainCoords(2) + coordsSelect(2, pixelCheckIt);
                    dif = centerPixelColor - img(r,c);
                    
                    %Contagem em sentido anti-horário
                    while (dif >= colorThreshold)
                        if arcPixelNumber >= pixelPerimeter; return; end;
                        arcPixelNumber = arcPixelNumber + 1;
                        arcColorDiferences(arcPixelNumber) = dif;
                        arcPixelsColor = arcPixelsColor + img(r,c);
                        pixelCheckIt = FAST.decrement(pixelCheckIt,pixelPerimeter);
                        r = pixelMainCoords(1) + coordsSelect(1, pixelCheckIt);
                        c = pixelMainCoords(2) + coordsSelect(2, pixelCheckIt);
                        dif = centerPixelColor - img(r,c);
                    end
                    
                    
                    % for controling
                    if arcPixelNumber>=arcPixelRequired  
                        restArc = arcPixelNumber+1;

                        while restArc <= pixelPerimeter

                            arcColorDiferences(restArc) = dif;
                            %arcPixelsColor = arcPixelsColor + img(r,c);
                            pixelCheckIt = FAST.decrement(pixelCheckIt,pixelPerimeter);
                            r = pixelMainCoords(1) + coordsSelect(1, pixelCheckIt);
                            c = pixelMainCoords(2) + coordsSelect(2, pixelCheckIt);
                            dif = centerPixelColor - img(r,c);

                            restArc = restArc+1;
                        end 
                    end
                    
            end
        end        
        
        function inc = increment(num,range)
            if num==range, inc=1; return; end;
            if num<range && num>=0, inc=num+1; return; end;
        end        
                
        function dec = decrement(num,range)
            if num==1, dec=range; return; end;
            if num<=range && num>0, dec=num-1; return; end;          
        end
        
        function [minimumAllowed, mininumSorted, cornersSortedIdx] = oneFrameAnalysis(extractions, pixelPerimeter, arcPixelRequired)           
            minimums = zeros(pixelPerimeter,extractions.number);
            idxPossibilities = zeros(arcPixelRequired,pixelPerimeter);            
            
            % FAZER COM DISTANCIAS MINIMAS E MAXIMAS
            limSup=arcPixelRequired;
            for limInf=1:pixelPerimeter
                idxPossibilities(:,limInf) = FAST.indexesRange(limInf,limSup,arcPixelRequired,pixelPerimeter);
                limSup = FAST.increment(limSup,pixelPerimeter);
            end
            %
            
            for i=1:extractions.number
                for j=1:pixelPerimeter;
                    minimums(j,i) = min(extractions.features.arcColorDiferences(idxPossibilities(:,j),i));
                end
            end
            
            minimumAllowed = max(minimums);            
            [mininumSorted,cornersSortedIdx] = sort(minimumAllowed);
        end
        
        % filtragem de cantos
        function [extractions] = filter(extractions, filterIndexes)            
            %filtragem para usedCornersMin número de cantos
            extractions.coordinates = extractions.coordinates(:,filterIndexes);
            extractions.features.colorThrSymmetry = extractions.features.colorThrSymmetry(filterIndexes);
%             extractions.features.arcPixelsNumber = extractions.features.arcPixelsNumber(filterIndexes);
%             extractions.features.arcPixelsColor = extractions.features.arcPixelsColor(filterIndexes);
%             extractions.features.arcColorDiferences = extractions.features.arcColorDiferences(:,filterIndexes);
            extractions.number = sum(filterIndexes);
        end       
        
        function indexes = indexesRange(limInf,limSup,idxSize,arrayRange)
            indexes = zeros(idxSize,1);
            i=limInf;
            j=1;
            
            while i~=limSup
                indexes(j) = i;
                i = FAST.increment(i,arrayRange);
                j=j+1;
            end
            indexes(j) = i;
        end
    end
end