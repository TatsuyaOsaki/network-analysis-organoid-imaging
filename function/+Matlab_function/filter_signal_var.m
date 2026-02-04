function [LP_Signal_fix, HP_Signal_fix, time_ms]=filter_signal_var(Fs, num_electrode, Signal, LP, BPL, BPH)
nm=num_electrode+1;
time_ms = Signal(:,1);
tl=length(time_ms);

Signal_fix=zeros(tl, nm);
HPt_Signal_fix=zeros(tl, nm);

parfor i=2:nm
    
    baseline= mean(Signal(:,i));
    Signal_fix(:, i) = Signal(:, i) -baseline;
    LP_Signal_fix(:, i)=lowpass(Signal_fix(:, i),LP, Fs);
    HPt_Signal_fix(:, i)=lowpass(Signal_fix(:, i),BPH, Fs);
    HP_Signal_fix(:, i)=highpass(HPt_Signal_fix(:, i),BPL, Fs);
end
HP_Signal_fix(:, 1)=[];
LP_Signal_fix(:, 1)=[];

clearvars HPt_Signal_fix Signal_fix;
end