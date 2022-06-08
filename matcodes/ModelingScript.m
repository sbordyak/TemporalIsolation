%% TestModel.m
%%
% Set figure font to size 14
set(0,'defaultAxesFontSize',14)

% Plot Distributions?
plotit = 0;

% Calculation types
calc_type = "conv"; % Temporal Isolation calculation method
cdf_type = 'normal'; % CDF calculation type
pdf_type = 'normal'; % PDF calculation type

% Latin and English names for populations
%TestModel.PopA = Latin, English
%TestModel.PopB = Latin, English

% Number of individuals in each population for RNG method
PopA.population = 1000;
PopB.population = 1000;

% For Populations A & B, we define ranges of parameters to investigate --
% mean, standard deviation, and distribution of emergence, tissue
% availability date, and lifespan

% Parameter ranges for PopulationA
PopA.tissue.mean = 100;
PopA.tissue.std = 12;
PopA.emergence.mean = 120;
PopA.emergence.std = 15;
PopA.lifespan.mean = linspace(1,5,15);
PopA.lifespan.std = log(2:15);

% Parameters ranges for PopulationB
PopB.tissue.mean = 160;
PopB.tissue.std = 12;
PopB.emergence.mean = 155;
PopB.emergence.std = 15;
PopB.lifespan.mean = 1;
PopB.lifespan.std = 2;

TIall = zeros(length(PopA.lifespan.mean),length(PopA.lifespan.std));
% Calculate temporal isolation over range of selected parameters
for i = 1:length(PopA.lifespan.mean)
    for j = 1:length(PopA.lifespan.std)
        PopAtmp = PopA;
        PopBtmp = PopB;
        PopAtmp.lifespan.mean = PopA.lifespan.mean(i);
        PopAtmp.lifespan.std = PopA.lifespan.std(j);
        TI = 0;

        [TI,PopAtmp,PopBtmp] = TempIso(calc_type, cdf_type, pdf_type, PopAtmp, PopBtmp);

        if plotit % Set to 0 above to avoid plotting
            PopPlot(PopAtmp, PopBtmp, TI);
        end
        TIall(i,j) = TI;
    end
end

HeatmapPlot(PopA, PopB, TIall);