%% MakeBarberExample.m
% This is a code to make a simple example analysis for the Barber proposal
% Create two bimodal distributions of emergence+lifespan
% Calculate TI based on difference in mean of dists. for two cases - 
% one where second dist is narrow (P3) and one where it's wide (P2)


%%
set(0,'defaultaxesfontsize',16) % Make figure font large

% Vector of days
d = linspace(0,365,1000);

ed1 = 150; % mean emergence for P1
std1a = 10; % std deviation for P1 peak a
std1b = 3; % std deviation for P1 peak b

% Calculate distribution for P1 with 2 gaussians
p1 = 1e7*(exp(-(ed1-d).^2/std1a^2)+.75*exp(-(ed1-std1a-d).^2/std1b^2));

% Choices of mean emergence data for P2,P3
ed2 = 150:-1:100;

% Loop over different mean emergences
for ii = 1:length(ed2);
    % Calculate distributions P2,P3
    p2 = 1e6*(exp(-(ed2(ii)-d).^2/std1a^2)+.75*exp(-(ed2(ii)-1.5*std1a-d).^2/std1b^2));
    p3 = 1e6*(exp(-(ed2(ii)-d).^2/(.5*std1a)^2)+.75*exp(-(ed2(ii)-1.5*(.5*std1a)-d).^2/(.5*std1b)^2));
    
    TI2(ii) = 1 - sum(p1.*p2)/sqrt(sum(p1.^2)*sum(p2.^2)); % Temporal isolation for P1 & P2
    TI3(ii) = 1 - sum(p1.*p3)/sqrt(sum(p1.^2)*sum(p3.^2)); % Temporal isolation for P1 & P3
end

%% Make figure showing how TI varies for difference in emergence

figure; % Open new figure
set(gcf,'position', [360   515   514   183]) % Set size of figure

plot(abs(ed2-ed1),TI2,'b','linewidth',2) % Plot difference in emergence vs TI for P1 & P2
hold on
plot(abs(ed2-ed1),TI3,'r','linewidth',2) % Plot difference in emergence vs TI for P1 & P2

% Make graph look nice
set(gca,'xlim',[0 40]) % Set limit of x-axis
box on
set(gca,'LineWidth',2)

% Axis labels and legend
xlabel('Difference in Mean Emergence (days)','fontsize',16)
ylabel('Temporal Isolation','fontsize',16)
legend({'\sigma=10 days','\sigma=  5 days'},'fontsize',16,'Location','northwest')
 

%% Make figure showing example emergence distributions

% Choose some aesthetically nice distributions from the above options
p1 = exp(-(ed1-d).^2/std1a^2)+.75*exp(-(ed1-std1a-d).^2/std1b^2);
p2a = exp(-(ed2(15)-d).^2/std1a^2)+.75*exp(-(ed2(15)-1.5*std1a-d).^2/std1b^2);
p2b = exp(-(ed2(50)-d).^2/(.5*std1a)^2)+.75*exp(-(ed2(50)-1.5*(.5*std1a)-d).^2/(.5*std1b)^2);

% New figure
H = figure;
set(H,'position', [360   515   514   183])

h1=area(d,p1,'LineWidth',2,'FaceColor','r','FaceAlpha',0.5); % Transparent area plot for P1
hold on;
h2 = area(d,p2a,'LineWidth',2,'FaceColor','g','FaceAlpha',0.5); % Transparent area plot for P2
area(d,p2b,'LineWidth',2,'LineStyle','--','FaceColor','g','FaceAlpha',0.4); % Transparent area plot for P3

% Make figure nice
box on
set(gca,'LineWidth',2)
set(gca,'xlim',[75 195],'ylim',[0 1.2])
set(gca,'YTick',[])
set(gca,'FontSize',16)

% Axis labels and legend
xlabel('Adult Emergence (Julian Day)','fontsize',16)
ylabel('Percent Alive','fontsize',16)
legend([h1,h2],{'Hawthorn','Apple'},'fontsize',16)

