classdef geometry
    
    methods (Static)
        
        % Coords Ã© uma matrix de coordenadas da cirfunferencia
        function coords = circumfSimple(radius)
            coords = zeros(2,4*radius);
            
            x=1:radius;
            coords(1,x) = x;
            coords(2,x) = round(sqrt(radius^2-x.^2));
            
            coords(1,x+radius) = -x;
            coords(2,x+radius) = round(sqrt(radius^2-x.^2));
            
            coords(1,x+2*radius) = x;
            coords(2,x+2*radius) = -round(sqrt(radius^2-x.^2));
            
            coords(1,x+3*radius) = -x;
            coords(2,x+3*radius) = -round(sqrt(radius^2-x.^2));
            
            
        end
        
        % Coords Ã© uma matrix de coordenadas da cirfunferencia
        function coords = circumf(radius,thick)            
            coords = geometry.circumfSimple(radius);
                
            for i=radius-thick:radius
                coordsAux = geometry.circumfSimple(i);
                coords(:,end+1:end+length(coordsAux)) = coordsAux;
            end
        end
        
        % Coordenadas de uma cruz
        function coords = cross(thick)           
            long = 5*thick;
            
            coords = zeros(thick,2*long,2);
            
            refCoords(:,:,1) = kron( -floor(long/2): 1: floor(long/2)   , ones(long,1) );
            refCoords(:,:,2) = kron( (floor(long/2):-1:-floor(long/2))' , ones(1,long) );
            
            coords(1:thick,1:long,:) = refCoords(ceil(long/2)-floor(thick/2):ceil(long/2)+floor(thick/2), 1:long, :);
            coords(1:thick,long+1:2*long,:) = coords(1:thick,1:long,[2 1]);
            
            %refCoords = permute(refCoords, [3 2 1]);
            coords = permute(coords, [3 2 1]);            
        end       
        
        % (x1,y1) pertence ao ponto anterior
        % (x2,y2) pertence ao ponto atual
        % markCoords -> [x1 x2 ; y1 y2]
        % coords -> coordendas de uma segmento de recta
        function coords = lineSimple(markCoords)
            pixelWindow = [1 1 0 -1 -1 -1 0 1 ; 0 1 1 1 0 -1 -1 -1];
            pixelAngle = [0 pi/4 pi/2 3*pi/4 pi -3*pi/4 -pi/2 -pi/4];
            
            if markCoords(1,1) > markCoords(1,2) && markCoords(2,1) > markCoords(2,2)
                markCoords = markCoords(:,[2 1]);
            end
            
            lineDrt.m = ( markCoords(2,2)-markCoords(2,1) ) / ( markCoords(1,2)-markCoords(1,1) ); % calculo de m
            lineDrt.b = markCoords(2,1) - lineDrt.m * markCoords(1,1); % calculo de b
            
            lineInv.m = ( markCoords(1,2)-markCoords(1,1) ) / ( markCoords(2,2)-markCoords(2,1) ); % calculo de m
            lineInv.b = markCoords(1,1) - lineInv.m * markCoords(2,1); % calculo de b
            
            previousPoint = markCoords(:,1);            
            
            i=1;
            while sum(previousPoint==markCoords(:,2))~=2 % enquanto o previousPoint não for ponto final
                vector = markCoords(:,2)-previousPoint;
                ag = angle(vector(1)+vector(2)*1i);

                distances = abs(ag-pixelAngle);
                [~,I] = sort(distances);
                pixelIdx = I(1:2); % indice de pixelWindow e pixelAngle
                
                x = previousPoint(1) + pixelWindow(1,pixelIdx); % dois x's possíveis
                if x(1)==x(2) % se os x's são iguais
                    y = lineDrt.m.*x(1)+lineDrt.b; % calcula cada y
                    d = abs(previousPoint(2) + pixelWindow(2,pixelIdx) - y); % distancia d em y entre pixelWindow e o y calculado
                    [~,dIdx] = sort(d); % indices de d
                    previousPoint = previousPoint + pixelWindow(:,pixelIdx(dIdx(1)));
                    coords(:,i) = previousPoint;
                end
                
                y = previousPoint(2) + pixelWindow(2,pixelIdx); % dois y's possíveis
                if y(1)==y(2) % se os y's são iguais
                    x = lineInv.m.*y(1)+lineInv.b; % calcula cada x
                    d = abs(previousPoint(1) + pixelWindow(1,pixelIdx) - x); % distancia d em x entre pixelWindow e o x calculado
                    [~,dIdx] = sort(d); % indices de d
                    previousPoint = previousPoint + pixelWindow(:,pixelIdx(dIdx(1)));
                    coords(:,i) = previousPoint;
                end

                i=i+1;
            end
        end
    end
end