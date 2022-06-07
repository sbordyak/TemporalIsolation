%%
% Set figure font to size 14
set(0,'defaultAxesFontSize',14)



% Plot Distributions?
plotit = 0;



% Latin and English names for populations
% replace with true variable names





% Number of individuals in each population
% replace with true variable names
PopA = 1000;
PopB = 1000;



% For Populations A & B, we define ranges of parameters to investigate --
% mean, standard deviation, and distribution of emergence, tissue
% availability date, and lifespan



% Parameter ranges for PopulationA



% Parameter ranges for PopulationB



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
%Qvtmp.LFcdf = makedist('lognormal',Qvtmp.LifeSpan,Qvtmp.LifeSpanSTD);
Qvtmp.LFcdf = cdf(Qvtmp.LFpdf,Qvtmp.LifeSpan);

Qgtmp.FDpdf = makedist('normal',Qgtmp.FlowerDate,Qgtmp.FlowerSTD);
Qgtmp.Hpdf = makedist('normal',Qgtmp.EmergeDate,Qgtmp.EmergeSTD);
Qgtmp.LFpdf = makedist('lognormal',Qgtmp.LifeSpan,Qgtmp.LifeSpanSTD);
%Qgtmp.LFcdf = makedist('lognormal',Qgtmp.LifeSpan,Qgtmp.LifeSpanSTD);
Qgtmp.LFcdf = cdf(Qgtmp.LFpdf,Qgtmp.LifeSpan);

[TI,Qvtmp,Qgtmp] = ComputeTI_conv(Qvtmp,Qgtmp);

if plotit % Set to 0 above to avoid plotting
figure(1)
plot(1:365,Qvtmp.Nalive,'k',1:365,Qgtmp.Nalive,'r')
title(sprintf('TI = %.3f, LS mean = %d, LS std = %d' ,TI,Qvtmp.EmergeDate,Qvtmp.EmergeSTD))
legend('Population A','Population B')
xlabel('Julian day');ylabel('Proportion of population alive')
set(gca,'ylim',[-.005 .05]);
drawnow
%pause
end

TIall(ii,jj) = TI;

end
end
%%
% figure
imagesc();
colorbar
xlabel()
ylabel()
title('Temporal Isolation Test Model')
set(gca,'ydir','normal')