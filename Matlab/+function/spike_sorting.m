function []=spike_sorting(Fs,deltaF, All_spike_data)

num_neurons=size(deltaF,2);


for i=1:num_neurons
    signal=deltaF(:, i);   
    locs=All_spike_data{i,2};
    count_spike = length(locs);
    

    
    for k =1:count_spike 
        T1=(locs(k)*Fs)-20;
        T2=(locs(k)*Fs)+40;
        if T1>0
            H_extract = H_signal(T1:T2);
            HP_pos_all_spikes(: , k)= +H_extract;
            
        else
        end
   
    end
    
    Pos_extracted_spikes{i,1}=HP_pos_all_spikes;

end























end