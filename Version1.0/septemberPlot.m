function [] = septemberPlot(model, saveSwitch, incremental_or_RNG)
    x = round(model.test_range + abs(model.seed(model.changingIndex1)));

    lengthOfRange = length(model.test_range);
    midpt = round(lengthOfRange/2);

    if incremental_or_RNG == 0
        TI = sort(model.TIall{1});
        % Low end of the range
        y1 = TI(1:model.tests); 
        % Midpoint of the range
        y2 = TI(((midpt-1)*model.tests)+1:midpt*model.tests);
        % High end of the range
        y3 = TI(((lengthOfRange-1)*model.tests)+1:lengthOfRange*model.tests);

        % Creation of separate convolution plots
        figure(1);
        subplot(3,1,1);
        hold on;
        plot([1:365], model.emergences{1}(1,1:365));
        plot([1:365], model.emergences{1}(2,1:365));
        hold off;
        subplot(3,1,2);
        hold on;
        plot([1:365], model.emergences{midpt}(1,1:365));
        plot([1:365], model.emergences{midpt}(2,1:365));
        hold off;
        subplot(3,1,3);
        hold on;
        plot([1:365], model.emergences{lengthOfRange}(1,1:365));
        plot([1:365], model.emergences{lengthOfRange}(2,1:365));
        hold off;

        % Creation of large lineplot
        figure(2);
        hold on;
        plot(x(1:model.tests),y1.');
        plot(x(1:model.tests),y2.');
        plot(x(1:model.tests),y3.');
    else
        TI = sort(model.TIall{1});
        % Low end of the range
        y1 = TI(1:lengthOfRange/3); 
        % Midpoint of the range
        y2 = TI((lengthOfRange/3)+1:lengthOfRange*2/3);
        % High end of the range
        y3 = TI((lengthOfRange*2/3)+1:lengthOfRange);

        % Creation of separate convolution plots
        figure(1);
        subplot(3,1,1);
        hold on;
        plot([1:365], model.emergences{1}(1,1:365));
        plot([1:365], model.emergences{1}(2,1:365));
        hold off;
        subplot(3,1,2);
        hold on;
        plot([1:365], model.emergences{round(lengthOfRange/3)}(1,1:365));
        plot([1:365], model.emergences{round(lengthOfRange/3)}(2,1:365));
        hold off;
        subplot(3,1,3);
        hold on;
        plot([1:365], model.emergences{round(lengthOfRange*2/3)}(1,1:365));
        plot([1:365], model.emergences{round(lengthOfRange*2/3)}(2,1:365));
        hold off;

        % Creation of large lineplot
        figure(2);
        hold on;
        %plot(x(1:lengthOfRange/3),y1.');
        %plot(x((lengthOfRange/3)+1:lengthOfRange*2/3),y2.');
        %plot(x((lengthOfRange*2/3)+1:lengthOfRange),y3.');
        plot(x(1:lengthOfRange/3),y1.');
        plot(x(1:lengthOfRange/3),y2.');
        plot(x(1:lengthOfRange/3),y3.');
    end
end