classdef matching
    
    % LINES COMMENTED OUT AFTER THESIS
    % 302 340 378 416    
    
    
    methods (Static)
        
%         % Adiciona dist??ncia dist ao vetor v, ordenadamente
%         function v = addDistance(v, dist)
%             len = length(v);
%             
%             if dist==0   % Se v est?? vazio
%                 return;
%             elseif len==1   % Se v tem apenas um elemento
%                 if v==0
%                     v = dist;
%                 elseif v>=dist  % Se a primeira posi????o de v for maior que dist
%                     v = [dist v];
%                 else %Caso contr??rio
%                     v = [v dist];
%                 end
%             else
%                 for i=1:len
%                     if v(i)>=dist
%                         v = [v(1:i-1) dist v(i:len)];
%                         return;
%                     elseif i==len
%                         v = [v(1:len) dist];
%                         return;
%                     end
%                 end
%             end
%         end
        
        % Devolve a posi????o de cornerDists mais pr??xima de num, sendo k a
        % posi????o que se ache mais prov??vel de se encontrar
        % cornerDists T??M DE TER AS DIST??NCIAS POR ORDEM CRESCENTE
        function [pos, content] = closestDistance(cornerDists,num,k)
            len = length(cornerDists);
            
            %             cornerDists = abs(cornerDists);
            %             num = abs(num);
            
            if len==1, pos = 1; content = cornerDists(pos); return; end
            
            if abs(num-cornerDists(len)) <= abs(num-cornerDists(len-1))  % se num estiver mais perto do valor da posi????o final de cornerDists
                pos = len;
            elseif abs(num-cornerDists(1)) < abs(num-cornerDists(2))
                pos = 1;
            else
                % Para comparar novamente com os ultimos valores de cornerDists
                if k>(len-2)
                    k=len-2;
                elseif k==1 || k==2
                    k=3;
                end
                %
                
                n=k-1;
                ni=n;
                
                difB = abs(num-cornerDists(k));
                k=k+1;
                difA = abs(num-cornerDists(k));
                
                % enquanto a (distancia do numero ?? posi????o mais pr??xima) for
                % maior que a (distancia do numero da posi????o seguinte)
                while difB > difA
                    difB = difA;
                    k=k+1;
                    difA = abs(num-cornerDists(k));
                end
                
                difA = abs(num-cornerDists(n));
                
                while difB > difA
                    difB = difA;
                    n=n-1;
                    difA = abs(num-cornerDists(n));
                end
                
                if ni==n
                    pos = k-1;
                else
                    pos = n+1;
                end
                
            end
            content = cornerDists(pos);
        end
        
        % Compara????o feita entre distances1 e distances2
