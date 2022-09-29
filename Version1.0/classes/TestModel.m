classdef TestModel
    properties
        TIall; % TIall matrix, hold TI data for each test
        scheduler; % Scheduler matrix, holds each test being run at a time
    end
    methods
        %% TestModel Constructor
        %   Creates an object of type TestModel given 2 population objects
        %   and the dimensions of the TIall matrix
        function self = TestModel(pop1, pop2, boolean, scheduler_slice, pop_or_slice)
            if pop_or_slice == 1
                self.CreateSchedulerSlice(pop1, pop2, boolean);
            elseif pop_or_slice == 2
                self.UploadSchedulerSlice(scheduler_slice, boolean);
            end
        end

        %% SchedulerTest
        %   New Test function based on the concept of the scheduler matrix,
        %   allows us to create as many new tests/cases that we choose
        %   while changing any variable (across either population) that we
        %   like
        function self = SchedulerTest(self, type, cdf_type, pdf_type, longevity_plot, save_switch, egg_sites, egg_layers)

            %% Longevity/%alive plot settings
            
            if longevity_plot == 1 % Longevity plot settings
                figure(1);
                hold on;
                set(gca,'ylim',[0 1.05]);
                title("longevity");
                ylabel('survivorship')
                set(gca,'xlim',[0 15]);
            elseif longevity_plot == 0% %alive plot settings
                figure(1);
                hold on;
                set(gca,'ylim',[-0.000005 0.25]);
                title("proportion alive");
                %xlabel('days');
                ylabel('survivor/emergence convolution')
                set(gca,'xlim',[50 200]);
            end

            %% Main test loop, loops through each test in Scheduler
            for i = 1:length(self.scheduler)
                scheduler_slice = self.scheduler{i}(2:end,:);
                for j = 1:length(scheduler_slice(:,1))
                    %display("i = " + i + ", j = " + j);

                    %% Create temporary PopA slice
                    emer.mean = scheduler_slice(j,1);
                    emer.std = scheduler_slice(j,2);
                    life.mean = scheduler_slice(j,3);
                    life.std = scheduler_slice(j,4);
                    tiss.mean = scheduler_slice(j,5);
                    tiss.std = scheduler_slice(j,6);
                    plong.mean = scheduler_slice(j,7);
                    plong.std = scheduler_slice(j,8);
                    PopAtmp = Population('', '', emer, life, tiss, 0, 0, plong);

                    %% Create temporary Pop B slice
                    emer.mean = scheduler_slice(j,9);
                    emer.std = scheduler_slice(j,10);
                    life.mean = scheduler_slice(j,11);
                    life.std = scheduler_slice(j,12);
                    tiss.mean = scheduler_slice(j,13);
                    tiss.std = scheduler_slice(j,14);
                    plong.mean = scheduler_slice(j,15);
                    plong.std = scheduler_slice(j,16);
                    PopBtmp = Population('', '', emer, life, tiss, 0, 0, plong);

                    %% Calculate TI and distributions for Temporary Populations
                    [TI, PopAtmp, PopBtmp] = self.TemporalIsolation(type, cdf_type, pdf_type, PopAtmp, PopBtmp, egg_sites, egg_layers);
                    self.TIall{i}(j) = TI;
                    %display(self.TIall(i));

                    %% Plot Longevity/%alive
                    if longevity_plot ~= -1
                        self.SurvivorPlot(longevity_plot, '', PopAtmp);
                    end
                end
            end
            xlabel('days');

            %% Save Longevity/%alive plot
            if save_switch 
                saveas(i,"fig"+string(i)+".jpg");
            end
        end

        %% ------------------------------------------------------------------
        % TempIso function
        % Description:
        % Calculates the temporal isolation between 2 populations using
        % the selected method of calculation
        % Implemented methods of calculation include:
        % - Convolution ('conv')
        % - Monte-Carlo ('rng')
        %
        % Inputs:
        % - type, method of finding temporal isolation ('conv' for conv
        % -olution, 'rng' for Monte-Carlo)
        % - cdf_type, method of cdf calculation (see cdf function docum
        % -entation for list of usable strings)
        % - pdf_type, method of pdf calculation (see pdf function docum
        % -entation for list of usable strings)
        %
        % Outputs:
        % - TI, Temporal Isolation calculated value, using Hood 2019
        % equation, room to add other calculation methods
        % - PopA, altered struct/object of population type
        % - PopB, altered struct/object of population type
        %
        % TODO:
        % - Add more calculation types, add way to use other temporal
        % isolation formulas if desired
        function [TI, PopAtmp, PopBtmp] = TemporalIsolation(self, type, cdf_type, pdf_type, PopAtmp, PopBtmp, egg_sites, egg_layers)
            %% Declare timespan%
            timespan = 1:365;

            %% Create empty vectors
            PopAtmp.tissue.distribution = zeros(size(timespan));
            PopAtmp.emergence.distribution = zeros(size(timespan));
            PopAtmp.lifespan.distribution = zeros(size(timespan));
            PopAtmp.plong.distribution = zeros(size(timespan));
            PopBtmp.tissue.distribution = zeros(size(timespan));
            PopBtmp.emergence.distribution = zeros(size(timespan));
            PopBtmp.lifespan.distribution = zeros(size(timespan));
            PopBtmp.plong.distribution = zeros(size(timespan));
            
            %% Calculate distributions
            %   Use PDF for tissue and emergence distribution and 1-CDF for
            %   lifespan distribution
            tempPDF = makedist(pdf_type, PopAtmp.tissue.mean, PopAtmp.tissue.std);
            PopAtmp.tissue.distribution = pdf(tempPDF, timespan);
            tempPDF = makedist(pdf_type, PopBtmp.tissue.mean, PopBtmp.tissue.std);
            PopBtmp.tissue.distribution = pdf(tempPDF, timespan);
            tempPDF = makedist(pdf_type, PopAtmp.emergence.mean, PopAtmp.emergence.std);
            PopAtmp.emergence.distribution = pdf(tempPDF, timespan);
            tempPDF = makedist(pdf_type, PopBtmp.emergence.mean, PopBtmp.emergence.std);
            PopBtmp.emergence.distribution = pdf(tempPDF, timespan);
            tempCDF = makedist(cdf_type, PopAtmp.lifespan.mean, PopAtmp.lifespan.std);
            PopAtmp.lifespan.distribution = 1-cdf(tempCDF, timespan);
            tempCDF = makedist(cdf_type, PopBtmp.lifespan.mean, PopBtmp.lifespan.std);
            PopBtmp.lifespan.distribution = 1-cdf(tempCDF, timespan);
            tempCDF = makedist(cdf_type, PopAtmp.plong.mean, PopAtmp.plong.std);
            PopAtmp.plong.distribution = 1-cdf(tempCDF, timespan);
            tempCDF = makedist(cdf_type, PopBtmp.plong.mean, PopBtmp.plong.std);
            PopBtmp.plong.distribution = 1-cdf(tempCDF, timespan);
            
            plant_alive_A_dist = conv(PopAtmp.tissue.distribution, PopAtmp.plong.distribution);
            plant_alive_A_dist = plant_alive_A_dist(1:365);
            plant_alive_B_dist = conv(PopBtmp.tissue.distribution, PopBtmp.plong.distribution);
            plant_alive_B_dist = plant_alive_B_dist(1:365);

