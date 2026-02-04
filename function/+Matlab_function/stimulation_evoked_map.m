%% data import

filename = 'C:\Users\Tatsuya\Documents\Matlab\Cortical-cortical2\c2_day63_s1_1h.csv';
delimiter = ',';
startRow = 4;
formatSpec = '%f%f%f%f%f%f%f%f%f%[^\n\r]';


fileID = fopen(filename,'r');
textscan(fileID, '%[^\n\r]', startRow-1, 'WhiteSpace', '', 'ReturnOnError', false, 'EndOfLine', '\r\n');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'ReturnOnError', false);
fclose(fileID);
Signal = [dataArray{1:end-1}];
clearvars  filename delimiter startRow formatSpec fileID dataArray ans;
%% %% data import dummy

filename = 'C:\Users\Tatsuya\Documents\Matlab\Cortical-cortical2\c2_d30_s1.csv';
delimiter = ',';
startRow = 4;
formatSpec = '%f%f%f%f%f%f%f%f%f%[^\n\r]';


fileID = fopen(filename,'r');
textscan(fileID, '%[^\n\r]', startRow-1, 'WhiteSpace', '', 'ReturnOnError', false, 'EndOfLine', '\r\n');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'ReturnOnError', false);
fclose(fileID);
Signal2 = [dataArray{1:end-1}];
clearvars  filename delimiter startRow formatSpec fileID dataArray ans;
%%
time_ms2 = Signal2(:,1);

% Sampling frequency
Fs=20000;

% 5 min

%Base line correction

for i=2:9
    
    baseline= mean(Signal2(:,i));
    length(Signal(:,i));
    Signal_fix2(:, i) = Signal2(:, i) -baseline;
end

HP_Signal_fix2=highpass(Signal_fix2, 300, Fs);
LP_Signal_fix2=lowpass(HP_Signal_fix2,3000, Fs);
%% Main script pallarel This has to be runed before any process

tic
%/////////////////////
% Initialization
% Sampling frequency
Fs=20000;

% Initialization

num_electrode=8;
time=[2: -0.05: -1];
t = rot90(time);
%/////////////////////

% Bandpass filter
[LP_Signal_fix, HP_Signal_fix, time_ms]=filter_signal(Fs, num_electrode, Signal);
%[LP_Signal_array_fix]=electrode_configuration_array(LP_Signal_fix, electode_position);
% [HP_Signal_array_fix]=electrode_configuration_array(HP_Signal_fix, electode_position);
% num_electrode=64;

tl=length(time_ms);
toc
%%
LE1= HP_Signal_fix(:,1);
LE2 = HP_Signal_fix(:,2);
LE3= HP_Signal_fix(:,3);
LE4 = HP_Signal_fix(:,4);


Dummy = LP_Signal_fix2(:,2)/1.2;
Dummy2=vertcat(Dummy, Dummy);
Dummy =vertcat(Dummy2, Dummy2);
Dummy =vertcat(Dummy, Dummy2);
Dummy =vertcat(Dummy, Dummy2);
Dummy =vertcat(Dummy, Dummy2);
Dummy =vertcat(Dummy, Dummy2);

Map_Signal_LE(:,1)= Dummy;
Map_Signal_LE(:,2)= Dummy;
Map_Signal_LE(:,3)= Dummy;
Map_Signal_LE(:,4)= Dummy;
Map_Signal_LE(:,5)= Dummy;
Map_Signal_LE(:,6)= Dummy;
Map_Signal_LE(:,7)= LE1;
Map_Signal_LE(:,8)= Dummy;
Map_Signal_LE(:,9)= Dummy;
Map_Signal_LE(:,10)= Dummy;
Map_Signal_LE(:,11)= LE2;
Map_Signal_LE(:,12)= LE3;
Map_Signal_LE(:,13)= Dummy;
Map_Signal_LE(:,14)= Dummy;
Map_Signal_LE(:,15)= LE4;
Map_Signal_LE(:,16)= Dummy;
%% preparation right

RE1= HP_Signal_fix(:,5);
RE2 = HP_Signal_fix(:,6);
RE3=HP_Signal_fix(:,7);
RE4 = HP_Signal_fix(:,8);

