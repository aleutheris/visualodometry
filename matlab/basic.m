classdef basic
    
    methods (Static)
        
        function ag = normalizeAngle(ag)
            ag = angle(cos(ag) + sin(ag)*1i);
        end
        
        function position = thereIsNumber(array,value)
            
            for i=flipud((1:length(array))')'
                if value==array(i)
                    position=i;
                    return;
                end
                position = 0;
            end
        end
                
        function o = corr( X, Y )
            o = cov(X,Y) / (std(X)*std(Y));
        end
        
        % Devolve um array com os valores ocorrios ordenados pela sua frequência
        function [M, F] = modeSort(array)
            M = zeros(1,length(array));
            F = zeros(1,length(array));
            
            counter = 1;
            while isempty(array) == 0
                [m, f] = mode(array);
                
                M(counter) = m;
                F(counter) = f;
                
                array = array(array ~= m);
                counter = counter + 1;
            end
            
            M = M(1:counter-1);
            F = F(1:counter-1);
        end
        
        function idx = choseIndexes(array, elems)            
            idx = zeros(1,length(array));
            
            for i=1:length(elems)
                idx = idx + (array==elems(i));
            end
            
        end
    end
end