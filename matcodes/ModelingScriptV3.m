close all
mean_range = 0:(1/2):10;
std_range = 0:(1/4):5;
% seed = zeros(1,12);
pop_or_sched = 0;
day_range = [-10:10];

%% Base Value assignment
% seed(1,1) = 120; %% Pop A Emergence mean
% seed(1,2) = 5; %% Pop A emergence std
% seed(1,3) = 10; %% Pop A lifespan mean
% seed(1,4) = 2; %% Pop A lifespan std
% seed(1,5) = 120; %% Pop A tissue mean
% seed(1,6) = 12; %% Pop A tissue std
% seed(1,7) = 120; %% Pop B Emergence mean
% seed(1,8) = 5; %% Pop B emergence std
% seed(1,9) = 10; %% Pop B lifespan mean
% seed(1,10) = 2; %% Pop B lifespan std
% seed(1,11) = 120; %% Pop B tissue mean
% seed(1,12) = 12; %% Pop B tissue std
DataExtract;
original = seed(1,7);
Model = TestModel(Population('','',0,0,0,0,0), Population('','',0,0,0,0,0), [0], seed, pop_or_sched);
    
scheduler1 = zeros(length(mean_range),12);
scheduler2 = zeros(length(std_range),12);
for i = day_range(1):day_range(end)
    %% Pop A Emergence Mean Scheduler
    seed(1,7) = original + i - 1;
    for k = 1:12
        scheduler1(:,k) = ones(length(mean_range),1) * seed(1,k);
    end
    scheduler1(:,1) = seed(1,1) + mean_range;
    boolean = [1 0 0 0 0 0 0 0 0 0 0 0];
    Model = Model.UploadSchedulerSlice(scheduler1,boolean);

    %% Pop A Emergence STD Scheduler
    for k = 1:12
        scheduler2(:,k) = ones(length(std_range),1) * seed(1,k);
    end
    scheduler2(:,2) = seed(1,2) + std_range;
    boolean = [0 1 0 0 0 0 0 0 0 0 0 0];
    Model = Model.UploadSchedulerSlice(scheduler2,boolean);
end
    
calc_type = "conv"; % Temporal Isolation calculation method
cdf_type = 'normal'; % CDF calculation method
pdf_type = 'normal'; % PDF calculation method
longevity_plot = 1; % Longevity plot switch (1 for longevity, 0 for survival distribution
save_switch = 0; % Save switch, 1 for save, 0 for dont save
Model = Model.SchedulerTest(calc_type, cdf_type, pdf_type, longevity_plot, save_switch);
    
figure();
hold on;
legend_vector = {1:length(day_range)};   
for i = 1:length(day_range)
    legend_vector{i} = num2str(day_range(i));
end
for i = 1:length(day_range)*2
    if mod(i,2)==1
        p1=plot(Model.scheduler{i}(2:end,1), Model.TIall{i},'-o','LineWidth',2,'Marker','none');
        p1.Color = [0.0 0.0 1-(i/(length(day_range)*2))];
        xlabel("Pop A Emergence \mu");
        ylabel("Temporal Isolation");
    end
end
title(legend, "Base Emergence \mu separation");
legend(legend_vector, 'Location', 'northeastoutside', 'NumColumns', 3);
hold off;

figure();
hold on;
for i = 1:length(day_range)*2
    if mod(i,2)==0
        p2=plot(Model.scheduler{i}(2:end,2), Model.TIall{i},'-o','LineWidth',2,'Marker','none');
        p2.Color = [0.0 0.0 1-(i/(length(day_range)*2))];
        xlabel("Pop A Emergence \sigma");
        ylabel("Temporal Isolation");
    end
end
title(legend, "Base Emergence \mu separation");
legend(legend_vector, 'Location', 'northeastoutside', 'NumColumns', 3);
hold off;
display(seed);