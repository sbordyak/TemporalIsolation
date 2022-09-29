close all;
options = {"ratio1", 'normal', 'normal', 500, 219};
samples = 100;
DataExtract;
lifespan_mean_mean = 2.5;
lifespan_mean_std = 0.5;
lifespan_std_mean = 1.2;
lifespan_std_std = 0.2;
plong_mean_mean = 14;
plong_mean_std = 2;
plong_std_mean = 2;
plong_std_std = 0.5;

em_mat = zeros(2,2,2);
life_mat = zeros(2,2,2);
tiss_mat = zeros(2,2,2);
plong_mat = zeros(2,2,2);
em_mat(1,:,:) = [emergence_mean_mean_A, emergence_mean_std_A;...
                 emergence_std_mean_A, emergence_std_std_A];
em_mat(2,:,:) = [emergence_mean_mean_B, emergence_mean_std_B;...
                 emergence_std_mean_B, emergence_std_std_B];  
life_mat(1,:,:) = [lifespan_mean_mean, lifespan_mean_std;...
                   lifespan_std_mean, lifespan_std_std];
life_mat(2,:,:) = [lifespan_mean_mean, lifespan_mean_std;...
                   lifespan_std_mean, lifespan_std_std];
tiss_mat(1,:,:) = [leaf_flush_mean_mean_A, leaf_flush_mean_std_A;...
                   leaf_flush_std_mean_A, leaf_flush_std_std_A];
tiss_mat(2,:,:) = [leaf_flush_mean_mean_B, leaf_flush_mean_std_B;...
                   leaf_flush_std_mean_B, leaf_flush_std_std_B];
plong_mat(1,:,:) = [plong_mean_mean, plong_mean_std;...
                    plong_std_mean, plong_std_std];
plong_mat(2,:,:) = [plong_mean_mean, plong_mean_std;...
                    plong_std_mean, plong_std_std];

test_case = 1;
switch(test_case)
    case 1
        test_range = -68:32;
        changing_variable = 1;
        xtitle = "Day Separation";
        x = round(test_range + abs(seed(1)-seed(9)));
        ptitle = "Temporal Isolation vs Day Separation";
        boolean = [1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0];
    case 2
        test_range = -67:33;
        changing_variable = 1;
        xtitle = "Budbreak Separation";
        x = round(test_range + abs(seed(5)-seed(13)));
        ptitle = "Temporal Isolation vs Budbreak Separation";
        boolean = [0 0 0 0 1 0 0 0 0 0 0 0 1 0 0 0];
    case 3
        test_range = -3:97;
        xtitle = "Longevity of Population A";
        x = round(test_range + abs(seed(3)));
        ptitle = "Temporal Isolation vs Longevity of Pop A";
        boolean = [0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0];
    case 4
%         test_range = -51:49;
        test_range = -81:19;
        changing_variable = 2;
        xtitle = "Budbreak separation from emergence mean, Pop A";
        x = round(test_range + abs(seed(1)-seed(5)));
        ptitle = "Temporal Isolation vs Budbreak Separation from emergence mean, Pop A";
        boolean = [1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0];
    case 5
        test_range = -69:31;
        changing_variable = 1;
        xtitle = "Budbreak separation from emergence mean, Pop B";
        x = round(test_range + abs(seed(5)-seed(9)));
        ptitle = "Temporal Isolation vs Budbreak Separation from emergence mean, Pop B";
        boolean = [0 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0];
end
Model = RNGTest(sum(boolean(:)==1), options, seed, boolean, em_mat, life_mat, tiss_mat, plong_mat, test_range, samples, test_case, changing_variable);

%% ScatterPlot

y = zeros(samples, length(test_range));
twofive = zeros(1,length(test_range));
ninesevenfive = zeros(1,length(test_range));
for i = 1:length(test_range)
    y(:,i) = Model.TIall{1}(((i-1)*samples)+1:i*samples);
    twofive(i) = quantile(y(:,i),0.025); 
    ninesevenfive(i) = quantile(y(:,i),0.975);
end
avg = mean(y);
stddev = std(y);
temparr1 = avg-stddev;
temparr2 = avg+stddev;
for i = 1:length(avg)
   if isnan(avg(i))
       avg(i) = (avg(i+1) + avg(i-1))/2;
   end
   if temparr2(i) > 1
       temparr2(i) = 1;
   end
end

figure(1);
hold on;
tempx = repmat(x, samples,1);
c1 = gray(samples);
c1 = flip(c1(samples*5/16:(samples*13/16)-1,:),1);
c2 = flip(c1,1);
c = [c1;c2];
for i = 1:length(test_range)
    scatter(tempx(:,i), sortrows(y(:,i)),40,c,'filled');
end
plot(x.',avg.','LineWidth', 3, 'DisplayName','Average Value at Day', 'Color', 'black');
plot(x.',twofive.','LineStyle', '--','LineWidth', 3, 'Color', 'black');
plot(x.',ninesevenfive.','LineStyle', '--','LineWidth', 3, 'Color', 'black');
hold off;
xlabel(xtitle);
ylabel("Temporal Isolation");
ylim([0 1]);
title(ptitle);
saveas(1, "figures/" + num2str(x(1)) + ":" + num2str(x(end)) + "_" + num2str(samples) + "_" + xtitle + "_Scatter.jpg");
