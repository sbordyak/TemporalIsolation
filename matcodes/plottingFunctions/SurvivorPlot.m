function [] = SurvivorPlot(Pop, l_or_a)
%SURVIVORPLOR Summary of this function goes here
%   Detailed explanation goes here
%     figure(1)
    if l_or_a
        temp = zeros(1, 365);
        temp(1) = 1;
        for i = 2:365
           temp(i) = Pop.lifespan.distribution(i-1); 
        end
        plot(0:364,temp);
    elseif ~l_or_a
        plot(0:364,Pop.alive);
    end
    
%     title("Survivorship");
%     %legend('Population A','Population B')
%     xlabel('days');
%     ylabel('survivorship')
%     set(gca,'xlim',[0 15]);
%     set(gca,'ylim',[0 1.05]);
%     drawnow
end

