%% TestModel.m
%%
% Set figure font to size 14
close all;
set(0,'defaultAxesFontSize',14)

% Plot Distributions?
plotit = 1;
l_or_a = 0;
save_switch = 1;

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
PopA.lifespan.mean = linspace(0,10,6);
PopA.lifespan.std = linspace(0,5,6);
% PopA.lifespan.mean = 2;
%PopA.lifespan.std = 0;

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
    figure(i);
    hold on;
    
    if l_or_a
        set(gca,'ylim',[0 1.05]);
        title("longevity");
        %legend('Population A','Population B')
        xlabel('days');
        ylabel('survivorship')
        set(gca,'xlim',[0 15]);
    else
        set(gca,'ylim',[-0.000005 0.25]);
        title("proportion alive");
        %legend('Population A','Population B')
        xlabel('days');
        ylabel('survivor/emergence convolution')
        set(gca,'xlim',[50 200]);
    end
    %display(i);
    for j = 1:length(PopA.lifespan.std)
        %display(j);
        PopAtmp = PopA;
        PopBtmp = PopB;
        %temp_index = mod(j-i,length(PopA.lifespan.mean));
        PopAtmp.lifespan.mean = PopA.lifespan.mean(i);
        PopAtmp.lifespan.std = PopA.lifespan.std(j);
        TI = 0;

        [TI,PopAtmp,PopBtmp] = TempIso(calc_type, cdf_type, pdf_type, PopAtmp, PopBtmp);

        if plotit % Set to 0 above to avoid plotting
            %PopPlot(PopAtmp, PopBtmp, TI);
            SurvivorPlot(PopAtmp, l_or_a);
        end
        TIall(i,j) = TI;
    end
    %legend('Survivorship 1', 'Survivorship 2', 'Survivorship 3','Survivorship 4')
    %lgd = legend
    %hold off;
    if save_switch
        saveas(i,"fig" + string(i) + ".jpg");
    end
    close all;
end

figure(7);
hold on;
if l_or_a
    set(gca,'ylim',[0 1.05]);
    title("longevity");
    %legend('Population A','Population B')
    xlabel('days');
    ylabel('survivorship')
    set(gca,'xlim',[0 15]);
else
    set(gca,'ylim',[-0.000005 0.25]);
    title("proportion alive");
    %legend('Population A','Population B')
    xlabel('days');
    ylabel('survivor/emergence convolution')
    set(gca,'xlim',[50 200]);
end
for i = 1:length(PopA.lifespan.mean)

    PopAtmp = PopA;
    PopBtmp = PopB;
    %temp_index = mod(j-i,length(PopA.lifespan.mean));
    PopAtmp.lifespan.mean = PopA.lifespan.mean(i);
    PopAtmp.lifespan.std = PopA.lifespan.std(i);
    TI = 0;

    [TI,PopAtmp,PopBtmp] = TempIso(calc_type, cdf_type, pdf_type, PopAtmp, PopBtmp);

    if plotit % Set to 0 above to avoid plotting
        %PopPlot(PopAtmp, PopBtmp, TI);
        SurvivorPlot(PopAtmp, l_or_a);
    end
    TIall(i,j) = TI;
end
saveas(7, "fig7.jpg");


% HeatmapPlot(PopA, PopB, TIall);