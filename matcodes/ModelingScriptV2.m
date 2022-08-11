close all
mean_range = 0:2:3;
std_range = 0:2:3;
[mgx mgy] = meshgrid(mean_range, std_range);
coords = [mgx(:), mgy(:)];
m = length(mgx(1,:));
n = length(mgy(:,1));
% seed = zeros(1,12);
pop_or_sched = 0;

% %% Base Value assignment
% seed(1,1) = 120; %% Pop A Emergence mean
% seed(1,2) = 5; %% Pop A emergence std
% seed(1,3) = 10; %% Pop A lifespan mean
% seed(1,4) = 2; %% Pop A lifespan std
% seed(1,5) = 120; %% Pop A tissue mean
% seed(1,6) = 12; %% Pop A tissue std
% seed(1,7) = 140; %% Pop B Emergence mean
% seed(1,8) = 5; %% Pop B emergence std
% seed(1,9) = 10; %% Pop B lifespan mean
% seed(1,10) = 2; %% Pop B lifespan std
% seed(1,11) = 120; %% Pop B tissue mean
% seed(1,12) = 12; %% Pop B tissue std
DataExtract;
Model = TestModel(Population('','',0,0,0,0,0), Population('','',0,0,0,0,0), [0], seed, pop_or_sched);

for i = 1:12
    scheduler = zeros(length(coords(:,1)),12);
    
    for j = i+1:12
        boolean = zeros(1,12);
        for k = 1:12
            scheduler(:,k) = ones(length(coords(:,1)),1) * seed(1,k);
        end
        scheduler(:,i) = seed(1,i) + coords(:,1);
        boolean(i) = 1;
        scheduler(:,j) = seed(1,j) + coords(:,2);
        boolean(j) = 1;
        Model = Model.UploadSchedulerSlice(scheduler,boolean);
    end
end

calc_type = "ratio1"; % Temporal Isolation calculation method
cdf_type = 'normal'; % CDF calculation method
pdf_type = 'normal'; % PDF calculation method
egg_sites = 500;
egg_layers = 219;
longevity_plot = 1; % Longevity plot switch (1 for longevity, 0 for survival distribution
save_switch = 0; % Save switch, 1 for save, 0 for dont save
Model = Model.SchedulerTest(calc_type, cdf_type, pdf_type, longevity_plot, save_switch, egg_sites, egg_layers);
% for i = 1:5
%     ScheduledSlices(Model.scheduler{i}, Model.TIall{i}, m, n,1,seed);
%     %ScheduledSlices(Model.scheduler{22}, Model.TIall{22}, m, n,1);
% end
Model.ScheduledSlices(m, n,1,seed);