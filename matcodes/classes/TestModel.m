classdef TestModel
    properties
        PopA; % Population A object of type Population  
        PopB; % Population B object of type Population
        TIall; % TIall matrix, hold TI data for each test
        m; % M dimension value for TIall, use with RunTest
        n; % N dimension value for TIall, use with RunTest
        scheduler; % Scheduler matrix, holds each test being run at a time
    end
    methods
        %% TestModel Constructor
        %   Creates an object of type TestModel given 2 population objects
        %   and the dimensions of the TIall matrix
        function self = TestModel(pop1, pop2, m_in, n_in)
            self.PopA = pop1;
            self.PopB = pop2;
            self.m = m_in;
            self.n = n_in;
            sets{1} = pop1.emergence.mean;
            sets{2} = pop1.emergence.std;
            sets{3} = pop1.lifespan.mean;
            sets{4} = pop1.lifespan.std;
            sets{5} = pop1.tissue.mean;
            sets{6} = pop1.tissue.std;
            sets{7} = pop2.emergence.mean;
            sets{8} = pop2.emergence.std;
            sets{9} = pop2.lifespan.mean;
            sets{10} = pop2.lifespan.std;
            sets{11} = pop2.tissue.mean;
            sets{12} = pop2.tissue.std;
            [self.scheduler] = self.CreateScheduler(sets);
            self.TIall = zeros(1,length(self.scheduler(:,1)));
        end

        %% RunTest
        %   Original test function based on TemporalIsolation.m and
        %   ModelingScript.m, replaced by SchedulerTest due to faster
        %   running time and better generalized design
        function RunTest(self, changing_variable, type, cdf_type, pdf_type, longevity_plot, save_switch)
            %if changing_variable == 1
            %    m = length(self.PopA.lifespan.mean);
            %    n = length(self.PopA.lifespan.std);
            %elseif changing_variable == 2
            %    m = length(self.PopA.emergence.mean);
            %    n = length(self.PopA.emergence.std);
            %elseif changing_variable == 3
            %    m = length(self.PopA.tissue.mean);
            %    n = length(self.PopA.tissue.std);
            %end

            for i = 1:self.m
                figure(i);
                hold on;
                if longevity_plot
                    set(gca,'ylim',[0 1.05]);
                    title("longevity");
                    ylabel('survivorship')
                    set(gca,'xlim',[0 15]);
                else
                    set(gca,'ylim',[-0.000005 0.25]);
                    title("proportion alive");
                    %xlabel('days');
                    ylabel('survivor/emergence convolution')
                    set(gca,'xlim',[50 200]);
                end
                for j = 1:self.n
                    PopAtmp = self.PopA;
                    PopBtmp = self.PopB;
                    if changing_variable == 1
                        PopAtmp.lifespan.mean = self.PopA.lifespan.mean(i);
                        PopAtmp.lifespan.std = self.PopA.lifespan.std(j);
                        temp = ['μ = ', num2str(self.PopA.lifespan.mean(i)), 'σ = ', num2str(self.PopA.lifespan.std(j))];
                    elseif changing_variable == 2
                        PopAtmp.emergence.mean = self.PopA.emergence.mean(i);
                        PopAtmp.emergence.std = self.PopA.emergence.std(j);
                        temp = ['μ = ', num2str(self.PopA.emergence.mean(i)), 'σ = ', num2str(self.PopA.emergence.std(j))];
                    elseif changing_variable == 3
                        PopAtmp.tissue.mean = self.PopA.tissue.mean(i);
                        PopAtmp.tissue.std = self.PopA.tissue.std(j);
                        temp = ['μ = ', num2str(self.PopA.tissue.mean(i)), ' σ = ', num2str(self.PopA.tissue.std(j))];
                    end
                    
                    [TI, PopAtmp, PopBtmp] = self.TemporalIsolation(type, cdf_type, pdf_type, PopAtmp, PopBtmp);
                    self.SurvivorPlot(longevity_plot, temp, PopAtmp);
                    self.TIall(i, j) = TI;
                end
                xlabel('days');
                if save_switch
                    saveas(i,"fig"+string(i)+".jpg");
                end
            end

            figure(7);
            hold on;
            if longevity_plot
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
            for i = 1:length(self.PopA.lifespan.mean)

                PopAtmp = self.PopA;
                PopBtmp = self.PopB;
                %temp_index = mod(j-i,length(PopA.lifespan.mean));
                PopAtmp.lifespan.mean = self.PopA.lifespan.mean(i);
                PopAtmp.lifespan.std = self.PopA.lifespan.std(i);
                TI = 0;

                [TI, PopAtmp,PopBtmp] = self.TemporalIsolation(type, cdf_type, pdf_type, PopAtmp, PopBtmp);
                
                self.SurvivorPlot(longevity_plot, '', PopAtmp);
            end
            if save_switch
                saveas(7, "fig7.jpg");
            end


        end

        %% SchedulerTest
        %   New Test function based on the concept of the scheduler matrix,
        %   allows us to create as many new tests/cases that we choose
        %   while changing any variable (across either population) that we
        %   like
        function self = SchedulerTest(self, type, cdf_type, pdf_type, longevity_plot, save_switch)

            %% Longevity/%alive plot settings
            figure(1);
            hold on;
            if longevity_plot % Longevity plot settings
                set(gca,'ylim',[0 1.05]);
                title("longevity");
                ylabel('survivorship')
                set(gca,'xlim',[0 15]);
            else % %alive plot settings
                set(gca,'ylim',[-0.000005 0.25]);
                title("proportion alive");
                %xlabel('days');
                ylabel('survivor/emergence convolution')
                set(gca,'xlim',[50 200]);
            end

            %% Main test loop, loops through each test in Scheduler
            for i = 1:length(self.scheduler(:,1))
                
                %% Create temporary PopA slice
                emer.mean = self.scheduler(i,1);
                emer.std = self.scheduler(i,2);
                life.mean = self.scheduler(i,3);
                life.std = self.scheduler(i,4);
                tiss.mean = self.scheduler(i,5);
                tiss.std = self.scheduler(i,6);
                PopAtmp = Population('', '', emer, life, tiss, 0, 0);

                %% Create temporary Pop B slice
                emer.mean = self.scheduler(i,7);
                emer.std = self.scheduler(i,8);
                life.mean = self.scheduler(i,9);
                life.std = self.scheduler(i,10);
                tiss.mean = self.scheduler(i,11);
                tiss.std = self.scheduler(i,12);
                PopBtmp = Population('', '', emer, life, tiss, 0, 0);

                %% Calculate TI and distributions for Temporary Populations
                [TI, PopAtmp, PopBtmp] = self.TemporalIsolation(type, cdf_type, pdf_type, PopAtmp, PopBtmp);
                self.TIall(i) = TI;
                %display(self.TIall(i));

                %% Plot Longevity/%alive
                self.SurvivorPlot(longevity_plot, '', PopAtmp);
            end
            xlabel('days');

            %% Save Longevity/%alive plot
            if save_switch 
                saveas(i,"fig"+string(i)+".jpg");
            end

            %display(self.TIall);
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
        function [TI, PopAtmp, PopBtmp] = TemporalIsolation(self, type, cdf_type, pdf_type, PopAtmp, PopBtmp)
            %% Declare timespan%
            timespan = 1:365;

            %% Create empty vectors
            PopAtmp.tissue.distribution = zeros(size(timespan));
            PopAtmp.emergence.distribution = zeros(size(timespan));
            PopAtmp.lifespan.distribution = zeros(size(timespan));
            PopBtmp.tissue.distribution = zeros(size(timespan));
            PopBtmp.emergence.distribution = zeros(size(timespan));
            PopBtmp.lifespan.distribution = zeros(size(timespan));
            
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

            %% %alive distribution calculated
            if type == 'conv' % Convolution method
                PopAtmp.alive = conv(PopAtmp.emergence.distribution, PopAtmp.lifespan.distribution);
                PopAtmp.alive = PopAtmp.alive(1:365);
                PopBtmp.alive = conv(PopBtmp.emergence.distribution, PopBtmp.lifespan.distribution);
                PopBtmp.alive = PopBtmp.alive(1:365);
            elseif type == 'rng' % Random number generation/Monte Carlo method
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
            end
            
            %% TI calculation
            TI = 1-sum(PopAtmp.alive.*PopBtmp.alive)/sqrt(sum(PopAtmp.alive.^2)*sum(PopBtmp.alive.^2));
        end

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
        function PopPlot(self)
            figure(1)
            plot(1:365,self.PopA.alive,'k',1:365,self.PopB.alive,'r')
            title(sprintf('TI = %.3f, LS mean = %d, LS std = %d',TI,self.PopA.emergence.mean,PopA.emergence.std));
            legend('Population A','Population B')
            xlabel('Julian day');ylabel('Proportion of population alive')
            set(gca,'ylim',[-.005 .05]);
            drawnow
        end

        %% ------------------------------------------------------------------
        %   HeatmapPlot function
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
        function HeatmapPlot(self, changing_variable, pop)
            %display(self.TIall);
            figure();
            if pop == 1
                if changing_variable == 1
                    imagesc(self.PopA.lifespan.mean, self.PopA.lifespan.std, reshape(self.TIall, length(self.PopA.lifespan.std), []));
                    colorbar;
                    xlabel('Population A lifespan (days)')
                    ylabel('Stdev of Population A lifespan (days)')
                end
                if changing_variable == 2
                    imagesc(self.PopA.emergence.mean, self.PopA.emergence.std, reshape(self.TIall, length(self.PopA.emergence.std), []));
                    colorbar;
                    xlabel('Population A emergence');
                    ylabel('Stdev of Population A emergence');
                end
                if changing_variable == 3
                    imagesc(self.PopA.tissue.mean, self.PopA.tissue.std, reshape(self.TIall, length(self.PopA.tissue.std), []));
                    colorbar;
                    xlabel('Population A tissue');
                    ylabel('stdev of Population A tissue');
                end
            elseif pop == 2
                if changing_variable == 1
                    imagesc(self.PopB.lifespan.mean, self.PopB.lifespan.std, reshape(self.TIall, length(self.PopB.lifespan.std), []));
                    colorbar;
                    xlabel('Population B lifespan (days)')
                    ylabel('Stdev of Population B lifespan (days)')
                end
                if changing_variable == 2
                    imagesc(self.PopB.emergence.mean, self.PopB.emergence.std, reshape(self.TIall, length(self.PopB.emergence.std), []));
                    colorbar;
                    xlabel('Population B emergence');
                    ylabel('Stdev of Population B emergence'); 
                end
                if changing_variable == 3
                    imagesc(self.PopB.tissue.mean, self.PopB.tissue.std, reshape(self.TIall, length(self.PopB.tissue.std), []));
                    colorbar;
                    xlabel('Population B tissue');
                    ylabel('stdev of Population B tissue');
                end
            end
            title('Temporal Isolation');
            set(gca, 'ydir', 'normal');
        end

        %% SurvivorPlot
        %   Plots a longevity distribution chart or percent alive
        %   distribution chart depending on the settings given to the
        %   function
        function SurvivorPlot(self, longevity_plot, leg, Pop)
            if longevity_plot
                temp = zeros(1, 365);
                temp(1) = 1;
                for i = 2:365
                    temp(i) = Pop.lifespan.distribution(i-1);
                end
                plot(0:364, temp, 'DisplayName', leg);
            elseif ~longevity_plot
                plot(0:364, Pop.alive, 'DisplayName', leg);
            end
        end

        %% CreateScheduler
        %   Creates a cartesian matrix (scheduler) that lists each unique
        %   test given the list of settings for 12 different variables
        %   across 2 populations
        function [scheduler_tmp] = CreateScheduler(self, sets)
            [Total{1:12}] = ndgrid(sets{:});
            for i = 1:12
                scheduler_tmp(:, i) = Total{i}(:);
            end
            scheduler_tmp = unique(scheduler_tmp, 'rows');
        end
    end
    
    methods(Static)
        function CompareDifference(ModelA, ModelB, changing_variable, pop)
           TIallA = ModelA.TIall;
           TIallB = ModelB.TIall;
           TIall_diff = abs(TIallA - TIallB);
           figure();
           if pop == 1
                if changing_variable == 1
                    imagesc(ModelA.PopA.lifespan.mean, ModelA.PopA.lifespan.std, reshape(TIall_diff, length(ModelA.PopA.lifespan.std), []));
                    colorbar;
                    xlabel('Population A lifespan (days)')
                    ylabel('Stdev of Population A lifespan (days)')
                end
                if changing_variable == 2
                    imagesc(ModelA.PopA.emergence.mean, ModelA.PopA.emergence.std, reshape(TIall_diff, length(ModelA.PopA.emergence.std), []));
                    colorbar;
                    xlabel('Population A emergence');
                    ylabel('Stdev of Population A emergence');
                end
                if changing_variable == 3
                    imagesc(ModelA.PopA.tissue.mean, ModelA.PopA.tissue.std, reshape(TIall_diff, length(ModelA.PopA.tissue.std), []));
                    colorbar;
                    xlabel('Population A tissue');
                    ylabel('stdev of Population A tissue');
                end
            elseif pop == 2
                if changing_variable == 1
                    imagesc(ModelA.PopB.lifespan.mean, ModelA.PopB.lifespan.std, reshape(TIall_diff, length(ModelA.PopB.lifespan.mean), []));
                    colorbar;
                    xlabel('Population B lifespan (days)')
                    ylabel('Stdev of Population B lifespan (days)')
                end
                if changing_variable == 2
                    imagesc(ModelA.PopB.emergence.mean, ModelA.PopB.emergence.std, reshape(TIall_diff, length(ModelA.PopB.emergence.std), []));
                    colorbar;
                    xlabel('Population B emergence');
                    ylabel('Stdev of Population B emergence');
                end
                if changing_variable == 3
                    imagesc(ModelA.PopB.tissue.mean, ModelA.PopB.tissue.std, reshape(TIall_diff, length(ModelA.PopB.tissue.std), []));
                    colorbar;
                    xlabel('Population B tissue');
                    ylabel('stdev of Population B tissue');
                end
           end
           title("Difference in Temporal Isolation");
           set(gca,'ydir','normal')
        end
    end
end