function [path, img] = mousePathRender(background,radius,thick,angleEscale,f1)
    %screenSize =get(0,'ScreenSize');

    img.previous = background;
    dim = size(background); img.dim = dim(1:2);

    standard.step = geometry.cross(thick);
    standard.coordsCirc = geometry.circumf(radius,thick);

    % Cor das v�rias composi��es do path
    pathStatic.colors.line = [0 0 255];
    pathStatic.colors.step = [0 255 0];
    pathStatic.colors.circ = [255 0 0];


    i=1;

    figure(f1)    
    imshow(img.previous) 
    set(f1,'units','normalized','outerposition',[0 0 1 1])

    path(i).pointerCoords.matrix = zeros(2,1);
    [path(i).pointerCoords.matrix(2), path(i).pointerCoords.matrix(1), b] = ginput(1); %busca ponto
    path(i).pointerCoords.matrix = round(path(i).pointerCoords.matrix); %arredondar

    path(i).pointerCoords.cartesian = round( refConv.matrixToCartesian(img.dim, path(i).pointerCoords.matrix) ); % converte de coordenadas matriz para coordenadas cartesianas

    path(i).vector = [0 ; 0];
    path(i).angle = 0;
    path(i).relativeAngle = 0;
    path(i).magnitude = 0;
    path(i).generatedAngle = rand()*(angleEscale(2)-angleEscale(1))+angleEscale(1);
    
    % Coordenadas da cirfunferencia
    path(i).coords.circ(1,:) = standard.coordsCirc(2,:) + path(i).pointerCoords.matrix(1);  
    path(i).coords.circ(2,:) = standard.coordsCirc(1,:) + path(i).pointerCoords.matrix(2);

    % Coordenadas do passo (cruz)
    path(i).coords.step(1,:) = standard.step(1,:) + path(i).pointerCoords.matrix(1);
    path(i).coords.step(2,:) = standard.step(2,:) + path(i).pointerCoords.matrix(2);  

    % Desenhar as coordenadas na imagem atual
    img.current = interf.drawCoords(img.dim, img.previous, path(i).coords, {'step', 'circ'}, pathStatic.colors);
    img.previous = interf.drawCoords(img.dim, img.previous, path(i).coords, {'step'}, pathStatic.colors);

    imshow(img.current) 
    set(f1,'units','normalized','outerposition',[0 0 1 1])
    fprintf('Point recorded: (%d,%d)\n',path(i).pointerCoords.matrix(1),path(i).pointerCoords.matrix(2));


    while b~=3 %enquanto o botão direito não for pressionado
        pointerCoords.matrix = zeros(2,1);
        [pointerCoords.matrix(2), pointerCoords.matrix(1), b] = ginput(1); %busca ponto
        pointerCoords.matrix = round(pointerCoords.matrix); %arredondar
      
        if sqrt( (pointerCoords.matrix(1)-path(i).pointerCoords.matrix(1))^2 + (pointerCoords.matrix(2)-path(i).pointerCoords.matrix(2))^2 )<=radius % s� se o ponto estiver dentro da circunfer�ncia � que ser� processado        
            i=i+1;           

            path(i).pointerCoords.matrix = pointerCoords.matrix; % Regista o ponto recolhido
            path(i).pointerCoords.cartesian = round( refConv.matrixToCartesian(img.dim, pointerCoords.matrix) ); % converte de coordenadas matriz para coordenadas cartesianas

            path(i).vector = [path(i).pointerCoords.cartesian(1)-path(i-1).pointerCoords.cartesian(1) ; path(i).pointerCoords.cartesian(2)-path(i-1).pointerCoords.cartesian(2)];
            path(i).angle = angle(path(i).vector(1)+path(i).vector(2)*1i);
            path(i).relativeAngle = path(i).angle - path(i-1).angle; path(i).relativeAngle = angle(cos(path(i).relativeAngle) + sin(path(i).relativeAngle)*1i);
            path(i).magnitude = abs(path(i).vector(1)+path(i).vector(2)*1i);
            path(i).generatedAngle = rand()*(angleEscale(2)-angleEscale(1))+angleEscale(1);
            
            % Coordenadas da linha
            path(i).coords.line = geometry.lineSimple([path(i-1).pointerCoords.matrix path(i).pointerCoords.matrix]);       

            % Coordenadas da circunferencia
            path(i).coords.circ(1,:) = standard.coordsCirc(2,:) + path(i).pointerCoords.matrix(1);  
            path(i).coords.circ(2,:) = standard.coordsCirc(1,:) + path(i).pointerCoords.matrix(2);

            % Coordenadas do passo (cruz)
            path(i).coords.step(1,:) = standard.step(1,:) + path(i).pointerCoords.matrix(1);
            path(i).coords.step(2,:) = standard.step(2,:) + path(i).pointerCoords.matrix(2);       

            % Desenhar as coordenadas na imagem atual
            img.current = interf.drawCoords(img.dim, img.previous, path(i).coords, {'line', 'step', 'circ'}, pathStatic.colors);
            img.previous = interf.drawCoords(img.dim, img.previous, path(i).coords, {'line', 'step'}, pathStatic.colors);

            imshow(img.current)
            title('Press mouse''s right button for last step')
            set(f1,'units','normalized','outerposition',[0 0 1 1])
            fprintf('Point recorded: (%d,%d)\n',pointerCoords.matrix(2),pointerCoords.matrix(1));        
        end   
    end
    close(f1);
end