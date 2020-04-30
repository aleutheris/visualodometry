classdef control
    
    methods (Static)
        
        function yest = arxCtrl(Y,U,u,yPrevious) 
            [est, ~] = estimator(Y,U);
            VERRRRRR
            yest = -est(1)*yPrevious + est(2)*u;
        end
        
        function [est fi] = estimator(y,u)   
            len = length(y);
            
            fi(1,:) = [1 1];
            
            for k=2:len
                fi(k,:) = [-y(k-1) u(k-1)];                              
            end
            
            est = (fi'*fi)\fi'*[0 ; y(1:k-1)];            
            %yest = fi(len,:) * est;            
        end
        
    end
    
end