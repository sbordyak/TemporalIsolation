function [] = PopPlot(PopA, PopB, TI)
    %% ------------------------------------------------------------------
    %   PopPlot function
    %   Description:
    %       Plots the overlap chart between 2 populations and gives a 
    %           value for temporal isolation
    %
    %   Inputs:
    %       - PopA, struct/object of population type
    %       - PopB, struct/object of population type
    %       - TI, value for temporal isolation
    %
    %   Outputs:
    %       - Produces a figure
    %% ------------------------------------------------------------------
    
    figure(1)
    plot(1:365,PopA.alive,'k',1:365,PopB.alive,'r')
    title(sprintf('TI = %.3f, LS mean = %d, LS std = %d',TI,PopA.emergence.mean,PopA.emergence.std));
    legend('Population A','Population B')
    xlabel('Julian day');ylabel('Proportion of population alive')
    set(gca,'ylim',[-.005 .05]);
    drawnow

end