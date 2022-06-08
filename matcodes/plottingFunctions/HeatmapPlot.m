function [] = HeatmapPlot(PopA, PopB, TIall)
%% ------------------------------------------------------------------
%   PopPlot function
%   Description:
%       Plots the set of heatmaps needed between 2 populations
%
%   Inputs:
%       - PopA, struct/object of population type
%       - PopB, struct/object of population type
%       - TIall, all values for temporal isolation across a timespan
%
%   Outputs:
%       - Produces figures (heatmaps)
%
%   TODO:
%       - Add and configure heatmaps as necessary, not final version
%% ------------------------------------------------------------------


    figure(2);
    imagesc(PopA.lifespan.mean, PopA.lifespan.std, TIall);
    colorbar;
    xlabel('Population A lifespan (days)')
    ylabel('Stdev of Population A lifespan (days)')
    title('Temporal Isolation')
    set(gca,'ydir','normal')

    %figure(3);
    %imagesc(PopB.lifespan.mean, PopB.lifespan.std, TIall);
    %colorbar;
    %xlabel('Population B lifespan (days)')
    %ylabel('Stdev of Population B lifespan (days)')
    %title('Temporal Isolation')
    %set(gca,'ydir','normal')

    figure(4);
    imagesc(PopA.emergence.mean, PopA.emergence.std, TIall);
    colorbar;
    xlabel('Population A emergence');
    ylabel('Stdev of Population A emergence');
    title('Temporal Isolation');
    set(gca, 'ydir', 'normal');

    figure(5);
    imagesc(PopA.tissue.mean, PopA.tissue.std, TIall);
    colorbar;
    xlabel('Population A tissue');
    ylabel('stdev of Population A tissue');
    title('Temporal Isolation');
    set(gca, 'ydir', 'normal');

end