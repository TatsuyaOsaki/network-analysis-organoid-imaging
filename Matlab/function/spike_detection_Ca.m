function[All_spikes, num_spks]=spike_detection_Ca(deltaF, Fs, num_neurons, v)
 All_spikes={};
 Avg_amp=zeros(num_neurons, 1);
 num_spks=zeros(num_neurons, 1);
 interspike_interval_sec_avg=zeros(num_neurons, 1);
 
tic
for i=1:num_neurons
    STDEV=std(deltaF(:,i));
    peak_th=2*STDEV;
    [spks, locs] = findpeaks(deltaF(:,i), Fs,'MinPeakHeight',peak_th );
    
    temp_all_locs_spks=horzcat(locs, spks);
    all_locs_spks=sortrows(temp_all_locs_spks, 1);
    interspike_interval=diff(all_locs_spks(:,1));
    
    All_spikes{i,1}=locs+(1/Fs);
    All_spikes{i,2}=spks;

    
    num_locs=length(locs);
    dummy_mat= ones(num_locs,1);
    Avg_amp(i, 1)=mean(spks);
    num_spks(i, 1)=length(spks);
    
    All_interspike_interval_sec{i,1}=interspike_interval;
    interspike_interval_sec_avg(i,1)=mean(interspike_interval);
        
    
    if v==1
        subplot(num_neurons, 1, i)
         hold on
        plot(deltaF(:, i), 'Color', 'black');
        plot(All_spikes{i,1}*Fs,All_spikes{i,2}, 'o');
        yline(peak_th,'r');
        hold off
        
     end


end
clearvars dummy_mat
toc
end