%             egg_sites_A = PopAtmp.tissue.distribution * egg_sites;
%             egg_sites_B = PopBtmp.tissue.distribution * egg_sites;
            egg_sites_A = plant_alive_A_dist * egg_sites;
            egg_sites_B = plant_alive_B_dist * egg_sites;
            PopAtmp.alive = conv(PopAtmp.emergence.distribution, PopAtmp.lifespan.distribution);
            PopAtmp.alive = PopAtmp.alive(1:365);
            PopBtmp.alive = conv(PopBtmp.emergence.distribution, PopBtmp.lifespan.distribution);
            PopBtmp.alive = PopBtmp.alive(1:365);
            egg_layer_A = PopAtmp.alive * egg_layers;
            egg_layer_B = PopBtmp.alive * egg_layers;

            %% %alive distribution calculated
            if type == "conv" % Convolution method
                PopAtmp.alive = conv(PopAtmp.emergence.distribution, PopAtmp.lifespan.distribution);
                PopAtmp.alive = PopAtmp.alive(1:365);
                PopBtmp.alive = conv(PopBtmp.emergence.distribution, PopBtmp.lifespan.distribution);
                PopBtmp.alive = PopBtmp.alive(1:365);
            elseif type == "rng" % Random number generation/Monte Carlo method
                birth_PopA = random(PopAtmp.emergence.distribution, PopAtmp.population, 1);
                death_PopA = birth_PopA + random(PopAtmp.lifespan.distribution, PopAtmp.population, 1);
                for i = 1:PopAtmp.population
                    tmp(i, floor(birth_PopA(i)):ceil(death_PopA(i))) = 1;
                end
                
                PopAtmp.alive = sum(tmp);
                
                birth_PopB = random(PopBtmp.emergence.distribution, PopBtmp.population, 1);
                death_PopB = birth_PopB + random(PopBtmp.lifespan.distribution, PopBtmp.population, 1);
                for i = 1:PopBtmp.population
                    tmp(i, floor(birth_PopB(i)):ceil(death_PopB(i))) = 1;
                end
                
                PopBtmp.alive = sum(tmp);
            elseif type == "iantest"
                PopAtmp.alive = conv(PopAtmp.emergence.distribution, PopAtmp.lifespan.distribution);
                PopAtmp.alive = conv(PopAtmp.alive, PopAtmp.tissue.distribution);
                PopAtmp.alive = PopAtmp.alive(1:365);
                PopBtmp.alive = conv(PopBtmp.emergence.distribution, PopBtmp.lifespan.distribution);
                PopBtmp.alive = conv(PopBtmp.alive, PopBtmp.tissue.distribution);
                PopBtmp.alive = PopBtmp.alive(1:365);
            elseif type == "ratio1"
                for i = 1:length(PopAtmp.alive)
                    PTratio_A = min(egg_sites_A(i)/egg_layer_A(i), 1);
                    PTratio_B = min(egg_sites_B(i)/egg_layer_B(i), 1);
                    PopAtmp.alive(i) = PopAtmp.alive(i) * PTratio_A;
                    PopBtmp.alive(i) = PopBtmp.alive(i) * PTratio_B;
                end
            elseif type == "ratio2"
                for i = 1:length(PopAtmp.alive)
                    if egg_sites_A(i) >= egg_layer_A(i)
                        PTratio_A = 1;
                    else
                        PTratio_A = 0;
                    end
                    if egg_sites_B(i) >= egg_layer_B(i)
                        PTratio_B = 1;
                    else
                        PTratio_B = 0;
                    end
                    PopAtmp.alive(i) = PopAtmp.alive(i) * PTratio_A;
                    PopBtmp.alive(i) = PopBtmp.alive(i) * PTratio_B;
                end
            end
