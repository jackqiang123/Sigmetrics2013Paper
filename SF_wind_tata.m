clear all
clc

load('SF_wind');  % MWh

[T,temp]=size(SF_wind);
FCZ5_COLL_wind=zeros(365*24,1);

for t=1:T/6
    FCZ5_COLL_wind(t,1)=SF_wind((t-1)*6+1,1)+SF_wind((t-1)*6+2,1)+SF_wind((t-1)*6+3,1)+SF_wind((t-1)*6+4,1)+SF_wind((t-1)*6+5,1)+SF_wind((t-1)*6+6,1);
    FCZ5_COLL_wind(t,1)=1000*FCZ5_COLL_wind(t,1)/6;       %KWh
end