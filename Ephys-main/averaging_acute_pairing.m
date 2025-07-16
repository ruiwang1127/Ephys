%27.05.24 just to calculate the acute pairing experiment traces. M will be
%the slope calculated from whatever experiment and code. first 10 will be
%baseline, normally. the rest are post effect. mis-detected ones should be
%NaN, otherwise the timerange will be shifted

%before and after stimulation
before=M(1:8);
after=M(9:end);

%calculated the moving average, the width of the window should be
%re-adjusted
M1 = movmean(before,3,"omitnan"); % 8 is the sliding window width
M2= movmean(after,3,"omitnan");
data_moved=[M1;M2];

%calculate the binned average, the width of binning should be adjusted

n = 5; % average every n values
%a = reshape(cumsum(ones(n,10),2),[],1); % arbitrary data
data_binned = arrayfun(@(i) mean(M(i:i+n-1),'omitnan'),1:n:length(M)-n+1)'; % the averaged vector