Map_Signal_RE(:,1)= Dummy;
Map_Signal_RE(:,2)= Dummy;
Map_Signal_RE(:,3)= Dummy;
Map_Signal_RE(:,4)= Dummy;
Map_Signal_RE(:,5)= RE1;
Map_Signal_RE(:,6)= Dummy;
Map_Signal_RE(:,7)= Dummy;
Map_Signal_RE(:,8)= Dummy;
Map_Signal_RE(:,9)= Dummy;
Map_Signal_RE(:,10)= Dummy;
Map_Signal_RE(:,11)=Dummy ;
Map_Signal_RE(:,12)= RE2;
Map_Signal_RE(:,13)= Dummy;
Map_Signal_RE(:,14)= Dummy;
Map_Signal_RE(:,15)= RE3;
Map_Signal_RE(:,16)= RE4;
%
%%
t1 = 1; 
t2 = 200000; 
time_windows=10000;
electrode=3;
[con_MI_delta_gamma]=conteneous_PAC(Fs, time_ms,LP_Signal_fix,t1, t2, electrode, time_windows);
%% 
% xrec2 = icwt(wt,f,[0.5 4],'SignalMean',mean(LE1_lim)); xrec3 = icwt(wt,f,[4 
% 8],'SignalMean',mean(LE1_lim));

fig1 = figure;
fig1.PaperUnits      = 'centimeters';
fig1.Units           = 'centimeters';
fig1.Color           = 'w';
fig1.InvertHardcopy  = 'off';
fig1.Name            = 'Time-Frequency analysis'
fig1.NumberTitle     = 'off';
set(fig1,'defaultAxesXColor','k');
figure(fig1);

tt1=1;
tt2=1000000;
time_lim=time_ms(tt1:tt2, :);

for i=1:8
    hold on
L1=LP_Signal_fix(:, i);

L1_lim=L1(tt1:tt2, :);
% [wt,f] = cwt(L1_lim,Fs);
% xrec1 = icwt(wt,f,[4 8],'SignalMean',mean(L1_lim));

plot(time_lim-1500, L1_lim+0.1*i);
% plot(time_lim-1500, xrec1+0.1*i);

end

hold off
xlim([-100 400]);
% ylim([-0.3 0.2]);
xlabel('Time (ms)');
ylabel('Amplitude (mV)');
%% 
% 
%% Absolute value

abs_Map_Signal_LE=abs(Map_Signal_LE);
abs_Map_Signal_RE=abs(Map_Signal_RE);
%%
[Peaks, location] = findpeaks(abs_Map_Signal_LE(:,7), 'MinPeakHeight',0.02 );
%%


fig1 = figure;
fig1.PaperUnits      = 'centimeters';
fig1.Units           = 'centimeters';
fig1.Color           = 'w';
fig1.InvertHardcopy  = 'off';
fig1.Name            = 'Mapping'
fig1.NumberTitle     = 'off';
set(fig1,'defaultAxesXColor','k');
figure(fig1);

