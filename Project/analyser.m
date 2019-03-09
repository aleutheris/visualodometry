classdef analyser
    
    methods (Static)
        
        function [inc, correctCorners, incorrectCorners] = cornerPropertiesCut(all,mate2)
            lenCorrect = length(mate2);
            
            %correctCorners = zeros(1,lenCorrect);
            
            sizeInfo = size(all.more);
            %lenIncorrect = sizeInfo(1) * sizeInfo(2) - lenCorners;
            
            %incorrectCorners = zeros(1,lenIncorrect);
            
            %figure
            
            j=1;
            for i=1:lenCorrect
                if mate2(i) ~= 0 && all.more(i,mate2(i)).accep==1
                    %correctCorners(j).avgDifs = all.more(i,mate2(i)).details.avgDif;
                    %correctCorners(j).stdd = std(nonzeros(all.more(i,mate2(i)).details.dif));
                    %correctCorners(j).dif = sort(nonzeros(all.more(i,mate2(i)).details.dif))';
                    correctCorners(j).diff = diff(correctCorners(j).dif);
                    %correctCorners(j).stdiff = std(correctCorners(j).diff(1:7));
                    
%                     hold on
%                     plot(1:length(correctCorners(j).dif),correctCorners(j).dif,'g')
                    
                    j=j+1;
                end
            end
            incorrectCorners = [];
            j=1;
            for r=1:sizeInfo(1)
                for c=1:sizeInfo(2)
                    if c ~= mate2(r) && all.more(r,c).accep==1 
                        %incorrectCorners(j).avgDifs = all.more(r,c).details.avgDif;
                        %incorrectCorners(j).stdd = std(nonzeros(all.more(r,c).details.dif));
                        %incorrectCorners(j).dif = sort(nonzeros(all.more(r,c).details.dif))';
                        incorrectCorners(j).diff = diff(incorrectCorners(j).dif);
                        
%                         if length(incorrectCorners(j).diff)>=7
%                             incorrectCorners(j).stdiff = std(incorrectCorners(j).diff(1:7));
%                         end
                        
                        j=j+1;
                    end
                end
            end
            
             inc = [];
           
%             figure
%             for j=1:length(incorrectCorners)
%                 %if length(incorrectCorners(j).dif)>=5 && sum(incorrectCorners(j).dif(1:5)<1.15)==5 % s� mostra os matches em que as primeiras 5 difs est�o abaixo de 1.15
%                 if length(incorrectCorners(j).dif)>=5 && mean(incorrectCorners(j).dif(1:5))<0.48
%                     hold on
%                     plot(1:length(incorrectCorners(j).dif),incorrectCorners(j).dif,'r')
%                     inc = [inc j];
%                 end
%             end
%             
%             
%             for j=1:length(correctCorners)               
%                 hold on
%                 plot(1:length(correctCorners(j).dif),correctCorners(j).dif,'g')
%             end

        end
        
        
        function [inc, correctCorners, incorrectCorners] = cornerPropertiesAll(all,mate2)
            lenCorrect = length(mate2);
            
            %correctCorners = zeros(1,lenCorrect);
            
            sizeInfo = size(all);
            %lenIncorrect = sizeInfo(1) * sizeInfo(2) - lenCorners;
            
            %incorrectCorners = zeros(1,lenIncorrect);
            
            %figure
            
            j=1;
            for i=1:lenCorrect
                if mate2(i) ~= 0
                    %correctCorners(j).avgDifs = all(i,mate2(i)).avgDif;
                    %correctCorners(j).stdd = std(nonzeros(abs(all(i,mate2(i)).dif)));
                    correctCorners(j).dif = sort(nonzeros(abs(all(i,mate2(i)).dif)));
%                     correctCorners(j).diff = diff(nonzeros(all(i,mate2(i)).dif));
%                     correctCorners(j).diff2 = diff(correctCorners(j).diff);
%                     correctCorners(j).diff3 = diff(correctCorners(j).diff2);
                    %correctCorners(j).stdiff = std(correctCorners(j).diff(1:5));
                    
%                     hold on
%                     plot(1:length(correctCorners(j).dif),correctCorners(j).dif,'g')
                    
                    j=j+1;
                end
            end
            
            j=1;
            for r=1:sizeInfo(1)
                for c=1:sizeInfo(2)
                    if c ~= mate2(r)
                        %incorrectCorners(j).avgDifs = all(r,c).avgDif;
                        %incorrectCorners(j).stdd = std(nonzeros(abs(all(r,c).dif)));
                        incorrectCorners(j).dif = sort(nonzeros(abs(all(r,c).dif)));
