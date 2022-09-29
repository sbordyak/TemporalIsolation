%% TestModel.m

%%
% Set figure font to size 14
set(0,'defaultAxesFontSize',14)

% Plot Distributions?
plotit = 0;

% Latin and English names for populations
%TestModel.PopA = Latin name, English
%TestModel.PopB = Latin name, English

% Number of individuals in each population
%TestModel.PopA = 1000;
%TestModel.PopB = 1000;

% For Populations A & B, we define ranges of parameters to investigate --
% mean, standard deviation, and distribution of emergence, tissue
% availability date, and lifespan

% Parameter ranges for PopulationA
TestModel.PopA.tissue.mean = 100;
TestModel.PopA.tissue.std = 12;
% TestModel.PopA.emergence.mean = 100:5:200
% TestModel.PopA.emergence.std = 5:20
TestModel.PopA.emergence.mean = 120;
TestModel.PopA.emergence.std = 15;
TestModel.PopA.lifespan.distribution = linspace(1,5,15);
% TestModel.PopA.lifespan.std
TestModel.PopA.lifespan.std = 3;

% Parameters ranges for PolulationB
TestModel.PopB.tissue.mean = 160;
TestModel.PopB.tissue.std = 12;
TestModel.PopB.emergence.mean = 155;
TestModel.PopB.emergence.std = 15;
TestModel.PopB.lifespan = 1;
TestModel.PopB.lifespan.std = 2;


% Calculate temporal isolation over range of selected parameters

for ii = 1:length(TestModel.PopA.lifespan)
    
    
    for jj = 1:length(TestModel.PopA.lifespan.std)
        
        TestModel.PopAtmp = Atmp;
        TestModel.PopBtmp = Btmp;
        
        %PopA.emergence.mean = Atmp.emergence.mean(ii);
        %PopA.emergence.std = Atmp.emergence.std(jj);        
        TestModel.PopAtmp.lifespan.mean = Atmp.lifespan.mean(ii);
        TestModel.PopAtmp.lifespan.std = Atmp.lifespan.std(jj);
        
        TestModel.PopAtmp.tissuepdf = makedist('normal',TestModel.PopAtmp.tissue.mean,TestModel.PopAtmp.tissue.std);
        TestModel.PopAtmp.emergepdf = makedist('normal',TestModel.PopAtmp.emergence.mean,TestModel.PopAtmp.emergence.std);
        TestModel.PopAtmp.lifespancdf = makedist('normal',TestModel.PopAtmp.lifespan,TestModel.PopAtmp.lifespan.std);
        %TestModel.PopAtmp.lifespancdf = makedist('normal',TestModel.PopAtmp.lifespan,TestModel.PopA.lifespan.std);
        TestModel.PopAtmp.lifespancdf = cdf(Test.Model.PopAtmp.lifespancdf,TestModel.PopAtmp.lifespan);
        
        TestModel.PopBtmp.tissuepdf = makedist('normal',TestModel.PopBtmp.tissue.mean,TestModel.PopBtmp.tissue.std);
        TestModel.PopBtmp.emergepdf = makedist('normal',TestModel.PopBtmp.emergence.mean,TestModel.PopBtmp.emergence.std);
        TestModel.PopBtmp.lifespancdf = makedist('normal',TestModel.PopBtmp.lifespan,TestModel.PopBtmp.lifespan.std);
        %TestModel.PopBtmp.lifespancdf = makedist('normal',TestModel.PopBtmp.lifespan,TestModel.PopBtmp.lifespan.std);
        TestModel.PopBtmp.lifespancdf = cdf(TestModel.PopBtmp.lifespancdf,TestModel.PopBtmp.lifespan);
        
        [TI,TestModel.PopAtmp,TestModel.PopBtmp] = ComputeTI_conv(TestModel.PopAtmp,TestModel.PopBtmp);
        
        if plotit % Set to 0 above to avoid plotting
            figure(1)
            plot(1:365,TestModel.PopAtmp.PopA.alive,'k',1:365,TestModel.PopBtmp.PopB.alive,'r')
            title(sprintf('TI = %.3f, LS mean = %d, LS std = %d' ,TI,TestModel.PopAtmp.emergence.mean,TestModel.PopAtmp.emergence.std))
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
