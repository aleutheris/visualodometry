classdef interf
    
    methods (Static)
        
        function [cornerCmp] = showMatchingComparison(img1,img2,imgDim,mate2Gen,mateCalc,extractions)
            separation = 13;
            imgConcGen(:,:,1) = [img1(:,:,1)    zeros(imgDim(1),separation) img2(:,:,1)];
            imgConcGen(:,:,2) = [img1(:,:,2)    zeros(imgDim(1),separation) img2(:,:,2)];
            imgConcGen(:,:,3) = [img1(:,:,3)    zeros(imgDim(1),separation) img2(:,:,3)];
            %imgConcMatches = imgConcGen;

%             imgConcGen = matching.drawViewMatches(imgConcGen, imgDim(:,1), separation, mate2, extractions, [127 0 127], true);   %Matching do gerador
%             imgConcMatches = matching.drawViewMatches(imgConcMatches, imgDim(:,1), separation, matches.mate2, extractions, [255 255 0], true);   %Matching calculado
            [cornerCmp, imgConcComparation] = matching.viewMatching(imgConcGen, imgDim, separation, mate2Gen, mateCalc, extractions, uint8([0 255 0 ; 127 127 127 ; 255 0 0 ]), true);  %Matching comparação
            
%             figure
%             imshow(imgConcGen)
%             title('Corner Generator Transformation')
%             figure
%             imshow(imgConcMatches)
%             title('Corner Matching')
            figure
            imshow(imgConcComparation)
            title('Corner Differences')
        end
        
        % Mostra apenas o matching calculado
        function [imgConcMatches] = showMatching(img1,img2,imgDim,mate2,extractions)            
            separation = 19;
            imgConcMatches(:,:,1) = [img1(:,:,1) zeros(imgDim(1),separation) img2(:,:,1)];
            imgConcMatches(:,:,2) = [img1(:,:,2) zeros(imgDim(1),separation) img2(:,:,2)];
            imgConcMatches(:,:,3) = [img1(:,:,3) zeros(imgDim(1),separation) img2(:,:,3)];
           
            imgConcMatches = matching.drawViewMatches(imgConcMatches, imgDim, separation, mate2, extractions, [0 255 255], true);   %Matching calculado
                        