%                         incorrectCorners(j).diff = diff(nonzeros(all(r,c).dif)); 
%                         incorrectCorners(j).diff2 = diff(incorrectCorners(j).diff);
%                         incorrectCorners(j).diff3 = diff(incorrectCorners(j).diff2);
                        %incorrectCorners(j).stdiff = std(incorrectCorners(j).diff(1:5));
                        j=j+1;
                    end
                end
            end
            
            inc = [];
            
            figure(1)
            title('Diferences')
            
%             figure(2)
%             title('Diff')
%             
%             figure(3)
%             title('Diff2')
%             
%             
%             figure(4)
%             title('Diff incorrect')
%             
%             figure(5)
%             title('Diff2 incorrect')
%             
%             figure(6)
%             title('Diff incorrect')
%             
%             figure(7)
%             title('Diff2 incorrect')
%             
%             figure(8)
%             title('Diff3 incorrect')
                       
            for j=1:length(incorrectCorners)
                %if length(incorrectCorners(j).dif)>=8 && sum(incorrectCorners(j).dif(1:8)<100)==8 % s� mostra os matches em que as primeiras 5 difs est�o abaixo de 1.15
                d = diff(incorrectCorners(j).dif);
                
                %if length(incorrectCorners(j).dif)>=8 && mean(incorrectCorners(j).dif(1:8))<0.8
                 %   if length(d)>=4 && sum(d(1:4)<0.3)==4
                        %figure(1)
                        hold on
                        %subplot(3,1,1)
                        plot(1:length(incorrectCorners(j).dif), incorrectCorners(j).dif,'r')
                        
                        
%                         figure(2)
%                         hold on                
%                         %subplot(3,1,2)
%                         plot(1:length(incorrectCorners(j).diff), incorrectCorners(j).diff,'r')
%                         
%                         figure(4)
%                         hold on
%                         plot(1:length(incorrectCorners(j).diff), incorrectCorners(j).diff,'r')
%                         
%                         
%                         figure(3)
%                         hold on                
%                         %subplot(3,1,3)
%                         plot(1:length(incorrectCorners(j).diff2), incorrectCorners(j).diff2,'r')
%                         
%                         figure(5)
%                         hold on                       
%                         plot(1:length(incorrectCorners(j).diff2), incorrectCorners(j).diff2,'r')
%                         
%                         
%                         figure(8)
%                         hold on                
%                         %subplot(3,1,3)
%                         plot(1:length(incorrectCorners(j).diff3), incorrectCorners(j).diff3,'r')
                        
                        inc = [inc j];
                %    end
                %end
            end
            

            for j=1:length(correctCorners)
                figure(1)
                if length(correctCorners(j).dif)>=8 && mean(correctCorners(j).dif(1:8))<0.6
                    
                hold on
                %subplot(3,1,1)
                plot(1:length(correctCorners(j).dif), correctCorners(j).dif,'g')
                
                
%                 figure(2)
%                 hold on                
%                 %subplot(3,1,2)
%                 plot(1:length(correctCorners(j).diff), correctCorners(j).diff,'g')
%                 
%                 figure(6)
%                 hold on
%                 plot(1:length(correctCorners(j).diff), correctCorners(j).diff,'g')
%                 
%                 
%                 figure(3)
%                 hold on                
%                 %subplot(3,1,3)
%                 plot(1:length(correctCorners(j).diff2), correctCorners(j).diff2,'g')
%                 
%                 figure(7)
%                 hold on
%                 plot(1:length(correctCorners(j).diff2), correctCorners(j).diff2,'g')
%                 
%                 
%                 figure(8)
%                 hold on
%                 plot(1:length(correctCorners(j).diff3), correctCorners(j).diff3,'g')
                end
            end
            
%             figure
%             plot(1:length(nonzeros([incorrectCorners.stdd])),nonzeros([incorrectCorners.stdd]))
            
%             figure
%             title('Diff incorrect')
%             for j=1:length(incorrectCorners)
%                 hold on
%                 plot(1:length(incorrectCorners(j).diff), incorrectCorners(j).diff,'r')
%             end
%             
%             figure
%             title('Diff2 incorrect')
%             for j=1:length(incorrectCorners)
%                 hold on
%                 plot(1:length(incorrectCorners(j).diff2), incorrectCorners(j).diff2,'r')
%             end
%             
%             figure
%             title('Diff correct')
%             for j=1:length(correctCorners)
%                 hold on
%                 plot(1:length(correctCorners(j).diff), correctCorners(j).diff,'g')
%             end
%             
%             figure
%             title('Diff2 correct')
%             for j=1:length(correctCorners)
%                 hold on
%                 plot(1:length(correctCorners(j).diff2), correctCorners(j).diff2,'g')
%             end
        end
        
        
    end
end