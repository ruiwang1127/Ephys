%function [N ,out1] = spike_times_and_burst_checking_new_trysubplot(trace,threshold1,window_value,num_spike_expected)
% Rui March 2021 adapted from rune@berg-lab.net
% it is for count the num of spikes in inducing trace, need to open the
% trace (current clamp) of interest as a matlabfig, for example from
% onlineanalysis.

%   This function detects and locates the time points of action potentials in a trace of 
%   membrane potential as a function of time in a neuron. The trace should represent
%   a current clamp recording from a neuron.
%   Input: 
%   "trace" is the membrane voltage array of the neuron
%   "Theshold" is the value for the spike to cross to be detected.
%   Output:
%   The output array is the index location of spikes.
%
%   



figureofinterest=gcf;
h=findobj(figureofinterest, 'Type', 'line');
trace=get(h, 'Ydata');
gim=trace;

    clear('set_crossgi')
    threshold1=input('please enter the threshold')
    set_crossgi=find(gim(1:end) > threshold1)  ;  % setting the threshold
    clear('index_shift_neggi');clear('index_shift_pos');

if isempty(set_crossgi) < 1     % This to make sure there is a spike otherwise the code below gives problems. There is an empty else statement below.

    clear('set_cross_plusgi');clear('set_cross_minus')
    index_shift_posgi(1)=min(set_crossgi);
    index_shift_neggi(length(set_crossgi))=max(set_crossgi);

    for i=1:length(set_crossgi)-1
     if set_crossgi(i+1) > set_crossgi(i)+1 ; 
     index_shift_posgi(i+1)=i;
     index_shift_neggi(i)=i;
     end
    end

    %Identifying up and down slopes:

    set_cross_plusgi=  set_crossgi(find(index_shift_posgi));   % find(x) returns nonzero arguments.
    set_cross_minusgi=  set_crossgi(find(index_shift_neggi));   % find(x) returns nonzero arguments.
    set_cross_minusgi(length(set_cross_plusgi))= set_crossgi(end);
    nspikes= length(set_cross_plusgi); % Number of pulses, i.e. number of windows.

    %% Getting the spike coords

    for i=1: nspikes
            spikemax(i)=min(find(gim(set_cross_plusgi(i):set_cross_minusgi(i)) == max(gim(set_cross_plusgi(i):set_cross_minusgi(i))))) +set_cross_plusgi(i)-1;
    end

else
    spikemax=[];
    display('no spikes in trace')
end


figure; 
subplot(2,1,1)
plot(trace)
hold on
plot(spikemax, trace(spikemax),'.r');
hold off
xlabel ('time/10ms')
ylabel('Vm/mV')
titlestr_1 =['num of spikes in this trace are',' ', num2str(nspikes)]
title(titlestr_1)

N=length(spikemax) ;

out1=spikemax;

%Rui March 2021: below is the scripts to looks at my one min inducing trace
%to see if and where does the burst and silence happens in my trace
% window_value: the sampleing time window, for me becasue it is 5 hz, so
% window bin is: 0.2sec=2000
%num_spike expected is ideal num of spike each window

window_value=2000;
num_spike_expected=input('please enter the num of spikes to be expected each time bin');%here I put the number of spikes per 0.2 sec, becuase my simuli is 5hz, so the sampling time is 0.2sec
%and each stimuli I give 4 flush of lights, so I put 4 

for i=1:300
    if window_value==2000;
        freq(i)=length(find(spikemax(1:end)<window_value))-num_spike_expected;
    else 
        freq(i)=length(find(spikemax(1:end) < window_value&spikemax(1:end)>=(window_value-2000)) )-num_spike_expected;
    end
    window_value=window_value+2000;
end

%hm=HeatMap(freq);
%figure; 
%hm=imagesc(freq)
%title = addTitle(hm,'bursting property in inducing trace','Color','black');
%addXLabel(hm,'Time/0.2sec','FontSize',12)
%hm.Colormap=parula;
%colorbar('Direction','reverse')
%hm.Annotate = true;
subplot(2,1,2)
imagesc(freq, [-3 3])%16.4.21 put the clims there, to fix the range of color, makes the less confustion across different data range
%box on
%axis off

%ax = gca;
%ax.BoxStyle = 'full';
% Remove axis ticks and labels
set(gca, 'XTick', [], 'YTick', []);

% Set the box outline
box on;
custom_colormap = [0 0 0.4;    % darker bluer
                   0 0 0.7412;    % dark blue
                   0 0.5020 0.7412;    %light blue
                   1 1 1;    % white
                   0.9294 0.9020 0.1294; %light yellow
                   1 0.6 0; % cold orange
                   0.8510 0.3294 0.3020];   % warm orange
colormap(custom_colormap); % Set the custom colormap


C=colorbar('southoutside')%,'Ticks',[-2,-1,0,1,2,3,4,5,6],'TickLabels',{'silent',' ','just right','burst',' ',' ',' ',' ',' '}))
C.Ticks=[-2,0,2]
C.TickLabels={'silent','just right','burst'}
C.Label.String='bursting property'

%maintitlestr
%sgtitle('/s')

%C=colorbar('southoutside','Ticks',[-2,-1,0,1,2,3,4,5,6],'TickLabels',{'silent',' ','just right','burst',' ',' ',' ',' ',' '}))

%view(hm)
%hm=imagesc(freq)
%view(hm) it does not because imagesc not fit it, HeatMap fit this
%argument, but it is difficult to fit HeatMap object into subplot