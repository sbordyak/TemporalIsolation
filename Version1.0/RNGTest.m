function Model = RNGTest(stationary_variables, options, seed, boolean, em_mat, life_mat, tiss_mat, plong_mat, separation, samples, test_case, changing_variable)
%% RNGTest
% Function that takes in which variables are kept stable, a vector of
% options for the TestModel class, a seed vector of base values, a boolean
% vector of which values are being changed, emergence base value matrix,
% lifespan base value matrix, tissue base value matrix, plant longevity
% base value matrix, separation range of values to test the base values at,
% number of tests to perform for each value, and a test switch value to
% determine which test needs to be performed

    scheduler = zeros(16,length(separation)*samples).';
    Model = TestModel(Population('','',0,0,0,0,0,0), Population('','',0,0,0,0,0,0), boolean, seed, 0);
    sep = 0;
    for i = 1:length(separation)*samples
       %% Separation calculator
       % Determines if enough random tests have been done at this value
       if mod(i-1, samples) == 0
           sep = sep + 1;
       end
       
       %% Randomization
       % Randomization code, uses RANDN function as part of MATLAB
       scheduler(i,1) = em_mat(1,1,1) + em_mat(1,1,2) * randn(1);
       scheduler(i,2) = em_mat(1,2,1) + em_mat(1,2,2) * randn(1);
       scheduler(i,3) = life_mat(1,1,1) + life_mat(1,1,2) * randn(1);
       scheduler(i,4) = life_mat(1,2,1) + life_mat(1,2,2) * randn(1);
       scheduler(i,5) = tiss_mat(1,1,1) + tiss_mat(1,1,2) * randn(1);
       scheduler(i,6) = tiss_mat(1,2,1) + tiss_mat(1,2,2) * randn(1);
       scheduler(i,7) = plong_mat(1,1,1) + plong_mat(1,1,2) * randn(1);
       scheduler(i,8) = plong_mat(1,2,1) + plong_mat(1,2,2) * randn(1);
       scheduler(i,9) = em_mat(2,1,1) + em_mat(2,1,2) * randn(1);
       scheduler(i,10) = em_mat(2,2,1) + em_mat(2,2,2) * randn(1);
       scheduler(i,11) = life_mat(2,1,1) + life_mat(2,1,2) * randn(1);
       scheduler(i,12) = life_mat(2,2,1) + life_mat(2,2,2) * randn(1);
       scheduler(i,13) = tiss_mat(2,1,1) + tiss_mat(2,1,2) * randn(1);
       scheduler(i,14) = tiss_mat(2,2,1) + tiss_mat(2,2,2) * randn(1);
       scheduler(i,15) = plong_mat(2,1,1) + plong_mat(2,1,2) * randn(1);
       scheduler(i,16) = plong_mat(2,2,1) + plong_mat(2,2,2) * randn(1);
       %% Stabilization
       % Keeps values that need to stay the same, the same
       switch stationary_variables
           case 1
               %% For 1 stationary value
               for j = 1:16
                   if boolean(j) == 1
                       scheduler(i,j) = seed(j) + separation(sep);
                   end
               end
           case 2
               %% For 2 stationary values
               swap = 1;
               if changing_variable == 1
                   for j = 1:16
                       if swap == 1 && boolean(j) == 1 
                           scheduler(i,j) = seed(j) + separation(sep);
                           if j == 1
                               %% Test version
                               % Keeps budbreak within range of day separation
                               % values or vice versa
                               switch (test_case)
                                   case 1
                                       scheduler(i,5) = scheduler(i,5) + separation(sep);
                                   case 2
    %                                    scheduler(i,1) = scheduler(i,1) + separation(sep);
                               end
                           end
                           swap = 2;
                       elseif boolean(j) == 1
                           scheduler(i,j) = seed(j);
                       end
                   end
               elseif changing_variable == 2
                   for j = 1:16
                       if swap == 1 && boolean(j) == 1 
                           scheduler(i,j) = seed(j);
                           if j == 1
                               %% Test version
                               % Keeps budbreak within range of day separation
                               % values or vice versa
                               switch (test_case)
                                   case 1
                                       scheduler(i,5) = scheduler(i,5) + separation(sep);
                                   case 2
%                                        scheduler(i,1) = scheduler(i,1) + separation(sep);
                               end
                           end
                           swap = 2;
                       elseif boolean(j) == 1
                           scheduler(i,j) = seed(j) + separation(sep);
                       end
                   end
               end
       end
    end
    Model = Model.UploadSchedulerSlice(abs(scheduler(:,:)),boolean);

    Model = Model.SchedulerTest(options{1}, options{2}, options{3}, options{4}, options{5}, options{6}, options{7});
end