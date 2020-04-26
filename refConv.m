classdef refConv

    methods (Static)

        function coordsCartesian =  matrixToCartesian(imgDim,coordsMatrix)
            imgDim = round(imgDim/2);        
            s = size(coordsMatrix);
            
            coordsCartesian = zeros(2,s(2));
            transfMatrix = kin.transform2D_A([-imgDim(2) imgDim(1)],-1.570796); % transformação      
            
            for i=1:s(2)                                
                refMatrix = kin.translation2D(coordsMatrix(:,i)); % mudar de coordenadas para referencial                                              
                refCartesian = transfMatrix * refMatrix;               
                coordsCartesian(:,i) = refCartesian(1:2,3,:);
            end            
                        
%             center_cornerImg = kin.transform2D_A([-imgDim(2) imgDim(1)],-1.570796);
%             coordsCartesian = center_cornerImg * kin.translation2D(coordsMatrix);
%             coordsCartesian = coordsCartesian(1:2,3);
        end

        function coordsMatrix = cartesianToMatrix(imgDim,coordsCartesian)
            imgDim = round(imgDim/2);
            s = size(coordsCartesian);
            
            coordsMatrix = zeros(2,s(2));
            transfCartesian = kin.transform2D_A(imgDim,1.570796); % transformação      
            
            for i=1:s(2)                                
                refCartesian = kin.translation2D(coordsCartesian(:,i)); % mudar de coordenadas para referencial                                              
                refMatrix = transfCartesian * refCartesian;               
                coordsMatrix(:,i) = refMatrix(1:2,3,:);
            end
            
%             cornerImg_center = kin.transform2D_A(imgDim,1.5708); % desloca o referencial para o centro da imagem e roda-o 90 graus
%             coordsMatrix = cornerImg_center * kin.translation2D(coordsCartesian);
%             coordsMatrix = coordsMatrix(1:2,3);
        end

    end
end
