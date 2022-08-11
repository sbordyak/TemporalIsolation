%% TemporalIsolation.m 
% Top level script for basic testing of TI for gall wasp system
% User defines mean and standard dev for ED and LS. Flower Date not 
% implemented. Choose two parameters to vary in definitions to test the
% tradeoff between them.
% Outputs a heatmap figure for TI under different combinations of the two
% parameters.
%%

addpath(genpath('./matcodes'))

% Set figure font to size 14
set(0,'defaultAxesFontSize',14)

% Plot distributions?
plotit = 1;

% Number of simulated wasps (For random number generator (rng) version)
Qv.Nwasp = 10000;
Qg.Nwasp = 10000;


% For wasps that form galls in two species of trees, we define ranges of
% parameters to investigate--mean and standard deviation for flowering date
% of the tree, emergence of wasp, and lifespan of wasp.  

% Parameter ranges for Quercus virginiana
Qv.FlowerDate = 100;
Qv.FlowerSTD = 12;
%Qv.EmergeDate = 100:5:200;
%Qv.EmergeSTD = 5:20;
Qv.EmergeDate = 120;
Qv.EmergeSTD = 15;
Qv.LifeSpan = linspace(1,5,15);
%Qv.LifeSpanSTD = log(2);
Qv.LifeSpanSTD = log(2:15);

% Parameter ranges for Quercus geminata
Qg.FlowerDate = 160;
Qg.FlowerSTD = 12;
Qg.EmergeDate = 155;
Qg.EmergeSTD = 15;
Qg.LifeSpan = 1;
Qg.LifeSpanSTD = log(2);


% Calculate temporal isolation over range of selected parameters

for ii = 1:length(Qv.LifeSpan)
    
    
    for jj = 1:length(Qv.LifeSpanSTD)
        
        Qvtmp = Qv;
        Qgtmp = Qg;
        
        %Qvtmp.EmergeDate = Qv.EmergeDate(ii);
        %Qvtmp.EmergeSTD = Qv.EmergeSTD(jj);        
        Qvtmp.LifeSpan = Qv.LifeSpan(ii);
        Qvtmp.LifeSpanSTD = Qv.LifeSpanSTD(jj);
        
        Qvtmp.FDpdf = makedist('normal',Qvtmp.FlowerDate,Qvtmp.FlowerSTD);
        Qvtmp.Hpdf = makedist('normal',Qvtmp.EmergeDate,Qvtmp.EmergeSTD);
        Qvtmp.LFpdf = makedist('lognormal',Qvtmp.LifeSpan,Qvtmp.LifeSpanSTD);
        Qvtmp.LFcdf = cdf(Qvtmp.LFpdf, Qvtmp.LifeSpan);
        
        Qgtmp.FDpdf = makedist('normal',Qgtmp.FlowerDate,Qgtmp.FlowerSTD);
        Qgtmp.Hpdf = makedist('normal',Qgtmp.EmergeDate,Qgtmp.EmergeSTD);
        Qgtmp.LFpdf = makedist('lognormal',Qgtmp.LifeSpan,Qgtmp.LifeSpanSTD);
        Qgtmp.LFcdf = cdf(Qgtmp.LFpdf, Qgtmp.LifeSpan);
        
        [TI,Qvtmp,Qgtmp] = ComputeTI_conv(Qvtmp,Qgtmp);
        
        if plotit % Set to 0 above to avoid plotting
            figure(1)
            plot(1:365,Qvtmp.Nalive,'k',1:365,Qgtmp.Nalive,'r')
            title(sprintf('TI = %.3f, LS mean = %d, LS std = %d' ,TI,Qvtmp.EmergeDate,Qvtmp.EmergeSTD))
            legend('Q. virginiana','Q. geminata')
            xlabel('Julian day');ylabel('Proportion of wasps alive')
            set(gca,'ylim',[-.005 .05]);
            drawnow
            %pause
        end
        
        TIall(ii,jj) = TI;
        
    end
end
%%
%figure(99)
imagesc(Qv.LifeSpan,Qv.LifeSpanSTD,TIall');
colorbar
xlabel('Qv lifespan (days)')
ylabel('Stdev of Qv lifespan (days)')
title('Temporal Isolation')
set(gca,'ydir','normal')




