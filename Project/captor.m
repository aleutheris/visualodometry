classdef captor
    
    methods (Static)

%         % INPUT
%         % X -> [distance1 distance2] (2 distâncias do captor ao plano estático)
%         % Z -> [measure1 measure2] (2 medições correspondentes, nos objetos)
%         %
%         % OUTPUT
%         % b -> back length (longitude escondida do captor)
%         % alf -> anglo de abertura do captor (pode ser vertical, horizontal ou diagonal, consoante os X e Z)
%         function [ b, alf ] = calibrate( X, Z )
%             b = ( Z(1)*X(2) - Z(2)*X(1) ) / ( Z(2) - Z(1) );
%             alf = 2*atan( 0.5 * (Z(2)-Z(1)) / (X(2)-X(1)) );
%         end
%         
%         
%         % INPUT
%         % b e alf são as propriedades do captor
%         % px1 -> diagonal da imagem (pixeis)
%         % x1 -> distãncia momentânea captor-plano (mm)   
%         % px -> pixeis que se quer saber em mm
%         %
%         % px1 -- z1 (medições sabidas)
%         % px  -- ? (mm)
%         % 
%         % OUPUT
%         % z -> valor do px em milimetros
%         function z = pixelToMM(b, alf, px1, x1, px)
%             z1 = 2*tan(alf/2)*(b+x1); %diagonal da imagem (mm)
%             z = z1*px/px1;
%         end
        
        
%         %% INPUT
%         % m e b são as propriedades do captor
%         % dmm -> distãncia momentânea captor-plano (mm)
%         % Apx -> lateral da imagem (pixeis)
%         % s -> redução da imagem (scale)
%         % apx -> pixeis que se quer saber em mm
%         % 
%         % OUPUT
%         % amm -> valor do apx em milimetros
%         function amm = pixelToMM(lineX, lineY, s, dmm, Apx, apx)
%             AmmY = ( lineY.m*dmm+lineY.b ); %lateral da imagem (mm)
%             amm(2) = AmmY*apx(2)/Apx(2);
%             
%             AmmX = ( lineX.m*dmm+lineX.b ); %lateral da imagem (mm)
%             amm(1) = AmmX*apx(1)/Apx(1);
%             
% 
%         end
        
        %% INPUT
        % l.m e l.b ->
        % m e b são as propriedades do captor
        % imgDim -> dimensões da imagem (px)        % 
        % d -> distancia da camera ao teto
        % Apx -> pixeis que se quer saber em mm
        % 
        % OUPUT
        % Amm -> valor do apx em milimetros
        function Amm = pixelToMM(l, imgDim, d, Apx)
            g = imgDim(1)/3;
            Amm = (l.m * d + l.b) * Apx / g;
        end
        
    end
    
end