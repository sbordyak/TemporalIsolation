%%

% Figure title
figtitle = 'TestFig';

% Axes labels
axlab = {'Var 1','Var 2','Var 3','Var 4','Var 5','Var 6','Var 7'};

% Just make a random little dataset to plot
x = randn(100,7)+2*repmat(randn(100,1),1,7)*diag(randn(7,1),0);


% Open a figure and clear it
ifig = 99;
figure(ifig);clf

% Set up figure dimensions and printing information
set(gcf,'position',[334     1   800   800])
set(gcf,'PaperUnits','points','PaperSize',[800 800])

% X positions for subplots
xp = linspace(0.08,.96,8);
yp = linspace(0.08,.96,8);

% Create invisible axis to make a title for figure
axes
set(gca,'Position',[0.1 0.1 0.8, 0.86])
title(sprintf('Here are a lot of figures (%s)',figtitle),'Interpreter','none')
set(gca, 'visible', 'off') % Make axis invisible
set(findall(gca, 'type', 'text'), 'visible', 'on') % Turn text back on


for ii = 1:6
    
    
    for jj = ii:6
        
        
        
        figure(ifig)
        
        axes % Plots on the upper triangle
        scatter(x(:,jj+1),x(:,ii),'filled')
        box on
        set(gca,'Position',[xp(jj+1),yp(8-ii),.11,.11])
        set(gca,'ydir','normal','xtick',[],'ytick',[]);
        hold on
        
        
        axes % Plots on the lower triangle
%         scatter(x(:,ii),x(:,jj+1),'filled')
        scatter(x(:,jj+1),x(:,ii),'filled')
        box on
        set(gca,'Position',[xp(ii),yp(7-jj),.11,.11])
        set(gca,'ydir','normal')
        hold on
        if ii == 1
            ylabel(axlab{jj+1})
            
        else
            set(gca,'ytick',[])
        end
        if jj == 6
            xlabel(axlab{ii})
        else
            set(gca,'xtick',[])
        end
        %%
        
        
    end
end

figure(ifig)
print(gcf,['./' figtitle '.pdf'],'-dpdf')


