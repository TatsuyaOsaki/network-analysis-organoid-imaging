 function [Signal_comp]=init_csv(num_electrode)

fsep                = filesep;      % Get file separator depending on OS
csv_dir             = uigetdir();   % Select binary file directory
csv_files           = dir(fullfile(csv_dir, '*.csv')); % Get all binaries files in folder
nb_csv           = size(csv_files,1); % Get number of binary files in directory
%% csv reading

ini_formart='%f%';
number='f%';
nr='[^\n\r]';
for i=1:num_electrode
    ini_formart=strcat(ini_formart, number);
%     f_char=char(f_array);
    
end
formatSpec=strcat(ini_formart, nr);

if 1 <= nb_csv
     for i=1:nb_csv
           fprintf(sprintf("[Loading...] : %s\n", csv_files(i).name));
           fpath = sprintf("%s%s%s", csv_files(i).folder, fsep, csv_files(i).name);
         
          delimiter = ',';
          startRow = 4;
         
          fileID = fopen(fpath,'r');
          textscan(fileID, '%[^\n\r]', startRow-1, 'WhiteSpace', '', 'ReturnOnError', false, 'EndOfLine', '\r\n');
          dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'ReturnOnError', false);
          fclose(fileID);
          Signal = [dataArray{1:end-1}];
          clearvars  filename delimiter startRow fileID dataArray ans;
          
         Signal_comp{i, 1}=Signal;
         Signal_comp{i, 2}=csv_files(i).name;
     end
else
     
    disp ('OK')
end



 end