%         function [distancesRelation] = compareDistances(distances1, distances2, matchingDiferences)
%              distancesRelation = struct('pos',[],'dif',[],'avgDif',Inf);
%              x = xcorr(distances1,distances2);
%              len = length(x);            
%              
%              distancesRelation.avgDif = mean(abs(x(1:floor(len/2))-x(len:-1:ceil(len/2)+1)));
%         end
            
        % Compara????o feita entre distances1 e distances2
        function [distancesRelation] = compareDistances(distances1, distances2, compare)
            numCorners1 = length(distances1);
            numCorners2 = length(distances2);
                        
            distancesRelation.pos = zeros(1,min(numCorners1,numCorners2));
            distancesRelation.dif = zeros(1,min(numCorners1,numCorners2));
            
            [posCurrent,~] = matching.closestDistance(distances2,distances1(1),1);
            distancesRelation.pos(1) = posCurrent;
            distancesRelation.dif(1) = abs(distances1(1)-distances2(posCurrent));           
            
            % i -> distances1
            % posPos -> pos e distances1
            % posCurrent -> distances2
            for i = 2:numCorners1
                [posCurrent,~] = matching.closestDistance(distances2,distances1(i),i);
                
                posPos = basic.thereIsNumber(distancesRelation.pos,posCurrent);
                while posPos>0; % Ver se a posi????o posCurrent j?? foi registada
                    if abs(distances1(i)-distances2(posCurrent)) < abs(distances1(posPos)-distances2(posCurrent))  % Compara????o de distancias
                        distancesRelation.pos(posPos) = 0;
                        distancesRelation.dif(posPos) = 0;
                    elseif posCurrent==numCorners2; %Verificar se j??? chegou ao final do distances2
                        difNonzeros = distancesRelation.pos>0;
                        
                        avgDif = mean(distancesRelation.dif(difNonzeros));
                        goodCorners = not(distancesRelation.dif > avgDif * compare.distanceFilterProp);
                        
                        distancesRelation.pos1 = goodCorners & difNonzeros;
                        
                        distancesRelation.dif = distancesRelation.dif(distancesRelation.pos1);
                        distancesRelation.pos = distancesRelation.pos(distancesRelation.pos1);
                        
                        auxPos(distancesRelation.pos) = true(1,length(distancesRelation.pos)); % mudar os indices para logicos
                        distancesRelation.pos = auxPos;
                        
                        distancesRelation.dif = sort(distancesRelation.dif);    % ordenar e guarda dos elementos da ordem
                        
                        if length(distancesRelation.dif) < compare.matchingDiferences
                            distancesRelation.avgDif = Inf;
                            %distancesRelation.std = Inf;
                        else
                            distancesRelation.avgDif = mean(distancesRelation.dif(1:compare.matchingDiferences)); 
                            %distancesRelation.std = abs( std(distancesRelation.dif) );                           
                        end
                        
                        return;
                    else
                        posCurrent=posCurrent+1; % A posi??????o passa para pr???xima mais pr???xima
                    end
                    posPos = basic.thereIsNumber(distancesRelation.pos,posCurrent);
                end
                distancesRelation.pos(i) = posCurrent;
                distancesRelation.dif(i) = abs(distances1(i)-distances2(posCurrent));
            end
            
            % Chegou ao final do distances1            
            difNonzeros = distancesRelation.pos>0;
            
            avgDif = mean(distancesRelation.dif(difNonzeros));
            goodCorners = not(distancesRelation.dif > avgDif * compare.distanceFilterProp);
            
            distancesRelation.pos1 = goodCorners & difNonzeros;
            
            distancesRelation.dif = distancesRelation.dif(distancesRelation.pos1);
            distancesRelation.pos = distancesRelation.pos(distancesRelation.pos1);
            
            auxPos(distancesRelation.pos) = true(1,length(distancesRelation.pos)); % mudar os indices para logicos
            distancesRelation.pos = auxPos;
            
            distancesRelation.dif = sort(distancesRelation.dif);    % ordenar e guarda dos elementos da ordem
            
            if length(distancesRelation.dif) < compare.matchingDiferences
                distancesRelation.avgDif = Inf;
                %distancesRelation.std = Inf;
            else
                distancesRelation.avgDif = mean(distancesRelation.dif(1:compare.matchingDiferences));
                %distancesRelation.std = abs( std(distancesRelation.dif) );
            end
            
        end
        
        function [matches, aprovedCorners1, aprovedCorners2] = rejectCornerNoise(cornersSig, extractions, compare)
            len1 = cornersSig(1).range.number(2)-cornersSig(1).range.number(1)+1;
            len2 = cornersSig(2).range.number(2)-cornersSig(2).range.number(1)+1;
            
            range1 = cornersSig(1).range.number(1):cornersSig(1).range.number(2);
            range2 = cornersSig(2).range.number(1):cornersSig(2).range.number(2);           
                      
            matches.mate2 = zeros(1, cornersSig(1).range.number(2)-cornersSig(1).range.number(1)+1);
            
            matches.details(1:range1(end),1:range2(end)) = struct('pos',[],'dif',[],'pos1',[],'avgDif',Inf);
            
            analysisCorners1 = false(cornersSig(1).range.number(2)-cornersSig(1).range.number(1)); 
            analysisCorners2 = false(cornersSig(2).range.number(2)-cornersSig(2).range.number(1));
            
            indexes=zeros(2,range1(end)*range2(end));
            indexes(1,:) = kron(1:range1(end),ones([1 range2(end)]));
            indexes(2,:) = repmat(1:range2(end),1,range1(end));
            
            aprovedCorners1 = true(1,cornersSig(1).range.number(2)-cornersSig(1).range.number(1) +1);
            aprovedCorners2 = true(1,cornersSig(2).range.number(2)-cornersSig(2).range.number(1) +1);

            i = 0;
            counter = 0;
            counterAp = 0;
            
            while counterAp < 3
                i=i+1;
                
                i1 = indexes(1,i);
                i2 = indexes(2,i);
                
                [matches.details(i1,i2)] = matching.compareDistances(cornersSig(1).c(i1).dists, cornersSig(2).c(i2).dists, compare);
                
                if matches.details(i1,i2).avgDif ~= Inf
                    counter = counter + 1;
                    
                    idx1 = cornersSig(1).c(i1).cornerIdx(matches.details(i1,i2).pos1);
                    idx2 = cornersSig(2).c(i2).cornerIdx(matches.details(i1,i2).pos);
                    
                    analysisCorners1(counter,idx1) = true(1,length(idx1));
                    analysisCorners2(counter,idx2) = true(1,length(idx2));
                    
                    if counter > 1
                        [bestMatch1, bestMatchPos1, bestMatchQuality1] = matching.arrayBestMatch(analysisCorners1(1:counter-1,:), analysisCorners1(counter,:));
                        [bestMatch2, bestMatchPos2, bestMatchQuality2] = matching.arrayBestMatch(analysisCorners2(1:counter-1,:), analysisCorners2(counter,:));
                        
                        if bestMatchQuality1/(len1-1)>=compare.matchingDiferencesProp && bestMatchQuality2/(len2-1)>=compare.matchingDiferencesProp                   
                            aprovedCorners1 = aprovedCorners1 & analysisCorners1(counter,:);
                            aprovedCorners2 = aprovedCorners2 & analysisCorners2(counter,:);
                            
                            counterAp = counterAp + 1;
                            
                            matches.mate2(i1) = i2; 
                        end
                    end
                    
                end