% p= 11108;
for s=1:36
    p= 1844*20;
    subplot(6, 6, s)
    cMap=jet; %set the colomap using the "jet" sca
    e= 0.0005;
       a1 = [e e e e e e];
    a2 = [e abs_Map_Signal_LE(p, 1) abs_Map_Signal_LE(p, 2) abs_Map_Signal_LE(p, 3) abs_Map_Signal_LE(p, 4) e];
    a3=  [e abs_Map_Signal_LE(p, 5) abs_Map_Signal_LE(p, 6) abs_Map_Signal_LE(p, 7) abs_Map_Signal_LE(p, 8) e];
    a4=  [e abs_Map_Signal_LE(p, 9) abs_Map_Signal_LE(p, 10) abs_Map_Signal_LE(p, 11) abs_Map_Signal_LE(p, 12) e];
    a5=  [e abs_Map_Signal_LE(p, 13) abs_Map_Signal_LE(p, 14) abs_Map_Signal_LE(p, 15) abs_Map_Signal_LE(p, 16) e];
    a6 = [e e e e e e];
    Map1=vertcat(a1, a2, a3, a4, a5, a6);
    
    a1 = [e e e e e e];
    a2 = [e abs_Map_Signal_RE(p, 1) abs_Map_Signal_RE(p, 2) abs_Map_Signal_RE(p, 3) abs_Map_Signal_RE(p, 4) e];
    a3=  [e abs_Map_Signal_RE(p, 5) abs_Map_Signal_RE(p, 6) abs_Map_Signal_RE(p, 7) abs_Map_Signal_RE(p, 8) e];
    a4=  [e abs_Map_Signal_RE(p, 9) abs_Map_Signal_RE(p, 10) abs_Map_Signal_RE(p, 11) abs_Map_Signal_RE(p, 12) e];
    a5=  [e abs_Map_Signal_RE(p, 13) abs_Map_Signal_RE(p, 14) abs_Map_Signal_RE(p, 15) abs_Map_Signal_RE(p, 16) e];
    a6 = [e e e e e e];
    Map2=vertcat(a1, a4, a5, a2, a3, a6);
     
   
    C1 = conv2(Map1,Map1, 'full');
    C2 = conv2(Map2,Map2, 'full');
    
    subplot(1, 2, 1)
    contourf(C1,  'LineColor' , 'none','LevelStep', 0.000001);
    txt = ['T= ' num2str(p/20) ' ms'];
    text(0, 0,txt)
%     caxis([0 0.00001]);
set(gca,'ytick',[]);
    set(gca,'ycolor',[1 1 1])
    set(gca,'xtick',[]);
    set(gca,'xcolor',[1 1 1])

    subplot(1, 2, 2)
    contourf(C2,  'LineColor' , 'none','LevelStep', 0.000001);
%     caxis([0 0.00001]);

    colormap(cMap);

    caxis([0 0.0001]);
    set(gca,'ytick',[]);
    set(gca,'ycolor',[1 1 1])
    set(gca,'xtick',[]);
    set(gca,'xcolor',[1 1 1])


end


%%
fig1 = figure;
fig1.PaperUnits      = 'centimeters';
fig1.Units           = 'centimeters';
fig1.Color           = 'w';
fig1.InvertHardcopy  = 'off';
fig1.Name            = 'Mapping video'
fig1.NumberTitle     = 'off';
set(fig1,'defaultAxesXColor','k');
figure(fig1);

point=1500*20;
loops=p*1000;
F(loops) = struct('cdata',[],'colormap',[]);


for p=point:loops
    cMap=jet; %set the colomap using the "jet" sca
    e= 0.0002;
    a1 = [e e e e e e];
    a2 = [e abs_Map_Signal_LE(p, 1) abs_Map_Signal_LE(p, 2) abs_Map_Signal_LE(p, 3) abs_Map_Signal_LE(p, 4) e];
    a3=  [e abs_Map_Signal_LE(p, 5) abs_Map_Signal_LE(p, 6) abs_Map_Signal_LE(p, 7) abs_Map_Signal_LE(p, 8) e];
    a4=  [e abs_Map_Signal_LE(p, 9) abs_Map_Signal_LE(p, 10) abs_Map_Signal_LE(p, 11) abs_Map_Signal_LE(p, 12) e];
    a5=  [e abs_Map_Signal_LE(p, 13) abs_Map_Signal_LE(p, 14) abs_Map_Signal_LE(p, 15) abs_Map_Signal_LE(p, 16) e];
    a6 = [e e e e e e];
    Map1=vertcat(a1, a2, a3, a4, a5, a6);
    
    a1 = [e e e e e e];
    a2 = [e abs_Map_Signal_RE(p, 1) abs_Map_Signal_RE(p, 2) abs_Map_Signal_RE(p, 3) abs_Map_Signal_RE(p, 4) e];
    a3=  [e abs_Map_Signal_RE(p, 5) abs_Map_Signal_RE(p, 6) abs_Map_Signal_RE(p, 7) abs_Map_Signal_RE(p, 8) e];
    a4=  [e abs_Map_Signal_RE(p, 9) abs_Map_Signal_RE(p, 10) abs_Map_Signal_RE(p, 11) abs_Map_Signal_RE(p, 12) e];
    a5=  [e abs_Map_Signal_RE(p, 13) abs_Map_Signal_RE(p, 14) abs_Map_Signal_RE(p, 15) abs_Map_Signal_RE(p, 16) e];
    a6 = [e e e e e e];
    Map2=vertcat(a1, a4, a5, a2, a3, a6);
   
   
   
    C1 = conv2(Map1,Map1, 'full');
    C2 = conv2(Map2,Map2, 'full');
    
    subplot(1, 2, 1)
    contourf(C1,  'LineColor' , 'none','LevelStep', 0.000001);
    txt = ['T= ' num2str(p/20) ' ms'];
    text(0, 0,txt)
