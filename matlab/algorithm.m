classdef algorithm
    
    methods (Static)

        function [indexes2D,indexes1D] = combinationMin(matrix,dim,elementsNumber,elementsLimiter)            
            doneRowIdx = false(1,dim(1)); %verificação de linhas
            doneCollumnsIdx = false(1,dim(2)); %verificação de colunas
            indexes1D = zeros(1,elementsNumber);
            indexes2D = zeros(2,elementsNumber);
            
            [~,matrixIdx1D] = sort(matrix(:));  %indices 1D da matriz
            lenMatrix =length(matrix(:));
            
            j=0;
            i=0;
            while j<elementsNumber && i<lenMatrix
                i=i+1;
                
                r = mod(matrixIdx1D(i),dim(1));
                c = ceil(matrixIdx1D(i)/dim(1));
                
                if r==0
                    r = dim(1);
                end
                
                if matrix(matrixIdx1D(i)) >= elementsLimiter
                    return;
                end
                            
                if doneRowIdx(r)==false && doneCollumnsIdx(c)==false
                    j=j+1;
                    
                    indexes1D(j) = matrixIdx1D(i);                   
                    
                    indexes2D(:,j) = [r ; c];
                    doneRowIdx(r)=true;
                    doneCollumnsIdx(c)=true;
                end
            end
        end
        
        function distances = roulette(num1,num2,range)
            distances = [0 ; 0];            

            distances(1) = abs(num1-num2);
            distances(2) = range-distances(1);
            
            distances = sort(distances);
        end        
    end
end