classdef cornerSim
    
    methods (Static)
        
        % INPUT
        % 
        % OUTPUT
        % coordinates -> [x1 x2 ... xn ; y1 y2 ... yn]
        function [coordinates1] = cornerGen1(imgDim, numCorners)
            imgDim = imgDim - 6;
            if numCorners>imgDim(1) * imgDim(2)
                return;
            end

            coordinates1 = zeros(2, numCorners);

            for i = 1:numCorners
                x = round(rand(1) * (imgDim(2)-1) - (imgDim(2)-1) / 2);
                y = round(rand(1) * (imgDim(1)-1) - (imgDim(1)-1) / 2);

                while cornerSim.coordinatesCheck(coordinates1,[x;y]) > 0  %Enquanto x e y estiverem contidos em coordinates1 busca novos valores
                    x = round(rand(1) * (imgDim(2)-1) - (imgDim(2) - 1) / 2);
                    y = round(rand(1) * (imgDim(1)-1) - (imgDim(1) - 1) / 2);
                end

                coordinates1(:, i) = [x; y];
            end
        end        
        
        %% INPUT
        % imgDim1 -> [width height]
        % coordinates1 -> vetor de [x y]
        % variation -> varia????o de cantos da imagem 1 para a imagem 2
        % repeatabilityPic -> percentagem de repetibilidade por imagem
        % trans -> transla????o [x y]
        % angle -> anglo em radianos
        %
        % OUTPUT
        % mate2 -> matches corretos
        % coordinates2 -> vetor de coordenadas [x y] dos cantos da imagem 2
        % numRepeatedCorners -> numero de cantos repetidos
        
        function [mate2, coordinates2, numIntersectedCorners] = cornerGen2(imgDim1,coordinates1,numCorners2,numRepeatedCornersPic,trans,angle)
            imgDim1 = imgDim1 - 6;
            % range including values
            imgRange = [-fix(imgDim1(2)/2) fix(imgDim1(2)/2) ; -fix(imgDim1(1)/2) fix(imgDim1(1)/2)];
                        
            numCorners1 = length(coordinates1(1,:));
            
            if (numRepeatedCornersPic > numCorners1) || (numRepeatedCornersPic < 0)
                error('THE NUMBER OF REPEATED CORNERS ARE NOT POSSIBLE TO PROCESS!');
            end  
            
            %variation = numCorners1 * variation;
            %numCorners2 = numCorners1 + variation;
            numIntersectedCorners = 0;

            %numRepeatedCornersPic = numCorners1 * repeatabilityPic;

            if numRepeatedCornersPic > numCorners2
                error('NUMBER OF REPEATED CORNERS ABOVE NUMBER OF CORNERS IN PICTURES 1 PLUS VARIATION!');
            end

            coordinates2 = zeros(2,numCorners2);

            mate2 = zeros(1,numCorners1);
            auxCoordinates1 = coordinates1;
            auxCounter = numCorners1;

            % Igualar algumas coordenadas (de quantidade numRepeatedCornersPic) de coordinates2 a coordinates1
            for i = 1:numCorners1
                pos = round(rand(1)*(auxCounter-1)+1);    % Busca posi????o do vetor aleat??ria (entre 1 e auxCounter)                
                             
                cf_c2Coords = cornerSim.cornerFloorToCenter2(auxCoordinates1(:,pos),trans,angle); % coloca as coordenadas de imagem 1 transladada e rodada (invers??o de center2_center1)
                
                % se o ponto com as coordenadas da imagem 2 est?? dentro da imagem 1
                if (cf_c2Coords(1) >= imgRange(1,1) && cf_c2Coords(1) <= imgRange(1,2)) && (cf_c2Coords(2) >= imgRange(2,1) && cf_c2Coords(2) <= imgRange(2,2))
                    numIntersectedCorners = numIntersectedCorners+1;
                    coordinates2(:,numIntersectedCorners) = cf_c2Coords;
                    mate2(cornerSim.coordinatesCheck(coordinates1,auxCoordinates1(:,pos))) = numIntersectedCorners;
                end
                
                auxCoordinates1 = [auxCoordinates1(:,1:pos-1) auxCoordinates1(:,pos+1:auxCounter)]; % Retira elemento do vetor auxiliar
                auxCounter = auxCounter-1; % Decrementa o aux
                
                if numIntersectedCorners==numRepeatedCornersPic, break; end;    %Se o n??mero de cantos iguais nas duas imagens chegar ao suposto, sai do ciclo
            end

            % Preencher com mais cantos aleat??rios (de quantidade numCorners2-numRepeatedCornersPic+1)
            for i = numIntersectedCorners+1:numCorners2
                % Escolhe valores aleat??rios para x e y
                x = round(rand(1)*(imgDim1(2)-1) - (imgDim1(2)-1)/2);
                y = round(rand(1)*(imgDim1(1)-1) - (imgDim1(1)-1)/2);
    
                %Enquanto x e y existirem em coordinates2 ou em coordinates1 busca novos valores
                while cornerSim.coordinatesCheck(coordinates1,cornerSim.cornerFloorToCenter1([x;y],trans,angle))>0 || cornerSim.coordinatesCheck(coordinates2,[x;y])>0 
                    x = round(rand(1)*(imgDim1(2)-1) - (imgDim1(2)-1)/2);
                    y = round(rand(1)*(imgDim1(1)-1) - (imgDim1(1)-1)/2);
                end

                coordinates2(:,i) = [x;y];
            end
        end
        
        % Rela????o que coornerFloor tem com corner2, tendo em conta a transla????o trans e rota????o angle da imagem
        function cf_c2 = cornerFloorToCenter2(cf_c1Coords,trans,angle)
            cornerFloor_center1 = kin.translation2D(cf_c1Coords);
            center2_center1 = kin.transform2D_A(trans,angle);                
            cf_c2 = round(center2_center1 \ cornerFloor_center1);
            cf_c2 = cf_c2(1:2,3);
        end
        
        % Rela????o que coornerFloor tem com corner1, tendo em conta a
        % transla????o trans e rota????o angle da imagem
        function cf_c1 = cornerFloorToCenter1(cf_c2Coords,trans,angle)
            cornerFloor_center2 = kin.translation2D(cf_c2Coords);
            center2_center1 = kin.transform2D_A(trans,angle);                
            cf_c1 = round(center2_center1 * cornerFloor_center2);
            cf_c1 = cf_c1(1:2,3);
        end
                
        %% devolve a posi????o de coords em coordinates, ou 0 caso n??o exista
        function pos = coordinatesCheck(coordinates,coords)    
            for i = 1:length(coordinates)
                if coordinates(:,i) == coords
                    pos = i;     
                    return;
                end
            end
            pos = 0;
        end
        
        %% coordsOut ?? o vetor de coordenadas ordenado do vetor coordsIn da esquerda para a direita, debaixo para cima
        % odination -> 
        function [coordsOut, ordination] = ordinateCoordinates(coordsIn)            
            lenCoordsIn = length(coordsIn);
            coordsOut = zeros(2,lenCoordsIn);
            arrayOut = 1:lenCoordsIn-1;
            
            coordsInOriginal = coordsIn;
            
            ordination = zeros(1,lenCoordsIn);
            
            for i=arrayOut
                j=1;
                aux = coordsIn(:,j);
                auxArray = [coordsIn(:,1:j-1) coordsIn(:,j+1:lenCoordsIn)];
                My = max(auxArray(2,:));
                
                while not(aux(2)>My || (aux(2)==My && aux(1)<min(auxArray(1,auxArray(2,:)==My))))   % Condi????o de compara????o de aux e das outras coordenadas
                    j=j+1;
                    aux = coordsIn(:,j);
                    auxArray = [coordsIn(:,1:j-1) coordsIn(:,j+1:lenCoordsIn)];
                    My = max(auxArray(2,:));                    
                end
                coordsOut(:,i) = aux;
                coordsIn = auxArray;

                ordination( coordsInOriginal(1,:)==aux(1) & coordsInOriginal(2,:)==aux(2) ) = i;
                
                lenCoordsIn = lenCoordsIn-1;
            end
            
            coordsOut(:,i+1) = coordsIn;
            
            ordination( coordsInOriginal(1,:)==coordsIn(1) & coordsInOriginal(2,:)==coordsIn(2) ) = i+1;            
        end
        
        %% coordsOut ?? o vetor de coordenadas ordenado do vetor coordsIn da esquerda para a direita, debaixo para cima
        function [coordsOut1, coordsOut2, mate2Out] = ordinateCoordinatesBoth(coordsIn1, coordsIn2, mate2In)            
            [coordsOut1, ordination1] = cornerSim.ordinateCoordinates(coordsIn1);
            [coordsOut2, ordination2] = cornerSim.ordinateCoordinates(coordsIn2);          
            
            mate2Out = zeros(1,length(mate2In));          
            
            mate2Out(nonzeros(ordination1(mate2In>0))) = ordination2(nonzeros(mate2In));
        end
        
    end
    
end