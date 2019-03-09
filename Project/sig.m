classdef sig
    
    methods (Static)
        
        % cornersSig.distances é um vetor em que cada elemento representa a assinatura de cada
        % canto. Elementos esses que contêm as distâncias aos outros cantos
        function cornersSig = create(extractions, compare)
            cornersSig.range = extractions.range;
            cornersSig.number = extractions.number;
            cornersSig.features = extractions.features;            

            lenArray = length(extractions.coordinates);
            rangeArray = 1:lenArray;            
            
            cornersSig.c(rangeArray) = struct('dists',zeros(1,lenArray),'ag',zeros(1,lenArray),'neighbours',zeros(1,2),'neighboursAngle',0);
            
            for i1 = rangeArray(1:lenArray-1)
                for i2 = rangeArray(i1+1:lenArray)
                    complexDist = complex(extractions.coordinates(1,i2) - extractions.coordinates(1,i1), extractions.coordinates(2,i2) - extractions.coordinates(2,i1));
                    dist = abs(complexDist);
                    cornersSig.c(i1).dists(i2) = dist;
                    cornersSig.c(i1).ag(i2) = angle(complexDist);
                    cornersSig.c(i2).dists(i1) = dist;
                    cornersSig.c(i2).ag(i1) = angle(-complexDist);
                end
            end
            
            % sort
            for i = rangeArray
                [dists, sortedIdx] = sort(cornersSig.c(i).dists);
                acceptedIdx = sortedIdx(dists>compare.acceptedNeighbourhood);
                
                cornersSig.c(i).neighboursAngle = zeros(1,compare.numberOfAngles);
                cornersSig.c(i).neighboursDists = zeros(2,compare.numberOfAngles);
                cornersSig.c(i).neighbours = zeros(2,compare.numberOfAngles);
                
                for j = 1:compare.numberOfAngles
                    agIt = 2*j;
                    % calculo do angulo de 2 em relação a 1
                    ag = cornersSig.c(i).ag(acceptedIdx(agIt)) - cornersSig.c(i).ag(acceptedIdx(agIt-1));
                    if ag > pi() % angulo calculado pela volta maior (foi positiva)
                        ag = ag - 2*pi(); % normalizar
                    elseif ag < -pi() % angulo calculado pela volta maior (foi negativa)
                        ag = 2*pi() + ag; % normalizar
                    end
                    
                    if ag > 0
                        cornersSig.c(i).neighbours(:,j) = acceptedIdx([agIt-1 ; agIt]); % se ag positivo então 1 é o primeiro e 2 é o segundo
                    else
                        cornersSig.c(i).neighbours(:,j) = acceptedIdx([agIt ; agIt-1]); % caso contrario
                        ag = -ag; % angulo entre 1 e 2 é sempre positivo
                    end
                    
                    cornersSig.c(i).neighboursAngle(j) = ag;
                    cornersSig.c(i).neighboursDists(:,j) = [cornersSig.c(i).dists(cornersSig.c(i).neighbours(agIt-1)) cornersSig.c(i).dists(cornersSig.c(i).neighbours(agIt))];
                end
                
                cornersSig.c(i).cornerIdx = sortedIdx(2:end);
                cornersSig.c(i).dists = cornersSig.c(i).dists( cornersSig.c(i).cornerIdx );
            end
        end
        
        % Entradas
        % coordsIn -> [x1 x2 ... xn ; y1 y2 ... yn]
        % range.number -> [limite inferior ; limite superior]
        % range.coordinates -> [x1 x2 ; y1 y2]
        %
        % Saídas
        % coordsOut -> coordenadas filtradsa pelo range
        % rangePositions -> posição das coordenadas quando estavam em coordsIn
        function [coordsOut, rangePositions] = cornersFilter(coordsIn,range)
            coordsOut = zeros(2,range.number(2)-range.number(1)+1);
            coordsInLen = length(coordsIn);
            rangePositions = zeros(1,range.number(2)-range.number(1)+1);
            i=1;
            j=1;
            k=0;
            
            while i<=range.number(2) && j<=coordsInLen
                if coordsIn(1,j)<=range.coordinates(1,1) && coordsIn(1,j)>=range.coordinates(1,2) && coordsIn(2,j)<=range.coordinates(2,1) && coordsIn(2,j)>=range.coordinates(2,2)
                    if i>=range.number(1)
                        k = k+1;
                        coordsOut(:,k) = coordsIn(:,j);
                        rangePositions(k) = j;
                    end
                    i = i+1;
                end
                j = j+1;
            end
            coordsOut = coordsOut(:,1:k);
            rangePositions = rangePositions(1:k);
        end
        
    end
    
end