%                 end
%                 
%                 if mod(round(i1/(cornersSig(1).range.number(2)-cornersSig(1).range.number(1)+1)*100),5)==0
%                     fprintf('%.0f%% ',i1/(cornersSig(1).range.number(2)-cornersSig(1).range.number(1)+1)*100);
%                 end
            end            
%             fprintf('\n');
%             
%             entryDistances = [matches.details.avgDif];% + [matches.details.std] + abs(entryACD)*0.1/25;
%             entryDistancesSorted = sort(entryDistances);
%             
%             [matesIdx,~] = algorithm.combinationMin(entryDistances, [cornersSig(1).range.number(2)-cornersSig(1).range.number(1)+1 cornersSig(2).range.number(2)-cornersSig(2).range.number(1)+1], compare.requestedMatches, Inf);                      
%             
%             matches.mate2(matesIdx(1, matesIdx(1,:)>0)) = matesIdx(2, matesIdx(2,:)>0);
%             matches.matchingQuality = entryDistancesSorted(1);
        end
        
        % Encontra a melhor correspond??ncia do array em db
        function [bestMatch, bestMatchPos, bestMatchQuality] = arrayBestMatch(DB, array)
            bestMatchQuality = 0;
            
            switch ndims(DB)
                case 2
                    len = 1;
                case 3  
                    len = length(DB(:,1));
            end
            
            for i=1:len
                match = DB(i,:) == array;
                matchQuality = sum(match);
                
                if matchQuality > bestMatchQuality
                    bestMatch = match;  
                    bestMatchPos = i;
                    bestMatchQuality = matchQuality;
                end                
            end            
        end
        
        % Devolve os n??meros dos cantos da imagem 2 correspondentes ?? imagem 1
        function [matches, aMatches] = compareSigs(cornersSig, extractions, compare, constraints)
            range1 = cornersSig(1).range.number(1) : cornersSig(1).range.number(2);
            range2 = cornersSig(2).range.number(1) : cornersSig(2).range.number(2);
            matches.mate2 = zeros(1, cornersSig(1).range.number(2) - cornersSig(1).range.number(1) + 1);           

            %aprovedMatches = zeros(2,compare.requestedMatches);
            
            percentage = NaN;            
            
            matches.details(1:range1(end), 1:range2(end)) = struct('pos',[],'dif',[],'pos1',[],'avgDif',Inf);
            
            indexes = zeros(2, range1(end) * range2(end));
            indexesArray = randperm(range1(end) * range2(end));
            indexes(1, :) = kron(1:range1(end), ones([1 range2(end)]));
            indexes(2, :) = repmat(1:range2(end), 1, range1(end));            
            
            counter = 0;
            
            switch constraints
                
                case 1
            
                    for i = 1:range1(end) * range2(end)
                        %if extractions(1).features.colorThrSymmetry(indexes(1, indexesArray(i))) == extractions(2).features.colorThrSymmetry(indexes(2, indexesArray(i)))
                            if abs(cornersSig(1).c( indexes(1,indexesArray(i)) ).neighboursAngle-cornersSig(2).c( indexes(2,indexesArray(i)) ).neighboursAngle) < compare.triangleAngleDiff
                                if sum( abs(cornersSig(1).c( indexes(1,indexesArray(i)) ).neighboursDists(:,1)-cornersSig(2).c( indexes(2,indexesArray(i)) ).neighboursDists(:,1)) ) < compare.triangleDistDiff
                                    %
                                    %  %if sum( aprovedMatches(1,:) == indexes(1,indexesArray(i)) )==0 && sum( aprovedMatches(2,:) == indexes(2,indexesArray(i)) )==0  %verifica se uma das coordenadas j?? foi usada para fazer matching
                                    matches.details(indexes(1,indexesArray(i)), indexes(2,indexesArray(i))) = matching.compareDistances( cornersSig(1).c( indexes(1,indexesArray(i)) ).dists, cornersSig(2).c( indexes(2,indexesArray(i)) ).dists, compare );
                                    %
                                    if matches.details(indexes(1,indexesArray(i)), indexes(2,indexesArray(i))).avgDif < 0.8
                                        counter = counter + 1;
                                        % % provedMatches(1,counter) = indexes(1,indexesArray(i));
                                        % % aprovedMatches(2,counter) = indexes(2,indexesArray(i));
                                        %
                                        % %matches.mate2(indexes(1,indexesArray(i))) = indexes(2,indexesArray(i));
                                        %
                                        if counter >= compare.firstPhaseMatches
                                            fprintf('\n');
                                            break;
                                        end
                                        
                                        if mod(round(i/(range1(end)*range2(end))*100),5)==0 && percentage ~= round(i/(range1(end)*range2(end))*100)
                                            percentage = round(i/(range1(end)*range2(end))*100);
                                            fprintf('%.0f%% ',percentage);
                                        end
                                        
                                    end
                                    % end
                                    %
                                end
                            end
                        %end
                        
                    end
                    fprintf('\n');
            
                    
                case 2
                    
                    for i = 1:range1(end) * range2(end)
                        %if extractions(1).features.colorThrSymmetry( indexes(1,indexesArray(i)) ) == extractions(2).features.colorThrSymmetry( indexes(2,indexesArray(i)) )
                            if abs(cornersSig(1).c( indexes(1,indexesArray(i)) ).neighboursAngle-cornersSig(2).c( indexes(2,indexesArray(i)) ).neighboursAngle) < compare.triangleAngleDiff
                                %if sum( abs(cornersSig(1).c( indexes(1,indexesArray(i)) ).neighboursDists(:,1)-cornersSig(2).c( indexes(2,indexesArray(i)) ).neighboursDists(:,1)) ) < compare.triangleDistDiff
                                %
                                %  %if sum( aprovedMatches(1,:) == indexes(1,indexesArray(i)) )==0 && sum( aprovedMatches(2,:) == indexes(2,indexesArray(i)) )==0  %verifica se uma das coordenadas j?? foi usada para fazer matching
                                matches.details(indexes(1,indexesArray(i)), indexes(2,indexesArray(i))) = matching.compareDistances( cornersSig(1).c( indexes(1,indexesArray(i)) ).dists, cornersSig(2).c( indexes(2,indexesArray(i)) ).dists, compare );
                                %
                                if matches.details(indexes(1,indexesArray(i)), indexes(2,indexesArray(i))).avgDif < 0.8
                                    counter = counter + 1;
                                    % % provedMatches(1,counter) = indexes(1,indexesArray(i));
                                    % % aprovedMatches(2,counter) = indexes(2,indexesArray(i));
                                    %
                                    % %matches.mate2(indexes(1,indexesArray(i))) = indexes(2,indexesArray(i));
                                    %
                                    if counter >= compare.firstPhaseMatches
                                        fprintf('\n');
                                        break;
                                    end
                                    
                                    if mod(round(i/(range1(end)*range2(end))*100),5)==0 && percentage ~= round(i/(range1(end)*range2(end))*100)
                                        percentage = round(i/(range1(end)*range2(end))*100);
                                        fprintf('%.0f%% ',percentage);
                                    end
                                    
                                end
                                % end
                                %
                                %end
                            end
                        %end
                        
                    end
                    fprintf('\n');
                    
                    
                case 3
                    
                    for i=1:range1(end)*range2(end)
                        %if extractions(1).features.colorThrSymmetry( indexes(1,indexesArray(i)) ) == extractions(2).features.colorThrSymmetry( indexes(2,indexesArray(i)) )
                            %if abs(cornersSig(1).c( indexes(1,indexesArray(i)) ).neighboursAngle-cornersSig(2).c( indexes(2,indexesArray(i)) ).neighboursAngle) < compare.triangleAngleDiff
                            %if sum( abs(cornersSig(1).c( indexes(1,indexesArray(i)) ).neighboursDists(:,1)-cornersSig(2).c( indexes(2,indexesArray(i)) ).neighboursDists(:,1)) ) < compare.triangleDistDiff
                            %
                            %  %if sum( aprovedMatches(1,:) == indexes(1,indexesArray(i)) )==0 && sum( aprovedMatches(2,:) == indexes(2,indexesArray(i)) )==0  %verifica se uma das coordenadas j?? foi usada para fazer matching
                            matches.details(indexes(1,indexesArray(i)), indexes(2,indexesArray(i))) = matching.compareDistances( cornersSig(1).c( indexes(1,indexesArray(i)) ).dists, cornersSig(2).c( indexes(2,indexesArray(i)) ).dists, compare );
                            %
                            if matches.details(indexes(1,indexesArray(i)), indexes(2,indexesArray(i))).avgDif < 0.8
                                counter = counter + 1;
                                % % provedMatches(1,counter) = indexes(1,indexesArray(i));
                                % % aprovedMatches(2,counter) = indexes(2,indexesArray(i));
                                %
                                % %matches.mate2(indexes(1,indexesArray(i))) = indexes(2,indexesArray(i));
                                %
                                if counter >= compare.firstPhaseMatches
                                    fprintf('\n');
                                    break;
                                end
                                
                                if mod(round(i/(range1(end)*range2(end))*100),5)==0 && percentage ~= round(i/(range1(end)*range2(end))*100)
                                    percentage = round(i/(range1(end)*range2(end))*100);
                                    fprintf('%.0f%% ',percentage);
                                end
                                
                            end
                            % end
                            %
                            %end
                            %end
                        %end
                        
                    end
                    fprintf('\n');
                    
                    
                case 4
                    
                     for i=1:range1(end)*range2(end)
                        %if extractions(1).features.colorThrSymmetry( indexes(1,indexesArray(i)) ) == extractions(2).features.colorThrSymmetry( indexes(2,indexesArray(i)) )
                            %if abs(cornersSig(1).c( indexes(1,indexesArray(i)) ).neighboursAngle-cornersSig(2).c( indexes(2,indexesArray(i)) ).neighboursAngle) < compare.triangleAngleDiff
                            %if sum( abs(cornersSig(1).c( indexes(1,indexesArray(i)) ).neighboursDists(:,1)-cornersSig(2).c( indexes(2,indexesArray(i)) ).neighboursDists(:,1)) ) < compare.triangleDistDiff
                            %
                            %  %if sum( aprovedMatches(1,:) == indexes(1,indexesArray(i)) )==0 && sum( aprovedMatches(2,:) == indexes(2,indexesArray(i)) )==0  %verifica se uma das coordenadas j?? foi usada para fazer matching
                            matches.details(indexes(1,indexesArray(i)), indexes(2,indexesArray(i))) = matching.compareDistances( cornersSig(1).c( indexes(1,indexesArray(i)) ).dists, cornersSig(2).c( indexes(2,indexesArray(i)) ).dists, compare );
                            %
                            %if matches.details(indexes(1,indexesArray(i)), indexes(2,indexesArray(i))).avgDif < 0.8
                                counter = counter + 1;
                                % % provedMatches(1,counter) = indexes(1,indexesArray(i));
                                % % aprovedMatches(2,counter) = indexes(2,indexesArray(i));
                                %
                                % %matches.mate2(indexes(1,indexesArray(i))) = indexes(2,indexesArray(i));
                                %
