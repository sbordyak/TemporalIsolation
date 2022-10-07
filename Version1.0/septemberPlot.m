function [] = septemberPlot(model, saveSwitch)
    x = round(model.test_range + abs(model.seed(model.changingIndex1)-model.seed(model.changingIndex2)));

    lengthOfRange = length(model.test_range);
    midpt = round(lengthOfRange/2);

    % Low end of the range
    y1 = model.TIall{1}(1:model.tests); 
    % Midpoint of the range
    y2 = model.TIall{1}(((midpt-1)*model.tests)+1:midpt*model.tests);
    % High end of the range
    y3 = model.TIall{1}(((lengthOfRange-1)*model.tests)+1:lengthOfRange*model.tests);

    % Creation of separate convolution plots
    figure(1);
    hold on;
    subplot(3,1,1);
    % High TI Plot here
    subplot(3,2,1);
    % Mid TI Plot here
    subplot(3,3,1);
    % Low TI Plot here

    % Creation of large lineplot
    figure(2);
    hold on;
    plot(x,y1);
    plot(x,y2);
    plot(x,y3);
end