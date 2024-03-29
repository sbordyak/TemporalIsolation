classdef TemporalIsolationModel
    properties
        TIall; % TIall matrix, hold TI data for each test
        scheduler; % Scheduler matrix, holds each test being run at a time
        seed; % Starting values for test
        test_range; % Range of test values for stationary variables
        tests; % Number of tests per test value in test_range
        settingsArray; % settingsArray vector of variable status, 1 = stationary variable, 0 = randomized variable
        emergences;
        values_mat;
    end
    methods
        %% Constructor
        %   Calls RNGTest which creates the scheduler matrix and runs the 
        %   function that calculates Temporal Isolation for each test.
        %
        %   RNGTest -> Create Scheduler -> Calculate TI -> Produce TI Data for plotting
        function self = TemporalIsolationModel(stationary_variables, options, seed, settingsArray, values_mat, test_range, tests)
            self.scheduler = {};
            self.seed = seed;
            self.test_range = test_range;
            self.tests = tests;
            self.settingsArray = settingsArray;
            self.values_mat = values_mat;
            self = self.IncrementalTest(options);
        end

        %% SchedulerTest
        %   New Test function based on the concept of the scheduler matrix,
        %   allows us to create as many new tests/cases that we choose
        %   while changing any variable (across eitchangingIndex2her population) that we
        %   like`   
        function self = SchedulerTest(self, type, cdf_type, pdf_type, egg_sites, egg_layers, plant_switch, incremental_or_RNG)
            %% Main test loop, loops through each test in Scheduler
            for i = 1:length(self.scheduler)
                scheduler_slice = self.scheduler{i}(2:end,:);
                for j = 1:length(scheduler_slice(:,1))

                    %% Create temporary PopA slice
                    if incremental_or_RNG == 1 && self.settingsArray(1) == 0
                        emer.mean = self.values_mat{1}(1,1) + abs(self.values_mat{1}(1,2) * randn(1));                
                    else
                        emer.mean = scheduler_slice(j,1);
                    end

                    if incremental_or_RNG == 1 && self.settingsArray(2) == 0
                        emer.std = self.values_mat{1}(2,1) + abs(self.values_mat{1}(2,2) * randn(1));                
                    else
                        emer.std = scheduler_slice(j,2);
                    end

                    if incremental_or_RNG == 1 && self.settingsArray(3) == 0
                        life.mean = self.values_mat{2}(1,1) + abs(self.values_mat{2}(1,2) * randn(1));                
                    else
                        life.mean = scheduler_slice(j,3);
                    end

                    if incremental_or_RNG == 1 && self.settingsArray(4) == 0
                        life.std = self.values_mat{2}(2,1) + abs(self.values_mat{2}(2,2) * randn(1));                
                    else
                        life.std = scheduler_slice(j,4);
                    end

                    if incremental_or_RNG == 1 && self.settingsArray(5) == 0
                        tiss.mean = self.values_mat{3}(1,1) + abs(self.values_mat{3}(1,2) * randn(1));                
                    else
                        tiss.mean = scheduler_slice(j,5);
                    end

                    if incremental_or_RNG == 1 && self.settingsArray(6) == 0
                        tiss.std = self.values_mat{3}(2,1) + abs(self.values_mat{3}(2,2) * randn(1));                
                    else
                        tiss.std = scheduler_slice(j,6);
                    end

                    if incremental_or_RNG == 1 && self.settingsArray(7) == 0
                        plong.mean = self.values_mat{4}(1,1) + abs(self.values_mat{4}(1,2) * randn(1));                
                    else
                        plong.mean = scheduler_slice(j,7);
                    end

                    if incremental_or_RNG == 1 && self.settingsArray(8) == 0
                        plong.std = self.values_mat{4}(2,1) + abs(self.values_mat{4}(2,2) * randn(1));                
                    else
                        plong.std = scheduler_slice(j,8);
                    end
                    PopAtmp = Population('', '', emer, life, tiss, 0, 0, plong);


                    %% Create temporary PopB slice
                    if incremental_or_RNG == 1 && self.settingsArray(9) == 0
                        emer.mean = self.values_mat{5}(1,1) + abs(self.values_mat{5}(1,2) * randn(1));                
                    else
                        emer.mean = scheduler_slice(j,9);
                    end

                    if incremental_or_RNG == 1 && self.settingsArray(10) == 0
                        emer.std = self.values_mat{5}(2,1) + abs(self.values_mat{5}(2,2) * randn(1));                
                    else
                        emer.std = scheduler_slice(j,10);
                    end

                    if incremental_or_RNG == 1 && self.settingsArray(11) == 0
                        life.mean = self.values_mat{6}(1,1) + abs(self.values_mat{6}(1,2) * randn(1));                
                    else
                        life.mean = scheduler_slice(j,11);
                    end

                    if incremental_or_RNG == 1 && self.settingsArray(12) == 0
                        life.std = self.values_mat{6}(2,1) + abs(self.values_mat{6}(2,2) * randn(1));                
                    else
                        life.std = scheduler_slice(j,12);
                    end

                    if incremental_or_RNG == 1 && self.settingsArray(13) == 0
                        tiss.mean = self.values_mat{7}(1,1) + abs(self.values_mat{7}(1,2) * randn(1));                
                    else
                        tiss.mean = scheduler_slice(j,13);
                    end

                    if incremental_or_RNG == 1 && self.settingsArray(14) == 0
                        tiss.std = self.values_mat{7}(2,1) + abs(self.values_mat{7}(2,2) * randn(1));                
                    else
                        tiss.std = scheduler_slice(j,14);
                    end

                    if incremental_or_RNG == 1 && self.settingsArray(15) == 0
                        plong.mean = self.values_mat{8}(1,1) + abs(self.values_mat{8}(1,2) * randn(1));                
                    else
                        plong.mean = scheduler_slice(j,15);
                    end

                    if incremental_or_RNG == 1 && self.settingsArray(16) == 0
                        plong.std = self.values_mat{8}(2,1) + abs(self.values_mat{8}(2,2) * randn(1));                
                    else
                        plong.std = scheduler_slice(j,16);
                    end
                    PopBtmp = Population('', '', emer, life, tiss, 0, 0, plong);

                    %% Calculate TI and distributions for Temporary Populations
                    [TI, aliveA, aliveB] = self.TemporalIsolation(type, cdf_type, pdf_type, PopAtmp, PopBtmp, egg_sites, egg_layers, plant_switch);
                    self.emergences{end+1} = [ aliveA; aliveB ];
                    self.TIall{i}(j) = TI;
                end
            end
        end

        %% TempIso function
        %   Description:
        %   Calculates the temporal isolation between 2 populations using
        %   the selected method of calculation
        %
        %   Inputs:
        %   - type, method of finding temporal isolation ('conv' for convolution, 'rng' for Monte-Carlo)
        %   - cdf_type, method of cdf calculation (see cdf function documentation for list of usable strings)
        %   - pdf_type, method of pdf calculation (see pdf function documentation for list of usable strings)
        %
        %   Outputs:
        %   - TI, Temporal Isolation calculated value, using Hood 2019 equation, room to add other calculation methods
        %   - PopA, altered struct/object of population type
        %   - PopB, altered struct/object of population type
        function [TI, aliveA, aliveB]= TemporalIsolation(self, type, cdf_type, pdf_type, PopAtmp, PopBtmp, egg_sites, egg_layers, plant_switch)
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
            tempPDF = makedist(pdf_type, PopAtmp.emergence.mean, PopAtmp.emergence.std);
            PopAtmp.emergence.distribution = pdf(tempPDF, timespan);
            tempPDF = makedist(pdf_type, PopBtmp.emergence.mean, PopBtmp.emergence.std);
            PopBtmp.emergence.distribution = pdf(tempPDF, timespan);
            tempCDF = makedist(cdf_type, PopAtmp.lifespan.mean, PopAtmp.lifespan.std);
            PopAtmp.lifespan.distribution = 1-cdf(tempCDF, timespan);
            tempCDF = makedist(cdf_type, PopBtmp.lifespan.mean, PopBtmp.lifespan.std);
            PopBtmp.lifespan.distribution = 1-cdf(tempCDF, timespan);
            if plant_switch == 1
                tempPDF = makedist(pdf_type, PopAtmp.tissue.mean, PopAtmp.tissue.std);
                PopAtmp.tissue.distribution = pdf(tempPDF, timespan);
                tempPDF = makedist(pdf_type, PopBtmp.tissue.mean, PopBtmp.tissue.std);
                PopBtmp.tissue.distribution = pdf(tempPDF, timespan);
                tempCDF = makedist(cdf_type, PopAtmp.plong.mean, PopAtmp.plong.std);
                PopAtmp.plong.distribution = 1-cdf(tempCDF, timespan);
                tempCDF = makedist(cdf_type, PopBtmp.plong.mean, PopBtmp.plong.std);
                PopBtmp.plong.distribution = 1-cdf(tempCDF, timespan);
                plant_alive_A_dist = conv(PopAtmp.tissue.distribution, PopAtmp.plong.distribution);
                plant_alive_A_dist = plant_alive_A_dist(1:365);
                plant_alive_B_dist = conv(PopBtmp.tissue.distribution, PopBtmp.plong.distribution);
                plant_alive_B_dist = plant_alive_B_dist(1:365);
                egg_sites_A = plant_alive_A_dist * egg_sites;
                egg_sites_B = plant_alive_B_dist * egg_sites;
            else
                egg_sites_A = egg_sites;
                egg_sites_B = egg_sites;
            end

            PopAtmp.alive = conv(PopAtmp.emergence.distribution, PopAtmp.lifespan.distribution);
            PopAtmp.alive = PopAtmp.alive(1:365);
            PopBtmp.alive = conv(PopBtmp.emergence.distribution, PopBtmp.lifespan.distribution);
            PopBtmp.alive = PopBtmp.alive(1:365);
            egg_layer_A = PopAtmp.alive * egg_layers;
            egg_layer_B = PopBtmp.alive * egg_layers;

            %% %alive distribution calculated
            if type == "ratio1"
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
            
            %% TI calculation
            aliveA = PopAtmp.alive;
            aliveB = PopBtmp.alive;
            aliveA = PopAtmp.emergence.distribution;
            aliveB = PopBtmp.emergence.distribution;
            %self.emergences{end+1} = [ PopAtmp.alive; PopBtmp.alive ];
            TI = 1-sum(PopAtmp.alive.*PopBtmp.alive)/sqrt(sum(PopAtmp.alive.^2)*sum(PopBtmp.alive.^2));
        end

        %% CreateScheduler
        %   Creates a cartesian matrix (scheduler) that lists each unique
        %   test given the list of settings for 12 different variables
        %   across 2 populations.
        function [scheduler_tmp] = CreateScheduler(self, sets)
            [Total{1:16}] = ndgrid(sets{:});
            for i = 1:16
                scheduler_tmp(:, i) = Total{i}(:);
            end
            scheduler_tmp = unique(scheduler_tmp, 'rows');
        end
        
        %% CreateSchedulerSlice
        %   Creates a slice in the z direction of the scheduler matrix to
        %   be added to the rest of the matrix.
        function self = CreateSchedulerSlice(self, pop1, pop2, settingsArray)
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
            self.scheduler{end+1} = [settingsArray; self.CreateScheduler(sets)];
            self.TIall{end+1} = zeros(1, (length(self.scheduler{1}(:,1))-1));
        end
        
        %% UploadSchedulerSlice
        %   Uploads a scheduler slice to the object that was created outside
        %   the class.
        function self = UploadSchedulerSlice(self, slice, settingsArray)
            self.scheduler{end+1} = [settingsArray; slice];
            self.TIall{end+1} = zeros(1, (length(self.scheduler{1}(:,1))-1));
        end
        
        function self = IncrementalTest(self, options)
            locationArray = find(self.settingsArray==1);

            sets = {};
            for i = 1:16
                if ismember(i,locationArray) == 1
                    sets{end+1} = self.seed(i) + self.test_range;
                else
                    sets{end+1} = self.seed(i);
                end
            end
            
            self.scheduler{end+1} = [self.settingsArray; self.CreateScheduler(sets)];
            self.TIall{end+1} = zeros(1, (length(self.scheduler{1}(:,1))-1));
            
            
            self = self.SchedulerTest(options{1}, options{2}, options{3}, options{4}, options{5}, options{6}, options{7});
        end
        
        %% RNGTest - DEPRECATED
        %   Function that takes in which variables are kept stable, a vector of
        %   options for the TestModel class, a seed vector of base values, a settingsArray
        %   vector of which values are being changed, emergence base value matrix,
        %   lifespan base value matrix, tissue base value matrix, plant longevity
        %   base value matrix, test_range range of values to test the base values at,
        %   number of tests to perform for each value, and a test switch value to
        %   determine which test needs to be performed
        %
        %   Options: 1 - type
        %            2 - cdf_type
        %            3 - pdf_type
        %            4 - egg_sites
        %            5 - egg_layers
        %            6 - plant_switch
        function self = RNGTest(self, stationary_variables, options, seed, settingsArray, values_mat, test_range, tests, changing_variable)
            scheduler_slice = zeros(16,length(test_range)*tests).';
            sep = 0;
            for i = 1:length(test_range)*tests
                %% test_range calculator
                % Determines if enough random tests have been done at this value
                if mod(i-1, tests) == 0
                    sep = sep + 1;
                end
                
                %% Randomization
                % Randomization code, uses RANDN function as part of MATLAB
                em_mat = values_mat{1};
                life_mat = values_mat{2};
                tiss_mat = values_mat{3};
                plong_mat = values_mat{4};
                scheduler_slice(i,1) = em_mat(1,1) + em_mat(1,2) * randn(1);
                scheduler_slice(i,2) = em_mat(2,1) + em_mat(2,2) * randn(1);
                scheduler_slice(i,3) = life_mat(1,1) + life_mat(1,2) * randn(1);
                scheduler_slice(i,4) = life_mat(2,1) + life_mat(2,2) * randn(1);
                if options{6} == 1 % If plant values are to be included
                    scheduler_slice(i,5) = tiss_mat(1,1) + tiss_mat(1,2) * randn(1);
                    scheduler_slice(i,6) = tiss_mat(2,1) + tiss_mat(2,2) * randn(1);
                    scheduler_slice(i,7) = plong_mat(1,1) + plong_mat(1,2) * randn(1);
                    scheduler_slice(i,8) = plong_mat(2,1) + plong_mat(2,2) * randn(1);
                else
                    scheduler_slice(i,5) = 0;
                    scheduler_slice(i,6) = 0;
                    scheduler_slice(i,7) = 0;
                    scheduler_slice(i,8) = 0;
                end

                em_mat = values_mat{5};
                life_mat = values_mat{6};
                tiss_mat = values_mat{7};
                plong_mat = values_mat{8};
                scheduler_slice(i,9) = em_mat(1,1) + em_mat(1,2) * randn(1);
                scheduler_slice(i,10) = em_mat(2,1) + em_mat(2,2) * randn(1);
                scheduler_slice(i,11) = life_mat(1,1) + life_mat(1,2) * randn(1);
                scheduler_slice(i,12) = life_mat(2,1) + life_mat(2,2) * randn(1);
                if options{6} == 1 % If plant values are to be included
                    scheduler_slice(i,13) = tiss_mat(1,1) + tiss_mat(1,2) * randn(1);
                    scheduler_slice(i,14) = tiss_mat(2,1) + tiss_mat(2,2) * randn(1);
                    scheduler_slice(i,15) = plong_mat(1,1) + plong_mat(1,2) * randn(1);
                    scheduler_slice(i,16) = plong_mat(2,1) + plong_mat(2,2) * randn(1);
                else
                    scheduler_slice(i,13) = 0;
                    scheduler_slice(i,14) = 0;
                    scheduler_slice(i,15) = 0;
                    scheduler_slice(i,16) = 0;
                end

                %% Stabilization
                % Keeps values that need to stay the same, the same
                locationArray = find(settingsArray==1);
                for j = locationArray
                    if j == changing_variable
                        scheduler_slice(i,j) = seed(j) + test_range(sep);
                    else
                        scheduler_slice(i,j) = seed(j);
                    end
                end

                %% DEPRECATED FOR NOW
                %switch stationary_variables
                %    case 1
                %        %% For 1 stationary value
                %        for j = 1:16
                %            if settingsArray(j) == 1
                %                scheduler_slice(i,j) = seed(j) + test_range(sep);
                %            end
                %        end
                %    case 2
                %        %% For 2 stationary values
                %        swap = 1;
                %        if changing_variable == 1
                %            for j = 1:16
                %                if swap == 1 && settingsArray(j) == 1 
                %                    scheduler_slice(i,j) = seed(j) + test_range(sep);
                %                    if j == 1
                %                        scheduler_slice(i,5) = scheduler_slice(i,5) + test_range(sep);
                %                    end
                %                    swap = 2;
                %                elseif settingsArray(j) == 1
                %                    scheduler_slice(i,j) = seed(j);
                %                end
                %            end
                %        elseif changing_variable == 2
                %            for j = 1:16
                %                if swap == 1 && settingsArray(j) == 1 
                %                    scheduler_slice(i,j) = seed(j);
                %                    if j == 1
                %                        scheduler_slice(i,5) = scheduler_slice(i,5) + test_range(sep);
                %                    end
                %                    swap = 2;
                %                elseif settingsArray(j) == 1
                %                    scheduler_slice(i,j) = seed(j) + test_range(sep);
                %                end
                %            end
                %        end
                %end
            end
            %scheduler_slice(:,:);
            self.scheduler{end+1} = [settingsArray; abs(scheduler_slice(:,:))];
            self.TIall{end+1} = zeros(1, (length(self.scheduler{1}(:,1))-1));
        
            self = self.SchedulerTest(options{1}, options{2}, options{3}, options{4}, options{5}, options{6});
        end    
    end
end