%             
%             figure();
%             hold on; 
%             plot(365,PopAtmp.emergence.distribution, 'DisplayName', 'emergence');
%             plot(365,PopAtmp.lifespan.distribution, 'DisplayName', 'lifespan');
%             plot(365,PopAtmp.tissue.distribution, 'DisplayName', 'tissue');
%             hold off;
%             figure();
%             plot(365,PopAtmp.alive,'DisplayName','alive');
            
            %% TI calculation
            TI = 1-sum(PopAtmp.alive.*PopBtmp.alive)/sqrt(sum(PopAtmp.alive.^2)*sum(PopBtmp.alive.^2));
        end

        %% CreateScheduler
        %   Creates a cartesian matrix (scheduler) that lists each unique
        %   test given the list of settings for 12 different variables
        %   across 2 populations
        function [scheduler_tmp] = CreateScheduler(self, sets)
            [Total{1:16}] = ndgrid(sets{:});
            for i = 1:16
                scheduler_tmp(:, i) = Total{i}(:);
            end
            scheduler_tmp = unique(scheduler_tmp, 'rows');
        end
        
        function self = CreateSchedulerSlice(self, pop1, pop2, boolean)
            sets{1} = pop1.emergence.mean;
            sets{2} = pop1.emergence.std;
            sets{3} = pop1.lifespan.mean;
            sets{4} = pop1.lifespan.std;
            sets{5} = pop1.tissue.mean;
            sets{6} = pop1.tissue.std;
            sets{7} = pop1.plong.mean;
            sets{8} = pop1.plong.std;
            sets{9} = pop2.emergence.mean;
            sets{10} = pop2.emergence.std;
            sets{11} = pop2.lifespan.mean;
            sets{12} = pop2.lifespan.std;
            sets{13} = pop2.tissue.mean;
            sets{14} = pop2.tissue.std;
            sets{15} = pop2.plong.mean;
            sets{16} = pop2.plong.std;
            self.scheduler{1,end+1} = [boolean; self.CreateScheduler(sets)];
            %self.scheduler{2,end+1} = boolean;
            self.TIall{end+1} = zeros(1, (length(self.scheduler{1}(:,1))-1));
        end
        
        function self = UploadSchedulerSlice(self, slice, boolean)
            self.scheduler{1,end+1} = [boolean; slice];
            %self.scheduler{2,end+1} = boolean;
            self.TIall{end+1} = zeros(1, (length(self.scheduler{1}(:,1))-1));
        end
        
        function ScheduledSlices(self, m, n, heatmap, seed)
            names = ["Population A emergence \mu", ...
                "Population A emergence \sigma",...
                "Population A lifespan \mu",...
                "Population A lifespan \sigma",...
                "Population A tissue \mu",...
                "Population A tissue \sigma",...
                "Population A plant longevity \mu",...
                "Population A plant longevity \sigma",...
                "Population B emergence \mu", ...
                "Population B emergence \sigma",...
                "Population B lifespan \mu",...
                "Population B lifespan \sigma",...
                "Population B tissue \mu",...
                "Population B tissue \sigma",...
                "Population B plant longevity \mu",...
                "Population B plant longevity \sigma"];

            for k = 1:66
                vector_switch = 1;
                schedulerTmp = self.scheduler{k};
                TIallTmp = self.TIall{k};
                vectors = zeros(1,length(schedulerTmp(:,1))-1);
                base = [];
                for i = 1:16
                    if schedulerTmp(1,i)==1
                        if vector_switch == 1
                            vectors(1,:) = schedulerTmp(2:end, i);
                            axisnamex = names(i);
                            vector_switch = vector_switch + 1;
                        else
                            vectors(2,:) = schedulerTmp(2:end, i);
                            axisnamey = names(i);
                            o_or_e = i;
                        end
                    else
                        base(end+1) = schedulerTmp(2,i);
                    end
                end
                figure();
                ah = axes;
                hold on;
                p=plot(reshape(vectors(1,:), m, n).', reshape(TIallTmp(1:end), m, n),'-o', 'LineWidth',2, 'Parent', ah);
                for i = 1:length(p)
                    p(i).Color = [0 .5 1-(i/m)];
                    p(i).MarkerFaceColor = [0 .5 1-(i/m)];
                end
                if mod(o_or_e, 2) == 1
                    lh = legend(ah, p, "\mu = " + num2str(round(vectors(2,1:n).',2)),'NumColumns',2,'Location','northeastoutside');
                elseif mod(o_or_e, 2) == 0
                    lh = legend(ah, p, "\sigma = " + num2str(round(vectors(2,1:n).',2)),'NumColumns',2,'Location','northeastoutside');
                end
                ah2 = copyobj(ah,gcf);
                delete(get(ah2,'Children'));
                p1=plot(1:365, [1:365;1:365;1:365;1:365;1:365;1:365;1:365;1:365;1:365;1:365;1:365;1:365], 'Parent', ah2,'Visible','off');
                set(ah2, 'Color', 'none', 'XTick', [], 'YColor', 'none', 'Box', 'Off')
                lh2 = legend(ah2, p1,num2str(seed.'), 'Location', 'southeastoutside');
                lh2.NumColumns = 2;
                hold off;
                title(legend,axisnamey)
                xlabel(axisnamex)
                ylabel("TI")
                if heatmap
                    figure();
                    imagesc(vectors(1,:),vectors(2,:), reshape(TIallTmp, m, n).');
                    colorbar;
                    xlabel(axisnamex);
                    ylabel(axisnamey);
                    title("Temporal Isolation");
                    set(gca,'ydir','normal');
                end
            end
        end
    end
end