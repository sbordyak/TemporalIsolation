function ScheduledSlices(scheduler, TIall, m, n,heatmap,seed)
vector_switch = 1;
names = ["Population A emergence \mu", ...
    "Population A emergence \sigma",...
    "Population A lifespan \mu",...
    "Population A lifespan \sigma",...
    "Population A tissue \mu",...
    "Population A tissue \sigma",...
    "Population B emergence \mu", ...
    "Population B emergence \sigma",...
    "Population B lifespan \mu",...
    "Population B lifespan \sigma",...
    "Population B tissue \mu",...
    "Population B tissue \sigma"];

vectors = zeros(1,length(scheduler(:,1))-1);
base = [];
for i = 1:12
    if scheduler(1,i)==1
        if vector_switch == 1
            vectors(1,:) = scheduler(2:end, i);
            axisnamex = names(i);
            vector_switch = vector_switch + 1;
        else
            vectors(2,:) = scheduler(2:end, i);
            axisnamey = names(i);
            o_or_e = i;
        end
    else
        base(end+1) = scheduler(2,i);
    end
end
figure();
ah = axes;
hold on;
p=plot(reshape(vectors(1,:), m, n).', reshape(TIall(1:end), m, n),'-o', 'LineWidth',2, 'Parent', ah);
hold off;
for i = 1:length(p)
    p(i).Color = [0 .5 1-(i/m)];
    p(i).MarkerFaceColor = [0 .5 1-(i/m)];
end
if mod(o_or_e, 2) == 1
    lh = legend(ah, p, "\mu = " + num2str(round(vectors(2,1:n).',2)),'NumColumns',2,'Location','northeastoutside');
elseif mod(o_or_e, 2) == 0
    lh = legend(ah, p, "\sigma = " + num2str(round(vectors(2,1:n).',2)),'NumColumns',2,'Location','northeastoutside');
end
ah2 = copyobj(ah,gcf);
delete(get(ah2,'Children'));
p1=plot(1:365, [1:365;1:365;1:365;1:365;1:365;1:365;1:365;1:365;1:365;1:365;1:365;1:365], 'Parent', ah2,'Visible','off');
set(ah2, 'Color', 'none', 'XTick', [], 'YColor', 'none', 'Box', 'Off')
lh2 = legend(ah2, p1,num2str(seed.'), 'Location', 'southeastoutside');
title(lh2,'Base Values');
lh2.Title.Visible = 'on';
lh2.NumColumns = 2;

xlabel(axisnamex)
ylabel("TI")
xlim([90 95])


    

if heatmap
    figure();
    imagesc(vectors(1,:),vectors(2,:), reshape(TIall, m, n).');
    colorbar;
    xlabel(axisnamex);
    ylabel(axisnamey);
    title("Temporal Isolation");
    set(gca,'ydir','normal');
end