%     caxis([0 0.0001]);

    subplot(1, 2, 2)
    contourf(C2,  'LineColor' , 'none','LevelStep', 0.000001);
    
    colormap(cMap);

%     caxis([0 0.00008]);
    
    drawnow 
 
%     set(gca,'ytick
%     set(gca,'ycolor',[1 1 1])
%     set(gca,'xtick',[]);
%     set(gca,'xcolor',[1 1 1])

end
%    F(p) = getframe;
% movie(fig1,F,1, 2)
%%
fig3 = figure;
fig3.PaperUnits      = 'centimeters';
fig3.Units           = 'centimeters';
fig3.Color           = 'w';
fig3.InvertHardcopy  = 'off';
fig3.Name            = 'Mapping';
fig3.NumberTitle     = 'off';
set(fig3,'defaultAxesXColor','k');
figure(fig3);


for s=1:12
    p= location(1, 1)+s-8;
    subplot(12, 2, 2*s)
    cMap=jet; %set the colomap using the "jet" sca
    e= 0.0002;
    
    a1 = [e e e e e e];
    a2 = [e abs_Map_Signal_LE(p, 1) abs_Map_Signal_LE(p, 2) abs_Map_Signal_LE(p, 3) abs_Map_Signal_LE(p, 4) e];
    a3=  [e abs_Map_Signal_LE(p, 5) abs_Map_Signal_LE(p, 6) abs_Map_Signal_LE(p, 7) abs_Map_Signal_LE(p, 8) e];
    a4=  [e abs_Map_Signal_LE(p, 9) abs_Map_Signal_LE(p, 10) abs_Map_Signal_LE(p, 11) abs_Map_Signal_LE(p, 12) e];
    a5=  [e abs_Map_Signal_LE(p, 13) abs_Map_Signal_LE(p, 14) abs_Map_Signal_LE(p, 15) abs_Map_Signal_LE(p, 16) e];
    a6 = [e e e e e e];
    Map1=vertcat(a1, a2, a3, a4, a5, a6);
      
    C1 = conv2(Map1,Map1, 'full');
    contourf(C1,  'LineColor' , 'none','LevelStep', 0.000001);

    colormap(cMap);
%     cb=colorbar;
    caxis([0 0.001]);
    set(gca,'ytick',[]);
    set(gca,'ycolor',[1 1 1])
    set(gca,'xtick',[]);
    set(gca,'xcolor',[1 1 1])
end

for s=1:12
    p= location(1, 1)+s-8;
    subplot(12, 2, 2*s-1)
    cMap=jet; %set the colomap using the "jet" sca
    e= 0.0005;
    
    a1 = [e e e e e e];
    a2 = [e abs_Map_Signal_RE(p, 1) abs_Map_Signal_RE(p, 2) abs_Map_Signal_RE(p, 3) abs_Map_Signal_RE(p, 4) e];
    a3=  [e abs_Map_Signal_RE(p, 5) abs_Map_Signal_RE(p, 6) abs_Map_Signal_RE(p, 7) abs_Map_Signal_RE(p, 8) e];
    a4=  [e abs_Map_Signal_RE(p, 9) abs_Map_Signal_RE(p, 10) abs_Map_Signal_RE(p, 11) abs_Map_Signal_RE(p, 12) e];
    a5=  [e abs_Map_Signal_RE(p, 13) abs_Map_Signal_RE(p, 14) abs_Map_Signal_RE(p, 15) abs_Map_Signal_RE(p, 16) e];
    a6 = [e e e e e e];
    Map2=vertcat(a1, a2, a3, a4, a5, a6);

      
    C2 = conv2(Map2,Map2, 'full');
    contourf(C2,  'LineColor' , 'none','LevelStep', 0.000001);

    colormap(cMap);
%     cb=colorbar;
    caxis([0 0.001]);
    set(gca,'ytick',[]);
    set(gca,'ycolor',[1 1 1])
    set(gca,'xtick',[]);
    set(gca,'xcolor',[1 1 1])
end
%% 
LP_Signal_fix_reshape=reshape(LP_Signal_fix,10000,[]);


fig1 = figure;
fig1.PaperUnits      = 'centimeters';
fig1.Units           = 'centimeters';
fig1.Color           = 'w';
fig1.InvertHardcopy  = 'off';
fig1.Name            = 'Evoked_burst';
fig1.NumberTitle     = 'off';
set(fig1,'defaultAxesXColor','k');
figure(fig1);

time_bu=[400: -0.05: -100];
time_bu_rot = rot90(time_bu);
time_bu_rot(length(time_bu_rot), :)=[];

b=1;
%690
%for i=50000:57600

clear s1_all;
for i=25000:27000
    
    hold on
    s1=LP_Signal_fix_reshape(:, i);
%     s2=LP_Signal_fix_reshapre(:, i+1);
    [M_s1,I_s1] = max(abs(s1));
%     [C12,lag12] = xcorr(s1, s2);
%     C12 = C12/max(C12);
%     [M12,I12] = max(C12);
%     t12 = lag12(I12);
%     s1 = s1(abs(t12):end);
% 
if (I_s1 >= 150*20) && (I_s1 <= 200*20)&&(M_s1 >=0.075)
    
    plot(time_bu_rot, s1+0.05*b);
    s1_all(:, b)=+s1;
    b=b+1;
end

end
hold off

fig1 = figure;
fig1.PaperUnits      = 'centimeters';
fig1.Units           = 'centimeters';
fig1.Color           = 'w';
fig1.InvertHardcopy  = 'off';
fig1.Name            = 'Evoked_burst';
fig1.NumberTitle     = 'off';
set(fig1,'defaultAxesXColor','k');
figure(fig1);

s1_mean=mean(s1_all, 2);
s1_all_detrend = detrend(s1_all);

power_s1_all_detrend=s1_all_detrend.^2;
power_s1_mean_detrend=mean(power_s1_all_detrend, 2);


hold on
%plot(time_bu_rot, power_s1_mean_detrend, 'LineWidth', 2, 'Color',  [0 0 0]);
plot(time_bu_rot, power_s1_all_detrend, 'Color', [0.8 0.8 0.8]);
hold off
%% 

fig3 = figure;
fig3.PaperUnits      = 'centimeters';
fig3.Units           = 'centimeters';
fig3.Color           = 'w';
fig3.InvertHardcopy  = 'off';
fig3.Name            = 'Evoked_burst';
fig3.NumberTitle     = 'off';
set(fig3,'defaultAxesXColor','k');
figure(fig3);

for k=1:100
    hold on
    s1_single=s1_all_detrend(:, k);
    [se,te]=pentropy(s1_single, Fs);
    plot(te*1000, se+0.1*k);
    se_all(:, k)=+se;

end

hold off

%% 
fig3 = figure;
fig3.PaperUnits      = 'centimeters';
fig3.Units           = 'centimeters';
fig3.Color           = 'w';
fig3.InvertHardcopy  = 'off';
fig3.Name            = 'Evoked_burst';
fig3.NumberTitle     = 'off';

set(fig3,'defaultAxesXColor','k');
figure(fig3);
cluster_num=2;

s1_all_rot=rot90(s1_all);
cmap = hsv(cluster_num); 
[~,score,~,~,~] = pca(s1_all_rot, 'VariableWeights','variance');
opts = statset('Display','final');

[idx, ~]  = kmeans(score, cluster_num, 'Distance','correlation','Replicates',3,'Start', 'plus', 'Options', opts);
    % 'hamming''correlation''cosine''cityblock''sqeuclidean'
    
 for i = 1:cluster_num
             hold on
        plot(time_bu_rot, s1_all_rot(idx==i,:)','Color', cmap(i, :));
            title(sprintf('Cluster %d',i));
        hold off
end