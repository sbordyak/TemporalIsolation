%% TODO:
%   Create stable build with every variable staying the same except
%   changing variable.

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

values_mat = {};
values_mat{end+1} = [emergence_mean_mean_A, emergence_mean_std_A; emergence_std_mean_A, emergence_std_std_A];
values_mat{end+1} = [lifespan_mean_mean, lifespan_mean_std; lifespan_std_mean, lifespan_std_std];
values_mat{end+1} = [leaf_flush_mean_mean_A, leaf_flush_mean_std_A; leaf_flush_std_mean_A, leaf_flush_std_std_A];
values_mat{end+1} = [plong_mean_mean, plong_mean_std; plong_std_mean, plong_std_std];
values_mat{end+1} = [emergence_mean_mean_B, emergence_mean_std_B; emergence_std_mean_B, emergence_std_std_B];  
values_mat{end+1} = [lifespan_mean_mean, lifespan_mean_std; lifespan_std_mean, lifespan_std_std];
values_mat{end+1} = [leaf_flush_mean_mean_B, leaf_flush_mean_std_B; leaf_flush_std_mean_B, leaf_flush_std_std_B];
values_mat{end+1} = [plong_mean_mean, plong_mean_std; plong_std_mean, plong_std_std];
                
options = {"ratio1", 'normal', 'normal', 500, 219, 1};
tests = 10;
test_range = -19:20;
boolean = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
changing_variable = 1;
seed = [70 5 10 5 80 5 50 5 70 5 7 5 50 5 20 5];
incremental_or_RNG = 1;

model = TemporalIsolationModel(sum(boolean(:)==1), options, seed, boolean, values_mat, test_range, tests, changing_variable, incremental_or_RNG);

septemberPlot(model, 0, incremental_or_RNG);






