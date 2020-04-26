classdef model
    
    methods (Static)

        % Dá a transformação, considerando os cantos relacionados em match1 e match2
        % translation -> translação em pixeis
        % rotation -> angulo em radianos
        function [translation, ag, transf_matrix] = giveTransformationDual(match1, match2)            
            groundReference = match1 - match2;      
            
            modGR = sqrt(groundReference(1,:).^2 + groundReference(2,:).^2);
            
            % cossenos e senos
            groundReferenceNorm(:,1) = groundReference(:,1) ./ modGR';            
            groundReferenceNorm(:,2) = groundReference(:,2) ./ modGR';            
            %
            
            cf_c1 = kin.transform2D_V(match2(:,1),groundReferenceNorm(:,1));
            cf_c2 = kin.transform2D_V(match2(:,2),groundReferenceNorm(:,2));
            
            transf_matrix = cf_c1 / cf_c2; % "/ cf_c2" = "* inv(cf_c2)" 
            
            translation = transf_matrix(1:2,3);
            ag = kin.getRefAngle2D(transf_matrix);
        end
        
        % Dá a transformação, considerando todos os cantos relacionados em match
        % match(:,:,n) -> contem matching n do tipo [x1 x2 ; y1 y2], dos cantos 1 e 2 respetivamente 
        % translation -> translação em pixeis
        % rotation -> angulo em radianos
        function [translation, ag, transf_matrix] = giveTransformation(matchCoords)
            s = size(matchCoords);
            
            if size(s)<3
                error('NO ENOUGHT MATCHES!');
            end            

            len = s(3);
            halfLen = len/2;
            
            if mod(len,2) %Se len for impar
                halfLen = (len-1)/2;
                match2 = matchCoords(:,:,len);  % Coloca logo a ultima posição de matchCoords em match2
                divisor2 = halfLen+1;
            else
                match2 = zeros(2,2);
                divisor2 = halfLen;
            end
            match1 = zeros(2,2);
            divisor1 = halfLen;
            
            for i=1:halfLen
                match1 = match1 + matchCoords(:,:,i);
                match2 = match2 + matchCoords(:,:,i+halfLen);
            end
            
            match1 = match1/divisor1;
            match2 = match2/divisor2;
            
            [translation, ag, transf_matrix] = model.giveTransformationDual(match1, match2);
        end
        
    end
end