%             figure
%             imshow(imgConcMatches)            
            %set(gcf,'units','normalized','outerposition',[0 0 1 1])
            %title('Corner Matching')
        end
        
        function [acceptedCorners,numSigsGraph] = showCornersSigs(cornersSig,matches,fullMatches)
                       
            range = fullMatches.mate2(cornersSig(1).range.number(1):cornersSig(1).range.number(2));           
            
            cycleArray = find(range)+cornersSig(1).range.number(1)-1;
            
            numSigsGraph = length(cycleArray);
            
            for i=cycleArray
                m2 = fullMatches.mate2(i);
                
                figure
                
                subplot(2,1,1)
                cornersInd1 = fullMatches.details(i,m2).pos>0; % Indices booleanos das posições dos cantos que fazem assinatura na imagem 1
                cornersInd2 = nonzeros(fullMatches.details(i,m2).pos); % Indices das posições dos cantos que fazem assinatura na imagem 2
                
                distances1 = cornersSig(1).c(i).dists(cornersInd1);
                distances2 = cornersSig(2).c(m2).dists(cornersInd2);
                
                xAxes = 1:length(distances1);
                
                plot(xAxes, distances1, 'bx');
                hold on
                plot(xAxes, distances2, 'ro');
                legend(['Corner ' int2str(i) ' of Pic1'],['Corner ' int2str(fullMatches.mate2(i)) ' of Pic2'],'Location','NorthWest')
                title(['Signatures (' int2str(fullMatches.cornerMatchesNum(i)) ' corner matches)'])
                ylabel('Distances')
                
                subplot(2,1,2)
                dif = abs(distances1-distances2);
                plot(xAxes, dif,'g');
                hold on
                plot(xAxes, dif,'rx');
                hold on
                plot(xAxes,fullMatches.details(i,m2).rejectDistLim*ones(1,length(xAxes)),'b--')
                if sum(matches.mate2==fullMatches.mate2(i))
                    title(['Average Differences = ' num2str(fullMatches.avgDifs(i),3) ' : Average Differences Limit = ' num2str(fullMatches.rejectMatchesLim,3)])
                else
                    title(['Average Differences = ' num2str(fullMatches.avgDifs(i),3) ' : Average Differences Limit = ' num2str(fullMatches.rejectMatchesLim,3) ' (CORNER REJECTED)'])
                end
                xlabel('Granted Corners')
                ylabel('Differences')
                
                c1 = find(matches.mate2);                
                acceptedCorners = zeros(2,length(c1));
                acceptedCorners(1,:) = c1;
                acceptedCorners(2,:) = nonzeros(matches.mate2(c1))';
            end
        end
        
        function [ background, imgResult ] = frame(background, patternDim, transformation, thick )
            if thick <= 2
                thick = 3;
            end
            
            percentage = NaN;
            
            fprintf('  Mapping frame... ')
            % Coordenadas cartesianas
            refCoords1(:,:,1) = kron(         -floor(patternDim(2)/2):1:floor(patternDim(2)/2)     , ones(patternDim(1),1) );
            refCoords1(:,:,2) = kron( flipud((-floor(patternDim(1)/2):1:floor(patternDim(1)/2))' ) , ones(1,patternDim(2)) ); 
            
            % Posição da imagem
            thick = floor(thick/2)*2+1;
            long = thick*6+1; 
            refCoordsMask11(1:thick, :, :) =          refCoords1( 1:thick, 1:patternDim(2), :); %linha superior
            refCoordsMask12(1:thick, :, :) =          refCoords1( patternDim(1)-(thick-1):patternDim(1), 1:patternDim(2), :); % linha inferior
            refCoordsMask13(1:thick, :, :) = permute( refCoords1( thick+1:patternDim(1)-thick, 1:thick, :), [2 1 3]); %linha esquerda
            refCoordsMask14(1:thick, :, :) = permute( refCoords1( thick+1:patternDim(1)-thick, patternDim(2)-thick+1:patternDim(2), :), [2 1 3]); %linha direita
            refCoordsMask15(1:thick, :, :) =          refCoords1( floor(patternDim(1)/2)-floor(thick/2):floor(patternDim(1)/2)+floor(thick/2), floor(patternDim(2)/2)-floor(long/2):floor(patternDim(2)/2)+floor(2*long/2), :); % linha horizontal
            refCoordsMask16(1:thick, :, :) = permute( refCoords1( floor(patternDim(1)/2)-floor(long/2):floor(patternDim(1)/2)+floor(long/2), floor(patternDim(2)/2)-floor(thick/2):floor(patternDim(2)/2)+floor(thick/2), :), [2 1 3]); % linha vertical

            refCoordsMask1 = [refCoordsMask11 refCoordsMask12 refCoordsMask13 refCoordsMask14 refCoordsMask15 refCoordsMask16];

            refCoords1 = permute(refCoords1, [3 2 1]);
            refCoordsMask1 = permute(refCoordsMask1, [3 2 1]);
            
            sizeRCM1 = size(refCoordsMask1);
            lenRCM1 = sizeRCM1(2)*sizeRCM1(3);            
            
            imgResult = uint8(zeros( patternDim(1,1), patternDim(2,1), 3 ));
            refCoordsMatrix2 = zeros(2, patternDim(1,1), patternDim(2,1));
            
            bgSize = size(background.orig);
            
            % Ciclo para buscar o frame
            i=1; 
            for r=1:patternDim(1)
                for c=1:patternDim(2)
                    rC2 = round( transformation * kin.transform2D_A( refCoords1(:,i), 0 ) ); % Coordenadas cartesianas da transformação
                    refCoords2 = rC2(1:2,3); % Coordenadas cartesianas da transformação
                    refCoordsMatrix2(:,i) = round( refConv.cartesianToMatrix(bgSize(1:2),refCoords2) ); % Coordenadas matriz da transformação                    
                    
                    try
                        imgResult(r,c,:) = background.orig( refCoordsMatrix2(1,i), refCoordsMatrix2(2,i), : ); % Busca a zona da imagem
                        %background.mapping(refCoordsMatrix2(1,i), refCoordsMatrix2(2,i), :) = background.orig(refCoordsMatrix2(1,i), refCoordsMatrix2(2,i), :);
                    catch me
                        warning('OUT OF MAP!');
                    end
                    i=i+1;
                end
                if mod(round(r/patternDim(1)*100),5)==0 && percentage ~= round(r/patternDim(1)*100)
                    percentage = round(r/patternDim(1)*100);
                    fprintf('%.0f%% ',r/patternDim(1)*100);
                end
            end
            refCoordsMaskMatrix2 = zeros(2,lenRCM1);
            
            fprintf('\n Drawing mask...\n')
            % Ciclo para mask 
            for i=1:lenRCM1
                rC2 = round( transformation * kin.transform2D_A( refCoordsMask1(:,i), 0 ) ); % Coordenadas cartesianas da transformação
                refCoords2 = rC2(1:2,3); % Coordenadas cartesianas da transformação
                refCoordsMaskMatrix2(:,i) = round( refConv.cartesianToMatrix(bgSize(1:2),refCoords2) ); % Coordenadas matriz da transformação
                background.mouseTrack( refCoordsMaskMatrix2(1,i), refCoordsMaskMatrix2(2,i), 1 ) = 255;
            end            
        end
        
        function map = mapping(map, frame, mapDim, frameDim, transformation )
            % Coordenadas cartesianas
            refCoords1(:,:,1) = kron(         -(frameDim(2)/2):1:floor(frameDim(2)/2)-1     , ones(frameDim(1),1) );
            refCoords1(:,:,2) = kron( flipud((-(frameDim(1)/2):1:floor(frameDim(1)/2)-1)' ) , ones(1,frameDim(2)) );
            
            refCoords1 = permute(refCoords1, [3 2 1]);
            
            refCoordsMaskMatrix2 = zeros(2,frameDim(1)*frameDim(2));
            
            i=1;
            for r=1:frameDim(1)
                for c=1:frameDim(2)
                    rC2 = round( transformation * kin.transform2D_A( refCoords1(:,i), 0 ) ); % Coordenadas cartesianas da transformação
                    refCoords2 = rC2(1:2,3); % Coordenadas cartesianas da transformação
                    refCoordsMaskMatrix2(:,i) = round( refConv.cartesianToMatrix(mapDim,refCoords2) ); % Coordenadas matriz da transformação                    
                    
                    map( refCoordsMaskMatrix2(1,i),refCoordsMaskMatrix2(2,i),: ) = frame(r,c,:);
                    
                    i=i+1;
                end
            end
            
%             limitMaxRow = max(refCoordsMaskMatrix2(1,:));
%             limitMinRow = min(refCoordsMaskMatrix2(1,:));
%             limitMaxColumn = max(refCoordsMaskMatrix2(2,:));
%             limitMinColumn = min(refCoordsMaskMatrix2(2,:));
%             
%             for r = limitMinRow:limitMaxRow
%                 for c = limitMinColumn:limitMaxColumn
%                     mapCC = round( refConv.matrixToCartesian(frameDim,[r c]) );
%                     mapCCoords = round( mapCC / transformation );
%                     
%                     
%                     
%                     if
%                         map(r,c,:) = frame();
%                     end
%                 end
%             end
            
        end
        
        % Desenha a trajet�ria das coordenadas coords em bg
        % bgDim -> dimens�o de bg
        % bg -> imagem background onde colocar a trajet�ria
        % positionCoords -> coordenas das posi��es da trajet�ria
        % colors -> cores do step e line, colors.step e colors.line exigido vetor de 3 posi��es em cada
        % thick -> espessura da cruz do step
        function [img, track] = drawTrack(bgDim, bg, positionCoords, colors, thick)
            sizeCoords = size(positionCoords);
            crossStandard = geometry.cross(thick);
            
            track(1:sizeCoords(2)) = struct('coords',struct('step',[],'stepIni',[],'line',[]));
            
            img.bw = uint8(zeros(bgDim(1),bgDim(2)));
            
            track(1).coords.stepIni(1,:) = crossStandard(1,:) + positionCoords(1,1);
            track(1).coords.stepIni(2,:) = crossStandard(2,:) + positionCoords(2,1);           
            
            img.bg = interf.drawCoords(bgDim, bg, track(1).coords, {'stepIni'}, colors); %desenha cruz
            img.bw = interf.drawCoords(bgDim, img.bw, track(1).coords, {'stepIni'}, colors); %desenha cruz
            for i=2:sizeCoords(2)
                track(i).coords.step(1,:) = crossStandard(1,:) + positionCoords(1,i);
                track(i).coords.step(2,:) = crossStandard(2,:) + positionCoords(2,i);
                
                track(i).coords.line = geometry.lineSimple([positionCoords(:,i-1) positionCoords(:,i)]); %constroi reta em coordenadas   
            
                img.bg = interf.drawCoords(bgDim, img.bg, track(i).coords, {'step','line'}, colors); %desenha reta
                img.bw = interf.drawCoords(bgDim, img.bw, track(i).coords, {'step','line'}, colors); %desenha reta
            end
        end
        
        % img -> imagem com 1 ou 3 canais
        % coords -> coordenas do que se quer marcar
        % 
        % color ->
        function img = drawCoords(imgDim, img, coords, fields, color)
            chanmelsType = length(size(img));            
            
            if chanmelsType == 2
            
                for i=1:numel(fields)
                    img( imgDim(1)*( coords.(fields{i})(2,:)-1 ) + coords.(fields{i})(1,:) ) = 255;
                end 
                
            elseif chanmelsType == 3
                
                for i=1:numel(fields)
                    img( imgDim(1)*( coords.(fields{i})(2,:)-1 ) + coords.(fields{i})(1,:) ) = color.(fields{i})(1); %permute(color.(fields{i}),[3 1 2]);                    
                    img( imgDim(1)*( coords.(fields{i})(2,:)-1 ) + coords.(fields{i})(1,:) + prod(imgDim)) = color.(fields{i})(2);
                    img( imgDim(1)*( coords.(fields{i})(2,:)-1 ) + coords.(fields{i})(1,:) + 2*prod(imgDim)) = color.(fields{i})(3);
                end
                
            end
        end
        
        
        %% Criar uma matriz imgDim [height width] com os pixeis das coordinates [x1 x2 ... xn ; y1 y2 ... yn] a 1
        function frame = coordintesToImg(frameDim, extractions, frame)
            len = length(extractions.coordinates(1,:));
                      
            switch ndims(frame)
                case 2
                    cornerColorP = 255;
                    cornerColorN = 255;
                case 3
                    cornerColorP = [255 0 0];
                    cornerColorN = [255 255 0];
            end
            
            for i=1:len
                coords = round(refConv.cartesianToMatrix(frameDim,extractions.coordinates(:,i)));
                
                switch extractions.features.colorThrSymmetry(i)
                    case 1
                        frame(coords(1),coords(2),:) = cornerColorN;
                    case 2
                        frame(coords(1),coords(2),:) = cornerColorP;
                end
            end
        end
        
        %% Criar uma matriz imgDim [height width] com os pixeis das coordinates [x1 x2 ... xn ; y1 y2 ... yn] a 1
        function frame = coordintesToImgGen(frameDim, extractions, frame)
            len = length(extractions.coordinates(1,:));
            
            for i=1:len
                coords = round(refConv.cartesianToMatrix(frameDim,extractions.coordinates(:,i)));
                frame(coords(1),coords(2),:) = [255 0 0];              
            end
        end
        
    end
end