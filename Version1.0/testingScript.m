% % ## TODO:
% #   - Create other models


% ## Change these to change the variables
emergence_mean_mean_A = 70;
emergence_mean_std_A = 5;
emergence_std_mean_A = 5;
emergence_std_std_A = 2.5;
emergence_mean_mean_B = 70;
emergence_mean_std_B = 5;
emergence_std_mean_B = 5;
emergence_std_std_B = 2.5;
leaf_flush_mean_mean_A = 80;
leaf_flush_mean_std_A = 5;
leaf_flush_std_mean_A = 5;
leaf_flush_std_std_A = 2.5;
leaf_flush_mean_mean_B = 60;
leaf_flush_mean_std_B = 5;
leaf_flush_std_mean_B = 5;
leaf_flush_std_std_B = 2.5;
lifespan_mean_mean = 2.5;
lifespan_mean_std = 0.5;
lifespan_std_mean = 1.2;
lifespan_std_std = 0.2;
plong_mean_mean = 14;
plong_mean_std = 2;
plong_std_mean = 2;
plong_std_std = 0.5;
            
% ## Change these to change the settings of the model calculation

% # options = {type of egg ratio calculation, type of distribution used for PDF, type of distribution used for CDF, egg site number, egg layer number, include plant variables(1) or dont(0), rng (1) or incremental (0)}
options = {"ratio1", 'normal', 'normal', 500, 219, 1, 1};

% # number of tests to run for randomized testing
tests = 10;

% # range of test values to use
test_range = -19:20;

% # array of changing variables (1) and stationary variables (0) in order of: 
% #   [emergence_mean_A, emergence_STD_A, leaf_flush_mean_A, leaf_flush_STD_A, lifespan_mean_A, lifespan_STD_A, plong_mean_A, plong_STD_A,
% #    emergence_mean_B, emergence_STD_B, leaf_flush_mean_B, leaf_flush_STD_B, lifespan_mean_B, lifespan_STD_B, plong_mean_B, plong_STD_B]
ternary = [1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0];

% # base values for each variable in the order of:
% #   [emergence_mean_A, emergence_STD_A, leaf_flush_mean_A, leaf_flush_STD_A, lifespan_mean_A, lifespan_STD_A, plong_mean_A, plong_STD_A,
% #    emergence_mean_B, emergence_STD_B, leaf_flush_mean_B, leaf_flush_STD_B, lifespan_mean_B, lifespan_STD_B, plong_mean_B, plong_STD_B]
seed = [70 5 10 5 80 5 50 5 70 5 7 5 50 5 20 5];

% ## Don't change these, these are for variable loading
values_mat = {};
values_mat{end+1} = [emergence_mean_mean_A, emergence_mean_std_A; emergence_std_mean_A, emergence_std_std_A];
values_mat{end+1} = [lifespan_mean_mean, lifespan_mean_std; lifespan_std_mean, lifespan_std_std];
values_mat{end+1} = [leaf_flush_mean_mean_A, leaf_flush_mean_std_A; leaf_flush_std_mean_A, leaf_flush_std_std_A];
values_mat{end+1} = [plong_mean_mean, plong_mean_std; plong_std_mean, plong_std_std];
values_mat{end+1} = [emergence_mean_mean_B, emergence_mean_std_B; emergence_std_mean_B, emergence_std_std_B];  
values_mat{end+1} = [lifespan_mean_mean, lifespan_mean_std; lifespan_std_mean, lifespan_std_std];
values_mat{end+1} = [leaf_flush_mean_mean_B, leaf_flush_mean_std_B; leaf_flush_std_mean_B, leaf_flush_std_std_B];
values_mat{end+1} = [plong_mean_mean, plong_mean_std; plong_std_mean, plong_std_std];

model = TemporalIsolationModel(sum(ternary(:)==1), options, seed, ternary, values_mat, test_range, tests);
