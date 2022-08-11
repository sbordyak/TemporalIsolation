close all;
% rand_array_size = 10;
% day_range = -58:12;
pop_or_sched = 0;
lifespan_mean_mean = 2.5;
lifespan_mean_std = 0.5;
lifespan_std_mean = 1.2;
lifespan_std_std = 0.2;
plong_mean_mean = 10;
plong_mean_std = 1;
plong_std_mean = 2;
plong_std_std = 0.5;

DataExtract;

scheduler = zeros(2,16,length(day_range)*rand_array_size);
Model = TestModel(Population('','',0,0,0,0,0), Population('','',0,0,0,0,0), [0], seed, pop_or_sched);
day = 0;
for i = 1:length(day_range)*rand_array_size
   if mod(i-1, rand_array_size) == 0
       day = day + 1;
   end
   scheduler(1,1,i) = seed(1) + day_range(day);
   scheduler(2,1,i) = seed(1);
   scheduler(2,9,i) = seed(7) + day_range(day);
   scheduler(1,9,i) = seed(7);
   scheduler(:,2,i) = [seed(2) + emergence_std_std_A * randn(1), seed(2) + emergence_std_std_A * randn(1)];
   scheduler(:,3,i) = [lifespan_mean_mean + lifespan_mean_std * randn(1), lifespan_mean_mean + lifespan_mean_std * randn(1)];
   scheduler(:,4,i) = [lifespan_std_mean + lifespan_std_std * randn(1), lifespan_std_mean + lifespan_std_std * randn(1)];
   scheduler(:,5,i) = [leaf_flush_mean_mean_A + leaf_flush_mean_std_A * randn(1) + day_range(day), leaf_flush_mean_mean_A + leaf_flush_mean_std_A * randn(1) + day_range(day)];
   scheduler(:,6,i) = [leaf_flush_std_mean_A + leaf_flush_std_std_A * randn(1), leaf_flush_std_mean_A + leaf_flush_std_std_A * randn(1)];
   scheduler(:,7,i) = [plong_mean_mean + plong_mean_std * randn(1), plong_mean_mean + plong_mean_std * randn(1)];
   scheduler(:,8,i) = [plong_std_mean + plong_std_std * randn(1), plong_std_mean + plong_std_std * randn(1)];
   scheduler(:,10,i) = [seed(10) + emergence_std_std_B * randn(1), seed(8) + emergence_std_std_B * randn(1)];
   scheduler(:,11,i) = [lifespan_mean_mean + lifespan_mean_std * randn(1), lifespan_mean_mean + lifespan_mean_std * randn(1)];
   scheduler(:,12,i) = [lifespan_std_mean + lifespan_std_std * randn(1), lifespan_std_mean + lifespan_std_std * randn(1)];
   scheduler(:,13,i) = [leaf_flush_mean_mean_B + leaf_flush_mean_std_B * randn(1) + day_range(day), leaf_flush_mean_mean_B + leaf_flush_mean_std_B * randn(1) + day_range(day)];
   scheduler(:,14,i) = [leaf_flush_std_mean_B + leaf_flush_std_std_B * randn(1), leaf_flush_std_mean_B + leaf_flush_std_std_B * randn(1)];
   scheduler(:,15,i) = [plong_mean_mean + plong_mean_std * randn(1), plong_mean_mean + plong_mean_std * randn(1)];
   scheduler(:,16,i) = [plong_std_mean + plong_std_std * randn(1), plong_std_mean + plong_std_std * randn(1)];
end
%scheduleTmp = scheduler(1,:,:);
Model = Model.UploadSchedulerSlice(abs(squeeze(scheduler(1,:,:)).'),[1 0 0 0 0 0 0 0 0 0 0 0]);
Model = Model.UploadSchedulerSlice(abs(squeeze(scheduler(2,:,:)).'),[0 0 0 0 0 0 1 0 0 0 0 0]);

calc_type = "ratio1"; % Temporal Isolation calculation method
cdf_type = 'normal'; % CDF calculation method
pdf_type = 'normal'; % PDF calculation method
egg_sites = 500;
egg_layers = 219;
longevity_plot = -1; % Longevity plot switch (1 for longevity, 0 for survival distribution
save_switch = 0; % Save switch, 1 for save, 0 for dont save
Model = Model.SchedulerTest(calc_type, cdf_type, pdf_type, longevity_plot, save_switch, egg_sites, egg_layers);

%% ScatterPlot
x = round(day_range + abs(seed(1)-seed(7)));
y = zeros(rand_array_size, length(day_range));
p = {};
for i = 1:length(day_range)
    y(:,i) = Model.TIall{1}(((i-1)*rand_array_size)+1:i*rand_array_size);
    %p{end+1} = polyfit(x,y(:,i),2);
end
avg = mean(y);

figure(1);
hold on;
plot(x.',avg.','LineWidth', 3, 'DisplayName','Average Value at Day');
for i = 1:rand_array_size
    scatter(x, y(i,:), '.', 'LineWidth', 1.5);
end
hold off;
xlabel("Day Separation");
ylabel("Temporal Isolation");
title("Temporal Isolation vs Day Separation");
saveas(1, "figures/" + num2str(x(1)) + ":" + num2str(x(end)) + "_" + num2str(rand_array_size) + "_Scatter.jpg");

%% Line Plot
figure(2);
plot(x,y);
xlabel("Day Separation");
ylabel("Temporal Isolation");
title("Temporal Isolation vs Day Separation");
saveas(2, "figures/" + num2str(x(1)) + ":" + num2str(x(end)) + "_" + num2str(rand_array_size) + "_Line.jpg");

%% BOXPLOT
figure(3);
boxplot(y);
xlabel("Day Separation");
ylabel("Temporal Isolation");
title("Temporal Isolation vs Day Separation");
saveas(3, "figures/" + num2str(x(1)) + ":" + num2str(x(end)) + "_" + num2str(rand_array_size) + "_Box.jpg");

