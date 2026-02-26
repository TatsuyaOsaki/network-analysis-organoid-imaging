function [idx]=dlx_indexing(num_neurons, num_spikes)
idx=zeros(num_neurons, 1);
for i=1:num_neurons

    spikes=num_spikes(i, 1);
    if spikes>8
        idx(i, 1)=1;
    else
        
    end

end