%                                 if counter >= compare.firstPhaseMatches
%                                     fprintf('\n');
%                                     break;
%                                 end
                                
                                if mod(round(i/(range1(end)*range2(end))*100),5)==0 && percentage ~= round(i/(range1(end)*range2(end))*100)
                                    percentage = round(i/(range1(end)*range2(end))*100);
                                    fprintf('%.0f%% ',percentage);
                                end
                                
                            %end
                            % end
                            %
                            %end
                            %end
                        %end
                        
                    end
                    fprintf('\n');
            end
            
            if counter == 0
                aMatches = 0;
                return;
                %error('NO MATCHES FOUND DUE TO TOO MUCH RESTRICTION!\n');
            end
            
            [matesIdx,~] = algorithm.combinationMin([matches.details.avgDif], [cornersSig(1).range.number(2)-cornersSig(1).range.number(1)+1 cornersSig(2).range.number(2)-cornersSig(2).range.number(1)+1], compare.secondPhaseMatches, Inf);                      
            
            matches.mate2(matesIdx(1, matesIdx(1,:)>0)) = matesIdx(2, matesIdx(2,:)>0);
            aMatches = sum(matches.mate2>0);
        end
        
        
        % Devolve os n??meros dos cantos da imagem 2 correspondentes ?? imagem 1
        function [matches] = compareSigsTesting(cornersSig, extractions, compare)            
            range1 = cornersSig(1).range.number(1):cornersSig(1).range.number(2);
            range2 = cornersSig(2).range.number(1):cornersSig(2).range.number(2);           
                      
            matches.mate2 = zeros(1, cornersSig(1).range.number(2)-cornersSig(1).range.number(1)+1);
            
            matches.details(1:range1(end),1:range2(end)) = struct('pos',[],'dif',[],'pos1',[],'avgDif',Inf);
            
            aprovedMatches = zeros(2, min(extractions(1).number, extractions(2).number));
            
            counter = 0;
            for i1=range1
                for i2=range2
                     if extractions(1).features.colorThrSymmetry( i1 ) == extractions(2).features.colorThrSymmetry( i2 )
                        if sum( aprovedMatches(1,:)==i1 & aprovedMatches(2,:)==i2 ) == 0 %verifica se as coordenadas j?? foram usadas
                            
                            nbAg = false(1,compare.numberOfAngles);
                            nbDists = false(1,compare.numberOfAngles);
                            
                            for a = 1:compare.numberOfAngles
                                nbAg(a) = abs(cornersSig(1).c(i1).neighboursAngle(a)-cornersSig(2).c(i2).neighboursAngle(a)) < compare.triangleAngleDiff;
                                nbDists(a) = sum( abs(cornersSig(1).c(i1).neighboursDists(:,1)-cornersSig(2).c(i2).neighboursDists(:,1)) ) < compare.triangleDistDiff;
                            end                            
                            
                            if sum(nbAg)==compare.numberOfAngles% && sum(nbDists)==compare.numberOfAngles
                                %principal
                                counter = counter + 1;
                                aprovedMatches(1,counter) = i1;
                                aprovedMatches(2,counter) = i2;
                                
                                %matches.mate2(i1) = i2;
                                [matches.details(i1,i2)] = matching.compareDistances(cornersSig(1).c(i1).dists, cornersSig(2).c(i2).dists, compare);
                                if matches.details(i1,i2).avgDif == Inf
                                    continue;
                                end
                                
                                % vizinho 1 do principal
                                counter = counter + 1;
                                aprovedMatches(1,counter) = cornersSig(1).c(i1).neighbours(1);
                                aprovedMatches(2,counter) = cornersSig(2).c(i2).neighbours(1);
                                
                                %matches.mate2(aprovedMatches(1,counter)) = aprovedMatches(2,counter);
                                [matches.details( aprovedMatches(1,counter), aprovedMatches(2,counter) )] = matching.compareDistances(cornersSig(1).c( aprovedMatches(1,counter) ).dists, cornersSig(2).c( aprovedMatches(2,counter) ).dists, compare);
                                if matches.details(i1,i2).avgDif == Inf
                                    continue;
                                end
                                
                                %vizinho 2 do principal
                                counter = counter + 1;
                                aprovedMatches(1,counter) = cornersSig(1).c(i1).neighbours(2);
                                aprovedMatches(2,counter) = cornersSig(2).c(i2).neighbours(2);
                                
                                %matches.mate2(aprovedMatches(1,counter)) = aprovedMatches(2,counter);
                                [matches.details( aprovedMatches(1,counter), aprovedMatches(2,counter) )] = matching.compareDistances(cornersSig(1).c( aprovedMatches(1,counter) ).dists, cornersSig(2).c( aprovedMatches(2,counter) ).dists, compare);
                            end
                                                         
                        end
                    end
                end
                
                if mod(round(i1/(cornersSig(1).range.number(2)-cornersSig(1).range.number(1)+1)*100),5)==0
                    fprintf('%.0f%% ',i1/(cornersSig(1).range.number(2)-cornersSig(1).range.number(1)+1)*100);
                end
            end            
            fprintf('\n');
            
            entryDistances = [matches.details.avgDif];
            entryDistancesSorted = sort(entryDistances);
            
            [matesIdx,~] = algorithm.combinationMin(entryDistances, [cornersSig(1).range.number(2)-cornersSig(1).range.number(1)+1 cornersSig(2).range.number(2)-cornersSig(2).range.number(1)+1], compare.requestedMatches, Inf);                      
            
            matches.mate2(matesIdx(1, matesIdx(1,:)>0)) = matesIdx(2, matesIdx(2,:)>0);
            matches.matchingQuality = entryDistancesSorted(1);
        end
        
        function [bestModel, mate2, iterations, lengthCS] = ransac(data, dataLink, RSC)
            i=1;
            lenDL = length(dataLink);
            percentage = 0;
            bestModel = zeros(3,3);
            bestModelInliersNumber = 0;
            previousSelectData = zeros(2,2,lenDL);
            
            p = 0.99;
            m = 2;
            %E = ;
            iterations = round(log(1-p)/log(1-(1- RSC.outlierRatio )^m));
            
