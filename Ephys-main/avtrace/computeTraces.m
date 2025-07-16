function output = computeTraces(xData,yData,niceFig,lowerT,upperT,displayAll)
%% This function is based on the averageTraces.m Script by "BF 2016"
% It takes in data in the form of xData and yData (the latter can be an
% array or cell array) and computes the peak location and the slope. It can
% also output the results if one or two figure handles are given to it. 
% Parameters.
% xData - Time axis. Single Vector.
% yData - Measured Data. Can be an array or a cell array. Will be averaged
%           together in the first dimension.
% lowerT, upperT - Threshold values for the slope. Default values are 0.2
%           and 0.6, fitting the slope to the datapoints inbetween 20% and
%           60% of the peak height compared to the baseline
% display - Set to true if you want both plots and the text output. False
%           will only use the nice, main output figure.
% niceFig - handle to the figure to plot the main output figure into
% checkFig - handle to the figure to plot the check figure into
% Output
% output - struct containing the results
%% Settings - ignore unless neccessary
    relevantDataStartTime = 603;
    relevantDataEndTime = 618;
    baselineStartTime = 580;
    baselineEndTime = 600;
    plotStartTime = 600;
    plotEndTime = 650;
    minimumDipSize = -10;

%% Check for parameters and set defaults
    if nargin < 2
        error('Not enough input arguments!')
    end
    if lowerT < 0
        error('Slope Start has to be above zero!');
    end
    if lowerT >= 1
        error('Slope Start cannot be at higher values than one!');
    end
    if upperT < 0
        error('Slope End cannot be below zero!');
    end
    if upperT > 1
        error('Slope End cannot be above 1!');
    end
    
    
    %niceFig = figure; %Uncomment if you need the 'Pairing' option
    displayResults = displayAll;
    slopeFitThresholdLower = lowerT;
    slopeFitThresholdUpper = upperT;

%% Prepare Data
    if iscell(yData)
        arraydata=cell2mat(yData);
        average=mean(arraydata,1);
    else
        average=mean(yData,1);
    end
    time = xData;

    relevantShortTime = time((time >= relevantDataStartTime) .* (time <= relevantDataEndTime) == 1);
    relevantShortData = average((time >= relevantDataStartTime) .* (time <= relevantDataEndTime) == 1);

    if displayResults
        disp('Analyzing yData with text output enabled. ');
    end
 
%% Determine the baseline
    baselineData = average((time >= baselineStartTime) .* (time <= baselineEndTime) == 1);
    baselineTime = time((time >= baselineStartTime) .* (time <= baselineEndTime) == 1);
    %     filteredBaseline = baselineData;
    %     filteredBaseline(filteredBaseline>mean(filteredBaseline)+ ...
    %         removeBaselineDatapointsMoreThanNSigma*std(filteredBaseline))=[];
    baseline = median(baselineData);
    if displayResults
        disp(['Baseline found to be ' num2str(baseline) '!']);
    end
    
    relevantShortData = relevantShortData - baseline;
    
%% First, we find the peak 
    % Find the minima (maxima of data*-1)
    [Maxima,MaxIdx] = findpeaks(relevantShortData*(-1));

    % Select the peak - the first minimum that is smaller than the noise
    % threshold
    indexOfDip = -1;
    for i=1:numel(Maxima)
        if abs(Maxima(i)) > abs(minimumDipSize)
            indexOfDip = MaxIdx(i);
            break;
        end
    end

    if indexOfDip == -1
        if nargout > 0
            output.peak = NaN;
            output.time = NaN;
            output.slope = NaN;
            output.baseline = NaN;
            return;
        else
            figure;
            clf;
            hold on
            plot(relevantShortTime,relevantShortData,'black');
            refline(0,minimumDipSize);
            title('No Peak found in this image');
            legend('off');
            error('No minimum found!')
        end
    end

    valueOfDip = relevantShortData(indexOfDip);

    if displayResults
        disp(['Dip found at time ' num2str(relevantShortTime(indexOfDip)) ' with depth ' num2str(valueOfDip) '!']);
    end

