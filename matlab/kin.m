classdef kin

    methods (Static)
    
        % Matriz de translação
        function matrix = translation2D(T)
            s = size(T);
            matrix = zeros(3,3,s(2));
            matrix(1,1,:) = ones(1,1,s(2));
            matrix(2,2,:) = ones(1,1,s(2));
            matrix(3,3,:) = ones(1,1,s(2));
            matrix(1:2,3,:) = permute(T, [1 3 2]);
            %matrix = [1 0 T(1);0 1 T(2);0 0 1];
        end

        % Matriz de rotação
        function matrix = rotation2D(ag)
            len = length(ag);
            matrix = zeros(3,3,len);
            matrix(1,1,:) = permute(cos(ag), [1 3 2]);
            matrix(1,2,:) = permute(-sin(ag), [1 3 2]);
            matrix(2,1,:) = permute(sin(ag), [1 3 2]);
            matrix(2,2,:) = permute(cos(ag), [1 3 2]);
            matrix(3,3,:) = ones(1,1,len);
            %matrix = [ cos(ag) -sin(ag) 0 ; sin(ag) cos(ag) 0 ; 0 0 1];
        end
        
        % Matriz de translação e rotação com angulo
        function matrix = transform2D_A(T,ag)
            len = length(ag);
            
            matrix = zeros(3,3,len);
            
            matrix(1:2,3,:) = permute(T, [1 3 2]);            
            
            matrix(1,1,:) = permute(cos(ag), [1 3 2]);
            matrix(1,2,:) = permute(-sin(ag), [1 3 2]);
            matrix(2,1,:) = permute(sin(ag), [1 3 2]);
            matrix(2,2,:) = permute(cos(ag), [1 3 2]);
            matrix(3,3,:) = ones(1,1,len);
            %matrix = [cos(ag) -sin(ag) T(1) ; sin(ag) cos(ag) T(2) ; 0 0 1];
        end
        
        % 
        function matrix = transform2D_V(T,V)
            s = size(T);
            matrix = zeros(3,3,s(2));
            
            matrix(1:2,1,:) = permute(V, [1 3 2]);
            matrix(1:2,3,:) = permute(T, [1 3 2]);
            matrix(1,2,:) = -matrix(2,1,:);
            matrix(2,2,:) = matrix(1,1,:);
            matrix(3,3,:) = ones(1,1,s(2));
            %matrix = [V(1) -V(2) T(1) ; V(2) V(1) T(2) ; 0 0 1];
        end        
        
        % Devolve o módulo do ponto do referencial
        function mod = getRefMod2D(ref)
            mod = sqrt( ref(1,3)^2 + ref(2,3)^2 );
        end
        
        % Devolve o angulo do ponto do referencial
        function ag = getRefAngle2D(ref)
            ag = angle( ref(1,1) + ref(2,1)*1i );
        end

        
%         function coordsDest = rotateCoords2D(coordsOrig, coordsCenter, angle)
%             coordsOrig = matrixToCartesian(coordsOrig);
%             coordsCenter = matrixToCartesian(coordsCenter);
% 
%             angle = pi * angle / 180;
% 
%             coordsDest.x = round( (coordsOrig.x - coordsCenter.x) * cos(angle) + (coordsOrig.y - coordsCenter.y) * sin(angle) + coordsCenter.x );
%             coordsDest.y = round( (coordsOrig.y - coordsCenter.y) * cos(angle) - (coordsOrig.x - coordsCenter.x) * sin(angle) + coordsCenter.y ); 
% 
%             coordsDest = cartesianToMatrix(coordsDest);
%         end
%         
%         function coordsDest = translateCoords2D(coordsOrig, coordsDirection)
%             %coordsOrig = matrixToCartesian(coordsOrig);
%             %coordsDirection = matrixToCartesian(coordsDirection);
% 
%             coordsDest.r = coordsOrig.r + coordsDirection.r;
%             coordsDest.c = coordsOrig.c + coordsDirection.c;
% 
%             %coordsDest = cartesianToMatrix(coordsDest);
%         end
%         
%         function coordsDest = transformCoords2D(coordsDirection, coordsOrig, coordsCenter, angle)
%             coordsOrig = translation(coordsOrig, coordsDirection);
%             coordsDest = rotation(coordsOrig, coordsCenter, angle);
%         end
    
    end

end

