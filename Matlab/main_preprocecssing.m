
clear;
S=readNPY('example\CO_calcium_activity\suite2p\plane0\spks.npy');
F=readNPY('example\CO_calcium_activity\suite2p\plane0\F.npy');
%S =readNPY('example\CO_calcium_activity\suite2p\plane0\stat.npy');

S_transpose=transpose(S);
F_transpose=transpose(F);
[deltaF, num_neurons]=deltaF_norm(F_transpose);


Fs=5;
Visualization=1;

[All_spikes, num_spikes]=spike_detection_Ca(S_transpose,Fs,num_neurons, Visualization);
idx=dlx_indexing(num_neurons, num_spikes);

    Processed_Data(1).Name='Organoid_activity_1' ;
    Processed_Data(1).Organoid_ID='1';
    Processed_Data(1).F=F_transpose;
    Processed_Data(1).deltaF=deltaF;
    Processed_Data(1).norm_deltaF=normalize(deltaF, "zscore");
    Processed_Data(1).deconvS=S_transpose;
    Processed_Data(1).norm_deconvS=normalize(S_transpose, "zscore");
    Processed_Data(1).Num=num_neurons;
    Processed_Data(1).Samling_frequency=Fs;
    Processed_Data(1).All_spikes=All_spikes;
    Processed_Data(1).Num_spikes=num_spikes;
    Processed_Data(1).dlx_index=idx;
  
save('example\CO_calcium_activity\suite2p\Processed_Data.mat', 'Processed_Data');


Data_summary={};
Data_summary{1, 1}=Processed_Data;