clear all
clc

pa='C:\TDDOWNLOAD\sigmetrics\solar2010.txt';

fid = fopen(pa);
    
% read column headers 1 line
C_text = textscan(fid, '%s', 3,'delimiter', ',');

% read data
mydata = textscan(fid,'%*s %*u %f','delimiter', ',');
   
fclose(fid);

[T,temp]=size(mydata{1,1});

solar_radiation=mydata{1,1};
    


    

            
   