%% Find the slope and fit it
    startPoint = -1;
    endPoint = -1;
    for i=indexOfDip:-1:1
        if (endPoint == -1) && (abs(relevantShortData(i)) < abs(slopeFitThresholdUpper*valueOfDip))
            endPoint = i;
        end
        if (startPoint == -1) && (abs(relevantShortData(i)) < abs(slopeFitThresholdLower*valueOfDip))
            startPoint = i;
            break;
        end
    end

    if (startPoint == -1) || (endPoint == -1)
        if nargout > 0
            output.peak = NaN;
            output.time = NaN;
            output.slope = NaN;
            output.baseline = NaN;
            return;
        else
            figure;
            clf;
            hold on
            plot(relevantShortTime,relevantShortData,'black');
            plot(relevantShortTime(indexOfDip),valueOfDip,'Xb','MarkerSize',20);
            refline(0,slopeFitThresholdLower*valueOfDip);
            refline(0,slopeFitThresholdUpper*valueOfDip);
            title('Slope not clear in this image');
            legend('off');
            error('Couldnt find starting point or end point for the slope!');
        end
    end

    slopeTime = relevantShortTime(startPoint:endPoint);
    slopeData = relevantShortData(startPoint:endPoint);

    % Autogenerated fit by cftool
    [xData, yData] = prepareCurveData( slopeTime, slopeData' );
    % Set up fittype and options.
    ft = fittype( 'poly1' );
    opts = fitoptions( 'Method', 'LinearLeastSquares' );
    opts.Robust = 'Bisquare';
    % Fit model to data.
    [fitresult, ~] = fit( xData, yData, ft, opts );

    % The value we determined:
    slopeOfDip = fitresult.p1;

    if displayResults
        disp(['Slope found to be ' num2str(slopeOfDip) '!']);
    end

%% Plot results
    % We make this the nice picture, the next is the stuff to check if
    % everything is working
%     subplot(niceFig);
    if (strcmp(get(niceFig, 'type'), 'figure') && isa(niceFig, 'matlab.ui.Figure'))
        figure(niceFig);
        hold on
        relevantTime = time((time >= plotStartTime) .* (time <= plotEndTime) == 1);
        relevantData = average((time >= plotStartTime) .* (time <= plotEndTime) == 1);
        plot(relevantTime,relevantData,'blue','LineWidth',2);
        set(gca,'fontsize',14);
        xlabel('Time (ms)'), ylabel('Peak value (pA)');
        xl = get(gca,'xlim');
        yl = get(gca,'ylim');
        stringToDisplay = {['Peak: ' num2str(valueOfDip) ' pA'], ['Time: ' num2str(relevantShortTime(indexOfDip)) ' ms'], ['Slope: ' num2str(slopeOfDip) ' pA/ms']};
        text(xl(1)+0.6*(xl(2)-xl(1)),yl(1)+0.2*(yl(2)-yl(1)),stringToDisplay,'fontsize',10);
    end
%     close(niceFig);
    
    if displayResults
        figure;
        clf;
        hold on
        plot(relevantShortTime,relevantShortData,'black');
        plot(baselineTime,baselineData-baseline,'black');
        plot(fitresult);
        refline(0,0);
        plot(relevantShortTime(indexOfDip),valueOfDip,'Xb','MarkerSize',20);
        title('Ugly Plot so Margo can see if Stuff is working');
        xlim([min(baselineTime) max(relevantShortTime)]);
        ylim([1.2*valueOfDip 3*max(relevantShortData)]);
        legend('off');
    end

%% Output wanted?
    if nargout > 0
        output.peak = valueOfDip;
        output.time = relevantShortTime(indexOfDip);
        output.slope = slopeOfDip;
        output.baseline = baseline;
    end
end