%             comb2_3 = nchoosek(lenDL,m);
%             if iterations > comb2_3
%                 iterations = comb2_3;
%             end
            
            while i<=iterations                
                consensusSet = matching.randomSelectData(dataLink, lenDL, RSC.numberSelectedData);
%                 while sum(sum(sum(previousSelectData(:,:,1:i-1) == repmat(consensusSet,[1 1 i-1])))==4) > 0                    
%                     consensusSet = matching.randomSelectData(dataLink, RSC.numberSelectedData);                  
%                 end
                previousSelectData(:,:,i) = consensusSet;
                
                maybeInliersCoords = matching.indexisToCoords(consensusSet, data);
                [~, ~, maybeModel] = model.giveTransformation(maybeInliersCoords);
                
                consensusSet = matching.improveConsensusSet(data, dataLink, consensusSet, maybeModel, RSC.distThreshold);
                
                lengthCS(i) = length(consensusSet);
                if lengthCS(i) > bestModelInliersNumber
                    bestModel = maybeModel;
                    bestModelInliersNumber = lengthCS(i);
                    bestConsensusSet = consensusSet;
                end
                
                i=i+1;
                if mod(round(i/iterations*100),5)==0 && percentage ~= round(i/iterations*100)
                    percentage = round(i/iterations*100);
                    fprintf('%.0f%% ',i/iterations*100);
                end
            end
            fprintf('\n');
            
            mate2 = zeros(1,data(1).number);
            mate2(bestConsensusSet(1,:)) = bestConsensusSet(2,:); 
        end
        
        function [selectedData] = randomSelectData(dataLink, len, n)
            selectedData = zeros(2,n);
            
            counter = 0;
            while counter<n
                ptr = randi(len,1);
                
                if sum(selectedData(1,:)==dataLink(1,ptr))==0 && sum(selectedData(2,:)==dataLink(2,ptr))==0 % s?? quando n??o existe nenhuma das coordenadas no selectedData 
                    counter = counter + 1;
                    selectedData(:,counter) = dataLink(:,ptr);
                end
            end
            
            [selectedData(1,:),idxCS] = sort(selectedData(1,:));
            selectedData(2,:) = selectedData(2,idxCS);
        end
        
        function [consensusSet] = improveConsensusSet(data, dataLink, consensusSet, matrixModel, distThreshold)
            len = length(dataLink);
            
            counter = length(consensusSet);            
            for i=1:len
                if sum( consensusSet(1,:)==dataLink(1,i) )==0 && sum( consensusSet(2,:)==dataLink(2,i) ) == 0                    
                    if matching.pointAccuracyModel(data, matrixModel, dataLink(:,i)) < distThreshold
                        counter = counter + 1;
                        consensusSet(:,counter) = dataLink(:,i);
                    end
                end 
            end
        end
        
        
        function [acc] = pointAccuracyModel(extractions, matrixModel, dataLinkMatch)
            calculatedPoint = matrixModel * [extractions(2).coordinates(:, dataLinkMatch(2)) ; 1];
            
            acc = sqrt( (extractions(1).coordinates(1, dataLinkMatch(1) ) - calculatedPoint(1) )^2 + (extractions(1).coordinates(2, dataLinkMatch(1) ) - calculatedPoint(2) )^2 );
        end
        
        function [correctMatches,missingMatches,misMatches,cornerCmp] = cornerComparation(mate2Gen, mate2Calc)
            m2len = length(mate2Gen);
            
            % Indices
            mate2TrueCalc = mate2Gen==mate2Calc;    % C??lculos iguais aos do gerador (bool)
            mate2Diferences = not(mate2TrueCalc);   % Diferen??as entre o mate2 gerado e o calculado (bool)
            mate2MisCalc = mate2Diferences&mate2Calc;
            mate2MissingCalc = xor(mate2Diferences,mate2MisCalc);
            
            correctMatches = zeros(1,m2len);
            missingMatches = zeros(1,m2len);
            misMatches = zeros(1,m2len);
            
            correctMatches(mate2TrueCalc) = mate2Calc(mate2TrueCalc); cornerCmp(1) = length(find(correctMatches));
            missingMatches(mate2MissingCalc) = mate2Gen(mate2MissingCalc); cornerCmp(2) = length(find(missingMatches));
            misMatches(mate2MisCalc) = mate2Calc(mate2MisCalc); cornerCmp(3) = length(find(misMatches));
        end
        
        % IN
        % images -> 2 matrix of b&w images
        % separation -> width of separation
        % matches
        % str -> estrutura do tipo cornersSig ou extractions, dependedo do qual tiver coordinates
        % OUT
        % imageConc -> imagem concatenada
        function [cornerCmp, imageConc] = viewMatching(imageConc, imgDim, separation, mate2Gen, mate2Calc, str, lineColor, markStatus)            
            [correctMatches,missingMatches,misMatches,cornerCmp] = matching.cornerComparation(mate2Gen, mate2Calc);
            
            imageConc = matching.drawViewMatches(imageConc, imgDim, separation, correctMatches, str, lineColor(1,:), markStatus);   %Matches corretos
            imageConc = matching.drawViewMatches(imageConc, imgDim, separation, missingMatches, str, lineColor(2,:), markStatus);   %Matches em falta
            imageConc = matching.drawViewMatches(imageConc, imgDim, separation, misMatches, str, lineColor(3,:), markStatus);   %Matches mal calculados
        end
        
        function imageConc = drawViewMatches(imageConc, imgDim, separation, mate2, str, lineColor, markStatus)
            markRefCoords(1,:) = [-3 -3 -2 -1  0  1  2  3  3  3  2  1  0 -1 -2 -3];  %Linhas
            markRefCoords(2,:) = [ 0  1  2  3  3  3  2  1  0 -1 -2 -3 -3 -3 -2 -1];  %Colunas
            
            markCoords = zeros(2,2);
            
            range = mate2(str(1).range.number(1):str(1).range.number(2));
            
            for i=find(range)+str(1).range.number(1)-1
                markCoords(:,1) = round( refConv.cartesianToMatrix(imgDim, str(1).coordinates(:,i)) );
                markCoords(:,2) = round( refConv.cartesianToMatrix(imgDim, str(2).coordinates(:,mate2(i)) ) );
                markCoords(2,2) = markCoords(2,2) + imgDim(2) + separation;
                
                if markStatus % criar circulo ?? volta do canto
                    for j=1:16
                        imageConc(markCoords(1,1)+markRefCoords(1,j), markCoords(2,1)+markRefCoords(2,j), :) = [0 0 255];
                        imageConc(markCoords(1,2)+markRefCoords(1,j), markCoords(2,2)+markRefCoords(2,j), :) = [0 0 255];
                    end
                end
                
                imageConc = matching.drawLine(imageConc, markCoords, lineColor);
            end
            
        end
        
        % Desenha uma linha verde entre as coordenadas de markCoords
        % markCoordsC -> [x1, x2 ; y1, y2]
        function img = drawLine(img, markCoords, lineColor)
            line.m = ( markCoords(1,1)-markCoords(1,2) ) / ( markCoords(2,1)-markCoords(2,2) );
            line.b = markCoords(1,1) - line.m*markCoords(2,1);
            
            for j=markCoords(2,1)+2:markCoords(2,2)-2
                coords = [round(line.m*j+line.b) j];
                img( coords(1), coords(2), :) = lineColor;
            end
        end
        
        % Correspond???ncia entre
        function matchCoords = indexisToCoords(mate2,extractions)
            sizeMate2 = size(mate2);
            
            switch sizeMate2(1)
                case 1
                    nzLen = length(find(mate2));
                    matchCoords = zeros(2,2,nzLen);

                    j=1;
                    for i=1:sizeMate2(2)
                        if mate2(i)>0
                            matchCoords(:,1,j) = extractions(1).coordinates(:,i);
                            matchCoords(:,2,j) = extractions(2).coordinates(:,mate2(i));
                            j=j+1;
                        end
                    end
            
                case 2
                    matchCoords = zeros(2,2,sizeMate2(2));
                    
                    for i=1:sizeMate2(2)
                        matchCoords(:,1,i) = extractions(1).coordinates(:,mate2(1,i));
                        matchCoords(:,2,i) = extractions(2).coordinates(:,mate2(2,i));
                    end
            end
                    
        end
        
%         function [chosenPoints] = choosePoints(array,numberPoints)
%             halfNumberPoints = floor(numberPoints / 2);
%             
%             len = length(array);
%             meadle = floor(len/2);
%             
%             n = nthroot(meadle,halfNumberPoints);
%             
%             x = 1:halfNumberPoints;
%             y1 = round(n.^x);
%             y2 = flipud(y1')';
%             y1 = y1 + meadle;
%             
%             t = zeros(1,numberPoints);
%             indEven = 1:2:numberPoints;
%             indOdd = 2:2:numberPoints;
%             
%             t(indEven) = y2;
%             t(indOdd) = y1;
%             
%             chosenPoints = array(t);
%         end
        
    end
end